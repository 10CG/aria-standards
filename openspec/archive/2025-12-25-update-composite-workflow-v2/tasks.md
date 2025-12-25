# Tasks: Update Composite Workflow Spec to v2.0

## Phase 1: Spec 更新

- [x] 1.1 更新 Purpose 部分
- [x] 1.2 更新 Requirement: Workflow Definition (Phase 定义)
- [x] 1.3 更新 Requirement: Sequential Execution (Phase 执行)
- [x] 1.4 更新 Requirement: Automatic Step Skip (委托机制)
- [x] 1.5 更新 Requirement: Context Preservation (context_for_next)
- [x] 1.6 更新 Requirement: Rollback Support (Phase 回滚)

## Phase 2: 验证

- [x] 2.1 运行 openspec validate 确认格式正确
- [x] 2.2 对比 workflow-runner SKILL.md 确认一致性

## Dependencies

```
1.1 ──▶ 1.2 ──▶ 1.3 ──▶ 1.4 ──▶ 1.5 ──▶ 1.6
                                        │
                                        ▼
                                  2.1 ──▶ 2.2
```

## Completion Summary

- **完成时间**: 2025-12-25
- **变更内容**:
  - 更新 Purpose 描述
  - 5 个 Requirements 全部更新为 v2.0 Phase-Based 架构
  - 新增 3 个 Scenarios (Custom step combination, Context merge strategy, Partial Phase rollback)
- **验证结果**: openspec validate --specs 通过 (4 specs, 0 failed)
