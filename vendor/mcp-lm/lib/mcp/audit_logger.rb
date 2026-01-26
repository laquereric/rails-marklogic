module Mcp
  class AuditLogger
    def self.policy_failure(error)
      Rails.logger.warn("[corr=#{Thread.current[:correlation_id]}] " +
        "[MCP][POLICY] #{error.code} policy=#{error.policy_id} env=#{error.environment} context=#{error.context.inspect}"
      )
    end

    def self.llm_call(provider:, model:, intent:)
      return unless Rails.env.development?

      Rails.logger.info(
        "[MCP][LLM] intent=#{intent} provider=#{provider} model=#{model}"
      )
    end
  end
end
