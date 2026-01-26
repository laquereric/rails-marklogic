require "test_helper"
require "open3"
require "json"

unless defined?(Mcp::JsonLd)
  module Mcp
    module JsonLd
      DEFAULT_CONTEXT = {
        "@vocab" => "http://example.com/mcp#"
      }.freeze

      def self.ensure_context(payload)
        return payload if payload.key?("@context")

        payload.merge("@context" => DEFAULT_CONTEXT)
      end
    end
  end
end

class McpLlmProbeTest < ActiveSupport::TestCase
  def setup
    skip "script/llm missing" unless File.executable?(llm_script)
    skip "ollama missing" unless system("which ollama >/dev/null 2>&1")
  end

  def test_cli_probe_matches_mcp
    env = { "LLM_CONFIG_PATH" => llm_config_path.to_s }

    stdout, stderr, status = Open3.capture3(
      env,
      llm_script.to_s,
      "probe",
      "--system", system_prompt,
      "--user", user_prompt,
      "--json"
    )

    assert status.success?, "llm probe failed: #{stderr}"

    probe = JSON.parse(stdout)

    result = Mcp::McpLm.call(
      policy: DevelopmentPolicy.new,
      input: {
        "system" => system_prompt,
        "user" => user_prompt
      }
    )

    assert result.success?, "Mcp::McpLm failed: #{result.inspect}"

    cli_response = probe.fetch("response").to_s
    mcp_response = result.value!.fetch("content").to_s

    assert_equal normalize_response(cli_response), normalize_response(mcp_response)
  end

  private

  def llm_script
    Rails.root.join("script/llm")
  end

  def llm_config_path
    Rails.root.join("config/llm.toml")
  end

  def system_prompt
    "You are verifying that the local MCP LLM gateway can reach its configured model. Respond succinctly."
  end

  def user_prompt
    "Reply with the text 'probe-ok'."
  end

  def normalize_response(value)
    value.to_s.strip.downcase
  end
end
