module LlmHelper
  def llm_panel(prompt_key, variables = {})
    client = Llm::Client.new
    prompt = LlmPrompt.fetch!(prompt_key)
    content = client.call(prompt: prompt, variables: variables)
    render partial: "shared/llm_panel", locals: { content: content }
  end
end
