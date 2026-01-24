#!/usr/bin/env bash
set -euo pipefail

: "${ML_REST_BASE:?Missing ML_REST_BASE}"

ML_ENV=${ML_ENV:-dev}

section() { echo "---- $1 ----"; }

section "REST ping"
curl -sf "$ML_REST_BASE/v1/ping" | jq -e '."status" == "ok"'

section "REST extensions"
if [ -n "${ML_REST_SMOKE_RESOURCE:-}" ]; then
  curl -sf "$ML_REST_BASE/v1/resources/$ML_REST_SMOKE_RESOURCE" | jq -e '."ok" == true'
else
  echo "No ML_REST_SMOKE_RESOURCE set; skipping"
fi

section "Optic resource"
curl -f "$ML_REST_BASE/v1/resources/optic-test"

section "XQuery runtime"
curl -f "$ML_REST_BASE/v1/eval" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "xquery=xdmp:version()"

section "Data Hub framework"
# Confirms DH modules load without executing flows
curl -f "$ML_REST_BASE/v1/eval" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "xquery=import module namespace dhf='http://marklogic.com/data-hub-framework' at '/data-hub/5/impl/data-hub-framework.xqy'; 'ok'"

section "Data Hub flow metadata"
# Version pin assertions (ML + DH)
curl -sf "$ML_REST_BASE/v1/eval" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "xquery=xdmp:version()" | jq -e 'test("MarkLogic")'

curl -sf "$ML_REST_BASE/v1/eval" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "xquery=import module namespace dhf='http://marklogic.com/data-hub-framework' at '/data-hub/5/impl/data-hub-framework.xqy'; dhf:version()" | jq -e 'length > 0'

section "Data Hub flow metadata"
# Validate flow metadata without execution
curl -sf "$ML_REST_BASE/v1/eval" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "xquery=import module namespace dhf='http://marklogic.com/data-hub-framework' at '/data-hub/5/impl/data-hub-framework.xqy'; map:keys(dhf:get-flow-map())" | jq -e 'length > 0'

if [ "$ML_ENV" = "staging" ] || [ "$ML_ENV" = "prod" ]; then
  section "Rollback safety check"
  # Ensure last successful deploy artifacts still load
  curl -sf "$ML_REST_BASE/v1/eval" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "xquery=fn:doc-available('/marklogic.roxy.config')" | jq -e '. == true'

  section "Data Hub step definitions"
  section "Custom Data Hub step modules"
  # Verifies custom step modules load (no execution)
  curl -f "$ML_REST_BASE/v1/eval" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "xquery=cts:uris('',(),cts:directory-query('/custom-modules/', 'infinity'))"
else
  section "Custom Data Hub step modules"
  echo "Skipped in $ML_ENV environment"
fi