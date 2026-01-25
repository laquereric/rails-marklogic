# MCP Starter Template

Copy this directory to seed new Rails projects with:
- Vendored MCP (`vendor/mcp-lm`) and governance docs (`COMPLIANCE.md`, `MCP_API.md`)
- CI wiring (`config/ci.rb`, `bin/check-vendor-mutations`, `bin/vendor-verify`)
- Agent operations kit (`docs/agents/**`, `config/agent_leases.yml`)

## Usage
1. Create a new repository.
2. Copy the contents of this template into the new project.
3. Run `bin/onboard --verify` to confirm the environment.
4. Update ownership metadata in `docs/vendors/**` and `config/agent_leases.yml`.

Keep the lockfiles and compliance docs in sync with the source repo; update them whenever MCP is upgraded.
