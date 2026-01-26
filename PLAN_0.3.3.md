# PLAN 0.3.3 - 0.4.0 Release Rehearsal (Dry Run)

## Intent
Rehearse the exact mechanics of a `0.4.0` release so the real bump is routine and minimizes the chance of half-bumped versions or doc/tag mismatch.

## Assumptions
- `PLAN_0.3.1.md` completed (metadata aligned).
- `PLAN_0.3.2.md` completed (aligned set defined, drift check exists).

## Goals
- A step-by-step playbook for the `0.4.0` bump.
- A clear "done" definition including verification commands.
- A rollback plan if anything is inconsistent.

## Non-Goals
- No actual bump in this plan document.

## Playbook (For the Actual 0.4.0 Execution)
1. Pre-flight
   - Ensure `main` is green.
   - Ensure vendor lock and lease registry are clean per `docs/releases/RELEASE_CHECKLIST.md`.
   - Confirm `git status` is clean (or changes are understood).

2. Update versions
   - Set root `VERSION` to `0.4.0`.
   - Update all components in the release-aligned set.
   - Run drift check (must pass).

3. Update release metadata
   - Add `0.4.0` section to `CHANGELOG.md` with date.
   - Ensure any release docs referencing version/tag format match the chosen convention.

4. Verify
   - Run `bin/onboard --verify`.
   - Run `bin/merge-queue-check`.
   - Run the project's test suite (or the subset required by policy).

5. Tag
   - Create annotated tag using the chosen format (must match the release checklist).
   - Ensure the tag points at the commit that includes `VERSION` + changelog updates.

6. Post-release
   - Ensure any quarterly review scheduling steps are followed.
   - Roll forward `[Unreleased]` items and open follow-ups if needed.

## Rollback Plan
- If drift check fails after bump:
  - revert the version edits (root + aligned set) until the drift check passes.
- If tag was created locally but should not be published:
  - delete the local tag and re-create after fixes (only if it has not been pushed).

## Definition of Done
- Versions are consistently `0.4.0` across the aligned set.
- Drift check passes.
- Changelog contains a `0.4.0` entry.
- Verification commands pass.
- Tag is created in the documented format.
