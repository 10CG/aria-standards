# Workflow Summary

> **Sources**: `standards/core/workflow/*.md`, `standards/core/ten-step-cycle/`

## AI Context Loading

**Principle**: Architecture docs first, code on-demand.

```yaml
Priority:
  1. CLAUDE.md → {module}/ARCHITECTURE.md → UPM
  2. shared/contracts/, shared/schemas/ (on-demand)
  3. Code files (only task-related)
```

## Ten-Step Cycle (Aria v3.0)

| Phase | Steps | Purpose |
|-------|-------|---------|
| **A: Planning** | A.0-A.3 | State scan → Spec → Tasks → Agents |
| **B: Development** | B.1-B.3 | Branch → Implement → Sync docs |
| **C: Integration** | C.1-C.2 | Commit → PR/Merge |
| **D: Closure** | D.1-D.2 | Update UPM → Archive Spec |

> **Note**: Seven-Step Cycle is DEPRECATED. Use Ten-Step Cycle.

## Requirements Workflows (Aria v3.0)

| Workflow | Purpose | Trigger |
|----------|---------|---------|
| requirements-check | Validate PRD/Story | `/requirements-check` |
| requirements-update | Sync Story → UPM | `/requirements-update` |
| iteration-planning | Sprint kickoff review | `/iteration-planning` |
| publish-prd | PRD → Forgejo Wiki | `/publish-prd` |

> See `standards/workflow/requirements-workflows.md` for details.

## Document Sync

- **Trigger**: Task completion, phase transition, KPI change
- **Order**: Write lifecycle doc → Update UPM → Verify consistency
- **StateToken**: Recalculate SHA256 on every update

## Best Practices

- Read UPM before any task
- Update immediately after completion
- Never skip verification commands
- Use standard paths for lifecycle docs

---
*For details: `standards/core/workflow/`*
