module VectorMCP
  class Tool
    attr_reader :name, :description, :schema, :client

    def initialize(tool_hash, client)
      @name = tool_hash["name"]
      @description = tool_hash["description"]
      @schema = tool_hash["input_schema"] || {}
      @client = client
    end

    def call(**args)
      validate!(args) if VectorMCP.config&.strict_contracts
      result = client.call_tool(name, coerce(args))
      Audit.log(tool: name, args: args, result: result)
      result
    end

    def validate!(args)
      return unless schema["properties"]
      missing = schema["required"].to_a - args.keys.map(&:to_s)
      raise ArgumentError, "Missing required args: #{missing.join(', ')}" if missing.any?
    end

    def coerce(args)
      return args unless schema["properties"]

      args.transform_values do |value|
        case value
        when String
          value
        when Numeric, TrueClass, FalseClass, Array, Hash
          value
        else
          value.to_s
        end
      end
    end
  end
end
