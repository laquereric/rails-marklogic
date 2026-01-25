class McpPolicy
  attr_reader :environment, :id

  def initialize(environment:, id: nil)
    @environment = environment.to_sym
    @id = id || environment
  end

  def allow_untyped?(direction)
    false
  end

  def allow_type_creation?
    false
  end

  def allow_type_inference?
    false
  end
end
