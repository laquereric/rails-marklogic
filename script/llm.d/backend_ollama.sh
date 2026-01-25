#!/usr/bin/env bash

llm_backend_ollama_invoke() {
  local model_name=$1
  local prompt=$2

  llm_require_command ollama

  local runner
  runner=$(llm_model_backend_runner "$model_name")
  if [ -z "$runner" ]; then
    llm_die "Model '$model_name' has no 'model' value configured"
  fi

  if ! printf '%s' "$prompt" | ollama run "$runner"; then
    llm_die "ollama invocation failed for runner '$runner'"
  fi
}

llm_backend_ollama_check_model() {
  local model_name=$1
  llm_require_command ollama

  local runner
  runner=$(llm_model_backend_runner "$model_name")
  if [ -z "$runner" ]; then
    llm_die "Model '$model_name' must define 'model' for the ollama backend"
  fi

  if ! ollama show "$runner" >/dev/null 2>&1; then
    printf 'Ollama runner "%s" is missing. Install it via: ollama pull %s\n' "$runner" "$runner" >&2
    return 1
  fi

  return 0
}
