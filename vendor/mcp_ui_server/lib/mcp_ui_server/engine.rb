require "rails"

module McpUiServer
  class Engine < ::Rails::Engine
    isolate_namespace McpUiServer
  end
end
