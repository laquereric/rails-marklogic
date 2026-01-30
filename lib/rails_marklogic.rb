# frozen_string_literal: true

require_relative "rails_marklogic/version"
require_relative "rails_marklogic/configuration"
require_relative "rails_marklogic/errors"
require_relative "rails_marklogic/client"

module RailsMarklogic
  @mutex = Mutex.new

  # Configure the MarkLogic connection.
  #
  #   RailsMarklogic.configure do |config|
  #     config.host     = "localhost"
  #     config.port     = 8000
  #     config.username = "admin"
  #     config.password = "admin"
  #   end
  #
  def self.configure
    yield(configuration)
  end

  # Returns the current configuration.
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Returns a thread-safe singleton client instance.
  def self.client
    @mutex.synchronize do
      @client ||= Client.new(configuration)
    end
  end

  # Reset configuration and client. Useful in tests.
  def self.reset!
    @mutex.synchronize do
      @configuration = nil
      @client = nil
    end
  end

  # --- Convenience delegations ---

  def self.put_document(uri, body, content_type: nil, collections: [])
    client.put_document(uri, body, content_type: content_type, collections: collections)
  end

  def self.get_document(uri)
    client.get_document(uri)
  end

  def self.delete_document(uri)
    client.delete_document(uri)
  end

  def self.eval_xquery(xquery, variables: {})
    client.eval_xquery(xquery, variables: variables)
  end

  def self.eval_javascript(js, variables: {})
    client.eval_javascript(js, variables: variables)
  end

  def self.search(query, options: {})
    client.search(query, options: options)
  end
end

require "rails_marklogic/railtie" if defined?(Rails::Railtie)
