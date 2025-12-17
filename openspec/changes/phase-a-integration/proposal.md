# Phase A Integration: 规划阶段 Skills 整合

> **Level**: Full (Level 3 Spec)
> **Status**: Draft
> **Created**: 2025-12-18
> **Context**: 十步循环 Phase A (Steps 0-3) 工具链优化

---

## Why

### 问题背景

当前 Phase A 的 Skills 实现存在以下问题：

1. **tasks.md 断层**
   - `spec-drafter` (Step 0) 在 Level 3 时生成 `tasks.md`
   - `task-planner` (Step 2) **不读取** 已存在的 `tasks.md`，而是重新从 `proposal.md` 分解任务
   - 造成重复劳动和信息不一致

2. **Step 2+3 边界模糊**
   - Step 3 标注为 `(built-in)`，覆盖率 100%
   - 但 `task-planner` 已经包含 Agent 预分配功能
   - Step 2 和 Step 3 实际上可以合并

3. **缺乏编排机制**
   - Step 0 → Step 1 → Step 2 → Step 3 之间没有自动化流程
   - 用户需要手动调用每个 Skill
   - 信息传递依赖人工衔接

### 数据流现状 (AS-IS)

```
spec-drafter (Step 0)
    │
    ├─→ proposal.md ────────────────────────┐
    │                                       │
    └─→ tasks.md ─────────────── ❌ 未使用   │
                                            │
progress-query-assistant (Step 1)           │
    │                                       │
    └─→ UPM 状态摘要                         │
                                            │
task-planner (Step 2) ◀────────────────────┘
    │
    └─→ 重新分解任务 + Agent 预分配 (Step 3)
```

### 期望数据流 (TO-BE)

```
spec-drafter (Step 0)
    │
    ├─→ proposal.md
    │
    └─→ tasks.md ─────────────────────────┐
                                          │
progress-query-assistant (Step 1)         │
    │                                     │
    └─→ UPM 状态摘要 + Pending Specs       │
                                          │
task-planner (Step 2+3) ◀─────────────────┘
    │
    ├─→ 优先读取 tasks.md (如存在)
    ├─→ 否则从 proposal.md 分解
    └─→ 输出: 结构化任务 + Agent 分配 + 执行顺序
```

---

## What

### 核心变更

#### 变更 1: 增强 task-planner 复用 tasks.md

**当前行为**:
- 只读取 `proposal.md` 的 `## Tasks` 章节
- 忽略 `tasks.md` 即使存在

**目标行为**:
```yaml
读取策略:
  1. 检查 changes/{feature}/tasks.md 是否存在
  2. 如果存在 → 解析 tasks.md 作为基础
  3. 如果不存在 → 从 proposal.md 分解任务
  4. 合并/补充来自 proposal.md 的 Success Criteria
```

#### 变更 2: 明确 Step 2+3 合并

**当前状态**:
- Step 2: task-planner (覆盖率 90%)
- Step 3: (built-in) (覆盖率 100%)

**目标状态**:
- Step 2+3: task-planner (覆盖率 95%)
- 移除 Step 3 的 "(built-in)" 标记
- task-planner 的 Agent 预分配即为 Step 3 实现

#### 变更 3: 添加 tasks.md 格式规范

**定义结构化 tasks.md 格式**:

```markdown
# Implementation Tasks

> **Spec**: {spec_path}
> **Generated**: {date}
> **Total Tasks**: {count}

## Task List

### TASK-{ID}: {Title}
- **Description**: {详细描述}
- **Complexity**: S/M/L/XL
- **Estimated**: {hours}h
- **Dependencies**: {task_ids} | None
- **Agent**: {agent_type}
- **Deliverables**:
  - {file1}
  - {file2}
- **Acceptance Criteria**:
  - [ ] {criterion}

## Execution Order
{依赖图 ASCII}

## Summary
{复杂度统计表}
```

#### 变更 4: 可选的 Phase A Orchestrator

