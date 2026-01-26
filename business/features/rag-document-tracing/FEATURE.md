# RAG Document Tracing

## What it is
Trace Retrieval-Augmented Generation (RAG) end-to-end so you can answer: which documents/chunks were retrieved, how they were ranked, what was injected into the prompt, and whether the final answer was grounded in those sources.

## Why it matters
RAG failures often look like "model hallucination" but originate upstream: wrong query rewrite, embedding drift, vector store latency, poor chunking, missing filters, or bad reranking. Document-level tracing connects the final answer back to retrieval decisions.

## What to capture
- Retrieval pipeline steps: query rewrite, embedding generation, vector search, keyword/hybrid search, rerank, final context assembly.
- Document lineage: corpus/index, document IDs/URIs, chunk IDs, versions, and score/rank at each stage.
- Context injection: which chunks were included/excluded, token budget pressure, truncation strategy.
- Outcome signals: whether citations/attributions align with retrieved chunks; user feedback or evaluator scores.

## OpenTelemetry mapping (practical)
- Identify the corpus/index with `gen_ai.data_source.id` (GenAI semantic conventions).
- Model calls for query embeddings or rerank prompts can be `gen_ai.operation.name = embeddings` or `chat` spans.
- Treat retrieval as a tool when it is invoked as part of an agent/tool chain, using an `execute_tool` span and `gen_ai.tool.*` attributes.
- Instrument vector/keyword stores with standard DB client spans/metrics (`db.*` semantic conventions), so retrieval latency correlates with the rest of the stack.

## Privacy + cardinality guidance
- Prefer stable identifiers (doc_id, chunk_id, corpus_id) over raw text.
- Make raw chunk text and full prompt context opt-in, and use redaction/truncation.
- If you need content for debugging, consider storing it externally and linking from telemetry (GenAI span guidance includes "uploading content to external storage").

## References
- OTel GenAI spans (covers `embeddings`, `execute_tool`, and content capture guidance): https://opentelemetry.io/docs/specs/semconv/gen-ai/gen-ai-spans/
- OTel GenAI agent spans (includes `gen_ai.data_source.id` on `invoke_agent`): https://opentelemetry.io/docs/specs/semconv/gen-ai/gen-ai-agent-spans/
- OTel GenAI attribute registry (`gen_ai.data_source.id`): https://opentelemetry.io/docs/specs/semconv/registry/attributes/gen-ai/
- OTel DB semantic conventions (for vector DB / search backends via `db.*`): https://opentelemetry.io/docs/specs/semconv/db/
