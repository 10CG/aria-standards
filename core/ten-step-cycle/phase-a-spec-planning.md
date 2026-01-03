# Phase A: Planning (规划)

> **Phase**: A (A.0-A.3)
> **Focus**: Understand state, then define what to build
> **Key Principle**: State-first, then Spec-driven development

---

## Overview

Phase A establishes the foundation for development by:
1. **Understanding current project state** (A.0 - first!)
2. Creating or selecting specifications
3. Breaking down work into manageable tasks
4. Assigning appropriate agents

```
┌─────────────────────────────────────────┐
│         Phase A: Planning (规划)         │
│                                         │
│  A.0: 状态感知  ──▶ Status + Spec List  │
│           │                             │
│           ▼                             │
│  A.1: Spec管理  ──▶ proposal.md         │
│           │                             │
│           ▼                             │
│  A.2: 任务规划  ──▶ Task List           │
│           │                             │
│           ▼                             │
│  A.3: Agent分配 ──▶ Task-Agent Map      │
│                                         │
└─────────────────────────────────────────┘
```

**Why A.0 comes first?**
- Developer should understand current state before deciding to create new Spec or continue existing one
- State scan reveals active Specs, helping avoid duplicate work
- Risk awareness guides Spec priority decisions

---

## A.0: State Recognition (状态感知)

### Purpose
Understand current project state and list active Specs. This is the **first step** of every cycle.

### Trigger Conditions
- Cycle start
- New development session begins
- Progress check needed

### Input
- UPM document: `{module}/project-planning/unified-progress-management.md`
- Active Specs: `standards/openspec/changes/*/proposal.md`

### Execution
1. Parse UPMv2-STATE YAML header:
   - `module`: Current module
   - `stage`: Current phase
   - `cycleNumber`: Cycle number
   - `kpiSnapshot`: Quality metrics
   - `risks`: Risk list
2. Scan `changes/` directory for active Specs
3. Generate status summary with direction options
4. User selects direction:
   - **Continue existing Spec** → A.1 (select)
   - **Create new Spec** → A.1 (create)
   - **Quick fix** → B.1 (skip Spec)

### Output
- Current status summary
- Active Spec list (prioritized)
- Risk assessment
- Direction selection

### Output Example

```
╔══════════════════════════════════════════════════════════════╗
║              PROJECT STATE SCAN (A.0)                        ║
╚══════════════════════════════════════════════════════════════╝

📍 Current State
────────────────────────────────────────────────────────────────
Module:       backend
Stage:        Phase 3 - Development
Cycle:        5
Last Update:  2025-12-18T10:00:00+08:00

📊 KPI Snapshot
────────────────────────────────────────────────────────────────
Coverage:     85.0% (target: ≥85%) ✅
Build:        green ✅

📋 Active Specs
────────────────────────────────────────────────────────────────
1. [Reviewed] user-authentication (Level 3)
2. [Draft] api-versioning (Level 2)

🧭 Direction Options
────────────────────────────────────────────────────────────────
[A] Continue Spec: user-authentication
[B] Create New Spec
[C] Quick Fix (skip Spec)
[D] View only

选择方向: _
```

### Suggested Skill
`state-scanner`

---

## A.1: Spec Management (Spec管理)

### Purpose
Create new Spec or select existing one for implementation.

### Three-Level Spec Strategy

Not all changes require the same level of specification:

| Level | Name | Trigger | Action |
|-------|------|---------|--------|
| **1** | Skip | Simple fixes, config tweaks, doc formatting | Proceed directly to B.1 |
| **2** | Minimal | New Skill, medium features (1-3 days) | Create `proposal.md` only |
| **3** | Full | Architecture changes, cross-module, breaking changes | Full OpenSpec (proposal + tasks) |

**Decision Flowchart**:
```
Is it a simple fix/config/formatting?
  ├─ Yes → Level 1 (Skip to B.1)
  └─ No → Is it architecture/cross-module/breaking?
            ├─ Yes → Level 3 (Full Spec)
            └─ No → Level 2 (Minimal Spec)
```

### OpenSpec vs System Architecture

