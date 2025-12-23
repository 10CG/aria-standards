# Ten-Step Cycle Restructure

> **Level**: Minimal (Level 2 Spec)
> **Status**: Archived
> **Created**: 2025-12-18
> **Implemented**: 2025-12-20
> **Archived**: 2025-12-23
> **Module**: standards

## Why

当前十步循环的 Step 0 (Spec 定义) 和 Step 1 (状态感知) 的顺序不够合理：

1. **逻辑顺序问题**: 开发者应先了解当前状态，再决定创建新 Spec 还是继续已有 Spec
2. **OpenSpec 对齐**: 状态感知应作为所有操作的起点
3. **流程连贯性**: Spec 相关步骤 (A.1, A.2, A.3) 应该连续，形成完整的规划流程

## What

重构十步循环，采用 Phase + Step 语义化编号，并调整步骤顺序。

### 新的步骤结构

```
Phase A: 规划 (Planning)
  A.0  状态感知 (state-scanner) - 读取 UPM + 活跃 Spec，用户选择方向
  A.1  Spec管理 (spec-drafter) - 创建新 Spec 或选择已有 Spec
  A.2  任务规划 (task-planner) - 分解任务
  A.3  Agent分配 (task-planner) - 匹配 Agent

Phase B: 开发 (Development)
  B.1  分支创建 (branch-manager)
  B.2  执行验证 (各类执行 Skill)
  B.3  架构同步 (architecture-doc-updater)

Phase C: 集成 (Integration)
  C.1  Git提交 (commit-msg-generator)
  C.2  分支合并 (branch-manager)

Phase D: 收尾 (Closure)
  D.1  进度更新 (progress-updater)
  D.2  Spec归档 (openspec:archive)
```

### 主要变更

| 变更类型 | 内容 |
|---------|------|
| **MODIFIED** | Step 编号从 0-10 改为 Phase.Step 格式 (A.0, A.1, B.1...) |
| **MODIFIED** | 状态感知从 Step 1 移到 A.0 (成为第一步) |
| **MODIFIED** | Spec定义从 Step 0 移到 A.1 (紧跟状态感知) |
| **ADDED** | 创建 `state-scanner` Skill (重命名自 progress-query-assistant) |
| **MODIFIED** | state-scanner 增加活跃 Spec 列表功能 |

### Key Deliverables

- `standards/core/ten-step-cycle/README.md` - 更新步骤编号和顺序
- `standards/core/ten-step-cycle/phase-a-spec-planning.md` - 更新 Phase A 详情
- `.claude/skills/state-scanner/SKILL.md` - 新 Skill (基于 progress-query-assistant)
- `CLAUDE.md` - 更新相关引用

## Impact

| Type | Description |
|------|-------------|
| **Positive** | 流程更符合实际开发顺序；Spec 相关步骤连续便于理解 |
| **Positive** | Phase + Step 编号更清晰，便于记忆和引用 |
| **Risk** | 现有文档中的步骤引用需要更新；通过全局搜索替换缓解 |

## Tasks

- [ ] 更新 `ten-step-cycle/README.md` 使用新编号
- [ ] 更新 `phase-a-spec-planning.md` 反映新顺序
- [ ] 创建 `state-scanner` Skill
- [ ] 更新 CLAUDE.md 中的步骤引用
- [ ] 更新其他相关文档中的步骤引用

## Success Criteria

- [ ] 所有文档中的步骤编号统一使用 Phase.Step 格式
- [ ] state-scanner Skill 可正常执行状态感知功能
- [ ] 用户可通过 A.0 获取项目状态和活跃 Spec 列表
