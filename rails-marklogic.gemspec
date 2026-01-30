# frozen_string_literal: true

require_relative "lib/rails_marklogic/version"

Gem::Specification.new do |spec|
  spec.name          = "rails-marklogic"
  spec.version       = RailsMarklogic::VERSION
  spec.authors       = ["Eric Laquer"]
  spec.email         = ["laquereric@gmail.com"]

  spec.summary       = "Minimal MarkLogic REST client for Rails"
  spec.description   = "Drop-in MarkLogic integration for any Rails app. " \
                        "Service/repository pattern with zero MarkLogic-specific dependencies."
  spec.homepage      = "https://github.com/laquereric/rails-marklogic"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7"

  spec.files         = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.add_dependency "httpclient"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end
