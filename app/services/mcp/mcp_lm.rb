module Mcp
  class McpLm
    include Mcp::Monads

    def self.call(policy:, input:, expected_output_type: nil, **llm_args)
      new(policy, input, expected_output_type, llm_args).call
    end

    def initialize(policy, input, expected_output_type, llm_args)
      @policy = policy
      @input  = input
      @expected_output_type = expected_output_type
      @llm_args = llm_args
    end

    def call
      return missing_policy unless @policy

      typed_input = MapType.call(payload: @input, policy: @policy)
      if typed_input.is_a?(Failure)
        Mcp::AuditLogger.policy_failure(typed_input.failure)
        return typed_input
      end

      llm_result = call_llm(typed_input.value!)
      return llm_result if llm_result.is_a?(Failure)

      typed_output = MapType.call(payload: llm_result.value!, policy: @policy)
      if typed_output.is_a?(Failure)
        Mcp::AuditLogger.policy_failure(typed_output.failure)
        return typed_output
      end

      enforce_expected_output_type(typed_output)
    end

    private

     def call_llm(typed_payload)
       if ENV["MCP_LLM_DISABLED"] == "true"
         return Failure(
           PolicyError.new(
             code: :llm_disabled,
             message: "LLM usage is disabled by configuration",
             policy: @policy
           )
         )
       end
       provider = Mcp::Providers::AutoProvider.new

       Mcp::AuditLogger.llm_call(
         provider: provider.provider_name,
         model: provider.model_name,
         intent: @policy&.id || "unknown"
       )

       response = provider.chat(
        messages: [
          { role: "system", content: typed_payload["system"] },
          { role: "user", content: typed_payload["user"] }
        ]
      )

      content = response.dig("choices", 0, "message", "content")

      Success({ "content" => content })
    rescue => e
      Failure(
        PolicyError.new(
          code: :llm_failure,
          message: e.message,
          policy: @policy
        )
      )
    end

    def enforce_expected_output_type(result)
      return result unless @expected_output_type

      if result.value!["@id"] == @expected_output_type
        result
      else
        Failure(
          PolicyError.new(
            code: :output_type_mismatch,
            message: "Output type does not match expected type",
            policy: @policy,
            context: { expected: @expected_output_type, actual: result.value!["@id"] }
          )
        )
      end
    end

    def missing_policy
      Failure(
        PolicyError.new(
          code: :missing_policy,
          message: "McpPolicy is required for all LLM calls",
          policy: OpenStruct.new(id: nil, environment: nil)
        )
      )
    end
  end
end
