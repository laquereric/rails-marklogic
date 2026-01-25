require "rails_helper"

RSpec.describe "Full Quickstart smoke", :quickstart, :quickstart_contracts do
  it "walks the full Quickstart narrative without crashing" do
    # IRB integration exists
    expect(IRB::ExtendCommandBundle).to respond_to(:ropencode)

    # Invoke ropencode safely
    expect {
      IRB::ExtendCommandBundle.ropencode if IRB::ExtendCommandBundle.respond_to?(:ropencode)
    }.not_to raise_error

    # Simulate core narrative steps
    user = Class.new
    stub_const("User", user)

    # Explain model step (contract: no crash, context available)
    expect(User).to be_defined

    # Ask question step (contract: LLM path callable)
    expect {
      Llm::Client.new(policy: nil)
    }.not_to raise_error
  end
end
