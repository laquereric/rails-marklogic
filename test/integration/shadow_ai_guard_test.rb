require "test_helper"

class ShadowAiGuardTest < ActiveSupport::TestCase
  FORBIDDEN_PATTERNS = [ /OpenAI::Client/, /Anthropic/, /Gemini/ ].freeze

  def test_vendor_sdks_are_not_used_directly
    base = Rails.root.to_s
    search_roots = %w[app config lib script bin test]
    allowlist = [
      "app/services/mcp/",
      "config/initializers/openai_guard.rb",
      "test/integration/shadow_ai_guard_test.rb"
    ]

    paths = search_roots.flat_map do |root|
      Dir.glob(File.join(base, root, "**/*.rb"))
    end

    paths.reject! do |path|
      relative = path.sub("#{base}/", "")
      allowlist.any? { |allowed| relative.start_with?(allowed) }
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
