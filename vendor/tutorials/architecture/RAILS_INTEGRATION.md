# Rails Integration Architecture

This document describes how Rails integrates with MarkLogic without leaking relational assumptions.

---

## Layered View

```
HTTP Request
     │
     ▼
Controller
     │
     ▼
Query Object
     │
     ▼
Optic Pipeline
     │
     ▼
Indexes / Documents
```

Each layer has a single responsibility.

---

## Models as Interfaces

```
Rails Model
     │
     ▼
Document Shape
     │
     ▼
URI Identity
```

Models describe behavior and shape, not storage mechanics.

---

## Query Objects

```
+-------------------+
| Query Object      |
|-------------------|
| inputs            |
| optic pipeline    |
| result shape      |
+-------------------+
```

Query objects represent questions the application knows how to ask.

---

## Associations

```
Model A      Model B
   │            │
   └── Optic Join ──► relationship
```

Associations are queries, not implicit foreign keys.

---

## Anti-Patterns

```
✗ Fat models
✗ Hidden queries
✗ Callback-driven loading
✗ ORM emulation
```

Rails is a client of the query system, not its owner.
