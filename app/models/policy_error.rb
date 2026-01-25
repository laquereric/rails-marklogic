class PolicyError
  attr_reader :code, :message, :policy_id, :environment, :context

  def initialize(code:, message:, policy:, context: {})
    @code = code
    @message = message
    @policy_id = policy.id
    @environment = policy.environment
    @context = context
  end

  def to_h
    {
      code: code,
      message: message,
      policy: policy_id,
      environment: environment,
      context: context
    }
  end
end
