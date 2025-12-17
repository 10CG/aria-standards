# Implementation Tasks: Phase A Integration

> **Spec**: changes/phase-a-integration/proposal.md
> **Generated**: 2025-12-18
> **Total Tasks**: 11
> **Estimated**: 14-20h (Option A: 6h, Option B: +8-14h)

---

## Phase 1: task-planner 增强

### TASK-001: 添加 tasks.md 检测逻辑
- **Description**: 在 task-planner 中添加检测 `changes/{feature}/tasks.md` 是否存在的逻辑
- **Complexity**: S (Small)
- **Estimated**: 1h
- **Dependencies**: None
- **Agent**: knowledge-manager
- **Deliverables**:
  - `.claude/skills/task-planner/SKILL.md` (更新 Step 2.1)
- **Acceptance Criteria**:
  - [ ] 能检测同目录下 tasks.md 是否存在
  - [ ] 检测结果用于决定后续解析策略

### TASK-002: 实现 tasks.md 解析器
- **Description**: 解析结构化 tasks.md 格式，提取任务列表、复杂度、依赖关系
- **Complexity**: M (Medium)
- **Estimated**: 2h
- **Dependencies**: TASK-001
- **Agent**: knowledge-manager
- **Deliverables**:
  - `.claude/skills/task-planner/SKILL.md` (更新解析逻辑章节)
- **Acceptance Criteria**:
  - [ ] 能解析 TASK-{ID} 格式
  - [ ] 能提取 Complexity, Dependencies, Agent 字段
  - [ ] 能处理 Markdown checkbox 格式

### TASK-003: 添加 fallback 逻辑
- **Description**: 当 tasks.md 不存在时，fallback 到从 proposal.md 分解任务
- **Complexity**: S (Small)
- **Estimated**: 1h
- **Dependencies**: TASK-002
- **Agent**: knowledge-manager
- **Deliverables**:
  - `.claude/skills/task-planner/SKILL.md` (更新执行流程)
- **Acceptance Criteria**:
  - [ ] 无 tasks.md 时自动切换到 proposal.md 解析
  - [ ] 日志输出当前使用的数据源

### TASK-004: 更新 SKILL.md 文档
- **Description**: 更新 task-planner 文档，说明新的 tasks.md 读取策略
- **Complexity**: S (Small)
- **Estimated**: 0.5h
- **Dependencies**: TASK-003
- **Agent**: knowledge-manager
- **Deliverables**:
  - `.claude/skills/task-planner/SKILL.md`
- **Acceptance Criteria**:
  - [ ] 文档包含 tasks.md 优先读取说明
  - [ ] 包含两种路径的流程图
  - [ ] 版本号更新到 1.1.0

---

## Phase 2: 模板和规范

### TASK-005: 创建 tasks.md 模板
- **Description**: 创建结构化 tasks.md 模板文件
- **Complexity**: S (Small)
- **Estimated**: 0.5h
- **Dependencies**: None
- **Agent**: knowledge-manager
- **Deliverables**:
  - `standards/openspec/templates/tasks.md`
- **Acceptance Criteria**:
  - [ ] 包含标准 TASK-{ID} 格式
  - [ ] 包含所有必需字段 (Description, Complexity, Dependencies, Agent, etc.)
  - [ ] 包含 Execution Order 和 Summary 章节

### TASK-006: 更新 templates/README.md
- **Description**: 更新模板目录的说明文档
- **Complexity**: S (Small)
- **Estimated**: 0.5h
- **Dependencies**: TASK-005
- **Agent**: knowledge-manager
- **Deliverables**:
  - `standards/openspec/templates/README.md`
- **Acceptance Criteria**:
  - [ ] 添加 tasks.md 模板说明
  - [ ] 更新 Level 3 Spec 的文件清单

### TASK-007: 更新 spec-drafter 模板生成
- **Description**: 让 spec-drafter 在 Level 3 时使用新的 tasks.md 模板格式
- **Complexity**: M (Medium)
- **Estimated**: 1.5h
- **Dependencies**: TASK-005
- **Agent**: knowledge-manager
- **Deliverables**:
  - `.claude/skills/spec-drafter/SKILL.md` (更新 Level 3 输出)
