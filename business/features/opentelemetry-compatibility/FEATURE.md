# OpenTelemetry Compatibility

## What it is
First-class support for emitting and/or ingesting telemetry using OpenTelemetry standards so LLM + MCP observability works with existing OTel pipelines (SDKs, Collector, OTLP exporters, and multiple backends).

## Why it matters
"Compatible" is often overloaded. In practice, teams need: (1) transport compatibility (OTLP), (2) correlation compatibility (trace context propagation), and (3) meaning compatibility (semantic conventions for GenAI + MCP). Without all three, data may arrive but remain hard to query, correlate, or compare across tools.

## Compatibility checklist
- OTLP ingest/export: supports OTLP over gRPC/HTTP (direct or via OpenTelemetry Collector).
- Trace context propagation: preserves W3C Trace Context (traceparent/tracestate) so LLM spans correlate with APM spans.
- GenAI semantic conventions: emits `gen_ai.*` attributes/events/spans/metrics per OpenTelemetry semantic conventions (noting GenAI conventions are currently marked "Development").
- MCP semantic conventions: emits `mcp.*` attributes such as `mcp.method.name`, `mcp.session.id`, and `mcp.protocol.version` when tracing MCP interactions.
- Resource + service identity: populates standard OTel resource attributes (e.g., `service.name`, environment) so multi-service correlation works.
- Versioning/stability controls: documents the semantic convention version it emits; for GenAI, supports the OTel transition guidance (e.g., `OTEL_SEMCONV_STABILITY_OPT_IN` for opting into newer GenAI conventions).

## Implementation notes (what "good" looks like)
- Prefer emitting standard spans/attributes and letting the backend derive higher-level LLM views, instead of inventing a parallel schema.
- Keep high-cardinality/sensitive fields (prompt text, tool args/results) behind explicit opt-in and/or redaction.
- When spanning across boundaries (agent -> MCP server -> tool), propagate context rather than creating disconnected traces.

## References
- OpenTelemetry semantic conventions for GenAI (status: Development): https://raw.githubusercontent.com/open-telemetry/semantic-conventions/main/docs/gen-ai/README.md
- GenAI attribute registry (`gen_ai.*`): https://opentelemetry.io/docs/specs/semconv/registry/attributes/gen-ai/
- MCP attribute registry (`mcp.*`): https://opentelemetry.io/docs/specs/semconv/registry/attributes/mcp/
- Context propagation concepts: https://opentelemetry.io/docs/concepts/context-propagation/
- OTLP specification: https://opentelemetry.io/docs/specs/otlp/