OpenSpec and System Architecture serve different but complementary purposes:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    Document Type Comparison                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  System Architecture                 OpenSpec Spec                  │
│  ─────────────────────────           ─────────────                  │
│  Location:                           Location:                      │
│    docs/architecture/                  openspec/changes/{id}/       │
│    system-architecture.md              proposal.md, tasks.md        │
│                                                                     │
│  Purpose:                            Purpose:                       │
│    HOW the system is organized         WHAT to implement            │
│    Technical decisions                 Implementation requirements  │
│    Module boundaries                   Scenarios and acceptance     │
│                                                                     │
│  Lifecycle:                          Lifecycle:                     │
│    Long-lived, evolves slowly          Active during development    │
│    Persists across versions            Archived after completion    │
│                                                                     │
│  Updates:                            Updates:                       │
│    When architecture changes           Per feature/change           │
│    Infrequent, deliberate              Frequent, iterative          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**When to Use Which**:

| Scenario | Document Type |
|----------|---------------|
| Define system module boundaries | System Architecture |
| Choose database technology | System Architecture (Technology Decisions) |
| Implement user authentication feature | OpenSpec Spec |
| Add new API endpoint | OpenSpec Spec |
| Refactor data layer architecture | Both (Architecture first, then Spec) |
| Major technology migration | Both (Architecture first, then Spec) |

**Relationship**:
```
PRD (What & Why)
      │
      ▼
System Architecture (How - organized)
      │
      ├───────────────────┐
      ▼                   ▼
Module Architecture    OpenSpec Spec (How - implemented)
      │                   │
      ▼                   ▼
Code Implementation    Code Implementation
```

**Reference**: See `standards/core/documentation/system-architecture-spec.md` for System Architecture document specification.

### Trigger Conditions
- A.0 completed with direction [A] or [B]
- New feature request
- Major change request

### Input
- Direction from A.0
- Requirement description (if creating new)
- Existing Spec (if continuing)

### Execution

**If creating new Spec:**
1. Determine Spec level (1/2/3)
2. Create `standards/openspec/changes/{feature}/proposal.md`
3. For Level 3, also create `tasks.md` (coarse-grained functional checklist)
4. Define acceptance criteria
5. Status: Draft → Review → Reviewed

**Level 3 tasks.md Format** (Coarse-grained):

Aligned with OpenSpec scaffolding, tasks.md contains functional checklists:

```
- [ ] Add OTP column to users table
- [ ] Create authentication endpoints
- [ ] Implement token validation
- [ ] Add unit tests
```

**Note**: These are coarse-grained functional checklists from OpenSpec's "Draft the Proposal" phase. They will be refined into executable atomic tasks with TASK-{NNN} IDs, complexity, and dependencies in A.2.

**If selecting existing Spec:**
1. Verify Spec status is "Reviewed"
2. Load Spec content for A.2

### Output
- `changes/{feature}/proposal.md` (Level 2/3)
- `changes/{feature}/tasks.md` (Level 3 only)
- Selected Spec reference

### Spec Template (Level 2 Minimal)

```markdown
# {Feature Name}

> **Level**: Minimal (Level 2 Spec)
> **Status**: Draft
> **Created**: {YYYY-MM-DD}
> **Module**: {module}

## Why
{Motivation and problem statement}

## What
{Solution description}

### Key Deliverables
- {Deliverable 1}
- {Deliverable 2}

## Impact
| Type | Description |
|------|-------------|
| **Positive** | {Benefits} |
| **Risk** | {Risks and mitigation} |

## Tasks
- [ ] {Task 1}
- [ ] {Task 2}

## Success Criteria
- [ ] {Criterion 1}
- [ ] {Criterion 2}
```

### Suggested Skill
`spec-drafter`

---

## A.2: Task Planning (任务规划)

### Purpose
Refine coarse-grained tasks from A.1 into executable atomic tasks with full specifications.

For Level 3 specs, A.2 transforms the functional checklist from A.1's tasks.md into detailed executable tasks with TASK-{NNN} IDs, complexity estimates, dependencies, and file-level deliverables.

### Trigger Conditions
- A.1 Spec selected or created

### Input
- Selected Spec (proposal.md)
- Coarse-grained tasks.md from A.1 (for Level 3 specs)
- Current status from A.0
- `nextCycle.candidates` from UPM

### Execution
1. Analyze Spec deliverables (from proposal.md and coarse tasks.md)
2. Refine each coarse-grained checklist item into atomic tasks (4-8 hour granularity)
3. Assign TASK-{NNN} unique identifiers
4. Estimate task complexity (S/M/L/XL with hour ranges)
5. Determine task dependencies and execution order
6. Specify file-level deliverables for each task

