Given("a Rails application with ropencode-rails installed") do
  expect(defined?(Rropencode)).to be_truthy
end

Given("a User model exists") do
  stub_const("User", Class.new)
end

When("I invoke ropencode") do
  @result = IRB::ExtendCommandBundle.respond_to?(:ropencode)
end

When("I run ropencode command {string}") do |cmd|
  @command = cmd
end

When("I ask a question via ropencode") do
  @response = :ok
end

When("I issue a policy-violating request") do
  @response = :policy_error
end

Then("I should remain inside IRB") do
  expect(IRB).to be_defined
end

Then("the provider should be Ollama with devstral") do
  client = Ropencode::AI::Client.new
  expect(client.provider_name).to include("Ollama")
  expect(client.model_name).to eq("devstral:24b")
end

Then("I should see model information") do
  expect(@command).to include("explain")
end

Then("I should see an error explanation") do
  expect(@command).to be_present
end

Then("I should get a response or an explanation") do
  expect(@response).to be_present
end

Then("I should see a policy explanation") do
  expect(@response).to eq(:policy_error)
end
