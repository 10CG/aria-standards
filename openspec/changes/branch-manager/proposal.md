# Branch Manager Skill

> **Level**: Minimal (Level 2 Spec)
> **Status**: Implemented (Retrospective)
> **Created**: 2025-12-16

## Why

十步循环中的 Step 4 (分支创建) 和 Step 8 (分支合并/PR) 需要标准化的操作流程：
- 确保分支命名规范一致
- 简化子模块内的分支管理
- 集成 Forgejo API 进行 PR 创建

## What

创建 `branch-manager` Skill，提供 Git 分支生命周期管理能力。

### Key Deliverables
- SKILL.md: 完整的 skill 规范文档
- SUBMODULE_WORKFLOW.md: 子模块分支工作流指南
- CHANGELOG.md: 版本变更记录

## Impact

| Type | Description |
|------|-------------|
| **Positive** | 统一分支管理流程，减少人为错误，支持主仓库和子模块操作 |
| **Risk** | 需要正确配置 Forgejo API 环境变量；风险低，有回滚指南 |

## Tasks

- [x] 设计分支命名规范 (feature/bugfix/hotfix/release/experiment)
- [x] 创建 SKILL.md 定义 Step 4 和 Step 8 操作流程
- [x] 创建 SUBMODULE_WORKFLOW.md 文档子模块场景
- [x] 更新 CLAUDE.md 注册新 skill
- [x] 更新 ten-step-cycle README 反映 skill 覆盖率

## Success Criteria

- [x] 分支创建流程清晰可执行 (Step 4)
- [x] PR 创建流程集成 Forgejo API (Step 8)
- [x] 子模块工作流有完整文档
- [x] Skill 已注册到 CLAUDE.md

## Implementation Notes

**已创建文件**:
- `.claude/skills/branch-manager/SKILL.md`
- `.claude/skills/branch-manager/SUBMODULE_WORKFLOW.md`
- `.claude/skills/branch-manager/CHANGELOG.md`

**Skill 覆盖率**:
- Step 4 (分支创建): 90%
- Step 8 (分支合并/PR): 90%

## Lessons Learned

此 Spec 为**回溯性创建**，在 skill 开发完成后补充。
未来新 Skill 创建应先执行 Phase A (Step 0-3)，再进入 Phase B (Step 4-6)。

参考: [CLAUDE.md - Phase A 检查点](../../../../CLAUDE.md)
