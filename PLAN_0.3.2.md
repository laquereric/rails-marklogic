# PLAN 0.3.2 - Version Propagation and Guardrails

## Intent
Define the authoritative version source and the set of components that must remain version-aligned with the root release, then add lightweight checks so drift is caught early.

## Recommended Policy
- **Authoritative version:** root `VERSION`.
- **Release-aligned set (recommended):** root plus in-repo vendored gems that are versioned here (gemspec/version constants).
- **Submodules:** only bump a submodule's version when the submodule pointer changes as part of the release.
  - Rationale: avoids cross-repo release coordination for unchanged dependencies.

## Goals
- Explicitly define "what gets bumped" for a platform release.
- Reduce manual version editing across gemspecs/constants.
- Add a deterministic verification step suitable for CI and local use.

## Non-Goals
- No new packaging or publishing workflow.
- No vendor content refactors.

## Work Items
1. Inventory version sources
   - Root `VERSION`.
   - Per-component `VERSION` files.
   - `lib/**/version.rb` constants.
   - Gem specs with inline string versions.
   - Submodules: treat as independent unless explicitly changed.

2. Standardize how aligned components derive version
   - Prefer `File.read("VERSION").strip` or equivalent within the component directory.
   - Where a constant exists, ensure it is generated from the local `VERSION` file (or ensure the local `VERSION` file is updated in lockstep).

3. Add a drift check
   - Provide a script or rake task that:
     - reads root `VERSION`
     - reads the aligned components' version sources
     - fails with a clear message if any diverge
   - Keep it fast (no network, no external dependencies beyond Ruby).
   - For submodules, verify only the ones touched in the release.

4. Document the contract
   - Add a short section to `docs/releases/RELEASE_CHECKLIST.md` describing:
     - what must be updated for a release bump
     - what is validated by the drift check

## Outputs
- A single documented versioning contract.
- A deterministic drift check that can run in CI.

## Verification
- Run the drift check with a clean tree (expect pass).
- Temporarily introduce a mismatch (expect fail with actionable output), then revert.
