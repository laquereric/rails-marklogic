# rails-marklogic

## Tutorials

This repository uses the `rails-marklogic-tutorial` repository as a **git submodule** for all tutorial and architectural documentation.

### Initialize tutorials

```bash
git submodule update --init --recursive
```

Tutorial content lives at:

```
vendor/rails-marklogic-tutorial/
```

The tutorial system is versioned independently and can also be consumed as a Ruby gem.

## Application

This repository contains the Rails integration and supporting code for working with MarkLogic.

## Vendor Inventory

This section inventories the contents of the `vendor/` directory and describes how each folder is integrated.

| Folder | Git Submodule | Gem Configuration | Gemfile Included |
|--------|---------------|-------------------|------------------|
| leann-gem | Yes | `leann.gemspec` | No |
| marklogic-core | Yes | `marklogic-core.gemspec` | Yes |
| mcp-culture | No | `mcp-culture.gemspec` | No |
| mcp-framework | No | None | No |
| mcp-intention | No | `mcp-intention.gemspec` | No |
| mcp-interchange | Yes | `mcp_interchange.gemspec` | Yes |
| mcp-language | No | None | No |
| mcp-lm | No | None | No |
| mcp-personality | Yes | `mcp-personality.gemspec` | Yes |
| mcp-policy | No | None | No |
| mcp-type | No | None | No |
| mcp-ui | No | None | No |
| pdf_to_json | No | `pdf_to_json.gemspec` | No |
| rails-box | No | `rails-box.gemspec` | No |
| rails-marklogic-tutorial | Yes | `rails-marklogic-tutorial.gemspec` | No |
| ropencode-rails | No | `opencode-rails.gemspec` | No |
| spawned | No | `spawned.gemspec` | No |
| vector-mcp-gem | No | `vector-mcp.gemspec` | No |

**Notes**

- *Git Submodule* is derived from `.gitmodules`.
- *Gem Configuration* indicates presence of a `.gemspec`.
- *Gemfile Included* means explicitly referenced via `path:` in the root `Gemfile`.
