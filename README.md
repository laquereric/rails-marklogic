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

## MCP Doctor Demo: “Why did the model answer this?”

Rails‑MarkLogic introduces **MCP Doctor**, a diagnostic substrate for AI systems built on MCP.

### The Question
A user asks a question. The model answers. MCP Doctor explains *why that answer was possible* — with evidence.

### What MCP Doctor Captures
- MCP message envelopes
- Tool invocations and declared schemas
- Retrieved RAG source documents
- Temporal and semantic constraints

### What MCP Doctor Explains
- Which documents influenced the answer
- Why those documents were eligible
- Which constraints were satisfied
- Which constraints were violated or missing
- Whether schema drift occurred during tool calls

### Example Diagnostic Output
```json
{
  "answer": "The contract is valid under New York law.",
  "doctor_report": {
    "confidence": "medium",
    "rag_justification": {
      "documents_used": ["contract_v3.xml", "case_law_2019.json"],
      "constraints_satisfied": ["domain=legal", "effective_date<=2024"],
      "constraints_violated": ["jurisdiction!=NY"]
    }
  }
}
```

This explanation is **schema‑aware, queryable, and auditable** — not probabilistic.

This capability is not achievable with vector search alone and is the core differentiator of Rails‑MarkLogic.

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
