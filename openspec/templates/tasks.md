# Implementation Tasks: {Feature Name}

> **Spec**: changes/{feature}/proposal.md
> **Generated**: {YYYY-MM-DD}
> **Total Tasks**: {N}
> **Estimated**: {X-Y}h

---

## Phase 1: {Phase Name}

### TASK-001: {Task Title}
- **Description**: {What needs to be done}
- **Complexity**: S (Small) | M (Medium) | L (Large) | XL (Extra Large)
- **Estimated**: {N}h
- **Dependencies**: None | TASK-{ID}
- **Agent**: {agent-type}
- **Deliverables**:
  - {File path or artifact 1}
  - {File path or artifact 2}
- **Acceptance Criteria**:
  - [ ] {Criterion 1}
  - [ ] {Criterion 2}

### TASK-002: {Task Title}
- **Description**: {What needs to be done}
- **Complexity**: {S/M/L/XL}
- **Estimated**: {N}h
- **Dependencies**: TASK-001
- **Agent**: {agent-type}
- **Deliverables**:
  - {File path or artifact}
- **Acceptance Criteria**:
  - [ ] {Criterion 1}

---

## Phase 2: {Phase Name}

### TASK-003: {Task Title}
- **Description**: {What needs to be done}
- **Complexity**: {S/M/L/XL}
- **Estimated**: {N}h
- **Dependencies**: None | TASK-{ID}
- **Agent**: {agent-type}
- **Deliverables**:
  - {File path or artifact}
- **Acceptance Criteria**:
  - [ ] {Criterion 1}

---

## Execution Order

```
┌─────────────────────────────────────────────────────────────┐
│                    PHASE 1                                  │
│  TASK-001 ──▶ TASK-002                                     │
│                                                             │
│                    PHASE 2 (依赖 Phase 1)                   │
│  TASK-003 ──▶ TASK-004                                     │
└─────────────────────────────────────────────────────────────┘
```

**并行分组**:

| Group | Tasks | Can Start After |
|-------|-------|-----------------|
| 1 | TASK-001, TASK-003 | - |
| 2 | TASK-002 | Group 1 |
| 3 | TASK-004 | TASK-002 |

---

## Summary

| Complexity | Count | Hours |
|------------|-------|-------|
| S (Small) | {N} | {X}h |
| M (Medium) | {N} | {X}h |
| L (Large) | {N} | {X}h |
| XL (Extra Large) | {N} | {X}h |
| **Total** | **{N}** | **{X}h** |

---

## Notes

- {Any important notes about implementation}
- {Risk factors or considerations}
- {Dependencies on external factors}

---

## Template Usage

### Complexity Guidelines

| Complexity | Hours | Typical Scope |
|------------|-------|---------------|
| **S (Small)** | 0.5-2h | Single file change, simple logic |
| **M (Medium)** | 2-4h | Multi-file, moderate logic |
| **L (Large)** | 4-8h | Complex feature, testing |
| **XL (Extra Large)** | 8-16h | Major feature, needs splitting |

### Agent Types

| Agent | Best For |
|-------|----------|
| `knowledge-manager` | Documentation, specs, standards |
| `backend-architect` | API design, database, services |
| `mobile-developer` | Flutter/Dart, UI components |
| `qa-engineer` | Testing, quality validation |
| `api-documenter` | OpenAPI specs, API docs |
| `tech-lead` | Architecture decisions, coordination |

### Task ID Format

- Format: `TASK-{NNN}` (e.g., TASK-001, TASK-002)
- Sequential within the document
- Used for dependency references and branch naming

### When to Create tasks.md

This template is used for **Level 3 (Full) Specs**:
- Architectural changes
- Cross-module changes
- Features requiring > 3 days work
- Changes affecting > 10 files

For simpler changes, use **Level 2 (Minimal) Spec** with only `proposal.md`.
