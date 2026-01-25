require "securerandom"

module Mcp
  class Doctor
    def self.capabilities
      {
        "audit_logging" => true,
        "kill_switch" => true,
        "local_llm" => true,
        "cloud_llm" => true
      }
    end

    def self.run(context: {}, format: nil)
      result = new.run(context:)
      return result.to_json if format == :json

      result
    end

    def self.ui_resources(context: {})
      result = run(context:)
      Report.new(answer_id: context[:answer_id], findings: result[:findings]).to_ui_resources
    end

    def run(context: {})
      @answer_id = context[:answer_id]

      if ENV["MCP_LLM_DISABLED"] == "true"
        return report(
          provider: "disabled",
          model: nil,
          findings: [ warn("LLM", "LLM usage is disabled by configuration") ]
        )
      end

      provider = Providers::AutoProvider.new

      findings = []
      findings.concat(environment_checks(provider))
      findings.concat(diagnostic_checks(context))

      report(
        provider: provider.provider_name,
        model: provider.model_name,
        findings: findings
      )
    end

    private

    def report(provider:, model:, findings:)
      findings.each { |finding| persist_finding(finding) }

      {
        provider: provider,
        model: model,
        capabilities: self.class.capabilities,
        findings: findings
      }
    end

    def environment_checks(provider)
      checks = []
      checks << ok("Rails")

      if provider.provider_name.include?("Ollama")
        checks << ollama_check
        checks << model_check(provider.model_name)
      else
        checks << ok("OpenAI configured")
      end

      checks
    end

    def diagnostic_checks(context)
      findings = []
      artifact = context[:artifact]
      return findings unless artifact

      if artifact.start_with?("vendor/knowledge_artifacts/domains/")
        findings << accept(
          artifact: artifact,
          message: "Artifact accepted as domain-scoped reference"
        )
        return findings
      end

      if artifact.start_with?("vendor/knowledge_artifacts/")
        findings << reject(
          artifact: artifact,
          reason: :out_of_scope,
          message: "Artifact is part of the knowledge playground and is illustrative-only"
        )

        if context[:effective_date].nil?
          findings << reject(
            artifact: artifact,
            reason: :temporal_invalidity,
            message: "Artifact has no effective date and cannot be trusted temporally"
          )
        end
      end

      findings
    end

    def accept(artifact:, message:)
      {
        id: SecureRandom.uuid,
        type: :authority_evidence,
        artifact: artifact,
        answer_id: @answer_id,
        outcome: :accepted,
        message: message,
        recorded_at: Time.now.utc
      }
    end

    def reject(artifact:, reason:, message:)
      {
        id: SecureRandom.uuid,
        type: :authority_evidence,
        artifact: artifact,
        answer_id: @answer_id,
        outcome: :rejected,
        reason: reason,
        message: message,
        recorded_at: Time.now.utc
      }
    end

    def ok(name)
      { name: name, status: :ok }
    end

    def persist_finding(finding)
      return finding unless defined?(MarkLogic)

      client = MarkLogic::Client.default
      id = finding[:id] ||= SecureRandom.uuid
      uri = "/mcp/doctor/findings/#{id}.json"

      client.write(
        uri,
        finding.merge(type: :doctor_finding),
        collections: [ "mcp-doctor-findings" ],
        permissions: [ "rest-reader", "rest-writer" ]
      )

      finding
    rescue => e
      warn("Doctor Persistence", e.message)
    end

    # --- Query helpers ---
    def self.find_rejections(artifact: nil)
      return [] unless defined?(MarkLogic)

      query = {
        type: :doctor_finding,
        outcome: :rejected
      }
      query[:artifact] = artifact if artifact

      MarkLogic::Client.default.search(query, collection: "mcp-doctor-findings")
    end

    def warn(name, message)
      { name: name, status: :warn, message: message }
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
