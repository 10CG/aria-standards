# Phase D: Closure & Archive

> **Phase**: D (Steps 9-10)
> **Focus**: Update progress and complete Spec lifecycle
> **Key Principle**: Close the loop, maintain history

---

## Overview

Phase D completes the development cycle:
1. Updating project progress state
2. Archiving completed Specs

```
┌─────────────────────────────────────────┐
│        Phase D: Closure & Archive       │
│                                         │
│  Step 9: 进度更新   ──▶ Updated UPM     │
│           │                             │
│           ▼                             │
│  Step 10: Spec归档  ──▶ Archived Spec   │
│                                         │
└─────────────────────────────────────────┘
```

---

## Step 9: Progress Update

### Purpose
Update project progress state after completing work.

### Trigger Conditions
- Step 8 branch merge completed

### Input
- Completed task information
- Commit SHA
- PR merge record

### Execution

1. **Update UPMv2-STATE Header**
   ```yaml
   lastUpdateAt: {current_time}
   lastUpdateRef: "git:{hash}-{message}"
   stateToken: {recalculated}
   ```

2. **Update kpiSnapshot**
   ```yaml
   kpiSnapshot:
     coverage: "{new_coverage}"
     build: "passing"
     lintErrors: 0
     typeErrors: 0
   ```

3. **Update Task Status**
   - `pending` → `completed`

4. **Record Progress History**
   - Add entry to history section

5. **Plan Next Cycle**
   - Update `nextCycle.candidates`

### Output
- Updated UPM document
- New stateToken

### UPM Update Example

```yaml
---
# UPMv2-STATE: Machine-readable progress state
module: "backend"
stage: "Phase 2 - Development"
cycleNumber: 3
lastUpdateAt: "2025-12-13T16:00:00+08:00"
lastUpdateRef: "git:abc1234-feat(auth): implement JWT service"
stateToken: "sha256:new-unique-identifier"

nextCycle:
  intent: "Implement user profile endpoints"
  candidates:
    - TASK-005: User profile API
    - TASK-006: Avatar upload

kpiSnapshot:
  coverage: "45%"
  build: "passing"
  lintErrors: 0
  typeErrors: 0

risks:
  - id: R1
    description: "External API rate limits"
    severity: P2
    mitigation: "Implement caching"
---
```

### stateToken Calculation

```
sha256({module}-{stage}-{cycleNumber}-{lastUpdateAt})
```

Example:
```
sha256("backend-Phase 2 - Development-3-2025-12-13T16:00:00+08:00")
```

### Suggested Skill
`progress-updater`

### Milestone-driven Mode (Optional)

> **Added**: 2026-04-23 — Fixes Forgejo #22. Enabled by `upm.milestone_driven: true`.

When `upm.milestone_driven: true`, Step 8.5 (Phase C C.2.6) appends sub-bullets to the UPM after each PR merge. In this mode, Step 9 only needs to **finalize** rather than rebuild the full history:

| Mode | Step 9 Work | Mid-cycle Transparency |
|------|-------------|----------------------|
| Default (`milestone_driven: false`) | Full single-pass update for all Stories | Low — UPM stays `[ ]` throughout multi-PR cycle |
| Milestone-driven (`milestone_driven: true`) | Finalize only: `[~]` → `[x]` + spec archive path | High — sub-bullet appended after each PR merge |

**Finalize actions (milestone-driven)**:
1. Upgrade all `[~]` Story markers to `[x] COMPLETED`
2. Append `archive: openspec/archive/{spec_id}/` after the last sub-bullet
3. Update UPMv2-STATE header (`lastUpdateAt`, `stateToken`, `completedTasks`)
4. Do NOT reconstruct history — sub-bullets were written in real time by C.2.6

**Skill reference**: `phase-d-closer` D.1 Milestone-driven section

---

## Step 10: Spec Archive

### Purpose
Complete the Spec lifecycle by archiving implemented Specs.

### Trigger Conditions
- Step 9 progress update completed (时序触发 only)

