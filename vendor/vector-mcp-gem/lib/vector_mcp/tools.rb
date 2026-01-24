module VectorMCP
  module Tools
    @cache = nil

    def self.all(client: VectorMCP.client)
      tools = client.tools
      if VectorMCP.config&.tool_allowlist
        tools = tools.select { |t| VectorMCP.config.tool_allowlist.include?(t["name"]) }
      end
      @cache ||= tools
    end

    def self.reset!
      @cache = nil
    end
  end
end
