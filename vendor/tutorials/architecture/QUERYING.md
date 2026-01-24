# Querying Architecture

This document explains the querying model using ASCII diagrams, showing how search, Optic, joins, and indexes fit together.

---

## Querying Mental Model

```
User Question
     │
     ▼
Candidate Selection
 (indexes)
     │
     ▼
Row Construction
 (Optic)
     │
     ▼
Composition
 (joins, filters)
     │
     ▼
Projection
 (shaped results)
```

Queries are pipelines, not commands.

---

## Identity vs Discovery

```
+-----------+        +------------------+
| URI Fetch |        | Search / Optic   |
|-----------|        |------------------|
| Exact     |        | Discovery-based  |
| Fastest  |        | Set-oriented     |
| Singular |        | Composable       |
+-----------+        +------------------+
```

Use URI fetch for identity. Use search/Optic for discovery.

---

## Index-Driven Execution

```
Indexes
  │
  ├── Collections ──► group documents
  ├── Range Index ──► answer value questions
  └── Lexicons ────► produce Optic rows
```

If a query cannot be answered by indexes, it will not scale.

---

## Optic Row Model

```
Index
  │
  ▼
+-------------------+
| Row               |
|-------------------|
| doc-uri           |
| value A           |
| value B           |
+-------------------+
```

Rows reference documents intentionally; documents are fetched explicitly.

---

## Joins

```
Rows A           Rows B
  │                │
  └──── join ──────┘
           │
           ▼
       Joined Rows
```

Join keys must be indexed and stable.

---

## Performance Rule

```
Good:
  index → rows → join → project → fetch

Bad:
  fetch → inspect → filter → join
```

Design queries so documents are fetched last, not first.
