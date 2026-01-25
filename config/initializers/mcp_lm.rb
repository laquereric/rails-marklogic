# Ensure vendored mcp-lm is on the load path
$LOAD_PATH.unshift(Rails.root.join("vendor/mcp-lm/lib").to_s)
require "mcp"
