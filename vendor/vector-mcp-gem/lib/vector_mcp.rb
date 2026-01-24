require "vector_mcp/runner"
require "vector_mcp/api"
require "vector_mcp/configuration"
require "vector_mcp/railtie"
require "vector_mcp/jobs"
require "vector_mcp/server"
require "vector_mcp/client"
require "vector_mcp/health"
require "vector_mcp/tools"
require "vector_mcp/dsl"
require "vector_mcp/tool"
require "vector_mcp/docs"
require "vector_mcp/console"

module VectorMCP
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config)
  end

  def self.run(*args, **opts)
    API.run(*args, **opts)
  end

  def self.client(url: "http://localhost:3333")
    Client.build(url: url)
  end
end
