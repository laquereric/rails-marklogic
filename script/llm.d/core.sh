#!/usr/bin/env bash

LLM_BIN_NAME=${LLM_BIN_NAME:-llm}

llm_die() {
  printf '%s: %s\n' "$LLM_BIN_NAME" "$*" >&2
  exit 1
}

llm_require_config() {
  if [ ! -f "$LLM_CONFIG_PATH" ]; then
    llm_die "Missing config file at $LLM_CONFIG_PATH"
  fi
}

llm_require_command() {
  local tool=$1
  if ! command -v "$tool" >/dev/null 2>&1; then
    llm_die "Required command '$tool' is not on PATH"
  fi
}
