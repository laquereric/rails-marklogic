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

  python3 - "$response" "$host" "$model" <<'PY'
import json
import sys

data = json.loads(sys.argv[1])
host = sys.argv[2]
model = sys.argv[3]

message = data.get("message", {}).get("content")
if not message:
    choices = data.get("choices") or []
    if choices:
        message = choices[0].get("message", {}).get("content")

if not message:
    message = "(no content)"

print(f"probe target: {host} -> {model}")
print("probe response:")
print(message)
PY
}
