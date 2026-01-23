# Frozen, enumerated prompt patterns for LLM usage.
# This model is intentionally immutable at runtime.

class LlmPrompt
  Prompt = Struct.new(:key, :system_role, :user_template, :constraints, :output_style, keyword_init: true)

  SYSTEM_ROLE = "You are assisting a developer learning MarkLogic. Be precise, factual, and conservative."

  PROMPTS = {
    explain_query: Prompt.new(
      key: :explain_query,
      system_role: SYSTEM_ROLE,
      user_template: <<~TEMPLATE,
        Tutorial: %{tutorial}
        Topic: %{topic}
        Query:
        %{code}

        Explain what this query does and why it behaves this way.
      TEMPLATE
      constraints: [
        "Do not invent execution results",
        "Do not execute queries",
        "Do not modify data"
      ],
      output_style: "Clear, structured explanation"
    ),

    summarize_result: Prompt.new(
      key: :summarize_result,
      system_role: SYSTEM_ROLE,
      user_template: <<~TEMPLATE,
        Tutorial: %{tutorial}
        Topic: %{topic}
        Result:
        %{result}

        Summarize the result and highlight important structures.
      TEMPLATE
      constraints: [
        "No speculation",
        "No recommendations"
      ],
      output_style: "Concise summary"
    ),

    compare_approaches: Prompt.new(
      key: :compare_approaches,
      system_role: SYSTEM_ROLE,
      user_template: <<~TEMPLATE,
        Tutorial: %{tutorial}
        Topic: %{topic}
        Approach A:
        %{a}
        Approach B:
        %{b}

        Compare these approaches neutrally.
      TEMPLATE
      constraints: [
        "Be neutral",
        "Avoid declaring a best option unless asked"
      ],
      output_style: "Side-by-side comparison"
    ),

    teach_concept: Prompt.new(
      key: :teach_concept,
      system_role: SYSTEM_ROLE,
      user_template: <<~TEMPLATE,
        Tutorial: %{tutorial}
        Concept: %{concept}
        Example:
        %{example}

        Teach this concept within the tutorial scope.
      TEMPLATE
      constraints: [
        "Stay within tutorial scope",
        "No external assumptions"
      ],
      output_style: "Educational explanation"
    ),

    suggest_alternatives: Prompt.new(
      key: :suggest_alternatives,
      system_role: SYSTEM_ROLE,
      user_template: <<~TEMPLATE,
        Tutorial: %{tutorial}
        Topic: %{topic}
        Query:
        %{code}

        Suggest alternative approaches. These are suggestions only and must not be executable.
      TEMPLATE
      constraints: [
        "Suggestions only",
        "Must not be executable"
      ],
      output_style: "Labeled suggestions"
    )
  }.freeze

  def self.fetch!(key)
    PROMPTS.fetch(key)
  end
end
