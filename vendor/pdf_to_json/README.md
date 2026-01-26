# PDF to JSON

Extract PDF content to structured JSON format with metadata and structure.

## Features

- **Full Text Extraction**: Extract all text content from PDF files
- **Page-Level Metadata**: Track content per page with character/word counts
- **Structure Detection**: Identify headings, sections, bullet points
- **Document Metadata**: Extract PDF metadata (title, author, creator, etc.)
- **JSON Output**: Clean, structured JSON format for downstream processing

## Installation

Add to your Gemfile:

```ruby
gem "pdf_to_json", path: "vendor/pdf_to_json"
```

Or install dependencies:

```bash
bundle install
```

## Usage

### CLI

Extract PDF to JSON:

```bash
bundle exec vendor/pdf_to_json/bin/pdf_to_json document.pdf
```

Specify output path:

```bash
bundle exec vendor/pdf_to_json/bin/pdf_to_json document.pdf output.json
```

### Ruby API

```ruby
require "pdf_to_json"

# Extract to Ruby hash
extractor = PdfToJson::Extractor.new
content = extractor.extract_to_json("document.pdf")

puts content[:metadata][:page_count]
puts content[:text].length
puts content[:structure].count { |s| s[:type] == 'heading' }
```

Extract to JSON file:

```ruby
extractor = PdfToJson::Extractor.new
output_path = extractor.extract_to_json_file("document.pdf")
puts "Output: #{output_path}"
```

## Output Format

The extracted JSON has this structure:

```json
{
  "metadata": {
    "filename": "document.pdf",
    "file_path": "/path/to/document.pdf",
    "file_size": 12998059,
    "page_count": 54,
    "pdf_version": "1.4",
    "info": {
      "title": "Document Title",
      "author": "Author Name",
      "creator": "Creator Application",
      "producer": "PDF Producer"
    },
    "extracted_at": "2026-01-26T12:59:21Z"
  },
  "pages": [
    {
      "page_number": 1,
      "text": "Page content here...",
      "character_count": 1500,
      "word_count": 250
    }
  ],
  "text": "Full text content from all pages...",
  "structure": [
    {
      "type": "heading",
      "level": 1,
      "text": "MAIN HEADING",
      "page_number": 1,
      "line_number": 5
    },
    {
      "type": "section",
      "level": 1,
      "text": "1. Introduction",
      "page_number": 1,
      "line_number": 10
    }
  ]
}
```

## Structure Detection

The extractor identifies these structural elements:

- **Headings**: ALL CAPS lines (< 100 chars)
- **Sections**: Numbered sections (e.g., "1. Introduction")
- **Subsections**: Numbered subsections (e.g., "1.1 Background")
- **Bullet points**: Lines starting with -, *, or •

## Integration with MarkLogic

Extract PDFs and store in MarkLogic:

```ruby
require "pdf_to_json"
require_relative "app/services/marklogic_service"

extractor = PdfToJson::Extractor.new
content = extractor.extract_to_json("document.pdf")

service = MarklogicService.new
service.put_document(
  "/documents/document.json",
  JSON.pretty_generate(content),
  content_type: 'application/json'
)
```

## Examples

See the main project for complete examples:

- `script/extract_pdf_with_marklogic.rb` - Extract and store in MarkLogic
- `script/query_pdf_content.rb` - Query extracted content from MarkLogic

## License

MIT

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
