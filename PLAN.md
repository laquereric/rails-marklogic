# Rails–MarkLogic Platform Plan

## 1. Purpose & Audience
This repository provides a **developer-focused, local-only platform** for working with MarkLogic using a Rails application as a presentation and orchestration layer.

Rails is not a database abstraction for MarkLogic. MarkLogic remains authoritative.

## 2. Architecture Overview

- Rails app (SQLite primary DB)
- `marklogic-core` Ruby gem
- MarkLogic Server (Docker + Roxy)
- Native MarkLogic tools (Admin, Query Console, Metrics)

```
Browser
  ↓
Rails UI
  ↓
marklogic-core
  ↓
MarkLogic REST / XQuery / Optic
  ↓
MarkLogic (Docker / Roxy)
```

## 3. Guiding Principles
- Developers first
- Shared credentials (easy mode)
- Writes are allowed
- Reset must be easy and safe
- Native MarkLogic tools are first-class
- No Rails abstractions over MarkLogic

## 4. Versioning Strategy
- Semantic versioning
- Root version is authoritative; bump submodules only when their pointers change
- VERSION file required
- Git tags used for releases

Current baseline: **0.4.0**

## 5. Phased Execution Plan

### Phase 1 — MarkLogic + Roxy
- Launch MarkLogic via Docker
- Configure REST, Admin, Query Console
- Establish deterministic ports
- Implement RESET ALL

### Phase 2 — marklogic-core
- Ruby HTTP client
- XQuery, JavaScript, Optic execution
- Read and write support
- Error translation

### Phase 3 — Rails Integration
- Rails initializer
- Service objects only
- No ActiveRecord adapters

## 6. RESET ALL Contract
RESET ALL must:
- Clear content databases
- Restore baseline configuration
- Be documented
- Be safe and repeatable

## 7. Explicit Non-Goals
- ActiveRecord adapter for MarkLogic
- MarkLogic as Rails primary DB
- Cloud deployment
- UI reimplementation of MarkLogic
- Multi-tenant authentication

## 8. Definition of Done
- Fresh clone works
- Submodules initialize cleanly
- MarkLogic runs locally
- Core examples execute real queries
- RESET ALL works reliably
