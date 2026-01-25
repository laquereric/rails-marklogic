module Mcp
  module Providers
    class OpenAiProvider < Mcp::Provider
      def initialize
        @client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
      end

      def chat(messages:, model: ENV.fetch("OPENAI_MODEL", "gpt-4o-mini"))
        @client.chat(parameters: { model: model, messages: messages })
      end
    end
  end
end
