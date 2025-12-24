# Spec-Enhanced AI-DDD Ten-Step Cycle

> **Version**: 2.0.0
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
│              Spec-Enhanced AI-DDD Ten-Step Cycle (v2.0)                      │
│                                                                              │
│   Phase A: Planning (规划)              Phase B: Development (开发)          │
│   ┌───────────────────┐               ┌─────────────────────────────────┐   │
│   │ A.0  状态感知      │──────────────▶│ B.1  分支创建                   │   │
│   │ A.1  Spec管理      │               │ B.2  执行验证                   │   │
│   │ A.2  任务规划      │               │ B.3  架构同步                   │   │
│   │ A.3  Agent分配     │               └─────────────────────────────────┘   │
│   └───────────────────┘                              │                       │
│                                                      ▼                       │
│   Phase D: Closure (收尾)              Phase C: Integration (集成)           │
│   ┌───────────────────┐               ┌─────────────────────────────────┐   │
│   │ D.1  进度更新      │◀──────────────│ C.1  Git提交                    │   │
│   │ D.2  Spec归档      │               │ C.2  分支合并/PR                │   │
│   └───────────────────┘               └─────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Phase Details

### Phase A: Planning (规划)

| Step | Name | Purpose | Key Output |
|------|------|---------|------------|
| **A.0** | 状态感知 | Understand current project state, list active Specs | Status summary, Spec list |
| **A.1** | Spec管理 (OpenSpec对齐层) | Create OpenSpec-compliant Spec and coarse-grained checklist | `proposal.md` + `tasks.md` |
| **A.2** | 任务规划 (执行准备层) | Transform functional checklist into executable atomic tasks | `detailed-tasks.yaml` with TASK-{NNN} |
| **A.3** | Agent分配 (资源匹配层) | Match tasks with specialized agents, set verification criteria | Enhanced `detailed-tasks.yaml` with agent + verification |

### Phase B: Development (开发)

| Step | Name | Purpose | Key Output |
|------|------|---------|------------|
| **B.1** | 分支创建 | Create isolated development environment | `feature/{module}/{task-id}-{desc}` |
| **B.2** | 执行验证 | Implement and verify against Spec | Code + test results |
| **B.3** | 架构同步 | Keep docs in sync with implementation | Updated ARCHITECTURE.md |

### Phase C: Integration (集成)

| Step | Name | Purpose | Key Output |
|------|------|---------|------------|
| **C.1** | Git提交 | Create versioned records | Commit SHA |
| **C.2** | 分支合并/PR | Safely integrate changes | PR merged to develop |

### Phase D: Closure (收尾)

| Step | Name | Purpose | Key Output |
|------|------|---------|------------|
| **D.1** | 进度更新 | Update project progress state | Updated UPM + stateToken |
| **D.2** | Spec归档 | Complete Spec lifecycle | `archive/{feature}/spec.md` |

## Dual-Layer Task Architecture

