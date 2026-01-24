require "rails"

module VectorMCP
  class Railtie < Rails::Railtie
    initializer "vector_mcp.configure" do
      VectorMCP.config ||= Configuration.new
    end

    console do
      TOPLEVEL_BINDING.eval('self').extend(VectorMCP::Console)
    end
  end
end
