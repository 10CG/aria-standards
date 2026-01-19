# Workflow Summary

> **Version**: 1.1.0
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
| **B: Development** | B.1-B.3 | Branch → Implement (TDD) → Sync docs |
| **C: Integration** | C.1-C.2 | Commit → PR/Merge |
| **D: Closure** | D.1-D.2 | Update UPM → Archive Spec |

> **Note**: Seven-Step Cycle is DEPRECATED. Use Ten-Step Cycle.

### Quality Enforcement (质量保障)

**TDD Enforcer** (测试驱动强制):
```yaml
RED Phase:   编写测试 → 运行确认失败 → 停止编码
GREEN Phase: 编写最小代码 → 运行通过 → 停止扩展
REFACTOR:    优化结构 → 运行通过 → 确认质量
```

**Auto-Trigger** (自动触发):
```yaml
"测试", "test" → tdd-enforcer
"分支", "branch" → branch-manager
"提交", "commit" → commit-msg-generator
"状态", "state" → state-scanner
```

**Hooks System** (钩子):
```yaml
SessionStart:  环境检查
PreCommit:     TDD验证 + 格式检查
TaskComplete:  覆盖率验证 + 文档同步
```

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

### Core Principles
- Read UPM before any task
- Update immediately after completion
- Never skip verification commands
- Use standard paths for lifecycle docs

### TDD Best Practices
- **Always**: Write test before implementation (RED phase)
- **Always**: Run tests to confirm failure before coding
- **Never**: Add extra features during GREEN phase
- **Always**: Keep tests passing during REFACTOR

### Workflow Automation
- Use Auto-Trigger keywords to activate appropriate skills
- Configure Hooks to enforce quality gates
- Follow Two-Phase Review (规范合规性 + 代码质量)
- Maintain ≥85% test coverage for new code

---
*For details: `standards/core/workflow/`*

**Updated**: 2026-01-20 (TDD, Auto-Trigger, Hooks integration)
