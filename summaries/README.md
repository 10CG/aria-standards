# Standards Summaries

> **版本**: 2.0.0 | **更新**: 2025-12-23
>
> L0 摘要层文件，用于优化 AI 上下文加载。
> Token 优化效果: ~70,000 → ~3,500 tokens (**-95%**)

## 摘要文件列表

| 摘要文件 | 源文件 | 用途 |
|---------|--------|------|
| [ten-step-cycle-summary.md](./ten-step-cycle-summary.md) | `core/ten-step-cycle/` | 十步循环开发模型 |
| [workflow-summary.md](./workflow-summary.md) | `core/workflow/*.md` | 工作流和同步机制 |
| [conventions-summary.md](./conventions-summary.md) | `conventions/*.md` | Git、命名、内容规范 |
| [extensions-summary.md](./extensions-summary.md) | `extensions/*.md` | Mobile/Backend 扩展 |
| [upm-summary.md](./upm-summary.md) | `core/upm/`, `core/state-management/` | 统一进度管理 |

## 迁移指南

新用户或从 @ 引用模式迁移？请阅读:
- [MIGRATION.md](./MIGRATION.md) - 完整迁移指南

## 使用方式

CLAUDE.md 引用这些摘要文件作为 L0 上下文加载层。
需要详细规范时，直接阅读源文件 (L2 层)。

## 维护规则

- 源文件重大变更时更新对应摘要
- 每个摘要保持 100 行以内
- 确保摘要反映源文件的核心内容
