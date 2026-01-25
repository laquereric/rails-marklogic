#!/usr/bin/env bash

llm_routing_validate() {
  if [ -n "${LLM_ROUTING_VALIDATED:-}" ]; then
    return
  fi

  local has_tasks=false
  local routing_task
  local routing_model
  while IFS=$'\t' read -r routing_task routing_model; do
    has_tasks=true
    if [ -z "$routing_task" ] || [ -z "$routing_model" ]; then
      llm_die "Routing entries must include both task and model"
    fi
    llm_model_assert_exists "$routing_model"
  done < <(llm_routing_pairs)

  if [ "$has_tasks" = false ]; then
    llm_die "Routing table is empty; add entries under [routing]"
  fi

  LLM_ROUTING_VALIDATED=1
}

llm_routing_pairs() {
  local json
  json=$(llm_routing_json)
  python3 - "$json" <<'PY'
import json
import sys

routing = json.loads(sys.argv[1]) or {}
for task, model in routing.items():
    print(f"{task}\t{model}")
PY
}

llm_routing_model_for() {
  local requested_task=$1
  llm_routing_validate
  local json
  json=$(llm_routing_json)
  local model
  model=$(python3 - "$json" "$requested_task" <<'PY'
import json
import sys

routing = json.loads(sys.argv[1]) or {}
task = sys.argv[2]
model = routing.get(task, '')
print(model)
PY
  )

  if [ -z "$model" ]; then
    llm_die "No routing rule for task '$requested_task'"
  fi

  printf '%s\n' "$model"
}

llm_routing_json() {
  if [ -z "${LLM_ROUTING_JSON:-}" ]; then
    LLM_ROUTING_JSON=$(llm_config_get routing)
  fi
  printf '%s\n' "$LLM_ROUTING_JSON"
}
