# QUICKSTART_CONTRACT

This document defines the **Quickstart Contract** for this project.

The Quickstart Contract is a **governing promise** made to developers:

> A Rails 7+ developer can follow the documented Quickstarts with default configuration and successfully reach a usable, recoverable development experience.

If this contract is broken, the project is considered **regressed**, regardless of feature completeness.

---

## Purpose

The Quickstart Contract exists to:

- Protect onboarding quality
- Make developer experience testable
- Prevent accidental erosion of defaults
- Align documentation, behavior, and CI

It treats the Quickstarts as **authoritative behavioral specifications**, not marketing material.

---

## Scope

The Quickstart Contract governs:

- Rails console integration
- Local / free LLM defaults
- Development-mode policy behavior
- Error recovery and context preservation
- Observability of LLM operations

It explicitly does **not** govern:

- Production enforcement
- Provider-specific performance
- Prompt wording or stylistic output
- Advanced configuration paths

---

## Contract Invariants

The following invariants must always hold:

### 1. Defaults Must Work

A developer must be able to:

- Install dependencies
- Run `rails console`
- Invoke `ropencode`

Without configuring:

- External LLM credentials
- Policy DSLs
- Environment-specific flags

---

### 2. Errors Must Not Eject the User

Failures must:

- Be explained
- Preserve context
- Return control to IRB / Enhanced TUI

Crashes or silent exits violate the contract.

---

### 3. Behavior Must Be Observable

Developers must be able to see:

- What prompt was executed
- Which policy applied
- Why a failure occurred

Hidden behavior violates the contract.

---

### 4. Development Mode Favors Exploration

In development:

- Policies are permissive
- Violations are descriptive
- Recovery is prioritized over enforcement

Strict enforcement belongs later in the lifecycle.

---

## Enforcement Mechanism

The Quickstart Contract is enforced by automated tests.

### Test Tags

The following tags define contract coverage:

- `@quickstart`
- `@onboarding`
- `@quickstart_contracts`
- `@smoke`

Any test tagged with `@quickstart_contracts` is considered **release-blocking**.

---

### Test Layers

| Layer | Tool | Responsibility |
|-----|-----|----------------|
| Structural | RSpec | Ensure system viability |
| Behavioral | Cucumber | Ensure documented flows work |
| CI Gate | GitHub Actions | Prevent regressions |

---

## Change Management

Any change that:

- Alters Quickstart documentation
- Modifies defaults
- Affects console startup
- Changes error handling behavior

Must be evaluated against this contract.

If a change requires weakening the contract, the contract must be **explicitly updated first**.

---

## Design Philosophy

The Quickstart Contract reflects these values:

- Developer trust is earned through predictability
- Onboarding quality is a first-class concern
- Documentation is executable
- Defaults are part of the API

Breaking the Quickstart Contract is treated as a breaking change.

---

## Status

This contract is **active** and enforced in CI.

If CI is green, the Quickstart Contract is considered upheld.
