# Full-Stack Correlation (APM/RUM + LLM)

## What it is
Link LLM/agent traces to the rest of the application: services, databases, APIs, queues, and (optionally) browser/user sessions.

## Why it matters
LLM issues are often downstream symptoms (slow DB, flaky API, bad cache). Correlation prevents “LLM blame” by showing the full causal chain.

## Key signals
- Trace/span linkage between LLM spans and service spans
- Request IDs / session IDs / user IDs (privacy-aware)
- Dependency maps and critical path

## Noted in this landscape
Datadog (APM + RUM correlation), New Relic (full-stack AI observability).
