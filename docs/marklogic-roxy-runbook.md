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
Re-deploy modules after each ML12 patch and validate REST endpoints.