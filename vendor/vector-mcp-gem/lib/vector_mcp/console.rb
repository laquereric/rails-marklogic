module VectorMCP
  module Console
    def mcp
      @mcp ||= VectorMCP::DSL.build
    end
  end
end
