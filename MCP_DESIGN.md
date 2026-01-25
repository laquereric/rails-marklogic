# MCP Design Overview

The Model Context Protocol (MCP) defines a language- and framework-agnostic architecture for representing application state, intent, and behavior in a consistent way.

This document is the **authoritative design reference** shared by all MCP-related gems.

## Core Principles

- **Separation of Concerns** – Core types, framework bindings, and application logic are isolated
- **Explicit Contracts** – Clear boundaries between layers and responsibilities
- **Portability** – Concepts translate cleanly across languages and runtimes
- **Minimal Runtime Coupling** – Documentation and structure first; behavior layered on top

## Layered Architecture

```
Application
└── Framework Bindings (mcp-framework)
    └── Domain Types (mcp-type)
        └── Intent & Policy (mcp-intention, mcp-policy)
            └── Interchange & IO (mcp-interchange)
```

## Package Roles

- **mcp-framework** – Framework-specific boundaries and terminology
- **mcp-type** – Core domain and structural types
- **mcp-intention** – Representation of goals and user intent
- **mcp-policy** – Constraints, rules, and governance
- **mcp-interchange** – Serialization and protocol boundaries
- **mcp-language / mcp-lm / mcp-ui** – Language model and UI integrations

## Usage Guidelines

- Higher layers may depend on lower layers, never the reverse
- Framework assumptions must not leak into core types
- Each MCP gem should remain independently versionable

## References

- Domain-Driven Design (Eric Evans)
- Clean Architecture (Robert C. Martin)
- Hexagonal Architecture (Alistair Cockburn)
- Official framework documentation (Rails, Django, Spring, .NET)
