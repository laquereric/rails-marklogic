# frozen_string_literal: true

module RailsMarklogic
  class Configuration
    attr_accessor :host, :port, :username, :password, :auth, :timeout, :logger

    def initialize
      @host     = ENV.fetch("MARKLOGIC_HOST", "localhost")
      @port     = ENV.fetch("MARKLOGIC_PORT", 8000).to_i
      @username = ENV.fetch("MARKLOGIC_USERNAME", "admin")
      @password = ENV.fetch("MARKLOGIC_PASSWORD", "admin")
      @auth     = :digest
      @timeout  = 30
      @logger   = nil
    end

    def base_url
      "http://#{host}:#{port}"
    end
  end
end
