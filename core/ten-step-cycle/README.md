# Spec-Enhanced AI-DDD Ten-Step Cycle

> **Version**: 1.0.0
> **Status**: Active
> **Based on**: AI-DDD Seven-Step Cycle + OpenSpec + Branch Management

## Overview

The Ten-Step Cycle is an enhanced development methodology that integrates:
- **OpenSpec**: Specification-driven development (Draft → Review → Implement → Archive)
- **AI-DDD**: AI-driven development workflow (State Recognition → Progress Update)
- **Branch Management**: Git workflow (feature branch → PR → merge)

## Cycle Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Spec-Enhanced AI-DDD 10-Step Cycle                        │
│                                                                              │
│   Phase A: Specification & Planning    Phase B: Development Execution        │
│   ┌───────────────────┐               ┌─────────────────────────────────┐   │
│   │ Step 0: Spec定义   │──────────────▶│ Step 4: 分支创建                │   │
│   │ Step 1: 状态感知   │               │ Step 5: 执行验证                │   │
│   │ Step 2: 任务规划   │               │ Step 6: 架构同步                │   │
│   │ Step 3: Agent分配  │               └─────────────────────────────────┘   │
│   └───────────────────┘                              │                       │
│                                                      ▼                       │
│   Phase D: Closure & Archive           Phase C: Commit & Integration         │
│   ┌───────────────────┐               ┌─────────────────────────────────┐   │
│   │ Step 9: 进度更新   │◀──────────────│ Step 7: Git提交                 │   │
│   │ Step 10: Spec归档  │               │ Step 8: 分支合并/PR             │   │
│   └───────────────────┘               └─────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Phase Details

### Phase A: Specification & Planning

| Step | Name | Purpose | Key Output |
|------|------|---------|------------|
| **0** | Spec定义 | Define what to build before coding | `changes/{feature}/spec.md` |
| **1** | 状态感知 | Understand current project state | Status summary, active Specs |
| **2** | 任务规划 | Break Spec into executable tasks | Task list with dependencies |
| **3** | Agent分配 | Match tasks with specialized agents | Task-Agent mapping |

### Phase B: Development Execution

| Step | Name | Purpose | Key Output |
|------|------|---------|------------|
| **4** | 分支创建 | Create isolated development environment | `feature/{module}/{task-id}-{desc}` |
| **5** | 执行验证 | Implement and verify against Spec | Code + test results |
| **6** | 架构同步 | Keep docs in sync with implementation | Updated ARCHITECTURE.md |

### Phase C: Commit & Integration

| Step | Name | Purpose | Key Output |
|------|------|---------|------------|
| **7** | Git提交 | Create versioned records | Commit SHA |
| **8** | 分支合并/PR | Safely integrate changes | PR merged to develop |

### Phase D: Closure & Archive

| Step | Name | Purpose | Key Output |
|------|------|---------|------------|
| **9** | 进度更新 | Update project progress state | Updated UPM + stateToken |
| **10** | Spec归档 | Complete Spec lifecycle | `archive/{feature}/spec.md` |

## Mapping to Original Systems

| New Step | AI-DDD 7-Step | OpenSpec | Branch Management |
|----------|---------------|----------|-------------------|
| Step 0 | - | Draft & Review | - |
| Step 1 | Step 1: 状态感知 | - | - |
| Step 2 | Step 2: 任务规划 | - | - |
| Step 3 | Step 3: Subagent分配 | - | - |
| Step 4 | - | - | Create feature branch |
| Step 5 | Step 4: 执行验证 | Implement | - |
| Step 6 | Step 5: 架构同步 | - | - |
| Step 7 | Step 6: Git提交 | - | Commit & push |
| Step 8 | - | - | PR & merge |
| Step 9 | Step 7: 进度更新 | - | - |
| Step 10 | - | Archive | - |

## Available Skills

| Step | Skill | Coverage |
|------|-------|----------|
| Step 0 | (planned) spec-drafter | 0% |
| Step 1 | progress-query-assistant | 90% |
| Step 2 | (planned) task-planner | 0% |
| Step 3 | (built-in) | 100% |
| Step 4 | branch-manager | 90% |
| Step 5 | flutter-test-generator | 30% |
| Step 6 | architecture-doc-updater, api-doc-generator | 80% |
| Step 7 | commit-msg-generator, strategic-commit-orchestrator | 95% |
| Step 8 | branch-manager | 90% |
| Step 9 | progress-updater | 90% |
| Step 10 | `openspec archive` (CLI built-in) | 100% |

## Quick Reference

```yaml
Phase A - Specification & Planning:
  Step 0: Create Spec → standards/openspec/changes/{feature}/spec.md
  Step 1: Read UPM → {module}/project-planning/unified-progress-management.md
  Step 2: Plan tasks → Task breakdown with dependencies
  Step 3: Assign agents → backend-architect, mobile-developer, etc.

Phase B - Development Execution:
  Step 4: Create branch → branch-manager → feature/{module}/{task-id}-{short-desc}
  Step 5: Implement → Code + tests + quality checks
  Step 6: Sync docs → ARCHITECTURE.md + API docs

Phase C - Commit & Integration:
  Step 7: Commit → commit-msg-generator (simple) / strategic-commit-orchestrator (complex)
  Step 8: Merge → branch-manager → PR → review → merge to develop → delete branch

Phase D - Closure & Archive:
  Step 9: Update UPM → progress-updater → stateToken, kpiSnapshot, progress history
  Step 10: Archive Spec → openspec archive {change} → standards/openspec/archive/{feature}/
```

## Phase Detail Documents

- [Phase A: Specification & Planning](./phase-a-spec-planning.md) (Steps 0-3)
- [Phase B: Development Execution](./phase-b-development.md) (Steps 4-6)
- [Phase C: Commit & Integration](./phase-c-integration.md) (Steps 7-8)
- [Phase D: Closure & Archive](./phase-d-closure.md) (Steps 9-10)

## Related Documents

### Core Standards (in this submodule)
- [Progress Management](../progress-management/ai-ddd-progress-management-core.md)
- [State Management](../state-management/ai-ddd-state-management.md)
- [UPM Specification](../upm/unified-progress-management-spec.md)
- [Workflow Standards](../workflow/ai-ddd-workflow-standards.md)
- [Seven-Step Cycle](../seven-step-cycle/README.md) (original)
- [Branch Management Guide](../../workflow/branch-management-guide.md)

### OpenSpec
- [OpenSpec Project](../../openspec/project.md)
- [OpenSpec Agents](../../openspec/AGENTS.md)

### Extensions
- [Backend Extension](../../extensions/backend-ai-ddd-extension.md)
- [Mobile Extension](../../extensions/mobile-ai-ddd-extension.md)

### Full Planning Document
- [Spec-Enhanced AI-DDD Fusion Plan](../../../docs/analysis/spec-enhanced-ai-ddd-fusion-plan.md) (in main repo)

---

**Version**: 1.0.0
**Created**: 2025-12-13
**Maintainer**: AI-DDD Development Team