Phase A implements a **dual-layer task architecture** to balance human readability with AI executability:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    Dual-Layer Task Architecture                     │
├─────────────────────────────────────────────────────────────────────┤
│  Layer 1: tasks.md (Human-readable)     Layer 2: detailed-tasks.yaml│
│  ┌────────────────────────────────┐     ┌──────────────────────────┐│
│  │ - [ ] 1.1 Update docs          │ ──▶ │ - id: TASK-001           ││
│  │ - [ ] 1.2 Add examples         │     │   parent: "1.1"          ││
│  │ - [x] 1.3 Review (completed)   │ ◀── │   status: completed      ││
│  └────────────────────────────────┘     └──────────────────────────┘│
│         ▲                                         │                 │
│         │ Backward Sync (B.2)       Forward Sync (A.2) │            │
│         └─────────────────────────────────────────────┘             │
└─────────────────────────────────────────────────────────────────────┘
```

| Layer | Format | Purpose | Created By |
|-------|--------|---------|------------|
| **Layer 1** | `tasks.md` | Human-readable checklist, OpenSpec standard | `spec-drafter` (A.1) |
| **Layer 2** | `detailed-tasks.yaml` | AI-executable specs with TASK-{NNN} IDs | `task-planner` (A.2) |

### Key Concepts

- **parent field**: Links TASK-{NNN} to tasks.md numbering (e.g., "1.1")
- **Forward Sync**: A.1 → A.2 (task-planner generates detailed-tasks.yaml)
- **Backward Sync**: B.2 → tasks.md (progress-updater updates checkboxes)
- **Numbering Immutability**: tasks.md numbering cannot change once established

For detailed documentation, see [Phase A: Planning](./phase-a-spec-planning.md#dual-layer-task-architecture).

---

## Mapping to Original Systems

| New Step | Old Step | AI-DDD 7-Step | OpenSpec | Branch Mgmt |
|----------|----------|---------------|----------|-------------|
| A.0 | Step 1 | 状态感知 | - | - |
| A.1 | Step 0 | - | Draft & Review | - |
| A.2 | Step 2 | 任务规划 | - | - |
| A.3 | Step 3 | Subagent分配 | - | - |
| B.1 | Step 4 | - | - | Create branch |
| B.2 | Step 5 | 执行验证 | Implement | - |
| B.3 | Step 6 | 架构同步 | - | - |
| C.1 | Step 7 | Git提交 | - | Commit & push |
| C.2 | Step 8 | - | - | PR & merge |
| D.1 | Step 9 | 进度更新 | - | - |
| D.2 | Step 10 | - | Archive | - |

## Available Skills

| Step | Skill / Command | Coverage | Notes |
|------|-----------------|----------|-------|
| A.0 | `state-scanner` | 90% | 状态感知 |
| A.1 | `spec-drafter` / `openspec:proposal` | 90% | Skill 智能辅助，Command 严格验证 |
| A.2 | `task-planner` | 90% | 双层架构生成 |
| A.3 | `task-planner` (集成) | 90% | Agent 自动分配 |
| B.1 | `branch-manager` | 90% | 分支创建 |
| B.2 | `test-verifier` + `flutter-test-generator` | 80% | 多模块测试验证 |
| B.3 | `arch-update` + `api-doc-generator` | 80% | 架构同步 |
| C.1 | `commit-msg-generator` / `strategic-commit-orchestrator` | 95% | 简单/复杂提交 |
| C.2 | `branch-manager` | 90% | PR 创建与合并 |
| D.1 | `progress-updater` | 90% | UPM 状态更新 |
| D.2 | `openspec:archive` | 100% | Spec 归档 |

## Quick Reference

```yaml
Phase A - Planning (规划):
  A.0: State scan → Read UPM + list active Specs → User chooses direction
  A.1: Spec manage → Create/select Spec → proposal.md + tasks.md (coarse-grained)
  A.2: Task plan → Transform checklist → detailed-tasks.yaml with TASK-{NNN}
  A.3: Agent assign → Match agents → Enhanced detailed-tasks.yaml (agent + verification)

Phase B - Development (开发):
  B.1: Create branch → branch-manager → feature/{module}/{task-id}-{short-desc}
  B.2: Implement → Code + tests + quality checks
  B.3: Sync docs → ARCHITECTURE.md + API docs

Phase C - Integration (集成):
  C.1: Commit → commit-msg-generator (simple) / strategic-commit-orchestrator (complex)
  C.2: Merge → branch-manager → PR → review → merge to develop → delete branch

Phase D - Closure (收尾):
  D.1: Update UPM → progress-updater → stateToken, kpiSnapshot, progress history
  D.2: Archive Spec → openspec:archive → standards/openspec/archive/{feature}/
```

## Execution Modes

The ten-step cycle supports flexible execution through Skills:

### Auto Mode (自动模式)
For simple changes (Level 1-2), steps can be packaged and executed automatically:
- `quick-fix`: A.0 → B.1 → B.2 → C.1 → C.2 → D.1 (skip Spec)
- `feature-dev(auto)`: Full cycle with minimal pauses

### Guided Mode (引导模式)
For complex changes (Level 3), pause between phases for user confirmation:
- Phase A complete → User confirms → Phase B
- Phase B complete → User confirms → Phase C/D

### Manual Mode (手动模式)
Execute each step individually with full control.

## Level-Based Routing

| Level | Scenario | Recommended Mode |
|-------|----------|------------------|
| 1 | Simple fix, config, typo | `quick-fix` (Auto) |
| 2 | New feature, medium change | `feature-dev` (Auto) |
| 3 | Architecture, cross-module | `feature-dev` (Guided) |

## Phase Detail Documents

- [Phase A: Planning](./phase-a-spec-planning.md) (A.0 - A.3)
- [Phase B: Development](./phase-b-development.md) (B.1 - B.3)
- [Phase C: Integration](./phase-c-integration.md) (C.1 - C.2)
- [Phase D: Closure](./phase-d-closure.md) (D.1 - D.2)

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

**Version**: 2.1.0
**Created**: 2025-12-13
**Updated**: 2025-12-20
**Maintainer**: AI-DDD Development Team
