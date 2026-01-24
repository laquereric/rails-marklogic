# Collection and Structured Search

## Goal

After completing this tutorial, you will understand how to reliably find documents using collections and structured search, and how these approaches differ from direct URI access.

## Context

Once documents are stored, most applications need to retrieve *sets* of documents based on shared characteristics. MarkLogic provides multiple ways to do this, each with different trade-offs.

This tutorial focuses on two foundational approaches:
- Collection-based search
- Structured search using document properties and structure

Understanding when and why to use each is essential for building predictable, performant queries.

## Prerequisites

- Understanding of documents, URIs, and collections
- Documents already loaded into the database

## Core Concepts

### Direct URI Retrieval

Retrieving a document by URI is the most precise and efficient operation.

Use this when:
- You know the exact document you need
- Identity matters more than discovery

URI retrieval does not scale to discovery problems.

### Collection Search

Collections allow you to retrieve documents by logical grouping.

Key characteristics:
- Fast and index-backed
- Explicit and predictable
- Orthogonal to document structure

Collections work best when documents share a lifecycle or role.

### Structured Search

Structured search matches documents based on their internal structure.

Examples:
- Element or property values
- JSON keys
- Range queries

Structured search is powerful but depends on schema discipline and indexing.

## Hands-On Example

1. Query all documents in a given collection
2. Narrow results using a structured constraint
3. Compare results to direct URI retrieval

Observe how each approach answers a different question.

## Verification

You should be able to:
- Retrieve a predictable set of documents using collections
- Narrow that set using structured criteria
- Explain why a given document appears or does not appear in results

If results feel surprising, your query model is incomplete.

## Common Pitfalls

- Using structured search where collections are sufficient
- Treating collections as hierarchical folders
- Overloading document structure for grouping concerns

## Transfer

This understanding transfers to:
- Designing search APIs
- Building Optic pipelines
- Improving query performance
- Explaining query behavior to application developers

Any time you ask "Why did this document match?", you are relying on these concepts.

## Next

- Optic Pipelines
- Rails Integration: Query Abstractions