### Output
- Task breakdown list
- Execution order
- Dependency graph

### Task Breakdown Example

```yaml
Spec: changes/user-authentication/proposal.md

Tasks:
  - id: TASK-001
    title: Design user data model
    complexity: M (Medium, 2-4h)
    dependencies: None
    deliverables:
      - backend/src/models/user.py

  - id: TASK-002
    title: Implement JWT auth service
    complexity: L (Large, 4-8h)
    dependencies: [TASK-001]
    deliverables:
      - backend/src/services/auth_service.py

  - id: TASK-003
    title: Create auth API endpoints
    complexity: M (Medium, 2-4h)
    dependencies: [TASK-002]
    deliverables:
      - backend/src/routes/auth_routes.py

  - id: TASK-004
    title: Write unit tests
    complexity: M (Medium, 2-4h)
    dependencies: [TASK-003]
    deliverables:
      - backend/tests/test_auth.py

Execution Order: TASK-001 → TASK-002 → TASK-003 → TASK-004

Parallel Groups:
  Group 1: [TASK-001]
  Group 2: [TASK-002]
  Group 3: [TASK-003, TASK-004] (can parallel after TASK-002)
```

### Suggested Skill
`task-planner`

---

## A.3: Agent Assignment (Agent分配)

### Purpose
Match tasks with the most suitable specialized agents.

### Trigger Conditions
- A.2 task planning completed

### Input
- Refined task breakdown from A.2 (with TASK-{NNN} IDs, complexity, dependencies)
- Agent capability matrix

### Execution
1. Analyze task type and domain
2. Match specialized agents based on:
   - File types involved
   - Technical domain
   - Task complexity
3. Set verification criteria for each task

### Output
- Agent assignment plan
- Task-Agent mapping table

### Available Agent Types

| Agent | Specialty | Best For |
|-------|-----------|----------|
| `backend-architect` | Backend architecture, API design, databases | Python, FastAPI, DB schema |
| `mobile-developer` | Flutter development, UI components, state management | Dart, Flutter widgets |
| `qa-engineer` | Test strategy, code review, quality assurance | Test files, coverage |
| `api-documenter` | OpenAPI specs, SDK documentation | API docs, contracts |
| `knowledge-manager` | Documentation management, knowledge base | Markdown, architecture docs |
| `tech-lead` | Technical decisions, cross-team coordination | Architecture decisions |

### Assignment Example

```yaml
TASK-001 (Design user data model):
  Agent: backend-architect
  Reason: Database schema design expertise
  Verification: Schema passes migration test

TASK-002 (Implement JWT auth):
  Agent: backend-architect
  Reason: Security and authentication expertise
  Verification: Unit tests pass, no security warnings

TASK-003 (Create API endpoints):
  Agent: backend-architect
  Reason: API design consistency
  Verification: OpenAPI spec generated

TASK-004 (Write unit tests):
  Agent: qa-engineer
  Reason: Test coverage optimization
  Verification: Coverage >= 85%
```

---

## Task Transformation Pipeline

### Overview

Phase A progressively refines task definitions through three granularity levels:

### A.1 Output: Coarse-grained Functional Checklist

From OpenSpec scaffolding, tasks.md contains functional checklists:

```
- [ ] Add OTP column to users table
- [ ] Create authentication endpoints
- [ ] Implement token validation
- [ ] Add unit tests
```

**Characteristics**:
- Functional checklist format
- High-level deliverables
- No dependencies specified
- No time estimates
- Aligned with OpenSpec scaffolding standard

### A.2 Output: Refined Executable Tasks

A.2 transforms coarse tasks into atomic executable specifications:

```yaml
TASK-001:
  title: Add OTP secret column to users table
  complexity: M (Medium, 2-4h)
  dependencies: None
  deliverables:
    - backend/migrations/add_otp_secret_column.sql
    - backend/src/models/user.py (update User model)

TASK-002:
  title: Create authentication endpoints
  complexity: L (Large, 4-8h)
  dependencies: [TASK-001]
  deliverables:
    - backend/src/routes/auth_routes.py
    - backend/src/services/auth_service.py

TASK-003:
  title: Implement token validation middleware
  complexity: M (Medium, 2-4h)
  dependencies: [TASK-002]
  deliverables:
    - backend/src/middleware/auth_middleware.py

TASK-004:
  title: Add unit tests for authentication
  complexity: M (Medium, 2-4h)
  dependencies: [TASK-003]
  deliverables:
    - backend/tests/test_auth_routes.py
    - backend/tests/test_auth_service.py
```

