# Tasks: Refactor Workflow Architecture

## Phase 1: state-scanner v2.0 升级

- [x] 1.1 设计推荐规则 YAML 格式
- [x] 1.2 实现状态收集模块增强
- [x] 1.3 实现推荐决策引擎
- [x] 1.4 实现推荐理由生成
- [x] 1.5 设计交互输出格式
- [x] 1.6 更新 SKILL.md 文档

## Phase 2: Phase Skills 创建

- [x] 2.1 创建 phase-a-planner Skill
  - [x] 2.1.1 定义 SKILL.md
  - [x] 2.1.2 实现 A.1-A.3 步骤编排
  - [x] 2.1.3 实现跳过规则
  - [x] 2.1.4 定义上下文输出

- [x] 2.2 创建 phase-b-developer Skill
  - [x] 2.2.1 定义 SKILL.md
  - [x] 2.2.2 实现 B.1-B.3 步骤编排
  - [x] 2.2.3 实现跳过规则
  - [x] 2.2.4 定义上下文输出

- [x] 2.3 创建 phase-c-integrator Skill
  - [x] 2.3.1 定义 SKILL.md
  - [x] 2.3.2 实现 C.1-C.2 步骤编排
  - [x] 2.3.3 实现跳过规则
  - [x] 2.3.4 定义上下文输出

- [x] 2.4 创建 phase-d-closer Skill
  - [x] 2.4.1 定义 SKILL.md
  - [x] 2.4.2 实现 D.1-D.2 步骤编排
  - [x] 2.4.3 实现跳过规则
  - [x] 2.4.4 定义上下文输出

## Phase 3: workflow-runner v2.0 重构

- [x] 3.1 重构 SKILL.md 为轻量编排器
- [x] 3.2 更新 WORKFLOWS.md 使用 Phase 引用
- [x] 3.3 实现自定义组合语法解析
- [x] 3.4 实现上下文传递机制
- [x] 3.5 移除 SKIP_RULES.md (移至各 Phase Skill)

## Phase 4: 集成与测试

- [x] 4.1 验证 state-scanner → workflow-runner 集成
- [x] 4.2 验证 Phase Skills 链式调用
- [x] 4.3 验证上下文传递完整性
- [x] 4.4 测试预置工作流兼容性
- [x] 4.5 测试自定义组合功能

## Phase 5: 文档更新

- [x] 5.1 更新 .claude/skills/README.md
- [x] 5.2 更新 standards/core/ten-step-cycle/README.md
- [x] 5.3 创建迁移指南 MIGRATION.md

## Dependencies

```
Phase 1 (state-scanner)
    │
    ▼
Phase 2 (Phase Skills) ←── 可并行开发 4 个 Phase Skills
    │
    ▼
Phase 3 (workflow-runner) ←── 依赖 Phase Skills 完成
    │
    ▼
Phase 4 (集成测试)
    │
    ▼
Phase 5 (文档)
```

## Estimated Effort

| Phase | 预计工作量 | 优先级 | 状态 |
|-------|-----------|--------|------|
| Phase 1 | 中等 | P0 | ✅ 完成 |
| Phase 2 | 较大 (4个Skill) | P0 | ✅ 完成 |
| Phase 3 | 中等 | P1 | ✅ 完成 |
| Phase 4 | 较小 | P1 | ✅ 完成 |
| Phase 5 | 较小 | P2 | ✅ 完成 |

## Verification Checklist

- [x] state-scanner 能正确识别项目状态
- [x] 推荐逻辑覆盖主要场景
- [x] 各 Phase Skill 可独立调用
- [x] workflow-runner 正确编排 Phase Skills
- [x] 上下文在 Phase 间正确传递
- [x] 现有预置工作流行为不变
- [x] 文档完整且准确

## Completion Summary

**完成时间**: 2025-12-25

**交付物**:
- state-scanner v2.0 (SKILL.md + RECOMMENDATION_RULES.md)
- 4 个 Phase Skills (phase-a-planner, phase-b-developer, phase-c-integrator, phase-d-closer)
- workflow-runner v2.0 (SKILL.md + WORKFLOWS.md + MIGRATION.md)
- 更新的文档 (.claude/skills/README.md, standards/core/ten-step-cycle/README.md)
