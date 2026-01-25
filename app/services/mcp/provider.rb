module Mcp
  class Provider
    def chat(messages:, **_opts)
      raise NotImplementedError
    end
  end
end
