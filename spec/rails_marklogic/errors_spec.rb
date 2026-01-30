# frozen_string_literal: true

require "spec_helper"

RSpec.describe RailsMarklogic::Error do
  def fake_response(status, body = "error")
    double("response", status: status, body: body)
  end

  describe ".from_response" do
    it "returns BadRequestError for 400" do
      err = described_class.from_response(fake_response(400, "bad request"))
      expect(err).to be_a(RailsMarklogic::BadRequestError)
      expect(err.status).to eq(400)
      expect(err.body).to eq("bad request")
    end

    it "returns AuthenticationError for 401" do
      err = described_class.from_response(fake_response(401))
      expect(err).to be_a(RailsMarklogic::AuthenticationError)
    end

    it "returns NotFoundError for 404" do
      err = described_class.from_response(fake_response(404))
      expect(err).to be_a(RailsMarklogic::NotFoundError)
    end

    it "returns ServerError for 500" do
      err = described_class.from_response(fake_response(500))
      expect(err).to be_a(RailsMarklogic::ServerError)
    end

    it "returns ServerError for 503" do
      err = described_class.from_response(fake_response(503))
      expect(err).to be_a(RailsMarklogic::ServerError)
    end

    it "returns base Error for unknown status" do
      err = described_class.from_response(fake_response(418, "teapot"))
      expect(err).to be_a(RailsMarklogic::Error)
      expect(err).not_to be_a(RailsMarklogic::ServerError)
    end
  end
end
