# MCP Request Lifecycle Monitoring

## What it is
Automatically trace and measure the full Model Context Protocol (MCP) request lifecycle: client request, tool selection, tool execution, and response.

## Why it matters
MCP introduces many new “edges” (tools, servers, function routing). Lifecycle visibility reduces time-to-diagnose across client/server boundaries.

## Key signals
- MCP request/response timings
- Tool and function identification
- Context propagation across hops
- Failure classification (tool error vs server error vs model error)

## Noted in this landscape
New Relic (automatic MCP lifecycle monitoring), Datadog (MCP client/server tracing), Langfuse (MCP tracing + context propagation).
