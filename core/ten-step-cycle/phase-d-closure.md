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

---

## Step 10: Spec Archive

### Purpose
Complete the Spec lifecycle by archiving implemented Specs.

### Trigger Conditions
- Step 9 progress update completed

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

1. **Verify All Acceptance Criteria Met**
   ```yaml
   Acceptance Criteria:
     - [x] Criterion 1: Verified
     - [x] Criterion 2: Verified
     - [x] Criterion 3: Verified
   ```

2. **Update Spec Status**
   ```markdown
   ## Status
   - [x] Draft
   - [x] Reviewed
   - [x] Implemented
   - [x] Archived
   ```

3. **Archive Using OpenSpec CLI**
   ```bash
   # Archive a completed change (interactive)
   openspec archive {change-name}

   # Archive without confirmation prompt
   openspec archive {change-name} --yes

   # Archive without validation
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
