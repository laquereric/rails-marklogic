require "json"
require "net/http"

module Mcp
  module Providers
    class OllamaProvider < Mcp::Provider
      HOST = "http://localhost:11434"
      MODEL = "devstral:24b"

      def chat(messages:, model: MODEL)
        uri = URI("#{HOST}/api/chat")
        req = Net::HTTP::Post.new(uri)
        req["Content-Type"] = "application/json"
        req.body = {
          model: model,
          messages: messages
        }.to_json

        Net::HTTP.start(uri.host, uri.port, open_timeout: 1, read_timeout: 60) do |http|
          res = http.request(req)
          payload = JSON.parse(res.body)
          content = payload.dig("message", "content")

          { "choices" => [ { "message" => { "content" => content } } ] }
        end
      end

      def provider_name
        "Ollama (local)"
      end

      def model_name
        MODEL
      end
    end
  end
end