- **Acceptance Criteria**:
  - [ ] Level 3 生成的 tasks.md 符合新模板格式
  - [ ] 包含 TASK-{ID} 编号
  - [ ] 包含 Complexity 和 Agent 预估

### TASK-008: 更新十步循环文档 Step 3
- **Description**: 更新 README.md 中 Step 3 的描述，移除 (built-in) 标记
- **Complexity**: S (Small)
- **Estimated**: 0.5h
- **Dependencies**: TASK-004
- **Agent**: knowledge-manager
- **Deliverables**:
  - `standards/core/ten-step-cycle/README.md`
- **Acceptance Criteria**:
  - [ ] Step 3 Skill 列更新为 `task-planner` (Agent 预分配)
  - [ ] 覆盖率更新说明

---

## Phase 3: Orchestrator (Option B, 可选)

### TASK-009: 设计 phase-a-planner 工作流
- **Description**: 设计编排器的工作流程，定义各 Skill 的调用顺序和数据传递
- **Complexity**: M (Medium)
- **Estimated**: 2h
- **Dependencies**: TASK-004, TASK-007
- **Agent**: tech-lead
- **Deliverables**:
  - `.claude/skills/phase-a-planner/DESIGN.md`
- **Acceptance Criteria**:
  - [ ] 完整的工作流图
  - [ ] 各步骤的输入/输出定义
  - [ ] 错误处理策略

### TASK-010: 实现 phase-a-planner
- **Description**: 实现 Phase A 编排器 Skill
- **Complexity**: L (Large)
- **Estimated**: 6h
- **Dependencies**: TASK-009
- **Agent**: knowledge-manager
- **Deliverables**:
  - `.claude/skills/phase-a-planner/SKILL.md`
- **Acceptance Criteria**:
  - [ ] 能自动检测 Level (1/2/3)
  - [ ] 能按顺序调用 spec-drafter → progress-query-assistant → task-planner
  - [ ] 统一输出规划结果

### TASK-011: 端到端测试
- **Description**: 对 phase-a-planner 进行完整的端到端测试
- **Complexity**: M (Medium)
- **Estimated**: 2h
- **Dependencies**: TASK-010
- **Agent**: qa-engineer
- **Deliverables**:
  - 测试报告
- **Acceptance Criteria**:
  - [ ] Level 1 场景: 正确跳过 Spec
  - [ ] Level 2 场景: 生成 proposal.md + 任务列表
  - [ ] Level 3 场景: 生成 proposal.md + tasks.md + 完整规划

---

## Execution Order

```
┌─────────────────────────────────────────────────────────────┐
│                    PHASE 1 (并行开始)                        │
│  TASK-001 ──▶ TASK-002 ──▶ TASK-003 ──▶ TASK-004           │
│                                                             │
│                    PHASE 2 (并行)                           │
│  TASK-005 ──┬──▶ TASK-006                                  │
│             └──▶ TASK-007                                  │
│                                                             │
│  TASK-008 (依赖 TASK-004)                                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│               PHASE 3 (Option B, 依赖 Phase 1+2)            │
│  TASK-009 ──▶ TASK-010 ──▶ TASK-011                        │
└─────────────────────────────────────────────────────────────┘
```

**并行分组**:

| Group | Tasks | Can Start After |
|-------|-------|-----------------|
| 1 | TASK-001, TASK-005 | - |
| 2 | TASK-002, TASK-006, TASK-007 | Group 1 |
| 3 | TASK-003 | TASK-002 |
| 4 | TASK-004, TASK-008 | TASK-003 |
| 5 | TASK-009 | Group 4 (Option B) |
| 6 | TASK-010 | TASK-009 (Option B) |
| 7 | TASK-011 | TASK-010 (Option B) |

---

## Summary

| Complexity | Count | Hours |
|------------|-------|-------|
| S (Small) | 6 | 4h |
| M (Medium) | 4 | 7.5h |
| L (Large) | 1 | 6h |
| **Option A Total** | **8** | **6.5h** |
| **Option B Total** | **11** | **17.5h** |

---

## Notes

- Option A (TASK-001 到 TASK-008) 可以独立交付，快速见效
- Option B 需要 Option A 完成后才能开始
- 建议先完成 Option A，验证效果后再决定是否实施 Option B
