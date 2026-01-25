module Mcp
  module JsonLd
    DEFAULT_CONTEXT = {
      "@vocab" => "http://example.com/mcp#"
    }.freeze

    def self.ensure_context(payload)
      return payload if payload.key?("@context")

      payload.merge("@context" => DEFAULT_CONTEXT)
    end
  end
end
