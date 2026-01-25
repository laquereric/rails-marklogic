# mcp-lm (vendored)

This directory vendors the **mcp-lm** Ruby gem for use by this application.

## Namespace

The gem exposes its public API under the `MCP::LM` namespace. All constants, classes, and modules provided by the library should be referenced through this namespace to avoid collisions.

## Minimum Supported Version

This application expects **mcp-lm >= 0.1.0**.

If the gem is updated or re-vendored, ensure that the replacement version is compatible with this minimum requirement.

## Purpose of Vendoring

The gem is vendored to:

- Ensure deterministic behavior independent of upstream releases
- Allow local patches or customizations if needed
- Avoid runtime dependency resolution issues

## Maintenance Notes

- Keep this README in sync with the actual vendored code
- Update the minimum version if APIs or behaviors change
- Prefer upstream fixes where possible, then re-vendor
