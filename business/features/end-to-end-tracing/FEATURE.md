# End-to-End LLM + Agent Tracing

## What it is
Capture a single trace across an agent workflow: prompts, responses, tool calls, model/guardrail/orchestrator steps, latency, errors, and token usage.

## Why it matters
Agentic systems fail in non-obvious places (tools, retrieval, orchestration). End-to-end traces make bottlenecks and failure modes debuggable.

## Key signals
- Prompt/response payload metadata (redacted as needed)
- Tool/function call spans
- Latency breakdown per step
- Error types and retries
- Token usage per span

## Noted in this landscape
Datadog, New Relic, Dynatrace; open-source stacks commonly implement via OpenTelemetry.
