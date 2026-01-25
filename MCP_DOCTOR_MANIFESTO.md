# MCP Doctor

AI systems do not fail loudly. They drift, hallucinate, and approximate.
MCP Doctor exists to explain *what happened*, *why it happened*, and *whether it should have happened* — using data contracts, provenance, and semantics instead of probability.

## The Problem
The modern MCP / agent ecosystem relies on:
- Untyped or weakly typed JSON
- Best-effort schema adherence
- Approximate retrieval (RAG)
- Post-hoc logging without truth guarantees

This makes AI behavior fast — but unverifiable.

## The Insight
MarkLogic already solves the hard problems AI systems are now rediscovering:
- Strong schemas
- Versioned documents
- Provenance and lineage
- Semantic reasoning
- Queryable truth

MCP Doctor brings those guarantees to MCP-native AI systems.

## What MCP Doctor Is
- A diagnostic substrate for AI behavior
- A post-hoc truth system for MCP messages, tools, and memory
- A bridge between AI intent and data reality

## What MCP Doctor Is Not
- Not an agent
- Not a validator
- Not a RAG framework
- Not an eval harness

## The Phases
### 1. Diagnose
Capture MCP traffic, tool calls, and RAG context.
Explain outcomes with evidence.

### 2. Guard
Warn or block unsafe or incorrect behavior — based on observed failures.

### 3. Govern
Define and enforce contracts at design time.

## The USP
Typed, explainable, queryable AI behavior.
Not embeddings. Not heuristics. Truth.

Rails-MarkLogic is the reference environment where this is possible.