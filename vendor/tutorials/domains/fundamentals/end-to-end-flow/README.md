# End-to-End Flow: Ingest → Query → Present

## Goal

After completing this tutorial, you will understand how an application flows end to end: designing documents, ingesting data, indexing for queries, retrieving data with Optic, and presenting results through Rails.

## Context

Most problems only make sense when viewed as a complete system. This tutorial ties together the core concepts introduced across the Fundamentals, Querying, and Rails Integration domains into a single mental model.

This is not a checklist or a quickstart. It is a conceptual walkthrough that shows *how decisions compound* across the stack.

## Prerequisites

- Documents, URIs, and Collections
- Collection and Structured Search
- Optic Pipelines and Joins
- Index Design for Performance
- Rails: Mapping Documents to Models
- Rails: Query Objects

## The Flow

### 1. Document Design

Start by deciding what a document represents.

Key questions:
- What is the unit of change?
- What data belongs together?
- What identifiers are stable?

These answers determine URI structure and document shape.

### 2. Ingestion

Ingestion inserts documents with:
- Stable URIs
- Intentional collections
- Predictable structure

Ingestion is where future query costs are decided.

### 3. Indexing

Indexes are added to answer known questions:
- Which documents belong together?
- Which values are queried or joined?

Indexes exist to serve queries, not to mirror schema.

### 4. Query Composition

Queries begin by narrowing candidates using indexes.

Optic pipelines then:
- Extract values
- Join related documents
- Project shaped results

Composition replaces ad-hoc logic.

### 5. Application Boundary (Rails)

Rails models act as interfaces over documents.

Query objects:
- Encapsulate retrieval intent
- Wrap Optic pipelines
- Produce stable result shapes

Controllers and APIs depend on queries, not storage.

### 6. Presentation

Results are rendered or serialized without leaking query logic.

Presentation concerns:
- Pagination
- Ordering
- Formatting

These remain separate from retrieval and modeling.

## Verification

You should be able to:
- Trace a user request through every layer
- Identify where each decision belongs
- Explain performance characteristics end to end

If debugging requires guessing which layer failed, boundaries are unclear.

## Common Failure Modes

- Treating ingestion as an afterthought
- Encoding query logic in controllers
- Overfetching documents
- Solving performance issues outside index design

## Transfer

This flow applies to:
- APIs
- Background jobs
- Reporting systems
- Data products

Whenever systems feel brittle, revisit the boundaries in this flow.

## Next

- Operations: Managing change over time
- Advanced querying patterns
