Gem::Specification.new do |spec|
  spec.name          = "mcp-lm"
  spec.version       = "0.3.0"
  spec.authors       = [ "Vendored" ]
  spec.email         = [ "dev@example.com" ]

  spec.summary       = "MCP language model integration"
  spec.description   = "Vendored copy of the mcp-lm gem used by this application."
  spec.homepage      = "https://example.com/mcp-lm"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7"

  spec.files         = Dir.glob("**/*").reject { |f| f.end_with?(".gemspec") }
  spec.require_paths = [ "lib" ]

  # Runtime dependencies (add as needed)
  # spec.add_dependency "some-gem", ">= 1.0"

  # Development dependencies (not typically used for vendored gems)
end
