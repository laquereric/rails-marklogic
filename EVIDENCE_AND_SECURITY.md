# Evidence and Security

## Security Invariant
UI-facing artifacts must never contain raw evidence.

## Evidence Handling
- Evidence is persisted as first-class documents in MarkLogic
- Each evidence record has its own permissions and URI

## ID-Only Referencing
- UIResources reference evidence by ID only
- No embedding, copying, or projection of secured data

## Threat Model
- UI clients are untrusted by default
- All access control is enforced at the data layer

## MarkLogic Guarantees
- Role-based access control
- Document-level permissions
- Temporal correctness

## Prohibited Patterns
- Passing evidence through APIs
- Caching evidence outside MarkLogic
- UI-driven filtering of secured data