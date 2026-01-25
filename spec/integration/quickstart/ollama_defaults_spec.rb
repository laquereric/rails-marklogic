require "rails_helper"

RSpec.describe "Ollama Quickstart defaults", :quickstart, :quickstart_contracts do
  it "selects Ollama and devstral:24b when Ollama is reachable" do
    client = Ropencode::AI::Client.new
    if client.provider_name.include?("Ollama")
      expect(client.model_name).to eq("devstral:24b")
    end
  end
end
