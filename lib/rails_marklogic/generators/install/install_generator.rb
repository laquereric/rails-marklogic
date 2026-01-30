# frozen_string_literal: true

require "rails/generators"

module RailsMarklogic
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Creates config/marklogic.yml and an optional initializer for RailsMarklogic"

      def copy_config_file
        template "marklogic.yml", "config/marklogic.yml"
      end

      def copy_initializer
        template "marklogic_initializer.rb", "config/initializers/rails_marklogic.rb"
      end

      def print_instructions
        say ""
        say "RailsMarklogic installed!", :green
        say "  Configure your connection in config/marklogic.yml"
        say "  or set MARKLOGIC_HOST, MARKLOGIC_PORT, MARKLOGIC_USERNAME, MARKLOGIC_PASSWORD."
        say ""
      end
    end
  end
end
