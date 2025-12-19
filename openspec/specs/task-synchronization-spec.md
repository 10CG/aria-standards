# Task Synchronization Mechanism Specification

> **Version**: 1.0.0
> **Status**: Draft
> **Created**: 2025-12-19
> **Related OpenSpec**: clarify-phase-a-task-pipeline

## Overview

This document defines the synchronization mechanism between `tasks.md` (coarse-grained functional checklist) and `detailed-tasks.yaml` (fine-grained executable tasks) to maintain consistency and traceability throughout the development lifecycle.

## Purpose

The synchronization mechanism ensures:
- **Consistency**: Both documents reflect the same work scope
- **Traceability**: Changes in one document propagate appropriately to the other
- **Single Source of Truth**: Clear authority for different concerns
- **OpenSpec Compatibility**: tasks.md remains compatible with OpenSpec CLI tools

## Document Roles

| Document | Role | Authority | Updated By | Update Trigger |
|----------|------|-----------|------------|----------------|
| **tasks.md** | Progress View | High-level completion status | B.2 execution, manual check-off | When TASK-{NNN} completes |
| **detailed-tasks.yaml** | Execution Spec | Implementation details, dependencies, complexity | A.2 task-planner, A.3 agent assignment | During Phase A planning |

### Single Source of Truth Rules

```yaml
For Progress Tracking:
  Authority: tasks.md checkboxes
  Reason: OpenSpec standard, human-readable, CLI-compatible

For Execution Details:
  Authority: detailed-tasks.yaml
  Reason: Structured, complete metadata, AI-optimized

For Task Relationships:
  Authority: detailed-tasks.yaml dependencies field
  Reason: Explicit DAG, enables scheduling

For Completion Criteria:
  Authority: detailed-tasks.yaml verification field (A.3)
  Reason: Precise, task-specific quality gates
```

## Forward Synchronization (A.1 → A.2 → A.3)

### A.1 to A.2: tasks.md → detailed-tasks.yaml

**Trigger**: task-planner skill execution during Phase A Step 2

**Process**:
1. Read tasks.md coarse-grained checklist
2. For each checklist item with section ID (e.g., "1.1"):
   - Create one or more TASK-{NNN} entries
   - Set `parent` field to section ID
   - Transform functional description into actionable `title`
   - Estimate `complexity` based on scope
   - Determine `dependencies` from logical relationships
   - Specify file-level `deliverables`
3. Write detailed-tasks.yaml

**Example Transformation**:

```markdown
# tasks.md (A.1 Output)
## 1. Database Setup
- [ ] 1.1 Add OTP secret column to users table
```

Transforms to:

```yaml
# detailed-tasks.yaml (A.2 Output)
tasks:
  - id: TASK-001
    parent: "1.1"
    title: Add OTP secret column to users table
    complexity: M (Medium, 2-4h)
    dependencies: []
    deliverables:
      - backend/migrations/add_otp_secret_column.sql
      - backend/src/models/user.py
```

**Invariants**:
- Every tasks.md checkbox item SHOULD have at least one corresponding TASK-{NNN}
- Complex items MAY decompose into multiple TASK-{NNN} entries
- All TASK-{NNN} entries MUST have valid `parent` field

### A.2 to A.3: Add Agent Metadata

**Trigger**: Agent assignment during Phase A Step 3

**Process**:
1. Read detailed-tasks.yaml from A.2
2. For each task:
   - Analyze task type, domain, file types
   - Select appropriate `agent` from capability matrix
   - Document assignment `reason`
   - Define task-specific `verification` criteria
3. Update detailed-tasks.yaml in place

**Example Enhancement**:

```yaml
# A.2 Output
tasks:
  - id: TASK-001
    parent: "1.1"
    title: Add OTP secret column to users table
    complexity: M (Medium, 2-4h)
    dependencies: []
    deliverables:
      - backend/migrations/add_otp_secret_column.sql
      - backend/src/models/user.py

# A.3 Output (enhanced)
tasks:
  - id: TASK-001
    parent: "1.1"
    title: Add OTP secret column to users table
    complexity: M (Medium, 2-4h)
    dependencies: []
    deliverables:
      - backend/migrations/add_otp_secret_column.sql
      - backend/src/models/user.py
    agent: backend-architect
    reason: Database schema design expertise, migration management
    verification:
      - Migration runs successfully
      - Column exists in schema with correct type
      - User model updated and tests pass
```

