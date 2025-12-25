# Tasks: Add Composite Skills

## Phase 1: 核心框架

- [x] 1.1 创建 workflow-runner Skill 基础结构
- [x] 1.2 实现工作流定义解析器
- [x] 1.3 实现步骤执行引擎

## Phase 2: 预置工作流

- [x] 2.1 实现 quick-fix 工作流 (B.1 → B.2 → C.1)
- [x] 2.2 实现 feature-dev 工作流 (A.2 → ... → C.1)
- [x] 2.3 实现 doc-update 工作流 (B.3 → C.1)
- [x] 2.4 实现 full-cycle 工作流 (完整十步)

## Phase 3: 智能跳过

- [x] 3.1 实现 Level 判断规则 (跳过 A.1)
- [x] 3.2 实现架构变更检测 (跳过 B.3)
- [x] 3.3 实现单文件检测 (简化 B.1)

## Phase 4: 上下文传递

- [x] 4.1 实现 Phase/Cycle 上下文读取
- [x] 4.2 实现变更文件列表传递
- [x] 4.3 实现步骤结果缓存

## Phase 5: 错误处理

- [x] 5.1 实现步骤失败检测
- [x] 5.2 实现回滚机制
- [x] 5.3 实现断点续执

## Phase 6: 文档

- [x] 6.1 创建 WORKFLOWS.md 文档
- [x] 6.2 创建 SKIP_RULES.md 文档
- [x] 6.3 更新 Skills README

## Dependencies

```
1.1 ──▶ 1.2 ──▶ 1.3
              │
              ▼
        ┌─────┴─────┐
        │           │
  2.1-2.4 (可并行)  3.1-3.3 (可并行)
        │           │
        └─────┬─────┘
              ▼
        4.1 ──▶ 4.2 ──▶ 4.3
                        │
                        ▼
              5.1 ──▶ 5.2 ──▶ 5.3
                              │
                              ▼
                        6.1-6.3 (可并行)
```

## Completion Summary

- **完成时间**: 2025-12-24
- **产出物**:
  - `.claude/skills/workflow-runner/SKILL.md` - 核心 Skill 定义
  - `.claude/skills/workflow-runner/WORKFLOWS.md` - 工作流详细定义
  - `.claude/skills/workflow-runner/SKIP_RULES.md` - 智能跳过规则
  - `.claude/skills/README.md` - 新增 Skill 说明 (v1.5.0)
