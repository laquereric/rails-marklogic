class SimulatedPolicy < McpPolicy
  def initialize(base_policy)
    @base = base_policy
    super(environment: base_policy.environment, id: :simulated)
  end

  def method_missing(name, *args)
    @base.public_send(name, *args)
  end

  def simulate?
    true
  end
end
