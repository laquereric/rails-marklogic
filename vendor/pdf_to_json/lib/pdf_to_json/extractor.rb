require "pdf-reader"
require_relative "converter"

module PdfToJson
  class Extractor
    def initialize
      # Initialize without LLM client for basic PDF extraction
    end

    def extract_to_json(pdf_path)
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

    def extract_to_json_file(pdf_path, output_path = nil)
      content = extract_to_json(pdf_path)

      output_path ||= pdf_path.sub('.pdf', '.json')
      File.write(output_path, JSON.pretty_generate(content))

      output_path
    end

    private

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
  end
end
