module Mcp
  class AuditLogger
    def self.policy_failure(error)
      Rails.logger.warn("[corr=#{Thread.current[:correlation_id]}] " +
        "[MCP][POLICY] #{error.code} policy=#{error.policy_id} env=#{error.environment} context=#{error.context.inspect}"
      )
    end
  end
end
