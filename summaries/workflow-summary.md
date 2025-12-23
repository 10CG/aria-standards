# Workflow Summary

> **Sources**: `standards/core/workflow/*.md`

## AI Context Loading

**Principle**: Architecture docs first, code on-demand.

```yaml
Priority:
  1. CLAUDE.md → {module}/ARCHITECTURE.md → UPM
  2. shared/contracts/, shared/schemas/ (on-demand)
  3. Code files (only task-related)
```

## Seven-Step Cycle (Original)

1. **State Recognition** - Read UPM
2. **Task Planning** - Plan next tasks
3. **Subagent Assignment** - Select agent
4. **Execution & Verification** - Implement
5. **Architecture Sync** - Update docs
6. **Git Commit** - Standard format
7. **Progress Update** - Update UPM

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
