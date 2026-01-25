require "test_helper"

class ShadowAiGuardTest < ActiveSupport::TestCase
  FORBIDDEN_PATTERNS = [ /OpenAI::Client/, /Anthropic/, /Gemini/ ].freeze

  def test_vendor_sdks_are_not_used_directly
    base = Rails.root.to_s
    search_roots = %w[app config lib script bin test]
    paths = search_roots.flat_map do |root|
      Dir.glob(File.join(base, root, "**/*.rb"))
    end

    violations = []

    paths.each do |path|
      text = File.read(path)
      FORBIDDEN_PATTERNS.each do |pattern|
        if text.match?(pattern)
          relative = path.sub("#{base}/", "")
          violations << "#{relative} matched #{pattern.inspect}"
        end
      end
    end

    assert violations.empty?, "Found forbidden LLM usage:\n#{violations.join("\n")}"
  end
end
