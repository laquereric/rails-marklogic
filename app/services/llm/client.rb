# OpenAI-compatible LLM client wrapper.
#
# This class is a thin application-level adapter around the MCP LLM layer.
# It is responsible for:
# - Rendering prompt templates with variables
# - Applying policy-scoped execution
# - Normalizing inputs/outputs for Rails callers
#
# It deliberately does NOT:
# - Manage provider configuration
# - Perform retries or streaming
# - Encode domain semantics (those live in prompts and policies)
#
# Treat this as an orchestration boundary, not an AI abstraction.
#
# Example:
#   prompt = Prompts::ExplainModel.new
#   client = Llm::Client.new(policy: Policies::Default)
#
#   response = client.call(
#     prompt: prompt,
#     variables: { model: "User" }
#   )
#
#   puts response
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
