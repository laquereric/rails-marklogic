# Documents, URIs, and Collections

## Goal

After completing this tutorial, you will understand how documents are identified and grouped in MarkLogic using URIs and collections, and how those concepts shape querying and application design.

## Context

MarkLogic stores data as documents. Unlike relational rows, documents are addressed directly and can belong to multiple logical groupings. Understanding URIs and collections early prevents data modeling mistakes that are difficult to undo later.

These concepts appear everywhere: ingestion, querying, security, performance tuning, and application integration.

## Prerequisites

- A running MarkLogic instance
- Basic familiarity with inserting and querying documents

## Core Concepts

### Documents

A document is a discrete unit of content stored in the database. Each document:
- Has exactly one URI
- Has one content type (XML, JSON, text, binary)
- Is retrieved and updated as a whole

Documents are not partial records; they are the atomic unit of storage.

### URIs

A URI is the unique identifier for a document.

Key properties:
- URIs must be unique within a database
- URIs are application-defined
- URIs often encode structure or meaning

Example URIs:
- `/articles/2026/intro.json`
- `/users/123/profile.xml`

Choosing stable, meaningful URIs is a long-term design decision.

### Collections

A collection is a logical grouping of documents.

Important characteristics:
- A document can belong to zero, one, or many collections
- Collections do not affect document identity
- Collections are commonly used for querying and organization

Collections are *labels*, not containers.

## Hands-On Example

1. Insert two documents with different URIs
2. Assign both documents to the same collection
3. Assign one document to an additional collection

The documents remain distinct, but their collection membership changes how you can query them.

## Verification

You should be able to:
- Retrieve each document directly by its URI
- Query documents by collection membership
- Observe that changing collections does not change document identity

If removing a document from a collection makes it unreachable, you are relying on collections incorrectly.

## Common Pitfalls

- Encoding volatile data in URIs
- Treating collections as folders
- Using collections where document structure would be more appropriate

## Transfer

This understanding transfers directly to:
- Designing ingestion pipelines
- Structuring search and Optic queries
- Applying security rules
- Integrating MarkLogic with Rails models

Whenever you ask "How do I group or find documents?", you are choosing between URI design, collections, and document structure.

## Next

- Data Modeling domain
- Querying documents by collection
