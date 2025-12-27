# Proposal: Architecture Documentation Separation

> **Change ID**: architecture-docs-separation
> **Status**: Draft
> **Created**: 2025-12-27
> **Author**: AI Assistant

## Summary

将 `docs/project-standards/` 下的架构文档管理系统（1主文档 + 8子文档）中的通用规则提取到 `@standards/core/architecture/`，项目级文档只保留项目特定配置。

## Problem Statement

当前 `docs/project-standards/architecture-documentation-management-system.md` 及其8个子文档存在以下问题：

1. **通用与项目混合**: 通用方法论（L0/L1/L2、模板格式、验证体系）与项目配置（脚本路径、端划分）混在一起

2. **无法跨项目复用**: Skills 引用这些文档时违反层级规则（`@docs/*` 是项目级）

3. **维护困难**: 修改通用规则需要同时考虑项目配置，增加维护成本

4. **已有部分迁移**: `@standards/core/architecture/` 已创建了初步的方法论文档，但未完成完整拆分

## Current State

### 文档清单 (9个文件)

```
docs/project-standards/
├── architecture-documentation-management-system.md  (主文档)
├── architecture-doc-index.md         (索引规范)
├── architecture-doc-templates.md     (模板集)
├── architecture-doc-operations.md    (操作指南)
├── architecture-doc-validation.md    (验证标准)
├── architecture-doc-tools.md         (工具集)
├── architecture-doc-version-control.md (版本管理)
├── architecture-doc-examples.md      (示例)
└── architecture-doc-quick-ref.md     (快速参考)
```

### 已迁移部分

```
standards/core/architecture/
├── README.md              (入口)
├── layering-system.md     (L0/L1/L2 - 初步版本)
├── document-templates.md  (模板 - 初步版本)
└── validation-levels.md   (验证 - 初步版本)
```

## Proposed Solution

### 目标架构

```
┌─────────────────────────────────────────────────────────────────┐
│              @standards/core/architecture/                       │
│              (通用方法论 - 可跨项目复用)                          │
│                                                                 │
│  ├── README.md                    入口导航                       │
│  ├── layering-system.md           L0/L1/L2 层级体系              │
│  ├── document-templates.md        文档模板规范                   │
│  ├── validation-levels.md         三级验证体系                   │
│  ├── naming-conventions.md        命名规范 (NEW)                 │
│  ├── lifecycle-management.md      生命周期管理 (NEW)             │
│  └── ai-integration-guide.md      AI 使用指南 (NEW)              │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼ 引用
┌─────────────────────────────────────────────────────────────────┐
│              docs/project-standards/                             │
│              (项目配置 - 本项目特定)                              │
│                                                                 │
│  ├── architecture-project-config.md     项目配置主文档           │
│  │   ├── 端划分 (mobile/backend/frontend)                       │
│  │   ├── 脚本路径                                               │
│  │   └── CI/CD 配置                                             │
│  ├── architecture-project-tools.md      项目工具配置             │
│  └── architecture-project-examples.md   项目示例                 │
└─────────────────────────────────────────────────────────────────┘
```

### 内容拆分规则

| 内容类型 | 目标位置 | 示例 |
|---------|---------|------|
| **通用方法论** | @standards | L0/L1/L2 定义、模板格式、验证概念 |
| **通用规范** | @standards | 命名规范、版本格式、时间格式 |
| **项目配置** | @docs | 端划分、脚本路径、CI/CD |
| **项目示例** | @docs | 具体目录结构、实际文件示例 |

### 各文档拆分计划

| 原文档 | 通用部分 → @standards | 项目部分 → @docs |
|--------|----------------------|------------------|
| 主文档 | 核心原则、决策流程 | 端划分、性能指标、脚本路径 |
| index | 索引格式规范 | 具体端的索引路径 |
| templates | 模板格式定义 | 项目特定模板示例 |
| operations | 操作流程通用步骤 | 项目脚本调用 |
| validation | 三级验证概念 | 项目验证脚本 |
| tools | 工具概念和接口 | 具体脚本实现 |
| version-control | 版本管理规范 | 项目版本策略 |
| examples | 通用示例模板 | 项目具体示例 |
| quick-ref | 通用速查 | 项目速查 |

## Success Criteria

1. **完全分离**: 通用规则在 @standards，项目配置在 @docs
2. **无重复**: 每条规则只在一处定义
3. **正确引用**: @docs 引用 @standards 的通用规则
4. **Skills 合规**: arch-common 只引用 @standards 和 @.claude
5. **可复用**: @standards/core/architecture 可直接用于其他项目

## Out of Scope

- 现有 arch-* Skills 的重构（保持引用 arch-common）
- 自动化迁移脚本开发
- 其他项目的迁移

## Risks and Mitigations

| 风险 | 缓解措施 |
|------|---------|
| 拆分边界不清晰 | 每个文档逐一分析，明确标注 |
| 引用关系断裂 | 更新所有引用，运行 doc-integrity-validator |
| 信息丢失 | 保留原文档备份，确保内容完整迁移 |

## Related Documents

- [validate-documentation-integrity](../validate-documentation-integrity/proposal.md)
- [STANDARDS_CLEANUP_CHANGE_PLAN.md](../../../docs/analysis/STANDARDS_CLEANUP_CHANGE_PLAN.md)

## Approval

- [ ] Tech Lead Review
- [ ] Knowledge Manager Review
