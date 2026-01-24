#!/usr/bin/env bash
set -euo pipefail

: "${ML_REST_BASE:?Missing ML_REST_BASE}"

ML_ENV=${ML_ENV:-dev}

section() { echo "---- $1 ----"; }

section "REST ping"
curl -f "$ML_REST_BASE/v1/ping"

section "REST extensions"
if [ -n "${ML_REST_SMOKE_RESOURCE:-}" ]; then
  curl -f "$ML_REST_BASE/v1/resources/$ML_REST_SMOKE_RESOURCE"
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

section "Data Hub flow discovery"
# Lists flows without execution
curl -f "$ML_REST_BASE/v1/eval" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "xquery=for $f in cts:uris('',(),cts:directory-query('/data-hub/flows/', 'infinity')) return $f"

if [ "$ML_ENV" = "staging" ] || [ "$ML_ENV" = "prod" ]; then
  section "Custom Data Hub step modules"
  # Verifies custom step modules load (no execution)
  curl -f "$ML_REST_BASE/v1/eval" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "xquery=cts:uris('',(),cts:directory-query('/custom-modules/', 'infinity'))"
else
  section "Custom Data Hub step modules"
  echo "Skipped in $ML_ENV environment"
fi