# MarkLogic 12 + Legacy Roxy Runbook

## Scope
Roxy is restricted to **modules-only deployments**.

## Allowed
- ml deploy modules

## Forbidden
- bootstrap
- deploy all
- deploy databases
- deploy servers

## CI
All deployments occur via GitHub Actions.

## Patch Upgrades

### Run Patch Gate (Prod)
1. Apply MarkLogic patch
2. Trigger **MarkLogic Patch Gate (Prod)** workflow manually
3. Confirm all REST, Optic, and Data Hub checks pass
4. Reopen traffic

### Rollback
- If Patch Gate fails, rollback the MarkLogic patch
- Do **not** change Roxy or redeploy infrastructure

### GitHub Protections
- `prod` environment must require manual approval
- Restrict secrets to `prod` environment only