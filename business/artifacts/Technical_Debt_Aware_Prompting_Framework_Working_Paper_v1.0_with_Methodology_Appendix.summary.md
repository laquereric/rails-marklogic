# PDF Extraction Summary

## Document Information

- **MarkLogic URI**: `/documents/Technical_Debt_Aware_Prompting_Framework_Working_Paper_v1.0_with_Methodology_Appendix.json`
- **Original PDF**: Technical_Debt_Aware_Prompting_Framework_Working_Paper_v1.0_with_Methodology_Appendix.pdf
- **Extraction Date**: 2026-01-26T13:06:26Z

## Extraction Statistics

- **Total Pages**: 54
- **Total Characters**: 98848
- **Total Words**: 11892
- **Estimated Reading Time**: 59.5 minutes

## Querying in MarkLogic

### Get the full document
```ruby
service = MarklogicService.new
content = service.get_document("/documents/Technical_Debt_Aware_Prompting_Framework_Working_Paper_v1.0_with_Methodology_Appendix.json")
parsed = JSON.parse(content)
```

### Search for specific terms
```ruby
# Use the query_pdf_content.rb script
bundle exec ruby script/query_pdf_content.rb "/documents/Technical_Debt_Aware_Prompting_Framework_Working_Paper_v1.0_with_Methodology_Appendix.json" search "your term"
```

### Get specific pages
```ruby
bundle exec ruby script/query_pdf_content.rb "/documents/Technical_Debt_Aware_Prompting_Framework_Working_Paper_v1.0_with_Methodology_Appendix.json" pages "1,2,3"
```

### Get document structure
```ruby
bundle exec ruby script/query_pdf_content.rb "/documents/Technical_Debt_Aware_Prompting_Framework_Working_Paper_v1.0_with_Methodology_Appendix.json" structure
```

### Get document summary
```ruby
bundle exec ruby script/query_pdf_content.rb "/documents/Technical_Debt_Aware_Prompting_Framework_Working_Paper_v1.0_with_Methodology_Appendix.json" summary
```

## Notes

- This summary file is automatically generated and stored alongside the original PDF
- The extracted content is stored in MarkLogic as a JSON document
- Use the provided query scripts to search and retrieve specific content
