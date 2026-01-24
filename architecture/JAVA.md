# Java Architecture (Gradle)

This document describes how Java/Gradle-based systems integrate with MarkLogic in parallel to Rails.

## Philosophy
- Java is a **peer client**, not a special case
- Same REST APIs, same semantics
- No hidden coupling to Rails

## Typical Java Stack

```
Java Application
  ↓
Gradle
  ↓
MarkLogic Java Client / REST
  ↓
MarkLogic Server
```

## Gradle Usage Patterns

Gradle is commonly used to:
- Build Java services
- Run MarkLogic-related tasks
- Package deployments

Examples:
- Loading reference data
- Running batch jobs
- Invoking REST or Optic queries

## Gradle vs Roxy

| Tool | Role |
|-----|------|
| Roxy | Legacy ML ≤9 configuration and deployment |
| Gradle | Modern Java-centric build and task orchestration |

For MarkLogic 12, Gradle + REST/Manage APIs are preferred.

## Key Point

Gradle does **not** replace MarkLogic tooling; it automates against it.
