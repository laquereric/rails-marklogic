Gem::Specification.new do |spec|
  spec.name          = "pdf_to_json"
  spec.version       = "0.5.0"
  spec.authors       = [ "Eric Laquer" ]
  spec.summary       = "PDF extraction and LLM-based JSON converter"
  spec.files         = Dir["lib/**/*.rb"]
  spec.require_paths = [ "lib" ]

  spec.add_dependency "pdf-reader", "~> 2.15"
  spec.add_dependency "json", "~> 2.18"
end
