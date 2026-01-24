# Operations Architecture

This document explains how systems evolve safely over time.

---

## Change Flow

```
Requirement Change
        │
        ▼
Query Change
        │
        ▼
Index Change
        │
        ▼
Deployment
```

Indexes follow queries, not the other way around.

---

## Zero-Downtime Evolution

```
Old Query ───────────► still supported
      │
      ▼
Add Index
      │
      ▼
Deploy New Query
      │
      ▼
Remove Old Path
```

Never remove an index before its query.

---

## Observability

```
Query
  │
  ├── uses index? ──► yes/no
  ├── fetch count ─► documents loaded
  └── latency ─────► response time
```

Observability answers *why* a query behaves as it does.

---

## Operational Boundaries

```
Developers   Operators
     │           │
     └── shared understanding ──► indexes + queries
```

Operations succeeds when query intent is explicit.

---

## Failure Modes

```
✗ Tuning without intent
✗ Index sprawl
✗ Breaking queries accidentally
✗ Treating ops as afterthought
```

Operations is part of system design, not cleanup work.
