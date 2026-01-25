module Mcp
  class Doctor
    def self.run
      new.run
    end

    def run
      if ENV["MCP_LLM_DISABLED"] == "true"
        return {
          provider: "disabled",
          model: nil,
          checks: [ warn("LLM", "LLM usage is disabled by configuration") ]
        }
      end

      provider = Providers::AutoProvider.new

      checks = []

      checks << ok("Rails")

      if provider.provider_name.include?("Ollama")
        checks << ollama_check
        checks << model_check(provider.model_name)
      else
        checks << ok("OpenAI configured")
      end

      {
        provider: provider.provider_name,
        model: provider.model_name,
        checks: checks
      }
    end

    private

    def ok(name)
      { name:, status: :ok }
    end

    def warn(name, message)
      { name:, status: :warn, message: }
    end

    def ollama_check
      require "net/http"
      uri = URI("http://localhost:11434/api/tags")

      Net::HTTP.start(uri.host, uri.port, open_timeout: 0.5, read_timeout: 0.5) do |http|
        res = http.get(uri.path)
        return ok("Ollama") if res.is_a?(Net::HTTPSuccess)
      end

      warn(
        "Ollama",
        "Ollama is not running. Start it with: docker run -d -p 11434:11434 ollama/ollama"
      )
    rescue
      warn(
        "Ollama",
        "Ollama is not reachable. Is Docker Desktop running?"
      )
    end

    def model_check(model)
      ok("Model #{model}")
    end
  end
end
