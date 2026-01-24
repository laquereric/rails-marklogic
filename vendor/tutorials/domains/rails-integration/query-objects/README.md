# Query Objects in Rails

## Goal

After completing this tutorial, you will understand how to encapsulate MarkLogic and Optic queries as first-class query objects in Rails, improving clarity, testability, and reuse.

## Context

As applications grow, embedding query logic directly inside models or controllers leads to duplication and hidden complexity. Query objects provide a clear boundary: they represent *questions the application knows how to ask*.

In a MarkLogic-backed Rails application, query objects are especially valuable because queries often involve Optic pipelines, joins, and index-aware design.

## Prerequisites

- Understanding of mapping documents to Rails models
- Familiarity with Optic pipelines and joins
- Basic Rails service object patterns

## Core Concepts

```
Controller → Query Object → Optic → Results
```

### Queries as Objects

A query object:
- Encapsulates one query intent
- Accepts explicit inputs
- Produces predictable outputs

It does not:
- Hide side effects
- Mutate application state
- Implicitly load data

### Separation from Models

Models represent document shapes and behavior.
Query objects represent *retrieval logic*.

This separation keeps models small and queries discoverable.

### Composability

Query objects can:
- Wrap Optic pipelines
- Be composed or extended
- Share common pipeline fragments

This mirrors how Optic itself encourages composition.

## Hands-On Example

1. Define a query object that returns documents from a collection
2. Add structured constraints to the query
3. Extend the query to include an Optic join
4. Use the query object from a controller or service

Observe how query logic remains explicit and isolated.

## Verification

You should be able to:
- Locate all query logic in one place
- Test a query object without loading Rails controllers
- Modify a query without touching model code

If changing a query breaks unrelated behavior, boundaries are unclear.

## Common Pitfalls

- Treating query objects as mini-ORMs
- Hiding query execution inside initializers
- Mixing presentation concerns into queries

## Transfer

This understanding transfers to:
- Building stable APIs
- Debugging complex data access paths
- Onboarding new developers
- Evolving queries as requirements change

Whenever queries start spreading through the codebase, introduce a query object.

## Next

- Caching and pagination strategies
- End-to-end application flow