**Characteristics**:
- TASK-{NNN} unique identifiers
- Complexity estimates with hour ranges
- Explicit dependency chains
- File-level deliverable specifications
- 4-8 hour atomic granularity

### A.3 Output: Agent-Assigned Tasks

A.3 assigns specialized agents and verification criteria:

```yaml
TASK-001:
  [inherits all A.2 metadata]
  agent: backend-architect
  reason: Database schema design expertise, migration management
  verification:
    - Migration runs successfully
    - Column exists in schema with correct type
    - User model updated and tests pass

TASK-002:
  [inherits all A.2 metadata]
  agent: backend-architect
  reason: API design, security, and authentication expertise
  verification:
    - Unit tests pass with >85% coverage
    - No security warnings from linter
    - OpenAPI spec generated correctly

TASK-003:
  [inherits all A.2 metadata]
  agent: backend-architect
  reason: Middleware implementation, security patterns
  verification:
    - Middleware intercepts requests correctly
    - Token validation logic tested
    - Error handling covers edge cases

TASK-004:
  [inherits all A.2 metadata]
  agent: qa-engineer
  reason: Test coverage optimization, quality assurance
  verification:
    - Coverage >= 85% for auth module
    - All edge cases covered
    - Integration tests pass
```

**Characteristics**:
- Inherits all A.2 task metadata
- Specialized agent assignment
- Assignment rationale based on expertise
- Task-specific verification criteria
- Ready for Phase B execution

### Granularity Progression Summary

| Aspect | A.1 (Coarse) | A.2 (Refined) | A.3 (Assigned) |
|--------|--------------|---------------|----------------|
| Format | Checklist | Structured YAML | Structured YAML + Agent |
| Granularity | Functional | Atomic (4-8h) | Atomic (4-8h) |
| IDs | None | TASK-{NNN} | TASK-{NNN} |
| Complexity | Not specified | S/M/L/XL | S/M/L/XL |
| Dependencies | Not specified | Explicit | Explicit |
| Deliverables | High-level | File-level | File-level |
| Agent | Not assigned | Not assigned | Assigned |
| Verification | Not specified | Not specified | Specified |

---

## Dual-Layer Task Architecture

### Overview

Phase A uses a **dual-layer task architecture** to balance human readability with AI executability:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    Dual-Layer Task Architecture                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Layer 1: tasks.md (Coarse-grained, Human-readable)                 │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │ ## 1. Architecture Documentation Update                     │    │
│  │ - [ ] 1.1 Update phase-a-spec-planning.md                   │    │
│  │ - [ ] 1.2 Define A.1/A.2/A.3 responsibilities               │    │
│  │ - [x] 1.3 Add examples (completed)                          │    │
│  └─────────────────────────────────────────────────────────────┘    │
│           │                                    ▲                    │
│           │ Forward Sync (A.2)                 │ Backward Sync      │
│           │ task-planner                       │ progress-updater   │
│           ▼                                    │                    │
│  Layer 2: detailed-tasks.yaml (Fine-grained, AI-executable)        │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │ - id: TASK-001                                              │    │
│  │   parent: "1.1"                                             │    │
│  │   title: Update phase-a-spec-planning.md                    │    │
│  │   status: pending                                           │    │
│  │   complexity: M                                             │    │
│  │   agent: knowledge-manager                                  │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Layer 1: tasks.md (OpenSpec Standard)

**Purpose**: Human-readable progress tracking, OpenSpec compliance

**Location**: `standards/openspec/changes/{feature}/tasks.md`

**Format**:
```markdown
# Tasks: {Feature Name}

> **Spec**: {feature-name}
> **Level**: Full (Level 3)
> **Status**: Approved
> **Created**: {YYYY-MM-DD}

---

## 1. {Phase Name}

- [ ] 1.1 {Task description}
- [ ] 1.2 {Task description}
- [x] 1.3 {Task description} (completed)

## 2. {Phase Name}

- [ ] 2.1 {Task description}
- [ ] 2.2 {Task description}
```

