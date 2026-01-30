# frozen_string_literal: true

require "spec_helper"

RSpec.describe RailsMarklogic::Client do
  let(:base) { "http://localhost:8000" }
  let(:client) { described_class.new }

  describe "#put_document" do
    it "PUTs a document and returns true" do
      stub_request(:put, "#{base}/v1/documents?uri=%2Fusers%2F1.json")
        .with(body: '{"name":"Eric"}', headers: { "Content-Type" => "application/json" })
        .to_return(status: 201)

      result = client.put_document("/users/1.json", '{"name":"Eric"}', content_type: "application/json")
      expect(result).to be true
    end

    it "auto-detects JSON content type" do
      stub_request(:put, "#{base}/v1/documents?uri=%2Fdoc.json")
        .with(headers: { "Content-Type" => "application/json" })
        .to_return(status: 201)

      client.put_document("/doc.json", '{"key":"value"}')
    end

    it "auto-detects XML content type" do
      stub_request(:put, "#{base}/v1/documents?uri=%2Fdoc.xml")
        .with(headers: { "Content-Type" => "application/xml" })
        .to_return(status: 201)

      client.put_document("/doc.xml", "<root/>")
    end

    it "defaults to octet-stream for binary" do
      stub_request(:put, "#{base}/v1/documents?uri=%2Ffile.bin")
        .with(headers: { "Content-Type" => "application/octet-stream" })
        .to_return(status: 201)

      client.put_document("/file.bin", "\x00\x01\x02")
    end

    it "sends collections as query params" do
      stub_request(:put, /v1\/documents/)
        .to_return(status: 201)

      result = client.put_document("/doc.json", "{}", collections: ["col1", "col2"])
      expect(result).to be true
      # Note: WebMock's httpclient adapter normalizes duplicate query params,
      # so we verify the URL building logic directly instead.
    end

    it "builds correct query string with collections" do
      query = client.send(:build_query, "/doc.json", collections: ["col1", "col2"])
      expect(query).to include("collection=col1")
      expect(query).to include("collection=col2")
      expect(query).to include("uri=%2Fdoc.json")
    end

    it "raises Error on failure" do
      stub_request(:put, /v1\/documents/).to_return(status: 500, body: "server error")

      expect { client.put_document("/fail.json", "{}") }
        .to raise_error(RailsMarklogic::ServerError)
    end
  end

  describe "#get_document" do
    it "returns the document body" do
      stub_request(:get, "#{base}/v1/documents?uri=%2Fusers%2F1.json")
        .to_return(status: 200, body: '{"name":"Eric"}')

      body = client.get_document("/users/1.json")
      expect(body).to eq('{"name":"Eric"}')
    end

    it "raises NotFoundError for 404" do
      stub_request(:get, /v1\/documents/).to_return(status: 404, body: "not found")

      expect { client.get_document("/missing.json") }
        .to raise_error(RailsMarklogic::NotFoundError)
    end
  end

  describe "#delete_document" do
    it "DELETEs a document and returns true" do
      stub_request(:delete, "#{base}/v1/documents?uri=%2Fusers%2F1.json")
        .to_return(status: 204)

      result = client.delete_document("/users/1.json")
      expect(result).to be true
    end
  end

  describe "#eval_xquery" do
    it "POSTs xquery and returns stripped body" do
      stub_request(:post, "#{base}/v1/eval")
        .with(body: hash_including("xquery" => "fn:current-dateTime()"))
        .to_return(status: 200, body: "  2026-01-30T12:00:00  ")

      result = client.eval_xquery("fn:current-dateTime()")
      expect(result).to eq("2026-01-30T12:00:00")
    end

    it "passes variables" do
      stub_request(:post, "#{base}/v1/eval")
        .with(body: hash_including("xquery" => "$x", "vars" => hash_including("x" => "42")))
        .to_return(status: 200, body: "42")

      result = client.eval_xquery("$x", variables: { x: 42 })
      expect(result).to eq("42")
    end
  end

  describe "#eval_javascript" do
    it "POSTs javascript and returns stripped body" do
      stub_request(:post, "#{base}/v1/eval")
        .with(body: hash_including("javascript" => "1 + 1"))
        .to_return(status: 200, body: "2")

      result = client.eval_javascript("1 + 1")
      expect(result).to eq("2")
    end
  end

  describe "#search" do
    it "GETs search results" do
      stub_request(:get, "#{base}/v1/search?q=hello")
        .to_return(status: 200, body: '{"results":[]}')

      result = client.search("hello")
      expect(result).to eq('{"results":[]}')
    end

    it "passes extra options as query params" do
      stub_request(:get, /v1\/search/)
        .to_return(status: 200, body: "{}")

      client.search("test", options: { format: "json", pageLength: "10" })

      expect(WebMock).to have_requested(:get, /format=json/).once
      expect(WebMock).to have_requested(:get, /pageLength=10/).once
    end
  end

  describe "error handling" do
    it "raises AuthenticationError for 401" do
      stub_request(:get, /v1\/documents/).to_return(status: 401, body: "unauthorized")

      expect { client.get_document("/test") }
        .to raise_error(RailsMarklogic::AuthenticationError)
    end
  end
end
