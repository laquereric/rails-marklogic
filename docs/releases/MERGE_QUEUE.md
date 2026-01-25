# Merge Queue Protocol

## Goal
Guarantee that every change merged into `main` has passed governance, vendor, and compliance gates before release.

## Workflow
1. Developers create feature branches (or agent branches) and open PRs.
2. PRs enter the merge queue only after:
   - CI green (`bin/ci`)
   - `bin/merge-queue-check` succeeds locally or via automation
   - Required reviewers approve (MCP owner + feature owner)
3. Queue merges sequentially to keep history linear.

## Required Checks
- Vendor immutability (`bin/check-vendor-mutations`)
- Vendor lock consistency (`bin/vendor-verify`)
- Shadow AI guard (`bin/rails test test/integration/shadow_ai_guard_test.rb`)
- MCP API contract (`bin/rails test test/services/mcp_api_contract_test.rb`)
- Full CI (`bin/ci`)

## Roles
- **Queue Steward:** Owns the queue, reruns checks after conflicts, communicates pauses.
- **MCP Owner:** Reviews changes touching MCP or compliance artifacts.
- **Release Manager:** Monitors changelog and schedules tags.

## Tooling
- `bin/merge-queue-check` consolidates mandatory gates.
- GitHub merge queue (recommended) or equivalent automation should invoke this script before merge.
