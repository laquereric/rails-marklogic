module Mcp
  class Provider
    def provider_name
      self.class.name
    end

    def model_name
      nil
    end
  end
end
