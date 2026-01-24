# Index Design for Query Performance

## Goal

After completing this tutorial, you will understand how index choices shape query performance and predictability, and how to design indexes to support Optic, structured search, and joins.

## Context

In MarkLogic, queries are fast when they are answered by indexes. Poorly performing queries are almost always a symptom of index mismatch, not algorithmic inefficiency.

Index design is therefore a *query design activity*, not an operational afterthought.

## Prerequisites

- Understanding of collection and structured search
- Familiarity with Optic pipelines and joins

## Core Concepts

### Indexes Answer Questions

Each index exists to answer a specific class of questions.

Examples:
- Collections answer "which documents belong together?"
- Range indexes answer "which documents have this value?"
- Lexicons answer "which values exist and how often?"

If a question is not supported by an index, the query must inspect documents.

### Document Fetch vs Index Resolution

Efficient queries:
- Resolve candidate documents using indexes
- Fetch documents only when necessary

Fetching documents early prevents the engine from optimizing query execution.

### Indexes and Optic

Optic pipelines rely on indexes to produce rows.

Key implications:
- Join keys must be indexed
- Projected values should come from lexicons when possible
- Adding indexes can radically simplify pipelines

## Hands-On Example

1. Run a structured query without a supporting index
2. Observe query latency and behavior
3. Add an appropriate range index
4. Re-run the query and compare results

The query logic remains the same; performance changes dramatically.

## Verification

You should be able to:
- Explain which index answers each part of a query
- Predict whether a query will scale
- Identify when a missing index is the root problem

If performance tuning feels like guesswork, index intent is unclear.

## Common Pitfalls

- Adding indexes without query intent
- Over-indexing volatile fields
- Fetching documents before filtering

## Transfer

This understanding transfers to:
- Designing stable query APIs
- Debugging slow production queries
- Collaborating with operations teams
- Planning schema evolution

Whenever performance matters, index design is the first lever to reach for.

## Next

- Operations: Index management
- Rails Integration: Performance-aware querying
