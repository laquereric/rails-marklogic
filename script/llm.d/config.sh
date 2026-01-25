#!/usr/bin/env bash

llm_config_load() {
  if [ -n "${LLM_CONFIG_LOADED:-}" ]; then
    return
  fi

  llm_require_config
  llm_require_command python3

  local json
  if ! json=$(python3 - "$LLM_CONFIG_PATH" <<'PY'
import json
import sys
import tomllib
from pathlib import Path

path = Path(sys.argv[1])
try:
    with path.open('rb') as handle:
        data = tomllib.load(handle)
except FileNotFoundError:
    print(f"Config file not found: {path}", file=sys.stderr)
    sys.exit(66)
except tomllib.TOMLDecodeError as exc:
    print(f"TOML error: {exc}", file=sys.stderr)
    sys.exit(65)
except Exception as exc:  # pragma: no cover
    print(f"Unable to read config: {exc}", file=sys.stderr)
    sys.exit(1)

json.dump(data, sys.stdout, separators=(',', ':'))
PY
  ); then
    llm_die "Failed to parse TOML config"
  fi

  export LLM_CONFIG_JSON="$json"
  LLM_CONFIG_LOADED=1

  _llm_config_validate_defaults
}

llm_config_get() {
  local path=${1:-}
  llm_config_load

  python3 - "$path" <<'PY'
import json
import os
import sys

data = json.loads(os.environ['LLM_CONFIG_JSON'])
path = sys.argv[1]

node = data
if path:
    for part in path.split('.'):
        if isinstance(node, dict) and part in node:
            node = node[part]
        else:
            node = None
            break

json.dump(node, sys.stdout, ensure_ascii=False)
PY
}

llm_config_models_names() {
  local json
  json=$(llm_config_get models)
  python3 - "$json" <<'PY'
import json
import sys

models = json.loads(sys.argv[1]) or {}
for name in models.keys():
    print(name)
PY
}

llm_config_default_models() {
  local json
  json=$(llm_config_get models)
  python3 - "$json" <<'PY'
import json
import sys

models = json.loads(sys.argv[1]) or {}
defaults = [name for name, cfg in models.items() if cfg.get('default')]
for name in defaults:
    print(name)
PY
}

llm_config_string() {
  local path=$1
  local raw
  raw=$(llm_config_get "$path")

  python3 - "$raw" <<'PY'
import json
import sys

value = json.loads(sys.argv[1])
if value is None:
    print('')
else:
    print(str(value))
PY
}

llm_config_bool() {
  local path=$1
  local raw
  raw=$(llm_config_get "$path")

  python3 - "$raw" <<'PY'
import json
import sys

value = json.loads(sys.argv[1])
print('true' if bool(value) else 'false')
PY
}

_llm_config_validate_defaults() {
  python3 - <<'PY'
import json
import os
import sys

config = json.loads(os.environ['LLM_CONFIG_JSON'])
models = config.get('models') or {}
defaults = [name for name, cfg in models.items() if cfg.get('default')]

if not defaults:
    print("Config error: define exactly one default model.", file=sys.stderr)
    sys.exit(78)

if len(defaults) > 1:
    joined = ', '.join(defaults)
    print(f"Config error: multiple default models detected ({joined}).", file=sys.stderr)
    sys.exit(79)
PY
}
