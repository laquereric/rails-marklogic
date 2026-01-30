# frozen_string_literal: true

require "rails"

module RailsMarklogic
  class Railtie < Rails::Railtie
    initializer "rails_marklogic.configure" do |_app|
      config_file = Rails.root.join("config", "marklogic.yml")

      if config_file.exist?
        yaml = ERB.new(config_file.read).result
        all_settings = YAML.safe_load(yaml, aliases: true) || {}
        settings = all_settings[Rails.env] || all_settings["default"] || {}

        RailsMarklogic.configure do |config|
          config.host     = settings["host"]          if settings["host"]
          config.port     = settings["port"].to_i     if settings["port"]
          config.username = settings["username"]       if settings["username"]
          config.password = settings["password"]       if settings["password"]
          config.auth     = settings["auth"].to_sym    if settings["auth"]
          config.timeout  = settings["timeout"].to_i   if settings["timeout"]
        end
      end

      RailsMarklogic.configuration.logger ||= Rails.logger
    end
  end
end
