require "test_helper"
require "json"

class McpApiContractTest < ActiveSupport::TestCase
  def test_docs_reference_current_version
    doc = File.read(Rails.root.join("MCP_API.md"))
    assert_includes doc, Mcp::MCP_API_VERSION
  end

  def test_doctor_capabilities_shape
    capabilities = Mcp::Doctor.capabilities

    %w[audit_logging kill_switch local_llm cloud_llm].each do |key|
      assert capabilities.key?(key), "Expected capabilities to include #{key}"
    end
  end

  def test_doctor_json_format
    json = Mcp::Doctor.run(format: :json)
    payload = JSON.parse(json)

    assert_kind_of Array, payload.fetch("findings")
    assert payload.key?("capabilities"), "Expected capabilities to be present"
  end
end
