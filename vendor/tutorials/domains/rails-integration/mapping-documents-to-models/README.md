# Mapping Documents to Models (Rails)

## Goal

After completing this tutorial, you will understand how to map MarkLogic documents to Rails models without forcing relational assumptions, and how to design model boundaries that align with Optic-backed querying.

## Context

Rails developers often approach data modeling through ActiveRecord, where tables, rows, and associations dominate thinking. MarkLogic uses a different model: documents, URIs, collections, and indexes.

This tutorial shows how to bridge these worlds safely—using Rails models as *interfaces* over documents, not as relational abstractions.

## Prerequisites

- Understanding of documents, URIs, and collections
- Familiarity with Optic pipelines and joins
- Basic Rails model concepts

## Core Concepts

### Models as Views, Not Tables

In a MarkLogic-backed Rails application, a model should represent:
- A document shape
- A query boundary
- A behavioral interface

A model does **not** represent:
- A table
- A fixed schema enforced by the database
- Ownership of persistence mechanics

### Identity and URIs

Model identity should map directly to document URIs.

Implications:
- `id` corresponds to a URI (or a derivation of it)
- Finding a record by ID is a direct document fetch
- Identity is stable and application-defined

### Collections as Scopes

Collections map naturally to Rails scopes.

Use collections to:
- Represent roles or lifecycles
- Partition large document sets
- Anchor default query behavior

Avoid encoding scope logic into model code when a collection expresses it more clearly.

### Associations via Queries

Relationships between models are implemented through queries, not foreign keys.

Patterns:
- Optic joins for one-to-many or many-to-many relationships
- Shared identifiers as join keys
- Explicit queries instead of implicit lazy loading

Associations should be *intentional and visible*.

## Hands-On Example

1. Define a Rails model representing a document type
2. Map the model ID to a document URI
3. Define a scope backed by a collection
4. Implement an association using an Optic join

Observe how queries remain explicit and predictable.

## Verification

You should be able to:
- Explain how a model instance maps to a document
- Trace a query from Rails code to Optic pipeline
- Predict query behavior without inspecting the database

If model behavior feels magical, abstraction has gone too far.

## Common Pitfalls

- Recreating ActiveRecord semantics
- Hiding queries behind callbacks
- Overloading models with persistence logic

## Transfer

This understanding transfers to:
- Designing maintainable Rails APIs
- Debugging production query behavior
- Onboarding Rails developers to MarkLogic
- Evolving schemas without migrations

Whenever Rails abstractions feel leaky, revisit the document-model boundary.

## Next

- Rails Integration: Query objects
- Operations: Performance-aware Rails queries
