# Tasks: {Feature Name}

> **Spec**: changes/{feature}/proposal.md
> **Level**: Full (Level 3)
> **Status**: Approved
> **Created**: {YYYY-MM-DD}
> **Estimated**: {X-Y}h

---

## 1. {Phase Name}

- [ ] 1.1 {Task Description}
- [ ] 1.2 {Task Description}
- [x] 1.3 {Task Description} (example: already completed)

## 2. {Phase Name}

- [ ] 2.1 {Task Description}
- [ ] 2.2 {Task Description}

## 3. {Phase Name}

- [ ] 3.1 {Task Description}
- [ ] 3.2 {Task Description}

---

## Summary

| Phase | Tasks | Estimated Hours |
|-------|-------|-----------------|
| 1. {Phase Name} | {N} | {X}h |
| 2. {Phase Name} | {N} | {X}h |
| 3. {Phase Name} | {N} | {X}h |
| **Total** | **{N}** | **{X-Y}h** |

---

## Dependencies

```
Phase 1 ──┬──> Phase 2 ──┬──> Phase 3
          │              │
          └──> [其他依赖]   └──> [其他依赖]
```

---

## Notes

1. **Numbering Immutability**: Once numbering (1.1, 1.2, etc.) is established, it MUST NOT be changed
   - Adding new tasks: Use new numbers (1.4, 1.5, etc.)
   - Removing tasks: Mark as ~~cancelled~~ instead of deleting
   - Renumbering: Forbidden - breaks parent references in detailed-tasks.yaml

2. **Task Granularity**: Each item should represent a coarse-grained functional deliverable
   - Focus on "what" not "how"
   - Keep descriptions brief and clear
   - One deliverable per checkbox preferred

3. **Phase Organization**:
   - Group related tasks under logical phases
   - Maintain sequential numbering within each phase
   - Phase names should reflect major work areas

---

## Dual-Layer Architecture

This tasks.md file serves as Layer 1 (coarse-grained) in the dual-layer architecture:

- **Layer 1** (this file): Human-readable progress tracking, OpenSpec CLI compatible
- **Layer 2** (detailed-tasks.yaml): AI-executable task specifications with TASK-{NNN} IDs

The `task-planner` skill will:
1. Parse this tasks.md file
2. Generate detailed-tasks.yaml with parent field linking (e.g., parent: "1.1")
3. Create atomic TASK-{NNN} items for each checkbox
4. Maintain bidirectional synchronization

---

## Template Usage Guidelines

### When to Use This Template

Use for **Level 3 (Full) Specs**:
- Architectural changes
- Cross-module changes
- Features requiring > 3 days work
- Changes affecting > 10 files

### Numbering Format

```
Format: {Phase}.{Task}
Example: 1.1, 1.2, 2.1, 2.2, 3.1

Rules:
- Phase: Sequential (1, 2, 3...)
- Task: Sequential within phase (1, 2, 3...)
- No gaps in numbering
- No reuse of numbers after deletion
```

### Task Description Best Practices

✅ Good:
- "Add OTP secret column to users table"
- "Create authentication endpoints"
- "Implement token validation middleware"

❌ Avoid:
- Technical implementation details (belongs in detailed-tasks.yaml)
- Agent assignments (belongs in detailed-tasks.yaml)
- File-specific paths (belongs in detailed-tasks.yaml)
- Time estimates (belongs in detailed-tasks.yaml)

### Example Transformation

```yaml
tasks.md (Layer 1):
- [ ] 1.1 Database Setup
- [ ] 1.2 API Implementation

↓ task-planner transforms to ↓

detailed-tasks.yaml (Layer 2):
- id: TASK-001
  parent: "1.1"
  title: Database Setup
  complexity: M
  deliverables: [backend/migrations/create_users.sql]

- id: TASK-002
  parent: "1.2"
  title: Create User API
  complexity: L
  deliverables: [backend/src/routes/users.py]
  dependencies: [TASK-001]
```