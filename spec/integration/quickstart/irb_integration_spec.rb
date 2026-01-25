require "rails_helper"

RSpec.describe "IRB integration", :quickstart do
  it "registers the ropencode command in IRB" do
    expect(IRB::ExtendCommandBundle).to respond_to(:ropencode)
  end

  it "does not raise unhandled exceptions when invoking ropencode" do
    expect { IRB::ExtendCommandBundle.ropencode if IRB::ExtendCommandBundle.respond_to?(:ropencode) }.not_to raise_error
  end
end
