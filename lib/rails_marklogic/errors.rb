# frozen_string_literal: true

module RailsMarklogic
  class Error < StandardError
    attr_reader :status, :body

    def initialize(message = nil, status: nil, body: nil)
      @status = status
      @body = body
      super(message || "MarkLogic error (HTTP #{status})")
    end

    def self.from_response(response)
      status = response.status
      body = response.body

      klass = case status
              when 400 then BadRequestError
              when 401 then AuthenticationError
              when 404 then NotFoundError
              when 500..599 then ServerError
              else Error
              end

      klass.new(body, status: status, body: body)
    end
  end

  class ConnectionError < Error; end
  class AuthenticationError < Error; end
  class NotFoundError < Error; end
  class BadRequestError < Error; end
  class ServerError < Error; end
end
