# Compliance FAQ & Runbook

## Data Flow
- Default mode uses a local Ollama provider; prompts and responses stay on the developer workstation.
- When cloud providers are explicitly enabled, all traffic still passes through MCP for auditing.
- Audit snapshots are written to `tmp/mcp_audit_counts.json` with aggregated counts, not raw prompts.

## Kill Switch
- Set `MCP_LLM_DISABLED=true` to disable MCP at runtime.
- Production LLM usage additionally requires `MCP_PRODUCTION_ENABLED=true`; absence of this flag triggers an immediate failure before any provider call.

## Incident Response
1. Set `MCP_LLM_DISABLED=true` to halt further LLM activity.
2. Capture `tmp/mcp_audit_counts.json` and relevant logs for investigation.
3. Mark the active lease `quarantined` in `config/agent_leases.yml` if an agent triggered the incident.
4. File an entry in `docs/agents/incidents.md` and open a governance review (see `compliance/reviews`).

## Retention & Logs
- Audit summaries can be rotated by truncating `tmp/mcp_audit_counts.json` or running `Mcp::AuditLogger.reset!`.
- No prompts or responses are persisted; only counts, provider names, models, and intents are stored.
- Developers may opt-in to longer retention by archiving the JSON snapshot as part of their review cadence.

## Bypass Prevention
- `bin/check-vendor-mutations` and `spec/integration/shadow_ai_guard_spec.rb` (mirrored in CI) block direct SDK usage.
- The MCP API contract (`Mcp::McpLm`, `Mcp::Doctor`) is versioned; unapproved entry points are considered violations.
- Vendor updates must follow the lease + lockfile workflow documented in `docs/vendors/README.md`.

## Escalation Matrix
- **MCP Owner:** First responder, triage incidents, manage leases.
- **Security Contact:** Reviews compliance posture quarterly using templates in `compliance/reviews`.
- **Engineering Leadership:** Approves policy changes or kill-switch overrides.
