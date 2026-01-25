# OpenAI-compatible LLM client wrapper.

class Llm::Client
  def initialize(policy:)
    @policy = policy
  end

  def call(prompt:, variables: {})
    payload = {
      system: prompt.system_role,
      user: render(prompt, variables)
    }

    result = Mcp::McpLm.call(
      policy: @policy,
      input: payload
    )

    return result if result.is_a?(Dry::Monads::Failure)

    result.value!
  end

  private

  def render(prompt, variables)
    body = format(prompt.user_template, **variables)
    constraints = prompt.constraints.map { |c| "- #{c}" }.join("\n")

    <<~CONTENT
      #{body}

      Constraints:
      #{constraints}
    CONTENT
  end
end
