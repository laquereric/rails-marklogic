require "json"

module PdfToJson
  class Converter
    SCHEMA = {
      document: {
        title: nil,
        metadata: {},
        sections: []
      }
    }

    def initialize(llm_client:)
      @llm = llm_client
    end

    def convert(pdf_bytes)
      prompt = <<~PROMPT
        Convert the attached PDF into structured JSON with sections, headings, and paragraphs.
        Preserve hierarchy and ordering.
        Output only valid JSON matching this schema:
        #{SCHEMA.to_json}
      PROMPT

      @llm.process_pdf(pdf_bytes, prompt: prompt)
    end
  end
end
