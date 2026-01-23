# OpenAI-compatible LLM client wrapper.

class Llm::Client
  def initialize(api_key: ENV.fetch("OPENAI_API_KEY"), model: ENV.fetch("OPENAI_MODEL", "gpt-4o-mini"))
    @client = OpenAI::Client.new(access_token: api_key)
    @model = model
  end

  def call(prompt:, variables: {})
    content = render(prompt, variables)

    response = @client.chat(
      parameters: {
        model: @model,
        messages: [
          { role: "system", content: prompt.system_role },
          { role: "user", content: content }
        ]
      }
    )

    response.dig("choices", 0, "message", "content")
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
