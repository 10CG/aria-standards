# Submodule Pointer Hygiene (Aria Convention)

> **Version**: v1.0.0 — 2026-05-24
> **Status**: Active
> **Source incident**: 2026-05-23 PR #123 in `10CG/Aria` silent submodule pointer regression (`6fea5d7` static-rolled back 4 aria-plugin commits; caught by post-merge audit + fast-forward fix `a8e0096`)
> **Mechanical companion**: aria-plugin v1.28.0+ ships `(B+)` pre-merge gate in `aria/skills/phase-c-integrator/SKILL.md §C.2.4.5` (Spec [`aria-submodule-pointer-regression-gate`](https://github.com/10CG/Aria/tree/master/openspec/changes/aria-submodule-pointer-regression-gate)).
> **Forgejo**: Aria [#124](https://forgejo.10cg.pub/10CG/Aria/issues/124)
> **NOT a numbered CLAUDE.md Rule** — convention SOT lives here in `standards/conventions/` to keep CLAUDE.md Rule list at #1-#9 cap. Mechanical gate in v1.28.0+ enforces the structural cases this doc documents.

---

## Why

`git checkout origin/<branch> -- <submodule>` reads the **local** `origin/<branch>` ref. If the local ref has not been refreshed via `git fetch` in the current shell session, the staged submodule pointer can be **silently stale**, causing newer submodule commits from parallel work to be invisibly reverted at merge time.

The 2026-05-23 incident: PR #123 rebase against master conflicted on submodule `aria`. Operator ran `git checkout origin/master -- aria` to take main repo's view. The local `origin/master` ref was stale (no `git fetch` before the checkout). Staged aria pointer was an old SHA. Merge silently reverted 4 dev-claude2 commits (aria-plugin v1.24.1 + atomicity-guard + v1.25.0 + v1.26.0). Post-merge audit caught it within ~10 min; `a8e0096` fast-forward fix restored the lost commits. But the failure mode is silent and could go undetected for days in a less audited workflow.

## Conventions

### Rule 1 — Always `git fetch origin` before any rebase that may touch submodule pointers

If a PR has both your changes AND submodule pointer changes from another branch / terminal, your rebase will likely produce submodule conflicts. **Before** invoking `git rebase` (or `git pull --rebase`), explicitly:

```bash
git fetch origin
# (optionally also fetch each submodule's origin if you intend to inspect submodule history)
for sub in $(git config --file .gitmodules --get-regexp '^submodule\..*\.path$' | awk '{print $2}'); do
    git -C "$sub" fetch origin
done
```

This ensures `origin/<branch>` and `origin/<other-branch>` reflect the actual remote tip, not your last `git fetch` (which may have been hours ago).

### Rule 2 — Never `git checkout origin/<branch> -- <submodule>` without a fresh `git fetch` in the same shell session

This is the **direct anti-pattern** that caused the 2026-05-23 incident. Per Rule 1, fetch first. If you cannot fetch (offline, auth lapse), **abort the rebase** and investigate rather than proceeding with a potentially stale ref.

### Rule 3 — For deliberate rollback, use the override mechanism

Sometimes you legitimately need to roll back a submodule pointer (e.g., the latest aria-plugin release has a critical regression and you want master to point back to the previous version). Do NOT proceed silently. Use one of two explicit per-PR overrides:

**Option A — Commit trailer** (preferred — per-commit justification, persists in git history):

```
Submodule-Rollback: aria a8e0096→3b688a9 reason=v1.24.1 introduced critical hook regression
```

ASCII alternative for `LANG=C/POSIX` locale safety:

```
Submodule-Rollback: aria a8e0096->3b688a9 reason=same as above
```

The mechanical gate (`aria/skills/phase-c-integrator/SKILL.md §C.2.4.5`) parses this trailer, verifies the SHAs match actual pointers (so you cannot accidentally override with stale SHAs), and writes an audit log entry to `aria/metrics/submodule-gate-overrides.jsonl`.

**Option B — PR label** `submodule-rollback-approved` (settable only by repo maintainers via Forgejo):

For multi-commit reverts where a trailer would clutter every commit. Same audit-log behavior.

**NOT supported**: sticky config flag like `gate.disable=true`. Sticky flags get forgotten on permanently, defeating the gate. Per-PR justification mirrors the same per-instance enforcement philosophy as `# secret-leak-ok-explicit` (Rule #7 secret hygiene).

### Rule 4 — Sequenced multi-repo gitlink bump after dependency merges

When a submodule PR merges, the consumer repo's gitlink should be re-bumped to **the post-merge HEAD of the submodule master**, not to your feature-branch tip. Per existing `feedback_sequenced_multirepo_gitlink_bump` memory:

```
1. Submodule PR merges first (e.g., aria-plugin PR #N → 10CG/aria-plugin master at SHA_A)
2. Pull aria-plugin master locally: `git -C aria pull --ff-only origin master`
3. Verify HEAD = SHA_A: `git -C aria rev-parse HEAD`
4. Bump consumer gitlink: `git add aria && git commit -m 'chore(submodule): bump aria to SHA_A'`
5. Push consumer → triggers consumer's pre-merge gate (B+) which validates forward bump
```

The gate enforces forward-only bumps mechanically. Following this sequence eliminates the class of bug the gate detects.

## Mechanical enforcement (v1.28.0+)

aria-plugin v1.28.0+ ships a pre-merge gate at `aria/skills/phase-c-integrator/SKILL.md §C.2.4.5`:

- **v1.28.0** (warn-only mode): logs `WOULD-BLOCK` for any regression/divergence detected; does NOT refuse merge. 14-day observation window for ecosystem false-positive feedback.
- **v1.29.0+** (block mode): refuses merge with exit 1 unless override (trailer or label) present.

Telemetry written to `aria/metrics/submodule-gate-warns.jsonl` (warn mode) / `submodule-gate-blocks.jsonl` (block mode) / `submodule-gate-overrides.jsonl` (override usage) / `submodule-gate-misses.jsonl` (post-merge tripwire detection).

Tripwire monitor at `.forgejo/workflows/submodule-gate-tripwire.yml` in `10CG/Aria` main repo runs weekly to detect any submodule pointer regression that escaped (B+) — auto-promotes (A) post-merge detector if any of: regression escape within 12mo / 100 merges / fetch-failure incident / non-PR-flow regression.

## Cross-references

- **Spec**: `openspec/changes/aria-submodule-pointer-regression-gate/proposal.md` (Approved 2026-05-24)
- **DEC**: `.aria/decisions/2026-05-24-aria-124-submodule-pointer-regression-gate.md`
- **Source incident commits**: `6fea5d7` (regression) + `a8e0096` (fast-forward fix)
- **Forgejo**: Aria [#124](https://forgejo.10cg.pub/10CG/Aria/issues/124)
- **Related convention**: `standards/conventions/secret-hygiene.md` (same per-instance-explicit override philosophy)
- **Related memory**: `feedback_sequenced_multirepo_gitlink_bump`, `feedback_submodule_pointer_post_merge_bump`

---

**Created**: 2026-05-24
**Maintained by**: 10CG Lab
**Convention SOT**: this file. Phase C.2.4.5 in `aria/skills/phase-c-integrator/SKILL.md` is the mechanical companion.