## Backward Synchronization (B.2 → tasks.md)

### Execution to Progress: TASK-{NNN} Complete → tasks.md Check-off

**Trigger**: Task completion during Phase B Step 2 (执行验证)

**Process**:
1. Task TASK-{NNN} completes and passes verification
2. Skill (e.g., task-progress-updater) reads task's `parent` field
3. Locates corresponding section in tasks.md
4. Checks off the checkbox: `- [ ]` → `- [x]`
5. May add completion note with date/commit

**Example Update**:

```markdown
# tasks.md (Before)
## 1. Database Setup
- [ ] 1.1 Add OTP secret column to users table

# tasks.md (After TASK-001 completes)
## 1. Database Setup
- [x] 1.1 Add OTP secret column to users table
```

**With Completion Note**:

```markdown
- [x] 1.1 Add OTP secret column to users table (completed 2025-12-19, commit: abc1234)
```

**Aggregation Rule**:
If tasks.md item "1.1" maps to multiple TASK-{NNN} entries (e.g., TASK-001, TASK-002), the checkbox is checked only when ALL child tasks complete.

```yaml
# Scenario: One-to-Many Mapping
tasks.md:
  - [ ] 1.1 Implement user authentication

detailed-tasks.yaml:
  - id: TASK-001
    parent: "1.1"
    title: Design user data model

  - id: TASK-002
    parent: "1.1"
    title: Implement JWT auth service

Rule:
  tasks.md 1.1 checked off only when both TASK-001 AND TASK-002 complete
```

## Conflict Resolution

### Scenario 1: tasks.md Manually Updated

**Situation**: Developer manually edits tasks.md (adds/removes items) after detailed-tasks.yaml exists

**Resolution**:
1. Flag discrepancy during next Phase A step
2. Options:
   - **Re-plan**: Re-run A.2 to regenerate detailed-tasks.yaml (discards old file)
   - **Manual Reconcile**: Update detailed-tasks.yaml manually to match new tasks.md
3. Document decision in proposal.md or change log

**Preventive Guideline**: Avoid editing tasks.md after A.2 execution; instead, update proposal.md and re-run A.1.

### Scenario 2: detailed-tasks.yaml Edited After A.3

**Situation**: Task complexity or dependencies change during development

**Resolution**:
1. Update detailed-tasks.yaml
2. Tasks.md remains unchanged (it tracks high-level progress)
3. Optionally note changes in proposal.md or commit message

**Guideline**: detailed-tasks.yaml may evolve; tasks.md is more stable.

### Scenario 3: Parent Field Mismatch

**Situation**: TASK-{NNN}.parent references non-existent tasks.md section

**Detection**: Validation tools flag orphaned tasks

**Resolution**:
1. If tasks.md section was removed: Remove or reassign orphaned TASK-{NNN}
2. If parent field is wrong: Correct the `parent` value

## Synchronization Tools

### task-planner Skill (Forward Sync)

**Responsibility**: Generate detailed-tasks.yaml from tasks.md

**Input**:
- tasks.md from A.1
- proposal.md context

**Output**:
- detailed-tasks.yaml with TASK-{NNN} entries, parent links, complexity, dependencies, deliverables

**Invocation**: Automatically during Phase A Step 2

### task-progress-updater Skill (Backward Sync)

**Responsibility**: Check off tasks.md items when TASK-{NNN} completes

**Input**:
- Completed TASK-{NNN} ID
- detailed-tasks.yaml (to read parent field)
- tasks.md (to update checkbox)

**Output**:
- Updated tasks.md with checked boxes

**Invocation**: Automatically during Phase B Step 2 after task verification

### Validation Tools

**Purpose**: Detect synchronization drift

