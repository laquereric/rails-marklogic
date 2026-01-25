# 10× Scale Execution Plan

## 1. Agent Infrastructure & Workflows
- Document agent roles, task briefs, expected outputs, and allowed directories in `docs/agents/OPERATIONS.md`.
- Build `bin/agent-start` helper that provisions per-agent worktrees (`agent/<task>` branches), installs dependencies, and records task metadata.
- Create a lightweight lease registry (YAML file or service) that tracks directory ownership; add a CI hook blocking overlapping leases.
- Define merge protocol: agent PR template, checklist for MCP owner review, required handoff summary, and post-merge cleanup script.

## 2. Vendored-Code Governance
- Introduce `vendor-lock.json` capturing submodule SHAs and tarball checksums; add `rake vendor:verify` to CI.
- Treat `vendor/**` as read-only by default with a CI guard that fails unless `ALLOW_VENDOR_MUTATION=true` is set.
- Provide `script/update-vendor <name>` to standardize vendor bumps, refresh the lockfile, and append changelog entries.
- Maintain per-vendor ownership notes and change logs under `docs/vendors/<name>.md`.

## 3. MCP Platform Hardening
- Publish `MCP_API.md` documenting public entry points, semantic versioning policy, compatibility guarantees, and deprecation workflow.
- Tie `MCP_API_VERSION` updates to automated checks that enforce version/doc synchronization during CI.
- Extend `Mcp::Doctor` with capability introspection (`capabilities` method and `--json` flag) for UIs, scripts, and CI.
- Add `mcp-lm.gemspec`, README, and release checklist to support packaging even if vendored initially.

## 4. Compliance & Security Enhancements
- Expand audit logging to emit structured counts per provider and environment, with optional alert thresholds.
- Author a compliance FAQ and operational runbook covering data flow, kill switch use, incident response, retention, and bypass prevention; cross-link from `COMPLIANCE.md`.
- Schedule quarterly governance reviews stored in `/compliance/reviews`, each capturing findings and remediation plans.
- Integrate CI shadow-AI scans, dependency licensing review, and security checklist verification.

## 5. Developer Experience & Onboarding
- Create `bin/onboard` that validates Docker/Ollama, seeds configs, runs `mcp doctor`, and launches `ropencode-rails` end to end.
- Enhance `FOR_MANAGERS.md` with slide-ready summary and KPI snapshot (LLM disabled by default, usage metrics, compliance posture).
- Produce an interactive TUI learning mode or scripted walk-through that teaches MCP concepts inside the developer workflow.
- Ship a template repository or generator that seeds new teams with MCP, governance docs, and CI wiring.

## 6. Release & Change Management
- Establish semantic release cadence (`mcp-v1.1.0`, etc.), automate changelog generation, and adopt a release-train checklist.
- Introduce a merge queue enforcing tests, compliance gates, vendor-lock verification, and lease checks before integration.
- Add `/rfcs` with templates and lifecycle tracking; require RFCs for architectural or governance-affecting changes.
- Track execution through GitHub Projects or equivalent, aligning tasks to agent workstreams and release milestones.
