# Agent Merge Protocol

## Before Opening a PR
- Ensure the worktree reports a clean `git status`.
- Update `AGENT_NOTES.md` with a final summary and outstanding risks.
- Set the lease status for the task to `review` in `config/agent_leases.yml`.
- Run the task-specific verification steps listed in the brief.

## Pull Request Checklist
- Title: `[agent] <slug> — <task summary>`
- Description includes:
  - Objective recap and links to task brief
  - Scope of files touched (aligned with lease directories)
  - Test results or manual verification evidence
  - Risks, follow-ups, or escalations
- Assign the MCP owner as reviewer and label with `agent`.

## Review Expectations
- Confirm only leased directories changed.
- Validate tests and compliance checks pass.
- Ensure documentation and notes reflect final state.
- Update lease status to `merged` upon approval.

## Post-Merge Cleanup
- Run `script/agent-cleanup <slug>` to remove the worktree and mark the lease `retired`.
- Archive the task brief and notes if long-term retention is required.
- Capture lessons learned in `docs/agents/logbook.md` (one-line summary).

## Incident Handling
- If unexpected files are present, request agent to quarantine the branch and rerun.
- For severe issues, revert via MCP owner and set lease status `quarantined`.
- Record the incident in `docs/agents/incidents.md` with remediation steps.
