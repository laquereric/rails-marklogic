require "rails_helper"

RSpec.describe "LLM defaults", :quickstart do
  it "builds a default LLM client without configuration" do
    expect { Llm::Client.new(policy: nil) }.not_to raise_error
  end
end