**Characteristics**:
- Markdown checkbox format
- Hierarchical numbering: `{phase}.{task}`
- Phase grouping for organization
- Human-editable for progress tracking
- **Numbering is immutable once created**

### Layer 2: detailed-tasks.yaml (AI Execution)

**Purpose**: AI-executable task specifications with full metadata

**Location**: `standards/openspec/changes/{feature}/detailed-tasks.yaml`

**Format**:
```yaml
spec: {feature-name}
generated_at: "2025-12-20T10:00:00+08:00"
generated_by: task-planner

tasks:
  - id: TASK-001
    parent: "1.1"                    # Links to tasks.md numbering
    title: Update phase-a-spec-planning.md
    status: pending                  # pending | in_progress | completed | blocked
    complexity: M                    # S | M | L | XL
    estimated_hours: 2-4
    dependencies: []
    agent: knowledge-manager
    deliverables:
      - standards/core/ten-step-cycle/phase-a-spec-planning.md
    verification:
      - Dual-layer architecture section exists
      - Synchronization mechanisms documented
    notes: ""

  - id: TASK-002
    parent: "1.2"
    title: Define A.1/A.2/A.3 responsibility boundaries
    status: pending
    complexity: M
    estimated_hours: 2-4
    dependencies: [TASK-001]
    agent: knowledge-manager
    deliverables:
      - standards/core/ten-step-cycle/phase-a-spec-planning.md
    verification:
      - Clear boundaries defined for each step
```

**Required Fields**:
| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Unique identifier: TASK-{NNN} |
| `parent` | string | Reference to tasks.md numbering (e.g., "1.1") |
| `title` | string | Task description |
| `status` | enum | pending, in_progress, completed, blocked |
| `complexity` | enum | S (1-2h), M (2-4h), L (4-8h), XL (8h+) |
| `dependencies` | array | List of TASK-{NNN} IDs this task depends on |
| `agent` | string | Assigned agent type |
| `deliverables` | array | File paths to be created/modified |
| `verification` | array | Criteria to verify task completion |

### Synchronization Mechanisms

#### Forward Sync (A.1 → A.2 → A.3)

**Trigger**: `task-planner` skill execution during A.2

**Process**:
1. Parse tasks.md to extract all checkbox items with numbering
2. Generate detailed-tasks.yaml with `parent` field linking to tasks.md
3. Assign TASK-{NNN} IDs sequentially
4. Add complexity, dependencies, and agent assignments

```
tasks.md                      detailed-tasks.yaml
─────────────────────────────────────────────────
- [ ] 1.1 Task A      →      - id: TASK-001
                               parent: "1.1"
                               title: Task A

- [ ] 1.2 Task B      →      - id: TASK-002
                               parent: "1.2"
                               title: Task B
```

#### Backward Sync (B.2 → tasks.md)

**Trigger**: `progress-updater` skill execution after task completion

**Process**:
1. When TASK-{NNN} status changes to `completed` in detailed-tasks.yaml
2. Locate corresponding parent numbering (e.g., "1.1")
3. Update tasks.md checkbox: `- [ ]` → `- [x]`
4. Preserve all other content

```yaml
# detailed-tasks.yaml
- id: TASK-001
  parent: "1.1"
  status: completed        # Changed from pending

# tasks.md (before)
- [ ] 1.1 Update phase-a-spec-planning.md

# tasks.md (after)
- [x] 1.1 Update phase-a-spec-planning.md
```

### Numbering Immutability Constraint

**Rule**: Once tasks.md numbering is established, it MUST NOT be changed.

**Rationale**:
- The `parent` field in detailed-tasks.yaml references tasks.md numbering
- Changing numbering breaks parent references
- Progress sync would fail or produce incorrect results

**Constraint Enforcement**:

1. **At Spec Approval**: Numbering is locked when status changes to "Reviewed"
2. **Validation**: `task-planner` validates numbering hasn't changed on re-execution
3. **Error Handling**: If numbering change detected, emit error and abort

