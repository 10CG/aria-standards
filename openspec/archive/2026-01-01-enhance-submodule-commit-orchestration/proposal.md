# Proposal: Enhance Submodule Commit Orchestration

> **Change ID**: enhance-submodule-commit-orchestration
> **Status**: draft
> **Created**: 2026-01-01
> **Author**: Claude Code

---

## Summary

扩展 `strategic-commit-orchestrator` Skill，新增类型E（全项目变更），支持自动检测并编排主项目与所有子模块的分组提交。

## Motivation

### 问题描述

当前 `strategic-commit-orchestrator` 存在以下局限：

1. **手动切换**: 需要手动在主项目和子模块间切换执行提交
2. **流程割裂**: 主项目提交和子模块提交是独立的两个工作流
3. **引用遗漏**: 容易忘记更新子模块引用
4. **效率低下**: 大型变更需要多次调用 skill

### 真实案例

`evolve-ai-ddd-system` OpenSpec 变更中：
- 主项目: 5个提交分组
- standards 子模块: 6个提交分组
- 需要手动执行两次 skill，再手动更新子模块引用

### 期望效果

一次调用 skill，自动完成：
1. 扫描所有有变更的子模块
2. 对每个子模块执行分组提交
3. 对主项目执行分组提交
4. 自动更新子模块引用

## Design

### 新增变更类型E

```yaml
类型E: 全项目变更 (Full-Project Change)
  特征:
    - 主项目有变更
    - 至少一个子模块有变更

  识别条件:
    - git status 显示 submodule modified/untracked
    - git submodule foreach 检测到子模块内变更
```

### 工作流程

```
┌─────────────────────────────────────────────────────────┐
│  Phase 0: 全项目状态扫描                                 │
│  - 扫描主项目变更                                        │
│  - 扫描所有子模块变更                                    │
│  - 生成变更地图 (change_map)                             │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│  Phase 1-6: 子模块分组提交 (循环)                        │
│  FOR each submodule in change_map.submodules:           │
│    - 执行标准分组提交流程                                │
│    - 记录 commit hash                                   │
│  END FOR                                                │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│  Phase 7: 主项目分组提交                                 │
│  - 执行主项目文件分组提交                                │
│  - 更新子模块引用                                        │
│  - 创建引用更新提交                                      │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│  Phase 8: 验证与汇总                                     │
│  - 验证所有提交                                          │
│  - 输出提交汇总                                          │
└─────────────────────────────────────────────────────────┘
```

### 子模块扫描策略

```bash
# Phase 0.1: 获取所有子模块
git submodule status

# Phase 0.2: 检测每个子模块变更
git submodule foreach --quiet '
  changes=$(git status --short | wc -l)
  if [ "$changes" -gt 0 ]; then
    echo "$name:$changes"
  fi
'

# Phase 0.3: 构建变更地图
change_map:
  main_project:
    has_changes: true
    files: [...]
  submodules:
    standards:
      has_changes: true
      files: [...]
      commit_hash: null  # 提交后填充
    mobile:
      has_changes: false
    backend:
      has_changes: false
```

### 执行策略

```yaml
执行顺序:
  1. 子模块提交 (可配置并行/串行)
     - 默认: 串行 (安全)
     - 可选: 并行 (不同子模块独立时)

  2. 主项目提交
     - 必须在子模块之后
     - 包含子模块引用更新

并行策略:
  submodule_parallel: false  # 默认串行
  main_after_all: true       # 主项目最后
```

### 提交消息增强

```markdown
chore(submodule): 更新子模块引用 / Update submodule references

更新以下子模块引用:
- standards: abc1234 → def5678 (6 commits)

🤖 Executed-By: knowledge-manager subagent
📋 Context: Phase8-Cycle1 enhance-submodule-commit-orchestration
🔗 Module: main
🔗 Submodules: standards@def5678
```

## Scope

### In Scope

1. 新增类型E变更识别逻辑
2. 新增 Phase 0 子模块扫描
3. 新增 WORKFLOW_TYPE_E.md 文档
4. 更新 CHANGE_TYPES.md 添加类型E
5. 更新 SKILL.md 入口文档
6. 新增 SUBMODULE_GUIDE.md 子模块处理指南

### Out of Scope

1. 子模块内部的复杂冲突解决
2. 跨子模块的依赖检测
3. 子模块嵌套支持 (submodule of submodule)

## Tasks

见 [tasks.md](./tasks.md)

## Risks

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| 子模块提交失败 | 中 | 提供回滚指南，不自动回滚 |
| 并行提交冲突 | 低 | 默认串行执行 |
| 子模块引用不一致 | 中 | 提交前验证子模块状态 |

## Success Criteria

1. 一次 skill 调用完成主项目+子模块的所有提交
2. 自动检测有变更的子模块
3. 自动更新子模块引用
4. 提供清晰的提交汇总报告
