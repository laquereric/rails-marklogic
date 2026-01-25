# MCP API Contract (v1.0)

## Overview
`Mcp::McpLm` and `Mcp::Doctor` form the public surface of the Model Control Plane. Consumers **must only** interact with these entry points. All other classes under `Mcp::*` are internal implementation details and can change without notice.

## Public Entry Points
- `Mcp::McpLm.call(policy:, input:, expected_output_type: nil, **kwargs)` — primary LLM invocation path.
- `Mcp::Doctor.run(context: {}, format: :hash | :json)` — readiness report and diagnostics.
- `Mcp::Doctor.capabilities` — capability introspection for UIs and automation.

## Stability Guarantees
- The interface above is locked to `MCP_API_VERSION = "1.0"`.
- Breaking changes require bumping the version constant and updating this document.
- Optional keyword arguments may be added, but existing arguments will not be removed within the same major version.

## Deprecation Policy
- Deprecated parameters or behaviors will be announced in the changelog with a migration timeline.
- Code paths marked as internal (any constant outside this list) may change at any time without a deprecation window.

## Testing & Verification
- RSpec and Cucumber quickstart smoke tests assert the behavioral contract.
- `bin/vendor-verify` and `bin/check-vendor-mutations` defend the supply chain.

## Changelog
- 1.0 — Initial API freeze with capabilities introspection and structured doctor output.
