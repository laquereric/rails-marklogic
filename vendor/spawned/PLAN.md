# Spawned Plan

## Goal
Vendored Rails gem enabling a parent Rails app to spawn new, independent Rails applications with explicit lineage and clean Git separation.

## Scope
- CLI-driven spawning via `bin/spawned`
- Spawned apps are autonomous after creation
- Parent app does not depend on spawned apps at runtime

## Defaults
- Spawn location: sibling directory (`../NNN`)
- Git: spawned app initializes its own repo; parent auto-ignores path
- Rails: full app by default, `--api` flag supported

## CLI
```
bin/spawned spawn -name NNN [--api] [--dry-run]
```

## Lineage
Each spawned app writes `config/spawned.yml`:
```yaml
parent:
  name: <parent_app_name>
  repo: <git repo or path>
spawned:
  name: NNN
  created_at: <iso8601>
```

## Safety
- Refuse to overwrite existing directories
- Explicit confirmation before execution
- Deterministic output

## Non-Goals
- No Rails engine behavior
- No shared runtime code
- No GitHub API integration
- No CI/CD automation
