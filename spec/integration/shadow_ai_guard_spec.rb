require "rails_helper"

RSpec.describe "Shadow AI Guard" do
  it "does not allow direct vendor LLM SDK usage outside MCP" do
    forbidden = [ /OpenAI::Client/, /Anthropic/, /Gemini/ ]
    paths = Dir.glob(Rails.root.join("**/*.rb")).reject { |p| p.include?("vendor/mcp-lm") }

    violations = paths.flat_map do |path|
      content = File.read(path)
      forbidden.select { |regex| content.match?(regex) }.map { |r| [ path, r ] }
    end

    expect(violations).to be_empty, "Found forbidden LLM usage: #{violations.inspect}"
  end
end
