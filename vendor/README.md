# Vendor Directory

This directory contains **vendored dependencies, internal frameworks, and reference implementations** used by the `rails-marklogic` project.

The contents fall into three broad categories:

- **Independent gems** vendored for local development
- **MCP (Model Context Protocol) packages** forming a layered internal architecture
- **Tutorials and reference projects** tracked separately from application code

---

## MCP Packages

MCP packages are designed as **minimum, independently versionable gems** with strict architectural boundaries.

All MCP packages conform to the shared design contract defined in:

- `MCP_DESIGN.md`

### MCP Layers

- **Framework layer** – `mcp-framework`
- **Core domain types** – `mcp-type`
- **Intent & semantics** – `mcp-intention`, `mcp-personality`
- **Policy & governance** – `mcp-policy`
- **Interchange & protocols** – `mcp-interchange`
- **Language & UI integration** – `mcp-language`, `mcp-lm`, `mcp-ui`
- **Cultural / contextual models** – `mcp-culture`

These packages are intentionally lightweight and may provide:

- Documentation and contracts
- Namespacing and structure
- Minimal or no runtime behavior

---

## Vendored Gems

These directories contain full Ruby gems vendored into the repository, either as git submodules or local copies:

- `marklogic-core` (git submodule)
- `leann-gem` (git submodule)
- `rails-box`
- `pdf_to_json`
- `vector-mcp-gem`
- `spawned`
- `opencode-rails`

Some are referenced directly in the root `Gemfile` via `path:` for local development.

---

## Tutorials and References

- `rails-marklogic-tutorial` – Architecture and usage documentation (git submodule)

This material is versioned independently and should not contain runtime application code.

---

## Integration Notes

- Vendored gems may be included in the root `Gemfile` using `path:`
- MCP packages are designed to be safe documentation or structure-only dependencies
- Git submodules must be initialized via:

```bash
git submodule update --init --recursive
```

---

## Conventions

- Every vendored directory should clearly declare its role
- MCP packages must not leak framework-specific assumptions into core layers
- Runtime dependencies are opt-in and explicit
