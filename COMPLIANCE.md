# Compliance and LLM Usage

This document describes how this project uses Large Language Models (LLMs), the safeguards in place, and why the default behavior is suitable for security‑ and compliance‑sensitive environments.

The intent of this document is to support:
- Internal security reviews
- Compliance and risk assessments
- Managerial or legal questions about AI usage

This is **not** a marketing document. It describes actual behavior enforced by code and tests.

---

## Executive Summary

- LLM usage is **development‑time only** by default
- The default configuration is **local‑first** and **cloud‑optional**
- No source code or data is transmitted off the developer’s machine unless explicitly configured
- All LLM access is mediated by a single, auditable system layer (MCP)
- Direct vendor SDK usage is explicitly guarded against

If CI is green, the documented safeguards are in effect.

---

## Scope of LLM Usage

LLMs are used only to:
- Assist developers during local development
- Explain existing code and schemas
- Generate draft artifacts for inspection

LLMs are **not** used to:
- Execute code automatically
- Modify production systems
- Make runtime decisions
- Enforce business rules

There is no autonomous behavior.

---

## Architectural Guardrails

### Single System Entry Point (MCP)

All LLM calls are routed through the **MCP (Model Control Plane)** layer:

```
Mcp::McpLm
```

This layer is responsible for:
- Provider selection
- Model selection
- Policy enforcement
- Error handling
- Auditing hooks

Application code and UI layers do not communicate with LLMs directly.

---

### Direct SDK Usage Is Forbidden

The application enforces a hard guard against direct vendor SDK usage.

For example:
- Direct instantiation of `OpenAI::Client` outside MCP raises a runtime error

This prevents:
- Accidental data exfiltration
- Shadow usage of external services
- Bypassing policy or audit layers

---

## Default Provider Behavior

### Local‑First by Default

When available, a **local LLM provider** is selected automatically.

Typical local setup:
- Docker Desktop
- Ollama
- Local model (e.g. `devstral:24b`)

In this mode:
- All prompts and responses stay on the local machine
- No network calls to external AI services occur

---

### Cloud Providers Are Optional

Cloud‑hosted LLMs (e.g. OpenAI) are used **only if**:
- Explicit credentials are configured
- The local provider is unavailable

This behavior is centralized and auditable.

---

## Development vs Production

### Development Mode

In development:
- Policies are permissive
- Failures are descriptive
- Exploration and understanding are prioritized

This mode is intentionally designed for learning and iteration.

---

### Production Safeguards

By default:
- LLMs are not required in production
- No runtime dependency on LLM availability exists
- No automatic execution of generated output occurs

Production usage can be restricted or disabled entirely without breaking the application.

---

## Observability and Auditing

### Visible Behavior

Developers can see:
- Which provider is active
- Which model is selected
- When an LLM call is attempted
- Why a failure occurred

There are no silent retries or hidden fallbacks.

---

### Health and Environment Checks

The system exposes a diagnostic interface:

```
Mcp::Doctor
```

This reports:
- Active provider
- Model availability
- Local environment readiness

UI layers (e.g. `ropencode`) delegate to this system check rather than duplicating logic.

---

## Testing and Enforcement

### Quickstart Contract

LLM behavior is governed by the **Quickstart Contract**:

```
QUICKSTART_CONTRACT.md
```

This contract defines non‑negotiable invariants such as:
- Defaults must work without configuration
- Errors must not eject the developer
- Behavior must be observable

---

### Automated Enforcement

The following tests are release‑blocking:
- RSpec integration smoke tests
- Cucumber Quickstart contract tests

Any regression in documented behavior causes CI to fail.

---

## Risk Posture Summary

| Risk | Mitigation |
|-----|------------|
| Data exfiltration | Local‑first defaults, guarded SDK usage |
| Shadow AI usage | Centralized MCP entry point |
| Unaudited behavior | Explicit provider and model visibility |
| Autonomy | No automatic execution or runtime dependency |

---

## Intended Audience

This system is designed to be acceptable for:
- Conservative engineering organizations
- Security‑reviewed environments
- Teams cautious about AI adoption

LLM usage is explicit, bounded, and optional.

---

## Status

This compliance posture is **active and enforced**.

If CI is green, the safeguards described here are in effect.

---

## Further Reading

- `COMPLIANCE_APPENDIX.md` — FAQ, incident response runbook, and escalation matrix.
