module Mcp
  module Providers
    class AutoProvider < Mcp::Provider
      OLLAMA_HOST  = "http://localhost:11434"
      MODEL        = "devstral:24b"

      def initialize
        if ollama_running?
          if ollama_model_available?
            @provider = OllamaProvider.new
          else
            @provider = MissingModelProvider.new(MODEL)
          end
        else
          @provider = OpenAiProvider.new
        end
      end

      def chat(messages:)
        @provider.chat(messages:)
      end

      def provider_name
        @provider.provider_name
      end

      def model_name
        @provider.model_name
      end

      private

      def ollama_running?
        require "net/http"
        uri = URI("#{OLLAMA_HOST}/api/tags")
        Net::HTTP.start(uri.host, uri.port, open_timeout: 0.5, read_timeout: 0.5) do |http|
          http.get(uri.path).is_a?(Net::HTTPSuccess)
        end
      rescue
        false
      end

      def ollama_model_available?
        require "net/http"
        require "json"
        uri = URI("#{OLLAMA_HOST}/api/tags")

        Net::HTTP.start(uri.host, uri.port, open_timeout: 0.5, read_timeout: 0.5) do |http|
          res = http.get(uri.path)
          data = JSON.parse(res.body)
          models = data.fetch("models", []).map { |m| m["name"] }
          models.include?(MODEL)
        end
      rescue
        false
      end
    end
  end
end
