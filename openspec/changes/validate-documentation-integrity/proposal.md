# Proposal: Validate Documentation Integrity

> **Change ID**: validate-documentation-integrity
> **Status**: Implemented
> **Created**: 2025-12-27
> **Updated**: 2025-12-27
> **Author**: AI Assistant

## Summary

创建一个 LLM-Powered Skill (`doc-integrity-validator`)，用于验证 Skills、Agents、Commands 等可移植组件的运行时上下文完整性，确保 @ 引用路径有效且符合架构层级规则。

## Problem Statement

当前项目存在以下问题：

1. **运行时上下文风险**: Skills/Agents 在 Claude Code 环境中加载时，@ 引用会被解析为文件内容。如果引用路径失效，组件将静默失败或行为异常。

2. **架构层级违规**: 可移植组件（Skills/Agents/Commands）应只引用通用级资源（`@.claude/*`, `@standards/*`），但可能错误引用项目级资源（`@docs/*`），导致跨项目复用时失效。

3. **语义一致性缺失**: 引用的文档内容可能与组件的实际用途不匹配，但无法通过简单的路径检查发现。

4. **手动检查低效**: 每次优化通用配置后，需要手动验证所有引用的有效性。

## Proposed Solution

### 核心理念

```
┌─────────────────────────────────────────────────────────────┐
│                   Claude Code 运行时环境                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────┐    @ 引用解析    ┌──────────────────┐  │
│  │ Skills/Agents   │ ──────────────→  │ 文件内容加载      │  │
│  │ (可移植组件)     │                  │ (运行时上下文)    │  │
│  └─────────────────┘                  └──────────────────┘  │
│                                                             │
│  验证维度:                                                   │
│  ① 路径有效性 - @ 引用指向存在的文件                          │
│  ② 层级合规性 - 可移植组件只引用通用级资源                     │
│  ③ 语义完整性 - 引用内容与组件用途相关 (LLM)                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 架构层级规则

| 资源路径 | 层级 | 可被引用方 |
|---------|------|-----------|
| `@.claude/*` | 通用级 | Skills, Agents, Commands, 项目文档 |
| `@standards/*` | 通用级 | Skills, Agents, Commands, 项目文档 |
| `@docs/*` | 项目级 | 仅项目文档 (不可被 Skills/Agents 引用) |

### 验证目标

| 检查维度 | 说明 | 实现方式 |
|---------|------|---------|
| 路径有效性 | @ 引用指向存在的文件 | 文件系统检查 |
| 层级合规性 | Skills/Agents 不引用 @docs/* | 正则 + 规则引擎 |
| 语义完整性 | 引用内容与组件用途相关 | LLM 分析 |

### 工作流程

```yaml
使用场景: 优化项目通用配置后的验证 (非 CI/pre-commit)

流程:
  1. 检测 (Detection)
     → 扫描 .claude/agents/*, .claude/skills/*, .claude/commands/*
     → 提取所有 @ 引用
     → 执行三维验证

  2. 报告 (Report)
     → 分类展示问题: 错误 / 警告 / 建议
     → 提供修复建议

  3. 交互确认 (Confirmation)
     → 用户审查建议
     → 选择接受/修改/跳过

  4. 自动修复 (Auto-fix)
     → 执行用户确认的修复
     → 更新文件
     → 生成变更摘要
```

## Success Criteria

1. **路径完整性**: 所有 @ 引用指向存在的文件
2. **层级合规性**: Skills/Agents 不引用项目级资源 (@docs/*)
3. **语义一致性**: 引用内容与组件用途相关
4. **可重复执行**: Skill 可在任意时间点运行
5. **交互友好**: 提供清晰的问题报告和修复建议
6. **确认后修复**: 用户确认后才执行自动修复

## Out of Scope

- CI/CD 集成 (本 Skill 用于手动验证)
- 外部 URL 可达性检查
- 代码逻辑验证
- 多语言翻译一致性

## Risks and Mitigations

| 风险 | 缓解措施 |
|------|---------|
| LLM 调用成本 | 仅在语义验证时使用 LLM，路径/层级检查使用规则引擎 |
| 误报过多 | 提供忽略规则配置 (.doc-validator-ignore) |
| 自动修复破坏 | 必须用户确认后才执行修复，生成变更摘要供回滚 |
| 路径格式差异 | 统一处理 Windows/Linux 路径格式 |

## Related Documents

- [STANDARDS_CLEANUP_CHANGE_PLAN.md](../../../docs/analysis/STANDARDS_CLEANUP_CHANGE_PLAN.md)
- [SUBAGENTS_STANDARDS_INTEGRATION_ANALYSIS.md](../../../docs/analysis/SUBAGENTS_STANDARDS_INTEGRATION_ANALYSIS.md)
- [OpenSpec VALIDATION.md](../../VALIDATION.md)

## Approval

- [ ] Tech Lead Review
- [ ] Knowledge Manager Review
