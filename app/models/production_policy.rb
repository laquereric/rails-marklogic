class ProductionPolicy < McpPolicy
  def initialize
    super(environment: :production, id: :production)
  end
end
