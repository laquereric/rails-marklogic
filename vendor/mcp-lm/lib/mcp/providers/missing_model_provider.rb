module Mcp
  module Providers
    class MissingModelProvider < Mcp::Provider
      def initialize(model)
        @model = model
      end

      def chat(messages:)
        raise "Ollama is running but model '#{@model}' is not available. Run: ollama pull #{@model}"
      end

      def provider_name
        "Ollama (local)"
      end

      def model_name
        @model
      end
    end
  end
end
