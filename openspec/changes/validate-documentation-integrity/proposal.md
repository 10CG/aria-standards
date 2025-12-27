# Proposal: Validate Documentation Integrity

> **Change ID**: validate-documentation-integrity
> **Status**: Draft
> **Created**: 2025-12-27
> **Author**: AI Assistant

## Summary

创建一个可重复执行的文档有效性验证系统，用于检查项目中 subagents、skills、standards 规范文档的完整性和引用有效性。

## Problem Statement

当前项目存在以下问题：

1. **引用失效**: 文档中的 `@` 路径引用可能指向不存在的文件
2. **格式不一致**: agents/skills/standards 文档缺乏统一的结构验证
3. **手动检查低效**: 每次变更后需要手动检查文档一致性
4. **无法自动化**: 没有可重复执行的验证机制

## Proposed Solution

### 验证系统架构

```
doc-validator/
├── validate-agents.sh      # 验证 .claude/agents/*.md
├── validate-skills.sh      # 验证 .claude/skills/*/SKILL.md
├── validate-standards.sh   # 验证 standards/**/*.md
├── validate-references.sh  # 验证所有 @ 引用路径
└── validate-all.sh         # 综合验证入口
```

### 检查项目

#### 1. Agents 验证 (.claude/agents/*.md)

| 检查项 | 说明 |
|--------|------|
| 文件存在性 | 验证所有引用的文件路径存在 |
| 必需字段 | 检查 name, description 等必需字段 |
| 格式规范 | 验证 Markdown 结构符合规范 |

#### 2. Skills 验证 (.claude/skills/*/SKILL.md)

| 检查项 | 说明 |
|--------|------|
| SKILL.md 存在 | 每个 skill 目录必须有 SKILL.md |
| Frontmatter | 验证 YAML frontmatter 完整性 |
| @ 引用有效 | 验证所有 `@path/to/file` 引用存在 |
| 相关文档 | 验证 EXAMPLES.md, TEMPLATES.md 等关联文件 |

#### 3. Standards 验证 (standards/**/*.md)

| 检查项 | 说明 |
|--------|------|
| 相对路径 | 验证内部相对路径引用有效 |
| 交叉引用 | 检查文档间的交叉引用一致性 |
| 版本信息 | 验证版本号格式规范 |

#### 4. 全局引用验证

| 检查项 | 说明 |
|--------|------|
| `@` 路径 | 验证所有 `@docs/`, `@standards/` 等引用 |
| 外部链接 | 可选检查外部 URL 有效性 |
| 循环引用 | 检测文档间的循环依赖 |

## Success Criteria

1. **零失效引用**: 所有 `@` 路径引用指向存在的文件
2. **结构完整**: 所有文档包含必需的元数据和章节
3. **可重复执行**: 验证脚本可在任意时间点运行
4. **CI/CD 集成**: 支持在提交前自动验证
5. **清晰报告**: 输出人类可读的验证报告

## Out of Scope

- 内容语义验证（如描述是否准确）
- 代码逻辑验证
- 多语言翻译一致性
- 外部 URL 可达性检查（可选功能）

## Risks and Mitigations

| 风险 | 缓解措施 |
|------|---------|
| 误报过多 | 提供忽略规则配置 |
| 性能问题 | 增量验证模式 |
| 路径兼容性 | 支持 Windows/Linux 路径格式 |

## Related Documents

- [STANDARDS_CLEANUP_CHANGE_PLAN.md](../../../docs/analysis/STANDARDS_CLEANUP_CHANGE_PLAN.md)
- [SUBAGENTS_STANDARDS_INTEGRATION_ANALYSIS.md](../../../docs/analysis/SUBAGENTS_STANDARDS_INTEGRATION_ANALYSIS.md)
- [OpenSpec VALIDATION.md](../../VALIDATION.md)

## Approval

- [ ] Tech Lead Review
- [ ] Knowledge Manager Review
