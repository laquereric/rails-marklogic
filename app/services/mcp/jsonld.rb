module Mcp
  # Zeitwerk expects this constant name to match the file path: app/services/mcp/jsonld.rb
  module Jsonld
    DEFAULT_CONTEXT = {
      "@vocab" => "http://example.com/mcp#"
    }.freeze

    def self.ensure_context(payload)
      return payload if payload.key?("@context")

      payload.merge("@context" => DEFAULT_CONTEXT)
    end
  end

  # Backward compatibility for code referring to Mcp::JsonLd
  JsonLd = Jsonld unless const_defined?(:JsonLd)
end
