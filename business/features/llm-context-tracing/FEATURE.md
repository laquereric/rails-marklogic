# LLM Context Tracing

## What it is
Capture and correlate the *effective context* used in an LLM/agent interaction: conversation/session identity, system instructions, prompt templates + versions, chat history, retrieved context (RAG), tool calls/results, and truncation/summarization decisions.

## Why it matters
Many LLM failures are context failures: the right data was never present, was truncated, was overwritten by later turns, or was poisoned by injection. Context tracing makes it possible to debug multi-turn behavior, reproduce regressions, and explain why a response happened (without relying on model introspection).

## What to capture
- Conversation identity: stable conversation/session/thread id; turn index; parent/child trace links for subcalls.
- Prompt assembly: prompt/template id + version; runtime variables; system instruction set; safety/guardrail policy id.
- Context window pressure: token budget, truncation strategy, summarization steps, dropped messages/chunks.
- Retrieval lineage: corpus/index ids; document/chunk ids and ranks; citations emitted vs retrieved.
- Tool interactions: tool name, args/result (redacted/hashed as needed), tool latency/error classification.

## OpenTelemetry mapping (practical)
- Use W3C Trace Context (`traceparent`/`tracestate`) so context spans correlate with normal APM spans.
- Propagate conversation/session ids across service boundaries via OTel Baggage when they are not natively available.
- Attach conversation/session identifiers via GenAI semantic conventions:
  - `gen_ai.conversation.id` (conversation/thread/session id)
  - `gen_ai.prompt.name` (prompt template identifier)
- Capture content behind explicit opt-in using GenAI opt-in attributes:
  - `gen_ai.system_instructions`
  - `gen_ai.input.messages`
  - `gen_ai.output.messages`
- For MCP-mediated flows, also emit MCP attributes such as `mcp.session.id` and `mcp.method.name`.
- If full content is too large/sensitive, follow OTel guidance to store it externally and link from telemetry.

## Privacy + cardinality guidance
- Default to identifiers and hashes (prompt_id, doc_id, tool_name) over raw text.
- Make prompt/context/tool payload capture opt-in; support redaction and truncation.
- Use retention controls; treat context as potentially containing secrets/PII.

## Noted in this landscape
Langfuse (sessions + distributed tracing), Traceloop/OpenLLMetry (OTel-native tracing), Datadog/New Relic/Dynatrace (full-stack correlation with APM).

## References
- OTel context propagation: https://opentelemetry.io/docs/concepts/context-propagation/
- W3C Trace Context: https://www.w3.org/TR/trace-context/
- OTel GenAI spans + content capture guidance: https://opentelemetry.io/docs/specs/semconv/gen-ai/gen-ai-spans/
- OTel GenAI attribute registry (`gen_ai.*`): https://opentelemetry.io/docs/specs/semconv/registry/attributes/gen-ai/
- OTel MCP attribute registry (`mcp.*`): https://opentelemetry.io/docs/specs/semconv/registry/attributes/mcp/
- Langfuse tracing: https://langfuse.com/docs/tracing
- Traceloop OpenLLMetry: https://www.traceloop.com/docs/openllmetry/introduction
