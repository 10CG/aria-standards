# task-planner Skill

> **Level**: Minimal (Level 2 Spec)
> **Status**: Implemented
> **Created**: 2025-12-17
> **Context**: Phase A 补齐，十步循环 Step 2

## Why

十步循环的 Step 2 (任务规划) 当前没有对应的 Skill 支持，覆盖率为 0%。Phase A (Steps 0-3) 是规范与规划阶段的核心，需要完整的工具链支持。

Step 1 的 `progress-query-assistant` 已能获取项目状态和待处理的 Spec 列表，但缺少将 Spec 分解为可执行任务的自动化工具。

## What

创建 `task-planner` Skill，用于将 OpenSpec proposal.md 分解为可执行的任务列表，支持：

1. **Spec 解析**: 读取 proposal.md，提取 Tasks 和 Success Criteria
2. **任务分解**: 将高层任务拆解为原子化子任务
3. **复杂度评估**: 自动评估 S/M/L/XL 复杂度
4. **依赖分析**: 识别任务间依赖关系
5. **执行顺序**: 生成最优执行顺序和依赖图
6. **Agent 预分配**: 根据任务类型预分配 Agent

### Key Deliverables

- `.claude/skills/task-planner/SKILL.md` - 主 Skill 文档
- `.claude/skills/task-planner/COMPLEXITY_GUIDE.md` - 复杂度评估指南

## Impact

| Type | Description |
|------|-------------|
| **Positive** | 完成 Phase A 工具链，实现 Spec → Tasks 的自动化流程，提升规划效率 |
| **Risk** | 任务分解质量依赖 Spec 质量；通过与 spec-drafter 协作，确保输入质量 |

## Tasks

- [x] 设计 Spec 解析引擎 (读取 proposal.md 结构)
- [x] 实现任务分解算法 (支持多层级拆解)
- [x] 实现复杂度评估规则 (基于关键词和影响范围)
- [x] 实现依赖分析逻辑 (构建 DAG)
- [x] 实现执行顺序生成 (拓扑排序)
- [x] 集成 Agent 预分配 (参考 Step 3 能力映射)
- [x] 创建 SKILL.md 主文档
- [x] 添加使用示例和测试用例

## Success Criteria

- [x] 能正确解析 proposal.md 的 Tasks 章节
- [x] 生成的任务包含：ID, 描述, 复杂度, 依赖, Agent
- [x] 依赖图正确 (无循环依赖)
- [x] 执行顺序有效 (尊重依赖关系)
- [x] 有至少 3 个完整使用示例
- [x] 与 spec-drafter 和 progress-query-assistant 协作流畅

## Integration Points

### 上游 (输入来源)

| Skill | 提供数据 |
|-------|----------|
| `spec-drafter` | proposal.md (Tasks, Success Criteria) |
| `progress-query-assistant` | 当前 Phase/Cycle, 活跃 Specs 列表, nextCycle.candidates |

### 下游 (输出消费)

| Skill/Step | 消费数据 |
|------------|----------|
| Step 3 Agent 分配 | 任务列表 + 预分配 Agent |
| `branch-manager` | 任务 ID 用于分支命名 |
| `progress-updater` | 任务完成状态更新 |

## Technical Notes

### 复杂度评估规则 (初版)

| Complexity | 条件 |
|------------|------|
| **S** | 单文件修改, 无依赖, 关键词: config, typo, format |
| **M** | 2-5 文件, 单模块, 关键词: implement, add, update |
| **L** | 5-10 文件, 可能跨组件, 关键词: refactor, integrate |
| **XL** | >10 文件, 跨模块, 关键词: architecture, migration, breaking |

### 依赖识别策略

```yaml
显式依赖: 任务描述中包含 "依赖", "需要先", "after"
隐式依赖:
  - 测试任务依赖实现任务
  - 文档任务依赖功能任务
  - 集成任务依赖组件任务
```
