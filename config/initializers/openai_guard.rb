if defined?(OpenAI::Client)
  OpenAI::Client.prepend(Module.new do
    def initialize(*args, **kwargs)
      caller_path = caller_locations(1, 5).map(&:path)
      allowed = caller_path.any? { |p| p.include?("/app/services/mcp") }

      unless allowed
        raise "Direct OpenAI::Client usage is forbidden. Use Mcp::McpLm instead."
      end

      super
    end
  end)
end
