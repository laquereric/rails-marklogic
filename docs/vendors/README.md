# Vendor Governance

## Overview
All vendored dependencies are treated as immutable snapshots. Updates require an explicit lease, recorded in `config/agent_leases.yml`, and must follow the workflow below.

## Update Workflow
1. Acquire a lease covering the vendor directory.
2. Run `script/update-vendor <path>` to fetch and check out the new revision.
3. Execute `bin/vendor-lock` to refresh `config/vendor-lock.json`.
4. Review diffs, update documentation, and run the full CI suite.
5. Submit a pull request using the agent template, tagging the MCP owner.

## Lockfile
- `config/vendor-lock.json` captures the expected commit for every submodule.
- `bin/vendor-verify` (or `rake vendor:verify`) fails if the working tree diverges from the lockfile.
- CI enforces the lock; set `ALLOW_VENDOR_MUTATION=true` only within sanctioned update branches.

## Changelogs & Ownership
- Each vendor should have a companion file at `docs/vendors/<name>.md` summarizing domain ownership and release notes.
- Record rationale, upstream references, and testing performed for every bump.

## Incident Handling
- Unexpected mutations surface through `bin/vendor-verify`.
- If drift is detected in CI, block the merge, set the associated lease to `quarantined`, and investigate.
