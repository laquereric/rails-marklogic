class DevelopmentPolicy < McpPolicy
  def initialize
    super(environment: :development, id: :development)
  end

  def allow_untyped?(_direction)
    true
  end

  def allow_type_creation?
    true
  end

  def allow_type_inference?
    true
  end
end
