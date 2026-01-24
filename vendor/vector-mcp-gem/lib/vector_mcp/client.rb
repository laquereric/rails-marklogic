module VectorMCP
  class Client
    def self.build(server: :default)
      begin
        require "mcp"
      rescue LoadError
        raise LoadError, "Add `gem 'mcp'` to use VectorMCP.client"
      end

      url = VectorMCP.config.servers.fetch(server)

      if VectorMCP.config&.auto_start_server && !Health.server_up?(url)
        VectorMCP::Server.start_async
        sleep 0.5
      end

      MCP::Client.new(url: url)
    end
  end
end