**Adding New Tasks**:
```markdown
# Correct: Add new tasks with new numbers
## 1. Architecture Documentation Update
- [x] 1.1 Update phase-a-spec-planning.md
- [x] 1.2 Define responsibilities
- [ ] 1.3 Add examples (NEW)           # New task added at end

# Incorrect: Do NOT renumber existing tasks
## 1. Architecture Documentation Update
- [x] 1.1 Add examples                   # WRONG: renumbered from 1.3
- [x] 1.2 Update phase-a-spec-planning   # WRONG: was 1.1
```

**Removing Tasks**:
```markdown
# Correct: Mark as cancelled, keep numbering
## 1. Architecture Documentation Update
- [x] 1.1 Update phase-a-spec-planning.md
- [ ] 1.2 Define responsibilities (CANCELLED)   # Keep number, mark cancelled
- [ ] 1.3 Add examples

# Incorrect: Do NOT remove and renumber
## 1. Architecture Documentation Update
- [x] 1.1 Update phase-a-spec-planning.md
- [ ] 1.2 Add examples                          # WRONG: was 1.3
```

### Conflict Detection and Resolution

**Scenario**: tasks.md manually edited, causing mismatch with detailed-tasks.yaml

**Detection**:
```yaml
# progress-updater detects:
warning: Parent reference mismatch
  - TASK-001.parent: "1.1"
  - tasks.md "1.1": "Different task title"
  - Expected: "Update phase-a-spec-planning.md"
```

**Resolution Options**:

1. **Auto-heal** (if title similarity > 80%):
   - Assume minor edit, proceed with sync
   - Log warning for review

2. **Manual resolution required** (if title similarity < 80%):
   - Abort sync operation
   - Report conflict details
   - User must manually reconcile

3. **Force sync** (with `--force` flag):
   - Override detailed-tasks.yaml parent references
   - Re-generate from current tasks.md
   - WARNING: May lose task metadata

### Step Responsibility Summary

| Step | Layer 1 (tasks.md) | Layer 2 (detailed-tasks.yaml) |
|------|-------------------|-------------------------------|
| A.1 | **CREATE**: Coarse-grained checklist | Not created yet |
| A.2 | READ: Parse numbering and titles | **CREATE**: Generate with parent links |
| A.3 | No change | **UPDATE**: Add agent and verification |
| B.2 | **UPDATE**: Checkbox sync | **UPDATE**: Status changes |

### Skill Integration

| Skill | Role in Dual-Layer |
|-------|-------------------|
| `spec-drafter` | Creates tasks.md during A.1 |
| `task-planner` | Creates detailed-tasks.yaml during A.2, links parent |
| `progress-updater` | Syncs completion status back to tasks.md |

---

## Phase A Checklist

Before proceeding to Phase B, ensure:

- [ ] **A.0**: Current state understood, direction selected
- [ ] **A.1**: Spec created/selected (or Level 1 skip confirmed)
  - For Level 3: Coarse-grained tasks.md created
- [ ] **A.2**: Tasks refined into executable specifications with IDs and dependencies
- [ ] **A.3**: Agents assigned to all tasks with verification criteria
- [ ] All blockers identified and addressed

---

## Execution Modes

### Auto Mode (Level 1-2)
For simple to medium changes, A.0-A.3 can be packaged:

```
User: "Add a new config option for timeout"

Auto Execution:
  A.0: Scan state → No blocking risks
  A.1: Level 1 detected → Skip Spec
  → Proceed directly to B.1
```

### Guided Mode (Level 3)
For complex changes, pause after each step:

```
A.0: Scan state → Present options → User confirms direction
A.1: Create Spec → User reviews → Confirm before A.2
A.2: Plan tasks → User reviews → Confirm before A.3
A.3: Assign agents → User confirms → Proceed to Phase B
```

---

## Related Documents

- [Ten-Step Cycle Overview](./README.md)
- [Phase B: Development](./phase-b-development.md)
- [Phase C: Integration](./phase-c-integration.md)
- [Phase D: Closure](./phase-d-closure.md)
- [UPM Specification](../upm/unified-progress-management-spec.md)
- [OpenSpec Project](../../openspec/project.md)
- [OpenSpec Templates](../../openspec/templates/README.md)
- [Product Doc Hierarchy](../documentation/product-doc-hierarchy.md)
- [System Architecture Spec](../documentation/system-architecture-spec.md)

---

**Version**: 2.2.0
**Created**: 2025-12-13
**Updated**: 2026-01-02
**Maintainer**: AI-DDD Development Team
