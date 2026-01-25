#!/usr/bin/env bash

llm_models_validate() {
  if [ -n "${LLM_MODELS_VALIDATED:-}" ]; then
    return
  fi

  local have_models=false
  local model_name
  while IFS= read -r model_name; do
    have_models=true
    local backend
    backend=$(llm_model_backend "$model_name")
    llm_model_require_backend_support "$backend" "$model_name"
  done < <(llm_config_models_names)

  if [ "$have_models" = false ]; then
    llm_die "No models declared in config"
  fi

  LLM_MODELS_VALIDATED=1
}

llm_model_backend() {
  local name=$1
  llm_model_assert_exists "$name"
  local backend
  backend=$(llm_config_string "models.$name.backend")
  if [ -z "$backend" ]; then
    llm_die "Model '$name' is missing a backend"
  fi
  printf '%s\n' "$backend"
}

llm_model_capabilities() {
  local name=$1
  llm_model_assert_exists "$name"
  llm_config_get "models.$name.capabilities"
}

llm_model_require_backend_support() {
  local backend=$1
  local name=$2

  case "$backend" in
    none)
      ;; # placeholder backend for smoke tests
    ollama)
      llm_require_command ollama
      ;;
    *)
      llm_die "Model '$name' references unsupported backend '$backend'"
      ;;
  esac
}

llm_model_default_name() {
  llm_config_default_models | head -n1
}

llm_model_exists() {
  local name=$1
  local raw
  raw=$(llm_config_get "models.$name")
  [ "$raw" != "null" ] && [ -n "$raw" ]
}

llm_model_assert_exists() {
  local name=$1
  if ! llm_model_exists "$name"; then
    llm_die "Unknown model '$name'"
  fi
}

llm_model_backend_runner() {
  local name=$1
  local backend
  backend=$(llm_model_backend "$name")
  case "$backend" in
    none)
      echo ""
      ;;
    ollama)
      local runner
      runner=$(llm_config_string "models.$name.model")
      if [ -z "$runner" ]; then
        llm_die "Model '$name' must set 'model' for ollama backend"
      fi
      printf '%s\n' "$runner"
      ;;
  esac
}

llm_model_invoke() {
  local name=$1
  local prompt=$2
  local backend
  backend=$(llm_model_backend "$name")

  case "$backend" in
    none)
      llm_die "Model '$name' uses placeholder backend 'none'; cannot invoke."
      ;;
    ollama)
      llm_model_require_backend_ready "$name"
      llm_backend_ollama_invoke "$name" "$prompt"
      ;;
    *)
      llm_die "Unsupported backend '$backend' for model '$name'"
      ;;
  esac
}

llm_models_verify_runtime() {
  local runtime_ok=true
  local model_name
  while IFS= read -r model_name; do
    if ! llm_model_check_backend_ready "$model_name"; then
      runtime_ok=false
    fi
  done < <(llm_config_models_names)

  if [ "$runtime_ok" = true ]; then
    return 0
  fi

  return 1
}

llm_model_check_backend_ready() {
  local name=$1
  local backend
  backend=$(llm_model_backend "$name")

  case "$backend" in
    none)
      return 0
      ;;
    ollama)
      llm_backend_ollama_check_model "$name"
      ;;
    *)
      llm_die "Unsupported backend '$backend' for model '$name'"
      ;;
  esac
}

llm_model_require_backend_ready() {
  local name=$1
  if ! llm_model_check_backend_ready "$name"; then
    llm_die "Model '$name' backend is not ready"
  fi
}
