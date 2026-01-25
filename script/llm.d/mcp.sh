#!/usr/bin/env bash

llm_mcp_assert_ready() {
  llm_mcp_require_vendor
  llm_require_command ruby
  llm_mcp_detect_version
  llm_mcp_check_min_version
  llm_mcp_verify_require
}

llm_mcp_require_vendor() {
  local dir
  dir=$(llm_mcp_dir)
  if [ ! -d "$dir" ]; then
    llm_die "mcp-lm vendor directory missing at $dir"
  fi
}

llm_mcp_detect_version() {
  if [ -n "${LLM_MCP_VERSION:-}" ]; then
    return
  fi

  local version
  local dir
  dir=$(llm_mcp_dir)

  if ! version=$(ruby - "$dir" <<'RUBY'
require 'rubygems'
spec_path = File.join(ARGV[0], 'mcp-lm.gemspec')
unless File.exist?(spec_path)
  warn "Unable to locate #{spec_path}"
  exit 1
end
spec = Gem::Specification.load(spec_path)
unless spec
  warn 'Unable to load Gem::Specification'
  exit 1
end
print spec.version.to_s
RUBY
  ); then
    llm_die "Failed to detect mcp-lm version"
  fi

  LLM_MCP_VERSION=$version
}

llm_mcp_check_min_version() {
  local min_version
  min_version=$(llm_config_string 'mcp.min_version')
  if [ -z "$min_version" ]; then
    return
  fi

  llm_mcp_detect_version

  if ! ruby - "$LLM_MCP_VERSION" "$min_version" <<'RUBY'
require 'rubygems'
actual = Gem::Version.new(ARGV[0])
required = Gem::Version.new(ARGV[1])
exit(actual >= required ? 0 : 1)
RUBY
  then
    llm_die "mcp-lm #{LLM_MCP_VERSION} does not meet minimum #{min_version}"
  fi
}

llm_mcp_verify_require() {
  llm_mcp_require_vendor
  local dir
  dir=$(llm_mcp_dir)
  if [ ! -f "$dir/lib/mcp/mcp_lm.rb" ]; then
    llm_die "Vendored mcp-lm is missing lib/mcp/mcp_lm.rb"
  fi
}

llm_mcp_dir() {
  if [ -n "${LLM_MCP_DIR:-}" ]; then
    printf '%s\n' "$LLM_MCP_DIR"
    return
  fi

  local configured
  configured=$(llm_config_string 'mcp.path')
  if [ -z "$configured" ]; then
    configured="vendor/mcp-lm"
  fi

  case "$configured" in
    /*)
      LLM_MCP_DIR="$configured"
      ;;
    *)
      LLM_MCP_DIR="$LLM_ROOT/$configured"
      ;;
  esac

  printf '%s\n' "$LLM_MCP_DIR"
}

llm_mcp_auto_provider_path() {
  printf '%s/lib/mcp/providers/auto_provider.rb\n' "$(llm_mcp_dir)"
}

llm_mcp_expected_runner() {
  if [ -n "${LLM_MCP_EXPECTED_RUNNER:-}" ]; then
    printf '%s\n' "$LLM_MCP_EXPECTED_RUNNER"
    return
  fi

  LLM_MCP_EXPECTED_RUNNER=$(llm_mcp_extract_auto_const "MODEL")
  printf '%s\n' "$LLM_MCP_EXPECTED_RUNNER"
}

llm_mcp_expected_host() {
  if [ -n "${LLM_MCP_EXPECTED_HOST:-}" ]; then
    printf '%s\n' "$LLM_MCP_EXPECTED_HOST"
    return
  fi

  LLM_MCP_EXPECTED_HOST=$(llm_mcp_extract_auto_const "OLLAMA_HOST")
  printf '%s\n' "$LLM_MCP_EXPECTED_HOST"
}

llm_mcp_extract_auto_const() {
  local constant=$1
  local file
  file=$(llm_mcp_auto_provider_path)
  if [ ! -f "$file" ]; then
    llm_die "Missing AutoProvider definition at $file"
  fi

  local value
  if ! value=$(python3 - "$file" "$constant" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
const_name = sys.argv[2]
text = path.read_text()
pattern = rf"{const_name}\s*=\s*([\"'])(.*?)\1"
match = re.search(pattern, text)
if not match:
    print(f"Constant {const_name} not found in {path}", file=sys.stderr)
    sys.exit(1)
print(match.group(2))
PY
  ); then
    llm_die "Unable to extract ${constant} from AutoProvider"
  fi

  printf '%s\n' "$value"
}

llm_mcp_require_alignment() {
  local expected_runner
  expected_runner=$(llm_mcp_expected_runner)
  local default_model
  default_model=$(llm_model_default_name)
  if [ -z "$default_model" ]; then
    llm_die "No default model defined in config"
  fi
  local configured_runner
  configured_runner=$(llm_model_backend_runner "$default_model")

  if [ "$expected_runner" != "$configured_runner" ]; then
    llm_die "Default model '$default_model' runs '$configured_runner' but MCP AutoProvider expects '$expected_runner'"
  fi
}
