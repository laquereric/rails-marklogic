# Tutorial System Architecture

This document describes the **architecture and design decisions** behind the tutorial system, using ASCII diagrams to make structure and intent explicit.

The tutorial system is designed as a **learning platform**, not a collection of ad-hoc documents.

---

## High-Level Philosophy

Applied Transfer Learning (ATL):

```
Learn one thing
     │
     ▼
Verify it works
     │
     ▼
Reuse the idea elsewhere
```

Key implications:
- Tutorials teach *transferable understanding*
- Verification is mandatory in spirit
- Structure favors reuse over completion

---

## System Overview

```
+-----------------------+
|   Tutorials Root      |
|-----------------------|
| README.md             |  ← philosophy, scope, navigation
| LEARNING_PATHS.md     |  ← advisory only
| CONTRIBUTING.md       |  ← contributor contract
|                       |
| domains/              |
| shared/               |
| architecture/         |
+-----------+-----------+
            |
            ▼
      Domains of Knowledge
```

---

## Domains of Knowledge

Domains are **conceptual partitions**, not difficulty levels or modules.

```
Tutorial System
      │
      ├── Fundamentals
      │      ├── documents-uris-collections
      │      ├── end-to-end-flow
      │      └── ...
      │
      ├── Querying
      │      ├── collection-and-structured-search
      │      ├── optic-pipelines
      │      ├── optic-joins
      │      └── index-design-for-performance
      │
      ├── Rails Integration
      │      ├── mapping-documents-to-models
      │      └── query-objects
      │
      └── Operations
             └── (future)
```

Design decisions:
- Domains are folders
- Every domain has a README
- Domain order is *conceptually suggested*, never enforced

---

## Units of Knowledge (Tutorials)

Each tutorial is a **single unit of knowledge**.

```
Domain
  │
  ├── tutorial-unit/
  │     ├── README.md   ← the tutorial
  │     └── (assets)    ← optional, local
  │
  └── another-unit/
        └── README.md
```

Design decisions:
- One directory per tutorial
- One primary learning goal per unit
- Tutorials are self-contained

---

## Tutorial Contract (Implicit)

Every tutorial follows the same conceptual contract:

```
+---------------------+
| Goal                |
+---------------------+
| Context             |
+---------------------+
| Core Concepts /     |
| Steps               |
+---------------------+
| Verification        | ← observable success
+---------------------+
| Transfer            | ← reuse elsewhere
+---------------------+
```

This contract is enforced socially, not mechanically.

---

## Separation of Concerns

The tutorial system separates *what is learned* from *how it is navigated*.

```
Conceptual Knowledge
        │
        ▼
   Domains (folders)
        │
        ▼
   Units (tutorials)
        │
        ▼
Learning Paths (advisory)
```

Learning paths do **not** own content.

---

## Contributor Model

```
Contributor
    │
    ▼
CONTRIBUTING.md
    │
    ▼
Unit Template
    │
    ▼
New Tutorial Unit
```

Design decisions:
- Low ceremony
- Clear quality bar
- No rigid process or tooling

---

## Why This Architecture

Problems this design avoids:
- Curriculum rigidity
- Overgrown reference docs
- Contributor paralysis
- Knowledge silos

Properties this design enables:
- Incremental growth
- Conceptual integrity
- Long-term maintainability

---

## Mental Model Summary

```
Tutorials are:
  not → pages
  not → courses
  not → references

Tutorials are:
  ✓ learning units
  ✓ transferable ideas
  ✓ verified understanding
```

This architecture is intentionally simple, explicit, and durable.
