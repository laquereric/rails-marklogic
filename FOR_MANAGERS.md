# For Managers: LLM Use in This Project

This document is written for engineering managers, technical leads, and stakeholders who need a clear, non‑hyped explanation of how (and why) Large Language Models (LLMs) are used in this project.

It is intentionally plain, conservative, and aligned with common organizational concerns around AI adoption.

---

## Executive Summary

- LLMs are used **only as optional developer assistance**
- By default, LLMs run **locally on the developer’s machine**
- No source code or data is sent to external services unless explicitly configured
- LLMs do **not** run in production or make runtime decisions
- Usage is controlled, observable, and test‑enforced

In short: this project uses AI as a *tool for developers*, not as an autonomous system.

---

## Snapshot (Slide-Ready)

- **Status:** MCP API v1.0 locked; production LLM calls disabled by default
- **Guardrails:** One entry point, kill switch, vendor lockfile, CI compliance checks
- **Metrics:** Audit counters in `tmp/mcp_audit_counts.json` track provider/model usage and policy failures
- **Next Review:** Quarterly governance cadence (`compliance/reviews`)

---

## Key Performance Indicators

| KPI | Target | Where to Find |
|-----|--------|---------------|
| Onboarding pass rate | 100% | CI `bin/onboard --verify` (see script) |
| LLM calls per day | Alert at threshold | `tmp/mcp_audit_counts.json` (`MCP_AUDIT_ALERT_THRESHOLD`) |
| Policy failures | 0 | Same audit snapshot |
| Shadow AI attempts | 0 | `test/integration/shadow_ai_guard_test.rb` (CI blocking) |

---

## What Problem This Solves

Developers spend significant time:
- Understanding existing code
- Exploring unfamiliar models and schemas
- Drafting boilerplate services or serializers

This project allows developers to do those tasks **faster and more safely**, without changing how the application behaves in production.

---

## What This Is (and Is Not)

### This *is*:
- A local development aid
- An interactive assistant inside the Rails console
- A way to explore and explain existing code

### This is *not*:
- An automated coding system
- A decision‑making engine
- A production dependency
- A replacement for developer judgment

---

## Default Behavior: Local and Offline‑Friendly

By default, the system uses:
- Docker Desktop
- A locally running LLM engine (e.g. Ollama)
- A local model (e.g. `devstral:24b`)

In this mode:
- No network calls to AI vendors occur
- No code or data leaves the machine
- The system works even in restricted environments

Cloud‑hosted AI services are **optional** and require explicit configuration.

---

## Safeguards and Controls

### Single Control Layer

All LLM usage goes through a single, auditable system component (the *Model Control Plane*).

This ensures:
- No accidental or hidden AI usage
- Centralized policy enforcement
- Clear audit points

---

### Hard Guards Against Misuse

The application enforces runtime guards that:
- Prevent direct use of vendor AI SDKs
- Require all AI calls to go through approved paths

If a developer attempts to bypass these safeguards, the application raises an error.

---

### Visibility

Developers can always see:
- Which AI provider is active
- Which model is in use
- When an AI call occurs
- Why a failure occurred

There are no silent fallbacks or hidden behavior.

---

## Production Impact

There is **no production dependency** on LLMs.

Specifically:
- The application does not require AI services to run
- Generated output is not executed automatically
- Production systems can disable AI entirely

This design prevents operational or compliance risk in live environments.

---

## Testing and Enforcement

Key guarantees are enforced by automated tests:
- If onboarding behavior breaks, CI fails
- If safeguards are weakened, CI fails

This ensures documented behavior matches actual behavior.

---

## Why This Is Safe for Cautious Organizations

This approach is appropriate for organizations that:
- Are cautious about AI adoption
- Must comply with data handling policies
- Want clear boundaries and controls

The system is explicit, local‑first, and opt‑in.

---

## Where to Learn More

For more detail:
- `COMPLIANCE.md` — technical safeguards and controls
- `QUICKSTART_CONTRACT.md` — enforced onboarding guarantees

These documents are part of the repository and kept in sync with the code.

---

## Bottom Line

This project does **not** introduce uncontrolled AI into the system.

It introduces a carefully bounded developer aid, designed to improve productivity while respecting organizational constraints.
