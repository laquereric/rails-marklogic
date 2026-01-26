# Release Train Checklist

## Preparation
- [ ] Ensure `main` is green on CI (vendor, compliance, tests)
- [ ] Confirm `config/vendor-lock.json` matches submodule state
- [ ] Verify `config/agent_leases.yml` has no `active` leases (only `retired`)
- [ ] Update `CHANGELOG.md` and `VERSION`
- [ ] Draft RFCs merged for any breaking changes

## Tag & Publish
- [ ] Run `bin/onboard --verify`
- [ ] Run `bin/merge-queue-check`
- [ ] Create annotated tag `<version>` (e.g. `0.4.0`)
- [ ] Push tag and changelog to origin

## Post-Release
- [ ] Notify stakeholders (engineering, compliance, managers)
- [ ] Schedule next quarterly review in `compliance/reviews`
- [ ] Close or roll over outstanding actions from the release retro
