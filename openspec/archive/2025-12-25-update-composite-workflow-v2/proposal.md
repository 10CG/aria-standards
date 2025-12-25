# Update Composite Workflow Spec to v2.0

> **Level**: 1 (Simple)
> **Status**: Draft
> **Module**: standards
> **Created**: 2025-12-25

## Why

`composite-workflow` spec 在归档时基于 v1.0 设计创建，但实际 skills 已升级到 v2.0 Phase-Based 架构。当前 spec 存在以下问题：

| 问题 | Spec 描述 | 实际实现 |
|------|----------|---------|
| 执行单元 | 步骤 `[B.1, B.2, C.1]` | Phase `[B, C]` |
| 跳过逻辑 | workflow-runner 集中管理 | 委托给各 Phase Skill |
| 架构模型 | 10 步骤模型 | 4 Phase 模型 |
| 上下文传递 | 隐式传递 | `context_for_next` 自动传递 |

这导致 spec 无法准确反映当前系统行为，违反了 Single Source of Truth 原则。

## What Changes

### MODIFIED: composite-workflow spec

更新所有 5 个 Requirements 以匹配 v2.0 架构：

1. **Workflow Definition** - 从步骤定义改为 Phase 定义
2. **Sequential Execution** - 从步骤执行改为 Phase 执行
3. **Automatic Step Skip** - 职责从 workflow-runner 改为 Phase Skills
4. **Context Preservation** - 添加 `context_for_next` 机制
5. **Rollback Support** - 从步骤回滚改为 Phase 回滚

### ADDED: Purpose 描述

补充 spec 的 Purpose 部分（当前为 TBD）。

## Impact

### Positive
- Spec 与实现一致，恢复 Single Source of Truth
- 开发者可依赖 spec 理解系统行为
- 为后续 skills 迭代提供准确基准

### Risk
- 无风险，仅文档更新

## Success Criteria

- [ ] spec 描述与 workflow-runner v2.0 SKILL.md 一致
- [ ] 所有 Scenarios 反映 Phase-Based 执行模型
- [ ] openspec validate 通过
