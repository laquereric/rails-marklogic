#!/usr/bin/env ruby
# Extract content from PDF and store in MarkLogic for querying and analysis

require 'pdf-reader'
require_relative '../config/environment'
require_relative '../app/services/marklogic_service'

# PDF extraction and MarkLogic storage
class PdfExtractor
  def initialize(marklogic_service: MarklogicService.new)
    @service = marklogic_service
  end

  def extract_and_store(pdf_path)
    pdf_filename = File.basename(pdf_path, '.pdf')
    pdf_uri = "/documents/#{pdf_filename}.json"

    # Extract content from PDF
    puts "Extracting content from PDF: #{pdf_path}"
    content = extract_from_pdf(pdf_path)

    # Store in MarkLogic
    puts "Storing extracted content in MarkLogic..."
    json_content = JSON.pretty_generate(content)

    @service.put_document(
      pdf_uri,
      json_content,
      content_type: 'application/json'
    )

    puts "Content stored at: #{pdf_uri}"

    # Verify storage
    puts "Verifying document in MarkLogic..."
    verify_javascript = "cts.doc('#{pdf_uri}') != null"
    exists = @service.eval_javascript(verify_javascript)
    puts "Document exists in MarkLogic: #{exists}"

    # Build result object
    result = {
      uri: pdf_uri,
      pages_extracted: content[:metadata][:page_count],
      total_characters: content[:text].length,
      word_count: content[:text].split(/\s+/).length
    }

    # Create summary.md file next to original PDF
    summary_path = File.join(File.dirname(pdf_path), "#{File.basename(pdf_path, '.pdf')}.summary.md")
    create_summary_file(summary_path, result[:uri], result[:pages_extracted], result[:total_characters], result[:word_count])
    puts "Summary file created: #{summary_path}"

    result
  end

  def extract_from_pdf(pdf_path)
    reader = PDF::Reader.new(pdf_path)

    content = {
      metadata: {
        filename: File.basename(pdf_path),
        file_path: pdf_path,
        file_size: File.size(pdf_path),
        page_count: reader.page_count,
        pdf_version: reader.pdf_version,
        info: extract_pdf_info(reader),
        extracted_at: Time.now.utc.iso8601
      },
      pages: [],
      text: '',
      structure: []
    }

    # Extract content page by page
    reader.pages.each_with_index do |page, index|
      page_number = index + 1
      page_text = page.text

      # Store page-level content
      content[:pages] << {
        page_number: page_number,
        text: page_text,
        character_count: page_text.length,
        word_count: page_text.split(/\s+/).length
      }

      # Extract structural elements (headings, etc.)
      structure = extract_structure(page_text, page_number)
      content[:structure].concat(structure) if structure.any?

      # Append to full text
      content[:text] += page_text + "\n\n"
    end

    content
  end

  def extract_pdf_info(reader)
    info = reader.info

    {
      title: info[:Title],
      author: info[:Author],
      subject: info[:Subject],
      keywords: info[:Keywords],
      creator: info[:Creator],
      producer: info[:Producer],
      creation_date: info[:CreationDate],
      modification_date: info[:ModDate]
    }.compact
  end

  def extract_structure(page_text, page_number)
    structure = []

    # Detect headings (all caps or numbered sections)
    lines = page_text.split("\n")

    lines.each_with_index do |line, line_index|
      line = line.strip

      next if line.empty?

      # Detect headings (all caps, short, likely heading)
      if line.length < 100 && line == line.upcase && line.length > 3
        structure << {
          type: 'heading',
          level: 1,
          text: line,
          page_number: page_number,
          line_number: line_index + 1
        }
      end

      # Detect numbered sections (e.g., "1. Introduction")
      if line =~ /^\d+\.\s+[A-Z]/
        structure << {
          type: 'section',
          level: 1,
          text: line,
          page_number: page_number,
          line_number: line_index + 1
        }
      end

      # Detect subsections (e.g., "1.1 Background")
      if line =~ /^\d+\.\d+\s+[A-Z]/
        structure << {
          type: 'subsection',
          level: 2,
          text: line,
          page_number: page_number,
          line_number: line_index + 1
        }
      end

      # Detect bullet points
      if line =~ /^[\-\*\•]\s+/
        structure << {
          type: 'bullet',
          text: line,
          page_number: page_number,
          line_number: line_index + 1
        }
      end
    end

    structure
  end

  def create_summary_file(path, uri, pages, chars, words)
    original_pdf_name = File.basename(path, '.summary.md') + '.pdf'
    summary_content = <<~MARKDOWN
      # PDF Extraction Summary

      ## Document Information

      - **MarkLogic URI**: `#{uri}`
      - **Original PDF**: #{original_pdf_name}
      - **Extraction Date**: #{Time.now.utc.iso8601}

      ## Extraction Statistics

      - **Total Pages**: #{pages}
      - **Total Characters**: #{chars}
      - **Total Words**: #{words}
      - **Estimated Reading Time**: #{(words / 200.0).round(1)} minutes

      ## Querying in MarkLogic

      ### Get the full document
      ```ruby
      service = MarklogicService.new
      content = service.get_document("#{uri}")
      parsed = JSON.parse(content)
      ```

      ### Search for specific terms
      ```ruby
      # Use the query_pdf_content.rb script
      bundle exec ruby script/query_pdf_content.rb "#{uri}" search "your term"
      ```

      ### Get specific pages
      ```ruby
      bundle exec ruby script/query_pdf_content.rb "#{uri}" pages "1,2,3"
      ```

      ### Get document structure
      ```ruby
      bundle exec ruby script/query_pdf_content.rb "#{uri}" structure
      ```

      ### Get document summary
      ```ruby
      bundle exec ruby script/query_pdf_content.rb "#{uri}" summary
      ```

      ## Notes

      - This summary file is automatically generated and stored alongside the original PDF
      - The extracted content is stored in MarkLogic as a JSON document
      - Use the provided query scripts to search and retrieve specific content
    MARKDOWN

    File.write(path, summary_content)
  end

  def search_in_marklogic(query, limit: 10)
    search_javascript = <<~JS
      const query = "#{query}";
      const limit = #{limit};

      // Search for documents containing the query
      const results = cts.search(
        cts.wordQuery(query),
        cts.collectionQuery("/documents")
      );

      // Format results
      let formatted = [];
      for (let i = 0; i < Math.min(results.length, limit); i++) {
        const doc = results[i];
        formatted.push({
          uri: xdmp.nodeUri(doc),
          score: cts.score(doc),
          snippet: cts.highlight(
            xdmp.quote(doc),
            cts.wordQuery(query),
            '<mark>$1</mark>'
          ).toString().substring(0, 500)
        });
      }

      {
        total: results.length,
        results: formatted
      };
    JS

    JSON.parse(@service.eval_javascript(search_javascript))
  end
