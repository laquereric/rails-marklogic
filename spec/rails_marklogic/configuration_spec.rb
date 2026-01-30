# frozen_string_literal: true

require "spec_helper"

RSpec.describe RailsMarklogic::Configuration do
  subject(:config) { described_class.new }

  it "has sensible defaults" do
    expect(config.host).to eq("localhost")
    expect(config.port).to eq(8000)
    expect(config.username).to eq("admin")
    expect(config.password).to eq("admin")
    expect(config.auth).to eq(:digest)
    expect(config.timeout).to eq(30)
    expect(config.logger).to be_nil
  end

  it "computes base_url from host and port" do
    expect(config.base_url).to eq("http://localhost:8000")
  end

  it "allows setting attributes" do
    config.host = "ml-server"
    config.port = 9000
    expect(config.base_url).to eq("http://ml-server:9000")
  end

  context "with environment variables" do
    around do |example|
      original = ENV.to_h.slice("MARKLOGIC_HOST", "MARKLOGIC_PORT", "MARKLOGIC_USERNAME", "MARKLOGIC_PASSWORD")
      ENV["MARKLOGIC_HOST"]     = "env-host"
      ENV["MARKLOGIC_PORT"]     = "9999"
      ENV["MARKLOGIC_USERNAME"] = "env-user"
      ENV["MARKLOGIC_PASSWORD"] = "env-pass"
      example.run
    ensure
      original.each { |k, v| v ? ENV[k] = v : ENV.delete(k) }
    end

    it "reads from ENV" do
      cfg = described_class.new
      expect(cfg.host).to eq("env-host")
      expect(cfg.port).to eq(9999)
      expect(cfg.username).to eq("env-user")
      expect(cfg.password).to eq("env-pass")
    end
  end
end
