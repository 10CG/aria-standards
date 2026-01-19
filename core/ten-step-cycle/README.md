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

## Quality Enforcement (质量保障)

Aria 采用**多层质量保障机制**，确保代码质量和工作流规范：

### TDD Enforcer (测试驱动强制)

遵循 **RED-GREEN-REFACTOR** 循环，强制测试先于代码：

```
┌─────────────────────────────────────────────────────────────┐
│                    TDD Development Cycle                    │
│                                                             │
│   RED (失败测试)     GREEN (最小实现)    REFACTOR (重构)    │
│   ─────────────     ────────────────    ─────────────────   │
│                                                             │
│   1. 编写测试        1. 编写最小代码       1. 优化结构       │
│   2. 运行测试        2. 运行测试           2. 提取抽象       │
│   3. 确认失败        3. 确认通过           3. 运行测试       │
│   4. 停止编码        4. 停止扩展           4. 确认通过       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

- **强制规则**: 编写业务代码前必须存在对应测试
- **删除保护**: 删除测试前验证无业务代码依赖
- **语言支持**: Python, JavaScript, TypeScript, Dart, Java, Go

详情: [.claude/skills/tdd-enforcer/SKILL.md](../../../.claude/skills/tdd-enforcer/SKILL.md)

### Auto-Trigger System (自动触发)

基于意图关键词自动激活对应 Skill：

```yaml
意图关键词 → Skill 映射 (示例):
  "test", "测试", "tdd"           → tdd-enforcer
  "branch", "分支", "pr"          → branch-manager
  "commit", "提交"                → commit-msg-generator
  "plan", "规划", "task"          → task-planner
  "state", "状态", "progress"     → state-scanner
```

- **配置文件**: `.claude/trigger-rules.json`
- **匹配算法**: 模糊匹配 + 上下文加成
- **置信度阈值**: ≥ 0.8 自动触发，0.6-0.8 确认触发

### Hooks System (钩子系统)

在关键节点自动执行验证：

```yaml
SessionStart (会话开始):
  - 环境检查 (Git status, dependencies)
  - 配置加载 (环境变量, aliases)

PreCommit (提交前):
  - TDD 状态验证 (计划中)
  - 代码格式检查

TaskComplete (任务完成):
  - 测试覆盖率验证
  - 文档同步检查
```

- **配置**: `aria/hooks/hooks.json`
- **实现**: `aria/hooks/session-start.sh`, `run-hook.cmd`

---

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
| **B.2** | 执行验证 | Implement with TDD + quality checks | Code + tests + verification report |
| **B.3** | 架构同步 | Keep docs in sync with implementation | Updated ARCHITECTURE.md |

**B.2 质量检查要点**:
- TDD 验证: 测试先于实现 (RED → GREEN → REFACTOR)
- 两阶段评审: 规范合规性 + 代码质量
- 测试覆盖: 新增代码必须有对应测试

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

### Phase-Based Architecture (v2.0)

十步循环采用 **Phase-Based 架构**，将 10 个步骤分组为 4 个 Phase：

```
state-scanner (A.0 + 推荐引擎)
    │
    │ 推荐工作流
    ▼
workflow-runner (轻量编排器)
    │
    ├──▶ phase-a-planner (A.1-A.3)
    ├──▶ phase-b-developer (B.1-B.3)
    ├──▶ phase-c-integrator (C.1-C.2)
    └──▶ phase-d-closer (D.1-D.2)
```

### Phase Skills

| Phase | Skill | Steps | Purpose |
|-------|-------|-------|---------|
| Entry | `state-scanner` | A.0 | 状态感知 + 智能工作流推荐 |
| A | `phase-a-planner` | A.1-A.3 | Spec 管理、任务规划、Agent 分配 |
| B | `phase-b-developer` | B.1-B.3 | 分支创建、测试验证、架构同步 |
| C | `phase-c-integrator` | C.1-C.2 | Git 提交、PR 创建/合并 |
| D | `phase-d-closer` | D.1-D.2 | 进度更新、Spec 归档 |
| Orchestrator | `workflow-runner` | 组合 | 编排 Phase Skills |

### Step-Level Skills

| Step | Skill / Command | Coverage | Notes |
|------|-----------------|----------|-------|
| A.0 | `state-scanner` | 95% | 状态感知 + 智能推荐 |
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
Quality Enforcement (质量保障):
  TDD Cycle: RED (写测试) → GREEN (实现) → REFACTOR (重构)
  Auto-Trigger: 意图关键词 → Skill 自动激活
  Hooks: SessionStart/PreCommit/TaskComplete 自动验证

Phase A - Planning (规划):
  A.0: State scan → Read UPM + list active Specs → User chooses direction
  A.1: Spec manage → Create/select Spec → proposal.md + tasks.md (coarse-grained)
  A.2: Task plan → Transform checklist → detailed-tasks.yaml with TASK-{NNN}
  A.3: Agent assign → Match agents → Enhanced detailed-tasks.yaml (agent + verification)

Phase B - Development (开发):
  B.1: Create branch → branch-manager → feature/{module}/{task-id}-{short-desc}
  B.2: Implement → RED→GREEN→REFACTOR + tests + quality checks
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

### Quality Enhancement (工作流增强)
- [TDD Enforcer](../../../.claude/skills/tdd-enforcer/SKILL.md) - RED-GREEN-REFACTOR 强制循环
- [Auto-Trigger Guide](../../workflow/auto-trigger-guide.md) - 意图关键词自动触发
- [Hooks System](../../../aria/hooks/README.md) - 关键节点自动验证
- [Migration Guide](../../workflow/migration-guide.md) - 从旧工作流迁移

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
<!-- 设计背景参考（主项目文档）:
     - docs/analysis/spec-enhanced-ai-ddd-fusion-plan.md
-->

---

**Version**: 2.3.0
**Created**: 2025-12-13
**Updated**: 2026-01-20
**Maintainer**: AI-DDD Development Team
