# frozen_string_literal: true

require "spec_helper"

RSpec.describe RailsMarklogic do
  describe ".configure" do
    it "yields the configuration" do
      described_class.configure do |config|
        config.host = "custom-host"
        config.port = 9999
      end

      expect(described_class.configuration.host).to eq("custom-host")
      expect(described_class.configuration.port).to eq(9999)
    end
  end

  describe ".configuration" do
    it "returns a Configuration instance" do
      expect(described_class.configuration).to be_a(RailsMarklogic::Configuration)
    end

    it "returns the same instance on repeated calls" do
      expect(described_class.configuration).to equal(described_class.configuration)
    end
  end

  describe ".client" do
    it "returns a Client instance" do
      expect(described_class.client).to be_a(RailsMarklogic::Client)
    end

    it "returns the same instance on repeated calls" do
      expect(described_class.client).to equal(described_class.client)
    end
  end

  describe ".reset!" do
    it "clears configuration and client" do
      old_config = described_class.configuration
      old_client = described_class.client

      described_class.reset!
      # Re-configure since reset clears config
      described_class.configure do |c|
        c.host = "localhost"
        c.port = 8000
        c.username = "admin"
        c.password = "admin"
      end

      expect(described_class.configuration).not_to equal(old_config)
      expect(described_class.client).not_to equal(old_client)
    end
  end

  describe "convenience delegations" do
    let(:mock_client) { instance_double(RailsMarklogic::Client) }

    before do
      allow(described_class).to receive(:client).and_return(mock_client)
    end

    it "delegates put_document" do
      expect(mock_client).to receive(:put_document).with("/u/1.json", "{}", content_type: nil, collections: [])
      described_class.put_document("/u/1.json", "{}")
    end

    it "delegates get_document" do
      expect(mock_client).to receive(:get_document).with("/u/1.json")
      described_class.get_document("/u/1.json")
    end

    it "delegates delete_document" do
      expect(mock_client).to receive(:delete_document).with("/u/1.json")
      described_class.delete_document("/u/1.json")
    end

    it "delegates eval_xquery" do
      expect(mock_client).to receive(:eval_xquery).with("1+1", variables: {})
      described_class.eval_xquery("1+1")
    end

    it "delegates eval_javascript" do
      expect(mock_client).to receive(:eval_javascript).with("1+1", variables: {})
      described_class.eval_javascript("1+1")
    end

    it "delegates search" do
      expect(mock_client).to receive(:search).with("test", options: {})
      described_class.search("test")
    end
  end
end
