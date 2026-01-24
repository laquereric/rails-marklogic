# Optic Joins and Multi-Document Queries

## Goal

After completing this tutorial, you will understand how Optic joins relate data across documents and when to model relationships for join-based querying.

## Context

Real applications rarely query a single document type in isolation. Relationships between documents—such as references, foreign keys, or shared attributes—must be expressed explicitly to query across them.

Optic joins provide a predictable, index-driven way to combine data from multiple document sets without loading full documents prematurely.

## Prerequisites

- Understanding of Optic pipelines
- Familiarity with collections and indexed properties

## Core Concepts

### Join Keys

Optic joins match rows using shared values called *join keys*.

Join keys:
- Must be indexed
- Are usually stable identifiers
- Often represent references between document types

### Inner vs Outer Joins

- **Inner joins** return rows where matches exist on both sides
- **Outer joins** preserve rows even when matches are missing

Choosing the correct join type determines whether missing relationships exclude or retain data.

### Join Order

Joins are composed like other pipeline stages.

Order matters for:
- Performance
- Result shape
- Debuggability

Favor joining smaller, selective row sets first.

## Hands-On Example

1. Create a pipeline from a primary collection
2. Join a secondary collection using a shared identifier
3. Project values from both sides of the join

Observe how rows expand while documents remain untouched.

## Verification

You should be able to:
- Explain what rows are produced before and after the join
- Predict how missing matches affect results
- Change join type intentionally

If joins feel magical or opaque, revisit row semantics.

## Common Pitfalls

- Joining on unindexed fields
- Fetching documents before joining
- Encoding volatile data into join keys

## Transfer

This understanding transfers to:
- Entity-style data modeling
- Search APIs spanning document types
- Rails associations backed by MarkLogic
- Performance tuning of complex queries

Whenever you need to relate documents without duplicating data, Optic joins are the right abstraction.

## Next

- Index design for joins
- Rails Integration: Modeling relationships
