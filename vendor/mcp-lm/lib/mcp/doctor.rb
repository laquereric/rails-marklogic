require "json"
require "securerandom"
require "time"

module Mcp
  class Doctor
    def self.run(context: {}, format: :hash)
      report = new(context: context).run
      format == :json ? JSON.pretty_generate(report) : report
    end

    def self.capabilities
      new.capabilities
    end

    def self.find_rejections(artifact: nil)
      return [] unless defined?(MarkLogic)

      query = {
        type: :doctor_finding,
        outcome: :rejected
      }
      query[:artifact] = artifact if artifact

      MarkLogic::Client.default.search(query, collection: "mcp-doctor-findings")
    end

    def initialize(context: {})
      @context = context
      @answer_id = context[:answer_id]
    end

    def run
      return disabled_report if kill_switch_enabled?

      provider = safe_provider

      return provider_error_report if provider.nil?

      checks = environment_checks(provider)
      diagnostics = diagnostic_checks

      persist_all(diagnostics)

      report = {
        provider: provider.provider_name,
        model: provider.model_name,
        checks: checks,
        diagnostics: diagnostics,
        capabilities: capabilities_for(provider),
        generated_at: Time.now.utc.iso8601
      }

      report[:findings] = checks
      report
    end

    def capabilities
      base = {
        "audit_logging" => true,
        "kill_switch" => kill_switch_enabled?
      }

      return base.merge("local_llm" => false, "cloud_llm" => false) if kill_switch_enabled?

      provider = safe_provider
      return base.merge("local_llm" => false, "cloud_llm" => false) if provider.nil?

      base.merge(capabilities_for(provider))
    end

    private

    def disabled_report
      warning = warn("LLM", "LLM usage is disabled by configuration")

      report = {
        provider: "disabled",
        model: nil,
        checks: [ warning ],
        diagnostics: [],
        capabilities: {
          "local_llm" => false,
          "cloud_llm" => false,
          "audit_logging" => true,
          "kill_switch" => true
        },
        generated_at: Time.now.utc.iso8601
      }
      report[:findings] = report[:checks]
      report
    end

    def capabilities_for(provider)
      name = provider.provider_name.to_s.downcase

      {
        "provider" => provider.provider_name,
        "model" => provider.model_name,
        "local_llm" => name.include?("ollama"),
        "cloud_llm" => name.include?("openai"),
        "audit_logging" => true,
        "kill_switch" => kill_switch_enabled?
      }
    end

    def provider_error_report
      warning = warn("LLM Provider", @provider_error || "No provider available")

      report = {
        provider: "unavailable",
        model: nil,
        checks: [ warning ],
        diagnostics: [],
        capabilities: {
          "local_llm" => false,
          "cloud_llm" => false,
          "audit_logging" => true,
          "kill_switch" => kill_switch_enabled?
        },
        generated_at: Time.now.utc.iso8601
      }
      report[:findings] = report[:checks]
      report
    end

    def safe_provider
      Providers::AutoProvider.new
    rescue => e
      @provider_error = e.message
      nil
    end

    def kill_switch_enabled?
      ENV["MCP_LLM_DISABLED"] == "true"
    end

    def environment_checks(provider)
      checks = []
      checks << ok("Rails")

      if provider.provider_name.to_s.include?("Ollama")
        checks << ollama_check
        checks << model_check(provider.model_name)
      else
        checks << ok("OpenAI configured")
      end

      checks
    end

    def diagnostic_checks
      findings = []
      artifact = @context[:artifact]
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

        if @context[:effective_date].nil?
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

    def warn(name, message)
      { name: name, status: :warn, message: message }
    end

    def persist_all(findings)
      findings.each { |finding| persist_finding(finding) }
    end

    def persist_finding(finding)
      return unless defined?(MarkLogic)

      client = MarkLogic::Client.default
      uri = "/mcp/doctor/findings/#{SecureRandom.uuid}.json"

      client.write(
        uri,
        finding.merge(type: :doctor_finding),
        collections: [ "mcp-doctor-findings" ],
        permissions: [ "rest-reader", "rest-writer" ]
      )
    rescue => e
      warn("Doctor Persistence", e.message)
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