end

# Command-line usage
if __FILE__ == $PROGRAM_NAME
  pdf_path = ARGV[0] || 'business/artifacts/Technical_Debt_Aware_Prompting_Framework_Working_Paper_v1.0_with_Methodology_Appendix.pdf'

  unless File.exist?(pdf_path)
    puts "Error: PDF file not found: #{pdf_path}"
    exit 1
  end

  puts "PDF Extraction with MarkLogic"
  puts "=" * 80

  begin
    extractor = PdfExtractor.new

    # Extract and store
    puts "\n[1] Extracting content and storing in MarkLogic..."
    result = extractor.extract_and_store(pdf_path)

    puts "\n[2] Extraction Summary:"
    puts "  Document URI: #{result[:uri]}"
    puts "  Pages: #{result[:pages_extracted]}"
    puts "  Total Characters: #{result[:total_characters]}"
    puts "  Word Count: #{result[:word_count]}"

    # Show some extracted text
    puts "\n[3] Sample of extracted content (first 500 chars):"
    # Get the document and show a sample
    doc_content = extractor.instance_variable_get(:@service).get_document(result[:uri])
    parsed = JSON.parse(doc_content)
    sample = parsed['text'] ? parsed['text'][0..500] : "No text content found"
    puts sample
    puts "\n[3.1] Structure overview:"
    puts "  Total pages: #{parsed['pages']&.length || 0}"
    puts "  Structure elements: #{parsed['structure']&.length || 0}"
    if parsed['structure'] && parsed['structure'].any?
      puts "  Sample structure elements:"
      parsed['structure'].first(5).each do |elem|
        puts "    - #{elem['type']}: #{elem['text']&.truncate(60)}"
      end
    end

    puts "\n[4] Search examples (you can search for specific terms):"
    puts "  Usage: ruby #{$0} [pdf_path]"
    puts "  Search: Run the search_in_marklogic method programmatically"

    puts "\n" + "=" * 80
    puts "Extraction complete! Content is now stored and searchable in MarkLogic."
    puts "=" * 80

  rescue => e
    puts "Error during extraction: #{e.message}"
    puts e.backtrace
    exit 1
  end
end
