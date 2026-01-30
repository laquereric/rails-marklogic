# frozen_string_literal: true

require "rails_marklogic"
require "webmock/rspec"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.before(:each) do
    RailsMarklogic.reset!
    RailsMarklogic.configure do |c|
      c.host     = "localhost"
      c.port     = 8000
      c.username = "admin"
      c.password = "admin"
    end
  end
end
