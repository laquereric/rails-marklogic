# Architecture Overview

This document describes the final, authoritative architecture of the **Rails–MarkLogic Platform**.

## Goals
- Keep MarkLogic authoritative
- Keep the core boring, thin, and stable
- Allow multiple client stacks (Ruby, Java)
- Make higher-level abstractions optional

## Layered Dependency Graph

```
Rails App
  ↓
(markmapper)        # optional
  ↓
marklogic-core
  ↓
MarkLogic REST APIs
  ↓
MarkLogic Server (Docker)
```

## Responsibilities by Layer

### Rails
- Orchestration, UI, jobs
- No database abstraction over MarkLogic
- Uses REST through `marklogic-core`

### marklogic-core
- ML12-compatible REST client
- Document PUT/GET
- XQuery / JavaScript eval
- Error handling
- No Rails, no mapping, no opinions

### markmapper (optional)
- Ruby object ↔ document mapping
- Domain convenience only
- Depends on `marklogic-core`

### MarkLogic
- Source of truth
- Content, modules, security
- Admin and Query Console exposed directly

## Reset Strategy

The canonical reset is Docker-based:

```bash
docker compose down -v
docker compose up -d
```

This guarantees a clean, repeatable environment.