**创建编排 Skill** (可选，Level 3 扩展):

```yaml
name: phase-a-planner
description: |
  Phase A 规划阶段编排器，协调 Step 0-3 的自动化流程。

功能:
  - 自动检测需求级别 (Level 1/2/3)
  - 编排 spec-drafter → progress-query-assistant → task-planner
  - 统一输出规划结果
```

---

### Key Deliverables

| 交付物 | 类型 | 说明 |
|--------|------|------|
| `.claude/skills/task-planner/SKILL.md` | 更新 | 添加 tasks.md 读取逻辑 |
| `standards/openspec/templates/tasks.md` | 新增 | 结构化 tasks.md 模板 |
| `standards/core/ten-step-cycle/README.md` | 更新 | Step 3 标记调整 |
| `.claude/skills/phase-a-planner/SKILL.md` | 新增 (可选) | 编排器 Skill |

---

## Impact

| Type | Description |
|------|-------------|
| **Positive** | 消除重复劳动；提升 Spec→Task 转换效率；统一 tasks.md 格式 |
| **Positive** | 明确 Step 2+3 边界，简化开发流程理解 |
| **Risk** | 需要更新现有 tasks.md 格式 (低风险，向后兼容) |
| **Risk** | phase-a-planner 增加复杂度 (可选实现) |

---

## Implementation Options

### Option A: Minimal (推荐)
仅实现变更 1-3，不创建 orchestrator

**优点**: 改动小，快速见效
**缺点**: 仍需手动调用多个 Skills

**工作量**: 4-6h

### Option B: Full
实现所有变更 1-4，包括 orchestrator

**优点**: 完整自动化，一键完成 Phase A
**缺点**: 复杂度高，需要更多测试

**工作量**: 12-16h

---

## Tasks

### Phase 1: task-planner 增强 (Option A)

- [ ] 添加 tasks.md 检测逻辑
- [ ] 实现 tasks.md 解析器
- [ ] 更新 SKILL.md 文档
- [ ] 添加 fallback 到 proposal.md 逻辑
- [ ] 测试两种路径 (有/无 tasks.md)

### Phase 2: 模板和规范 (Option A)

- [ ] 创建 `templates/tasks.md` 模板
- [ ] 更新 `templates/README.md`
- [ ] 更新 spec-drafter 使用新模板生成 tasks.md
- [ ] 更新十步循环文档 Step 3 描述

### Phase 3: Orchestrator (Option B, 可选)

- [ ] 设计 phase-a-planner 工作流
- [ ] 实现编排逻辑
- [ ] 集成 spec-drafter, progress-query-assistant, task-planner
- [ ] 创建 SKILL.md 文档
- [ ] 端到端测试

---

## Success Criteria

- [ ] task-planner 正确读取 tasks.md (如存在)
- [ ] task-planner 在无 tasks.md 时 fallback 到 proposal.md
- [ ] tasks.md 模板格式统一
- [ ] 十步循环文档 Step 3 标记更新
- [ ] (Option B) phase-a-planner 能一键完成 Step 0-3

---

## Decision Required

请选择实现方案:

- [ ] **Option A (Minimal)**: 仅增强 task-planner + 模板规范
- [ ] **Option B (Full)**: 包含 Phase A Orchestrator
- [ ] **其他**: _请说明_

---

## Related Documents

- [十步循环概览](../../../standards/core/ten-step-cycle/README.md)
- [Phase A: 规范与规划](../../../standards/core/ten-step-cycle/phase-a-spec-planning.md)
- [spec-drafter SKILL.md](../../../.claude/skills/spec-drafter/SKILL.md)
- [task-planner SKILL.md](../../../.claude/skills/task-planner/SKILL.md)
- [progress-query-assistant SKILL.md](../../../.claude/skills/progress-query-assistant/SKILL.md)

---

**审阅人**: _待分配_
**审阅日期**: _待定_
