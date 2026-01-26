#!/usr/bin/env bash

llm_probe_default_system() {
  cat <<'EOF'
You are verifying that the local MCP LLM gateway can reach its configured model. Respond succinctly.
EOF
}

llm_probe_default_user() {
  echo "Reply with the text 'probe-ok'."
}

llm_probe_run() {
  local system_msg=$1
  local user_msg=$2
  local output_mode=${3:-human}

  llm_require_command curl
  llm_require_command python3

  local host
  host=$(llm_mcp_expected_host)
  local model
  model=$(llm_mcp_expected_runner)
  local url="$host/api/chat"

  local payload
  payload=$(python3 - "$model" "$system_msg" "$user_msg" <<'PY'
import json
import sys

model, system_msg, user_msg = sys.argv[1:4]
payload = {
    "model": model,
    "messages": [
        {"role": "system", "content": system_msg},
        {"role": "user", "content": user_msg},
    ],
    "stream": False,
}
print(json.dumps(payload))
PY
  )

  local response
  if ! response=$(curl -sS --fail "$url" -H "Content-Type: application/json" -d "$payload"); then
    llm_die "Ollama probe failed against $url"
  fi

  local response_file
  response_file=$(mktemp)
  printf '%s' "$response" >"$response_file"

  local result_json
  if ! result_json=$(python3 - "$host" "$model" "$response_file" <<'PY'
import json
import sys
from pathlib import Path

host = sys.argv[1]
model = sys.argv[2]
path = Path(sys.argv[3])

try:
    data = json.loads(path.read_text())
except json.JSONDecodeError as exc:
    print(f"Unable to parse probe response: {exc}", file=sys.stderr)
    sys.exit(1)

message = data.get("message", {}).get("content")
if not message:
    choices = data.get("choices") or []
    if choices:
        message = choices[0].get("message", {}).get("content")

if not message:
    message = "(no content)"

print(json.dumps({
    "status": "ok",
    "host": host,
    "model": model,
    "response": message,
}, ensure_ascii=False))
PY
  ); then
    rm -f "$response_file"
    llm_die "Failed to interpret probe response"
  fi

  rm -f "$response_file"

  if [ "$output_mode" = "json" ]; then
    printf '%s\n' "$result_json"
    return
  fi

  python3 - "$result_json" <<'PY'
import json
import sys

data = json.loads(sys.argv[1])
print(f"probe target: {data['host']} -> {data['model']}")
print("probe response:")
print(data['response'])
PY
}
