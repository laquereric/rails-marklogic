# Optic Pipelines

## Goal

After completing this tutorial, you will understand how Optic pipelines model query logic as composable data flows, and when to prefer Optic over other query approaches.

## Context

As query complexity grows, ad-hoc search and imperative logic become difficult to reason about and optimize. Optic provides a declarative, relational-style approach that emphasizes composition, predictability, and reuse.

Optic is especially valuable when queries:
- Combine multiple constraints and joins
- Require projection and transformation
- Must evolve without rewriting from scratch

## Prerequisites

- Understanding of documents, URIs, and collections
- Familiarity with collection and structured search

## Core Concepts

```
Indexes → Rows → Pipeline Stages → Results
```

### Rows, Not Documents

Optic operates on *rows* produced by indexes, not directly on documents.

Each row represents:
- A document reference
- One or more extracted values

Documents are accessed intentionally, not implicitly.

### Pipelines

An Optic query is a pipeline of transformations.

Common stages:
- Source (from collections or lexicons)
- Filtering
- Joining
- Projection
- Ordering and limiting

Each stage returns a new pipeline.

### Declarative Composition

Optic pipelines describe *what* the result should look like, not *how* to retrieve it.

This allows:
- Query optimization by the engine
- Incremental refinement
- Easier reasoning about changes

## Hands-On Example

1. Start with documents from a collection
2. Extract indexed properties into rows
3. Filter rows based on values
4. Project a shaped result set

Notice how each step builds on the previous one without mutating state.

## Verification

You should be able to:
- Explain each pipeline stage in isolation
- Modify a stage without breaking others
- Predict how adding a filter changes results

If small changes cause unpredictable behavior, the pipeline model is not yet clear.

## Common Pitfalls

- Treating Optic like imperative code
- Fetching documents too early
- Overusing post-processing instead of projection

## Transfer

This understanding transfers to:
- Building complex search APIs
- Query reuse across applications
- Performance tuning through index selection
- Explaining queries to teammates

Whenever queries feel fragile or opaque, Optic is usually the right abstraction.

## Next

- Joining across document types
- Rails Integration: Optic-backed queries
