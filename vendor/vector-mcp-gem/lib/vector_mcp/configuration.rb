module VectorMCP
  class Configuration
    attr_accessor :default_index_path, :auto_start_server,
                  :strict_contracts, :admin_read_only,
                  :tool_allowlist, :servers

    def initialize
      @default_index_path = "./storage/vector"
      @auto_start_server = false
      @strict_contracts = false
      @admin_read_only = true
      @tool_allowlist = nil
      @servers = { default: "http://localhost:3333" }
    end
  end
end
