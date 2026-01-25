require "test_helper"

class Mcp::MapTypeTest < ActiveSupport::TestCase
  test "development policy allows untyped input" do
    policy = DevelopmentPolicy.new
    result = Mcp::MapType.call(payload: { foo: "bar" }, policy: policy)
    assert result.success?
  end

  test "production policy rejects untyped input" do
    policy = ProductionPolicy.new
    result = Mcp::MapType.call(payload: { foo: "bar" }, policy: policy)
    assert result.failure?
    assert_equal :untyped_input, result.failure.code
  end
end
