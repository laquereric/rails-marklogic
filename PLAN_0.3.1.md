# PLAN 0.3.1 - Version Metadata Alignment

## Intent
Bring the repository's stated version information into alignment with the current reality (`VERSION` is already `0.3.0`) so the `0.4.0` bump is mechanical, auditable, and low-risk.

## Context
- Root `VERSION` is `0.3.0`.
- `CHANGELOG.md` does not contain a `0.3.0` entry.
- `PLAN.md` still claims a baseline of `0.1.0`.
- Release docs mention a tag format (`mcp-v<version>`) that does not match the tags currently present (`v0.1.0`, `0.3.0`).

## Goals
- Changelog, plan docs, and release checklist tell the same story.
- Version sources are explicitly documented (what is authoritative vs derived).
- Release tag format is clarified so future releases are predictable.

## Non-Goals
- No version bump yet.
- No vendor upgrades.
- No functional code changes.

## Work Items
1. `CHANGELOG.md`
   - Add a `0.3.0` entry (dated) describing the changes that landed as part of the `0.3.0` release.
   - Leave `[Unreleased]` for post-0.3.0 work.

2. `PLAN.md`
   - Update "Current baseline" to `0.3.0`.
   - Ensure the versioning strategy section reflects current practice (root `VERSION`, tags, alignment).

3. `docs/releases/RELEASE_CHECKLIST.md`
   - Decide and codify a single tag format.
   - Recommended: keep the current repo tag format (`0.4.0`) and update the checklist accordingly.
   - Alternative: switch to `mcp-v<version>` and backfill/alias tags (requires more coordination).

4. Version source policy (document only)
   - Add a short note to `README.md` or `ROADMAP.md` clarifying:
     - Authoritative version file(s)
     - Which components are "release-aligned" (bumped together)
     - Which components are independent (not bumped in lockstep)

## Outputs
- Consistent, human-readable release metadata across:
  - `VERSION`
  - `CHANGELOG.md`
  - `PLAN.md`
  - `docs/releases/RELEASE_CHECKLIST.md`

## Verification
- Grep for stale baseline/version strings (e.g. `0.1.0` baseline references).
- Confirm release docs match the tag naming convention used in git.