> **Note (#134)**: Trigger 仅为时序条件。"是否可归档"的完成判定**不是** trigger,
> 而是 Execution 第 1 步 "Verify All Acceptance Criteria Met" 中的硬性 gate。

### Input
- Implemented Spec file
- Implementation verification result

### Prerequisites (Project Setup)

> **Note**: OpenSpec CLI requires `openspec/` directory at project root.
> Our project uses `standards/openspec/`, so a junction/symlink is required.

**Windows Setup (Junction)**:
```powershell
# Run once from project root (requires no admin rights)
New-Item -ItemType Junction -Path 'openspec' -Target 'standards\openspec'
```

**Linux/macOS Setup (Symlink)**:
```bash
# Run once from project root
ln -s standards/openspec openspec
```

The junction/symlink is already in `.gitignore`.

### Execution

1. **Verify All Acceptance Criteria Met (完成判定 gate, #134)**
   ```yaml
   Acceptance Criteria:
     - [x] Criterion 1: Verified
     - [x] Criterion 2: Verified
     - [x] Criterion 3: Verified
   ```

   完成判定在此步执行 (单一可执行 SOT: aria-plugin `state-scanner/scripts/lib/spec_complete.py`,
   gate 入口经 Bash 调同一脚本, 不再由 AI 解释 prose):
   - **Level 3** (有 `tasks.md`): `tasks.md` 全 `[x]` **且**无 inline carry-forward/defer 注释 → 可归档
   - **Level 2** (无 `tasks.md`): `Status` normalized == `done` → 可归档
   - **Approved-only** (仅设计定稿、实施未做): **不可**按常规归档, 须 `--archive-design-only` + reason
     (归档时 frontmatter 写 `archive_type: implementation-deferred` 标记)

   > 归档=功能完成; 设计定稿是 in_progress milestone 非归档理由; 确需归档未实施设计稿走 --archive-design-only + reason (留 implementation-deferred 标记)

2. **Update Spec Status (按 Level 分支条件判定, 非 checkbox 序列, #134)**
   - **Level 3** (有 `tasks.md`): 若 `tasks.md` 全 `[x]` 且无 inline carry-forward/defer 注释 → 可归档
   - **Level 2** (无 `tasks.md`): 若 `Status` normalized == `done` → 可归档
   - **Approved-only** (设计定稿未实施): 需 `--archive-design-only` + reason →
     归档时 frontmatter 留 `archive_type: implementation-deferred` 标记 (不改 Status)

3. **Archive Using OpenSpec CLI**
   ```bash
   # Archive a completed change (interactive)
   openspec archive {change-name}

   # Archive without confirmation prompt
   openspec archive {change-name} --yes

   # Archive without validation — DEPRECATED (#134): 勿用本 flag 绕过完成度 gate;
   # 归档未实施设计稿请改用 --archive-design-only + reason (留 implementation-deferred 标记)
   openspec archive {change-name} --no-validate
   ```

4. **Move to Project Archive Location**

   > **Note**: CLI places archives in `changes/archive/{date}-{name}/`.
   > Move to our standard location for consistency.

   ```bash
   # Move from CLI location to project archive
   mkdir -p standards/openspec/archive/{feature}/
   mv standards/openspec/changes/archive/{date}-{change-name}/* \
      standards/openspec/archive/{feature}/

   # Clean up CLI's archive directory
   rmdir standards/openspec/changes/archive/{date}-{change-name}
   ```

5. **Verify Archive Result**
   - Spec moved to `standards/openspec/archive/{feature}/`
   - Archive index updated (see below)

6. **(Optional) Merge to Stable Specs**
   - If spec defines lasting conventions, merge relevant content to `specs/`

### Output
- Archived Spec location
- Final Spec status record

### Directory Change

```
Before:
  standards/openspec/changes/{feature}/spec.md

CLI Output (temporary):
  standards/openspec/changes/archive/{date}-{feature}/...

After (final location):
  standards/openspec/archive/{feature}/spec.md
```

### Archive Index Entry

```markdown
# Archived Specs Index

## 2025-12

| Feature | Archived Date | Implementation PR | Notes |
|---------|---------------|-------------------|-------|
| user-auth | 2025-12-13 | #42 | JWT-based authentication |
| task-priority | 2025-12-15 | #45 | Priority field for tasks |
```

### Suggested Tool
`openspec archive` (CLI built-in)

See: [OpenSpec AGENTS.md](../../openspec/AGENTS.md) for workflow details

---

## Phase D Checklist

After completing Phase D:

- [ ] UPM document updated with latest state
- [ ] stateToken recalculated
- [ ] Progress history recorded
- [ ] Next cycle candidates identified
- [ ] Spec acceptance criteria verified
- [ ] 归档完成度 gate 通过 (L3: `tasks.md` 全 `[x]` 且无 carry-forward/defer 注释; L2: `Status` normalized == `done`; Approved-only 须 `--archive-design-only` + reason)
- [ ] Spec moved to archive
- [ ] Archive index updated

---

## Cycle Completion Summary

At the end of a complete 10-step cycle, you should have:

| Artifact | Location | Status |
|----------|----------|--------|
| Spec | `archive/{feature}/spec.md` | Archived |
| Code | `develop` branch | Merged |
| Tests | `{module}/tests/` | Passing |
| Docs | `ARCHITECTURE.md`, API docs | Updated |
| UPM | `project-planning/unified-progress-management.md` | Current |
| Commits | Git history | Recorded |

---

## Starting a New Cycle

After completing Phase D, the next cycle begins:

1. **Return to Step 0** if there are new features to implement
2. **Return to Step 1** if continuing with existing Specs in backlog
3. **Pause** if no immediate work is planned

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│    Phase D Complete                                    │
│         │                                              │
│         ├──▶ New Feature? ──▶ Step 0 (Spec Definition)│
│         │                                              │
│         ├──▶ Backlog Specs? ──▶ Step 1 (State Check)  │
│         │                                              │
│         └──▶ No Work? ──▶ Pause (Monitor)             │
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

## Related Documents

- [Ten-Step Cycle Overview](./README.md)
- [Phase A: Planning](./phase-a-spec-planning.md)
- [Phase B: Development](./phase-b-development.md)
- [Phase C: Integration](./phase-c-integration.md)
- [UPM Specification](../upm/unified-progress-management-spec.md)
- [State Management](../state-management/ai-ddd-state-management.md)

---

**Version**: 1.0.0
**Created**: 2025-12-13
