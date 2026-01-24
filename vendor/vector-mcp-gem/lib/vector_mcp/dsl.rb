module VectorMCP
  module DSL
    def self.build(client: VectorMCP.client, namespace: Module.new)
      tools = VectorMCP::Tools.all(client: client)

      tools.each do |tool_hash|
        tool = Tool.new(tool_hash, client)
        method_name = tool.name.to_s.gsub("-", "_")

        namespace.define_singleton_method(method_name) do |**args|
          tool.call(**args)
        end

        namespace.define_singleton_method("#{method_name}_tool") do
          tool
        end
      end

      namespace
    end

    def self.with_tools(client: VectorMCP.client)
      mod = build(client: client, namespace: Module.new)
      yield(mod)
    end
  end
end
  end
end
