module McpPolicyContext
  extend ActiveSupport::Concern

  included do
    helper_method :current_mcp_policy
  end

  def current_mcp_policy
    @current_mcp_policy ||= if Rails.env.production?
      ProductionPolicy.new
    else
      DevelopmentPolicy.new
    end
  end
end