**Checks**:
1. All tasks.md sections have at least one TASK-{NNN} referencing them
2. All TASK-{NNN}.parent values reference valid tasks.md sections
3. Checkbox state matches TASK-{NNN} completion status

**Invocation**: On-demand or as pre-commit hook

## Workflow Integration

```yaml
Phase A.1 (Spec Management):
  Output: tasks.md (coarse-grained checklist)
  Sync: N/A (initial creation)

Phase A.2 (Task Planning):
  Input: tasks.md
  Process: task-planner reads tasks.md
  Output: detailed-tasks.yaml with parent links
  Sync: Forward (tasks.md → detailed-tasks.yaml)

Phase A.3 (Agent Assignment):
  Input: detailed-tasks.yaml from A.2
  Process: Add agent, reason, verification fields
  Output: Enhanced detailed-tasks.yaml
  Sync: In-place enhancement (no tasks.md change)

Phase B.2 (Execution):
  Process: Execute TASK-{NNN}, pass verification
  Trigger: task-progress-updater skill
  Sync: Backward (TASK-{NNN} → tasks.md check-off)

OpenSpec CLI:
  Command: openspec list
  Reads: tasks.md checkboxes for progress display
  Sync: Read-only (no updates)
```

## Synchronization Guarantees

### Guaranteed

1. **Parent Linkage**: Every TASK-{NNN} has valid `parent` referencing tasks.md
2. **Progress Tracking**: tasks.md checkboxes reflect TASK-{NNN} completion
3. **Traceability**: Can trace from tasks.md item to all child TASK-{NNN} entries

### Not Guaranteed (By Design)

1. **One-to-One Mapping**: tasks.md item MAY map to multiple TASK-{NNN} entries
2. **Immediate Sync**: Backward sync happens at task completion, not real-time
3. **Bi-directional Edit**: Only forward edits (tasks.md → detailed-tasks.yaml) are automated; reverse requires manual reconciliation

## Example Complete Workflow

```yaml
Step 1 - A.1 (Spec Management):
  Create tasks.md:
    ## 1. Database Setup
    - [ ] 1.1 Add OTP secret column to users table
    - [ ] 1.2 Create OTP verification logs table

Step 2 - A.2 (Task Planning):
  task-planner generates detailed-tasks.yaml:
    tasks:
      - id: TASK-001
        parent: "1.1"
        title: Add OTP secret column to users table
        complexity: M (Medium, 2-4h)
        dependencies: []
        deliverables:
          - backend/migrations/add_otp_secret_column.sql
          - backend/src/models/user.py

      - id: TASK-002
        parent: "1.2"
        title: Create OTP verification logs table
        complexity: S (Small, 1-2h)
        dependencies: [TASK-001]
        deliverables:
          - backend/migrations/create_otp_logs_table.sql
          - backend/src/models/otp_log.py

Step 3 - A.3 (Agent Assignment):
  Enhance detailed-tasks.yaml:
    tasks:
      - id: TASK-001
        [... all A.2 fields ...]
        agent: backend-architect
        reason: Database schema design expertise
        verification:
          - Migration runs successfully
          - Column exists in schema with correct type

Step 4 - B.2 (Execution):
  Execute TASK-001:
    - Implement migration script
    - Update user model
    - Run verification checks
    - All pass → task-progress-updater triggers

Step 5 - Backward Sync:
  Update tasks.md:
    ## 1. Database Setup
    - [x] 1.1 Add OTP secret column to users table
    - [ ] 1.2 Create OTP verification logs table

Step 6 - Continue:
  Execute TASK-002 → Check off 1.2 → Both items complete
```

## Related Documents

- [detailed-tasks.yaml Format](./detailed-tasks-yaml-format.md) - Full field specification
- [Parent Field Linking Rules](./parent-field-linking-spec.md) - Detailed linking semantics
- [Phase A: Planning](../../core/ten-step-cycle/phase-a-spec-planning.md) - Context for synchronization
- [Phase B: Development](../../core/ten-step-cycle/phase-b-development.md) - Execution and backward sync

---

**Version**: 1.0.0
**Created**: 2025-12-19
**Maintainer**: AI-DDD Development Team
