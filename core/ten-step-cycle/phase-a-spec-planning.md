# Phase A: Specification & Planning

> **Phase**: A (Steps 0-3)
> **Focus**: Define what to build before coding
> **Key Principle**: Spec-first development

---

## Overview

Phase A establishes the foundation for development by:
1. Creating clear specifications
2. Understanding current project state
3. Breaking down work into manageable tasks
4. Assigning appropriate agents

```
┌─────────────────────────────────────────┐
│         Phase A: Spec & Planning        │
│                                         │
│  Step 0: Spec定义  ──▶ spec.md          │
│           │                             │
│           ▼                             │
│  Step 1: 状态感知  ──▶ Status Summary   │
│           │                             │
│           ▼                             │
│  Step 2: 任务规划  ──▶ Task List        │
│           │                             │
│           ▼                             │
│  Step 3: Agent分配 ──▶ Task-Agent Map   │
│                                         │
└─────────────────────────────────────────┘
```

---

## Step 0: Spec Definition (OpenSpec Draft & Review)

### Purpose
Define "what to build" before any coding begins.

### Three-Level Spec Strategy

Not all changes require the same level of specification. Use this decision guide:

| Level | Name | Trigger | Action |
|-------|------|---------|--------|
| **1** | Skip | Simple fixes, config tweaks, doc formatting | Proceed directly to Step 4 |
| **2** | Minimal | New Skill, medium features (1-3 days) | Create `proposal.md` only |
| **3** | Full | Architecture changes, cross-module, breaking changes | Full OpenSpec (proposal + tasks + specs) |

**Decision Flowchart**:
```
Is it a simple fix/config/formatting?
  ├─ Yes → Level 1 (Skip Step 0)
  └─ No → Is it architecture/cross-module/breaking?
            ├─ Yes → Level 3 (Full Spec)
            └─ No → Level 2 (Minimal Spec)
```

**Templates**: `standards/openspec/templates/`
- `proposal-minimal.md` - Level 2 template
- See existing `changes/` for Level 3 examples

### Trigger Conditions
- New feature request
- Major change request
- Architecture adjustment

### Input
- Requirement description (Issue/User Story)
- Existing architecture documents
- Current UPM state

### Execution
1. Create OpenSpec change file at `standards/openspec/changes/{feature}/spec.md`
2. Use Delta markers to define changes:
   - `ADDED`: New content
   - `MODIFIED`: Changed content
   - `REMOVED`: Deleted content
3. Define acceptance criteria
4. Team review (status: draft → reviewed)

### Output
- `changes/{feature}/spec.md` (status: reviewed)
- Review record

### Spec Template

```markdown
# {Feature Name} Specification

## Status
- [x] Draft
- [ ] Reviewed
- [ ] Implemented
- [ ] Archived

## Overview
{Feature description}

## Changes

### ADDED
- {New item 1}
- {New item 2}

### MODIFIED
- {Modified item}

### REMOVED
- {Removed item}

## Acceptance Criteria
- [ ] {Criterion 1}
- [ ] {Criterion 2}

## Dependencies
- {Dependency}

## Reviewer
- {Reviewer name}
- {Review date}
```

### Suggested Skill
`spec-drafter`

---

## Step 1: State Recognition (Enhanced)

### Purpose
Understand current project state and pending Specs.

### Trigger Conditions
- Step 0 completed
- Cycle start
- Progress check needed

### Input
- UPM document: `{module}/project-planning/unified-progress-management.md`
- Active Specs: `standards/openspec/changes/*/spec.md` (status=reviewed)

### Execution
1. Parse UPMv2-STATE YAML header:
   - `module`: Current module
   - `stage`: Current phase
   - `cycleNumber`: Cycle number
   - `kpiSnapshot`: Quality metrics
2. Load reviewed but unimplemented Spec list
3. Identify risks and blockers (`risks` field)
4. Generate status summary

### Output
- Current status summary
- Pending Spec list (prioritized)
- Risk assessment report

### Output Example

```yaml
Status Summary:
  Module: backend
  Stage: Phase 1 - Planning
  Cycle: Cycle 2
  Last Update: 2025-12-13T10:00:00+08:00

Pending Specs:
  - changes/user-auth/spec.md (Priority: P0)
  - changes/task-priority/spec.md (Priority: P1)

Current Risks:
  - R1: Tech stack selection (P1)
  - R2: Frontend collaboration alignment (P1)

KPI Snapshot:
  Coverage: 0%
  Build: n/a
  Lint Errors: 0
```

### Suggested Skill
`progress-query-assistant`

---

## Step 2: Task Planning (Enhanced)

### Purpose
Break Spec into executable tasks.

### Trigger Conditions
- Step 1 state recognition completed

### Input
- Current status summary
- Pending Spec list
- `nextCycle.candidates` from UPM

### Execution
1. Select Spec(s) to implement this cycle
2. Decompose Spec into atomic tasks
3. Estimate task complexity
4. Determine task dependencies
5. Generate execution order

### Output
- Task breakdown list
- Execution order
- Dependency graph

### Task Breakdown Example

```yaml
Spec: changes/user-auth/spec.md
Tasks:
  1. TASK-001: Design user data model
     Complexity: Medium
     Dependencies: None

  2. TASK-002: Implement JWT auth service
     Complexity: High
     Dependencies: TASK-001

  3. TASK-003: Create auth API endpoints
     Complexity: Medium
     Dependencies: TASK-002

  4. TASK-004: Write unit tests
     Complexity: Medium
     Dependencies: TASK-003

Execution Order: TASK-001 → TASK-002 → TASK-003 → TASK-004
```

### Suggested Skill
`task-planner`

---

## Step 3: Agent Assignment

### Purpose
Match tasks with the most suitable specialized agents.

### Trigger Conditions
- Step 2 task planning completed

### Input
- Task breakdown list
- Agent capability matrix

### Execution
1. Analyze task type and domain
2. Match specialized agents
3. Set verification criteria

### Output
- Agent assignment plan
- Task-Agent mapping table

### Available Agent Types

| Agent | Specialty |
|-------|-----------|
| `backend-architect` | Backend architecture, API design, databases |
| `mobile-developer` | Flutter development, UI components, state management |
| `qa-engineer` | Test strategy, code review, quality assurance |
| `api-documenter` | OpenAPI specs, SDK documentation |
| `knowledge-manager` | Documentation management, knowledge base |
| `tech-lead` | Technical decisions, cross-team coordination |

### Assignment Example

```yaml
TASK-001 (Design user data model):
  Agent: backend-architect
  Reason: Database schema design expertise

TASK-002 (Implement JWT auth):
  Agent: backend-architect
  Reason: Security and authentication expertise

TASK-003 (Create API endpoints):
  Agent: backend-architect
  Reason: API design consistency

TASK-004 (Write unit tests):
  Agent: qa-engineer
  Reason: Test coverage optimization
```

---

## Phase A Checklist

Before proceeding to Phase B, ensure:

- [ ] Spec file created and reviewed
- [ ] Current state understood
- [ ] Tasks broken down with dependencies
- [ ] Agents assigned to all tasks
- [ ] All team members aligned on scope

---

## Related Documents

- [Ten-Step Cycle Overview](./README.md)
- [Phase B: Development](./phase-b-development.md)
- [UPM Specification](../upm/unified-progress-management-spec.md)
- [OpenSpec Project](../../openspec/project.md)

---

**Version**: 1.0.0
**Created**: 2025-12-13
