# OpenTelemetry-Native, Vendor-Agnostic Telemetry

## What it is
Emit traces/metrics/logs using OpenTelemetry conventions so data can flow to multiple backends (Jaeger/Tempo/vendor platforms) without lock-in.

## Why it matters
Teams want flexibility across vendors and consistency across services; OpenTelemetry provides shared semantics and instrumentation paths.

## Key signals
- OTel spans for prompts/tool calls
- Standard attributes (model, tokens, tool name, error type)
- Export pipelines to multiple backends

## Noted in this landscape
Arize (Phoenix built on open standards), Traceloop (OpenLLMetry), open-source offerings emphasized as interoperable.
