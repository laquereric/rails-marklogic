# UIResource Contract

## Purpose
Defines the client-side contract consumed by MCP-UI and other presentation layers.

## Definition
A UIResource is a typed, deterministic object representing a diagnostic view.

## Allowed Contents
- IDs
- Summaries
- Derived metrics
- Relationships by ID

## Prohibited Contents
- Raw evidence
- Secured fields
- Presentation hints

## Canonical Kinds
- doctor.answer.report
- doctor.authority.evidence
- doctor.justification.chain
- doctor.conflict
- doctor.policy.suggestion

## Relationship Rules
- Relationships reference other UIResources or evidence by ID
- No deep embedding

## Versioning
UIResource kinds are versioned independently of implementation.

## Stability Guarantee
UIResource shapes change only via explicit versioning.