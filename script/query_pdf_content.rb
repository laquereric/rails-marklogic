#!/usr/bin/env ruby
# Query and search extracted PDF content from MarkLogic

require_relative '../config/environment'
require_relative '../app/services/marklogic_service'

class PdfContentQuery
  def initialize(marklogic_service: MarklogicService.new)
    @service = marklogic_service
  end

  def get_document(uri)
    puts "Fetching document: #{uri}"
    content = @service.get_document(uri)
    JSON.parse(content)
  rescue => e
    puts "Error fetching document: #{e.message}"
    nil
  end

  def search_text(query_term, limit: 10)
    puts "Searching for: #{query_term}"
    search_javascript = <<~JS
      const query = "#{query_term}";
      const limit = #{limit};

      // Search for documents containing the query term
      const results = cts.search(
        cts.andQuery([
          cts.wordQuery(query),
          cts.collectionQuery(["/documents"])
        ])
      );

      // Format results
      const formatted = [];
      for (let i = 0; i < Math.min(results.length, limit); i++) {
        const doc = results[i];
        const uri = xdmp.nodeUri(doc);

        // Get a snippet with highlighted matches
        const snippet = cts.highlight(
          xdmp.quote(doc),
          cts.wordQuery(query),
          '<mark>$1</mark>'
        );

        formatted.push({
          uri: uri,
          score: cts.score(doc),
          snippet: snippet.substring(0, 800)
        });
      }

      JSON.stringify({
        total: results.length,
        results: formatted
      });
    JS

    result = @service.eval_javascript(search_javascript)

    # Extract JSON from multipart response
    json_start = result.index('{') || result.index('[')
    if json_start
      json_content = result[json_start..-1]
      JSON.parse(json_content)
    else
      { total: 0, results: [] }
    end
  rescue => e
    puts "Error during search: #{e.message}"
    { total: 0, results: [] }
  end

  def search_by_metadata(uri, metadata_key)
    puts "Searching for metadata key: #{metadata_key}"
    doc = get_document(uri)
    return nil unless doc

    doc[metadata_key]
  end

  def get_pages(uri, page_numbers = nil)
    puts "Fetching pages from: #{uri}"
    doc = get_document(uri)
    return nil unless doc

    pages = doc['pages'] || []
    return pages unless page_numbers

    # Filter to specific pages
    page_numbers.map { |n| pages[n - 1] }.compact
  end

  def get_structure(uri)
    puts "Fetching structure from: #{uri}"
    doc = get_document(uri)
    return nil unless doc

    doc['structure'] || []
  end

  def print_summary(uri)
    puts "\n" + "=" * 80
    puts "Document Summary"
    puts "=" * 80

    doc = get_document(uri)
    return unless doc

    metadata = doc['metadata'] || {}

    puts "Filename: #{metadata['filename']}"
    puts "File Size: #{metadata['file_size']} bytes"
    puts "Page Count: #{metadata['page_count']}"
    puts "PDF Version: #{metadata['pdf_version']}"
    puts "Extracted At: #{metadata['extracted_at']}"
    puts "Total Characters: #{doc['text']&.length || 0}"
    puts "Word Count: #{(doc['text'] || '').split(/\s+/).length}"

    if metadata['info']
      puts "\nDocument Info:"
      metadata['info'].each do |key, value|
        puts "  #{key}: #{value}"
      end
    end

    structure = doc['structure'] || []
    puts "\nStructure Elements: #{structure.length}"
    structure.each_slice(5).with_index do |group, i|
      puts "\n  Group #{i + 1}:"
      group.each do |elem|
        text = elem['text']&.truncate(50) || 'N/A'
        puts "    #{elem['type']} (page #{elem['page_number']}): #{text}"
      end
    end

    puts "\n" + "=" * 80
  end
end

# Command-line usage
if __FILE__ == $PROGRAM_NAME
  uri = ARGV[0] || '/documents/Technical_Debt_Aware_Prompting_Framework_Working_Paper_v1.0_with_Methodology_Appendix.json'
  command = ARGV[1] || 'summary'

  query = PdfContentQuery.new

  case command
  when 'summary'
    query.print_summary(uri)

  when 'search'
    query_term = ARGV[2]
    unless query_term
      puts "Usage: #{$0} [uri] search [query_term]"
      exit 1
    end

    results = query.search_text(query_term, limit: 5)

    puts "\n" + "=" * 80
    puts "Search Results"
    puts "=" * 80
    puts "Total matches: #{results[:total]}"
    puts "Showing: #{results[:results].length} results"

    results[:results].each_with_index do |result, index|
      puts "\n[#{index + 1}] Score: #{result[:score]}"
      puts "    URI: #{result[:uri]}"
      puts "    Snippet: #{result[:snippet]}"
    end

    puts "\n" + "=" * 80

  when 'pages'
    page_nums = ARGV[2]&.split(',')&.map(&:to_i) || [ 1, 2, 3 ]
    pages = query.get_pages(uri, page_nums)

    puts "\n" + "=" * 80
    puts "Pages: #{page_nums.join(', ')}"
    puts "=" * 80

    pages&.each do |page|
      puts "\n--- Page #{page['page_number']} ---"
      puts "Characters: #{page['character_count']}"
      puts "Words: #{page['word_count']}"
      puts "Text preview (first 300 chars):"
      puts page['text'][0..300]
      puts "\n"
    end

  when 'structure'
    structure = query.get_structure(uri)

    puts "\n" + "=" * 80
    puts "Document Structure"
    puts "=" * 80
    puts "Total elements: #{structure&.length || 0}"

    structure&.each_with_index do |elem, index|
      puts "\n[#{index + 1}] #{elem['type']} (Level #{elem['level']})"
      puts "    Page #{elem['page_number']}, Line #{elem['line_number']}"
      puts "    Text: #{elem['text']&.truncate(100)}"
    end

    puts "\n" + "=" * 80

  when 'full_text'
    doc = query.get_document(uri)
    if doc && doc['text']
      puts "\n" + "=" * 80
      puts "Full Text Content"
      puts "=" * 80
      puts doc['text']
      puts "\n" + "=" * 80
    else
      puts "No text content found"
    end

  else
    puts "Usage: #{$0} [uri] [command] [args...]"
    puts ""
    puts "Commands:"
    puts "  summary              - Print document summary (default)"
    puts "  search [term]        - Search for text term"
    puts "  pages [1,2,3]        - Get specific pages"
    puts "  structure            - Get document structure"
    puts "  full_text            - Get full text content"
    puts ""
    puts "Examples:"
    puts "  #{$0}"
    puts "  #{$0} /documents/mydoc.json search 'technical debt'"
    puts "  #{$0} /documents/mydoc.json pages 1,2,3"
    puts "  #{$0} /documents/mydoc.json structure"
  end
end
