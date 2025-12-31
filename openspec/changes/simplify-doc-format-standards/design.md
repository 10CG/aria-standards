# Design: Unify Documentation Format Standards

> **Change**: simplify-doc-format-standards
> **Created**: 2025-12-29

## Problem Statement

1. **规范分散**: 文档格式规范分布在 `docs/project-standards/` 和 `standards/` 两处
2. **缺乏体系**: 没有完整梳理项目所需的全部文档类型
3. **过度设计**: 部分规范过于复杂（如精确到秒的时间戳）
4. **查漏补缺**: 可能有文档类型缺少对应规范

---

## Document Type Framework

### 完整项目生命周期 vs 十步循环

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    完整项目生命周期 (SDLC)                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌────────┐│
│  │ 需求分析  │ → │ 系统设计  │ → │ 开发实现  │ → │ 测试验收  │ → │ 运维部署││
│  └──────────┘   └──────────┘   └──────────┘   └──────────┘   └────────┘│
│       ↑                             │                                   │
│       │                             ↓                                   │
│       │                    ┌─────────────────┐                          │
│       │                    │  十步循环覆盖范围  │                          │
│       │                    │  (AI-DDD执行层)   │                          │
│       │                    └─────────────────┘                          │
│       │                                                                 │
│       └──────────────── 变更/迭代 ──────────────────────────────────────│
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

**关键认识**: 十步循环主要覆盖"开发实现"阶段的 AI 辅助工作流，不能替代完整的 SDLC 文档体系。

### 分类维度

```
文档类型分类:
├── 按 SDLC 阶段
│   ├── 1. 需求分析 (Requirements)
│   ├── 2. 系统设计 (Design)
│   ├── 3. 开发实现 (Implementation) ← 十步循环主要覆盖
│   ├── 4. 测试验收 (Testing)
│   ├── 5. 运维部署 (Operations)
│   └── 6. 项目管理 (Management)
│
├── 按通用性
│   ├── 通用规范 → 放入 standards/
│   └── 项目特定 → 放入项目 docs/
│
└── 按验证方式
    ├── Skill 动态验证
    ├── 人工检查
    └── 无需验证
```

### Document Type Matrix (按 SDLC 阶段)

#### 1. 需求分析阶段 (Requirements)

| 文档类型 | 英文名 | 用途 | 格式规范 | 适用场景 |
|----------|--------|------|----------|----------|
| 产品需求文档 | PRD | 定义产品功能和用户需求 | ❓ 待确认 | 大型项目/产品 |
| 商业需求文档 | BRD | 定义商业目标和价值 | ❓ 待确认 | 企业级项目 |
| 用户故事 | User Story | 从用户角度描述功能 | ❓ 待确认 | 敏捷开发 |
| 需求规格说明 | SRS | 详细的功能需求规格 | ❓ 待确认 | 瀑布/V模型 |
| 用例文档 | Use Case | 系统与用户的交互场景 | ❓ 待确认 | UML 驱动 |

#### 2. 系统设计阶段 (Design)

| 文档类型 | 英文名 | 用途 | 格式规范 | 适用场景 |
|----------|--------|------|----------|----------|
| 概要设计 | HLD | 系统架构和模块划分 | ❓ 待确认 | 大型系统 |
| 详细设计 | LLD | 模块内部实现细节 | ❓ 待确认 | 复杂模块 |
| 数据库设计 | DB Design | 数据模型和表结构 | ❓ 待确认 | 有数据库的项目 |
| API 设计 | API Design | 接口规范定义 | ✅ OpenAPI | 前后端分离 |
| UI/UX 设计 | UI/UX Spec | 界面和交互设计 | ❓ 待确认 | 有 UI 的项目 |

#### 3. 开发实现阶段 (Implementation) ← 十步循环覆盖

| 文档类型 | 英文名 | 用途 | 格式规范 | 验证方式 |
|----------|--------|------|----------|----------|
| OpenSpec Proposal | - | 功能变更提案 | ✅ `openspec/templates/` | Skill |
| OpenSpec Tasks | - | 任务分解 | ✅ `openspec/templates/` | Skill |
| OpenSpec Design | - | 设计决策 | ⚠️ 无明确格式 | 人工 |
| ARCHITECTURE.md | - | 模块架构说明 | ✅ L0/L1/L2 模板 | Skill |
| API Contract | - | API 接口定义 | ✅ OpenAPI | 工具 |
| 代码注释 | Code Comments | 代码内文档 | ⚠️ 分散 | Linter |
| 开发备忘 | Dev Notes | 临时开发记录 | ❌ 无需 | - |

#### 4. 测试验收阶段 (Testing)

| 文档类型 | 英文名 | 用途 | 格式规范 | 适用场景 |
|----------|--------|------|----------|----------|
| 测试计划 | Test Plan | 测试策略和范围 | ❓ 待确认 | 正式测试 |
| 测试用例 | Test Cases | 具体测试步骤 | ❓ 待确认 | 手工测试 |
| 测试报告 | Test Report | 测试结果汇总 | ❓ 待确认 | 测试完成 |
| 缺陷报告 | Bug Report | 问题记录和跟踪 | ❓ 待确认 | 缺陷管理 |

#### 5. 运维部署阶段 (Operations)

| 文档类型 | 英文名 | 用途 | 格式规范 | 适用场景 |
|----------|--------|------|----------|----------|
| 部署文档 | Deployment Guide | 部署步骤和配置 | ❓ 待确认 | 生产部署 |
| 运维手册 | Ops Manual | 日常运维操作 | ❓ 待确认 | 运维团队 |
| 发布说明 | Release Notes | 版本更新内容 | ❌ 缺失 | 版本发布 |
| 变更日志 | Changelog | 变更历史记录 | ⚠️ 无统一格式 | 所有项目 |
| 配置说明 | Config Guide | 环境配置说明 | ❓ 待确认 | 多环境 |

#### 6. 项目管理阶段 (Management)

| 文档类型 | 英文名 | 用途 | 格式规范 | 适用场景 |
|----------|--------|------|----------|----------|
| 项目计划 | Project Plan | 里程碑和资源规划 | ❓ 待确认 | 大型项目 |
| 进度管理 | UPM | 统一进度追踪 | ✅ `standards/core/upm/` | AI-DDD 项目 |
| 风险管理 | Risk Register | 风险识别和应对 | ❓ 待确认 | 大型项目 |
| 会议纪要 | Meeting Notes | 会议决策记录 | ❓ 待确认 | 团队协作 |

#### 7. 持续维护文档 (Continuous)

| 文档类型 | 英文名 | 用途 | 格式规范 | 验证方式 |
|----------|--------|------|----------|----------|
| CLAUDE.md | - | AI 上下文入口 | ✅ 有规范 | 人工 |
| README.md | - | 项目/模块说明 | ⚠️ 无统一格式 | 人工 |
| Standards | - | 开发规范 | ✅ 在 standards/ | 人工 |
| Conventions | - | 约定规范 | ✅ 在 standards/ | Skill |
| Summaries | - | 摘要文件 | ✅ 有格式 | 人工 |

**图例**:
- ✅ 有规范且适用
- ⚠️ 有规范但需简化/整合
- ❌ 缺失规范
- ❓ 待确认是否需要

---

## Document Types for Small Team (1-3人)

### 规模适配原则

```
企业级项目 (50+ 人)     → 完整 SDLC 文档体系
中型团队 (5-20 人)      → 精简 SDLC + 敏捷文档
小团队 (1-3 人)         → 最小必要文档 ← 本项目
```

**小团队核心原则**:
1. **文档即代码** - 能用代码/测试表达的，不写文档
2. **轻量优先** - 用 OpenSpec 替代正式 PRD/设计文档
3. **AI 友好** - 文档服务于 AI 辅助开发
4. **按需扩展** - 先有最小集，需要时再补充

### 小团队文档类型清单 (精简版)

#### 必需 (MUST HAVE)

| 文档类型 | 用途 | 格式规范 | 说明 |
|----------|------|----------|------|
| **CLAUDE.md** | AI 上下文入口 | ✅ 有 | - |
| **README.md** | 项目/模块说明 | ⚠️ 需模板 | - |
| **PRD (轻量版)** | 功能需求概述 | ❌ 需创建 | 宏观: What & Why |
| **User Story** | 细粒度需求 | ❌ 需创建 | 用户价值 |
| **OpenSpec Proposal** | 技术实现方案 | ✅ 有 | 技术: How |
| **OpenSpec Tasks** | 任务分解 | ✅ 有 | - |
| **ARCHITECTURE.md** | 代码架构说明 | ✅ L0/L1/L2 | 替代 HLD/LLD |
| **API Contract** | 接口定义 | ✅ OpenAPI | - |
| **UPM** | 进度追踪 | ✅ 有 | - |

#### 推荐 (SHOULD HAVE)

| 文档类型 | 用途 | 格式规范 | 说明 |
|----------|------|----------|------|
| **OpenSpec Design** | 复杂决策记录 | ⚠️ 需模板 | 复杂功能才需要 |
| **Changelog** | 版本变更记录 | ⚠️ 需模板 | Keep a Changelog 格式 |
| **Summaries** | 摘要文件 | ✅ 有 | Token 优化 |
| **Standards** | 开发规范 | ✅ 有 | 团队约定 |

#### 可选 (NICE TO HAVE)

| 文档类型 | 用途 | 何时需要 |
|----------|------|----------|
| Release Notes | 用户可见的版本说明 | 有外部用户时 |
| Deployment Guide | 部署步骤 | 部署复杂时 |
| Test Strategy | 测试策略 | 测试复杂时 |

#### 不需要 (NOT NEEDED)

| 文档类型 | 原因 |
|----------|------|
| BRD (商业需求) | 小团队不需要独立商业文档 |
| SRS (需求规格) | 轻量 PRD + User Story 替代 |
| HLD/LLD | ARCHITECTURE.md + OpenSpec Design 替代 |
| 正式测试计划/用例 | 代码测试 + test-verifier Skill 替代 |
| 运维手册 | 规模小，README 足够 |
| 项目计划/风险管理 | UPM + OpenSpec Tasks 替代 |
| 会议纪要 | 小团队口头沟通即可 |
| Bug Report 模板 | GitHub Issues 足够 |

### PRD → User Story → OpenSpec 三层关系

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         需求到实现的文档流                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  L1: PRD (产品需求)        L2: User Stories        L3: OpenSpec         │
│  ┌─────────────────┐       ┌─────────────┐        ┌─────────────────┐  │
│  │ 背景与目标       │       │ Story 1     │        │ Proposal A      │  │
│  │ 用户角色        │  →    │ Story 2     │   →    │ Proposal B      │  │
│  │ 功能范围        │       │ Story 3     │        │ Proposal C      │  │
│  │ 成功指标        │       │ ...         │        │ ...             │  │
│  └─────────────────┘       └─────────────┘        └─────────────────┘  │
│                                                                         │
│  What & Why                 用户价值                 How (技术实现)      │
│  (宏观，一个功能一个)        (细粒度，多个)           (每个实现一个)       │
└─────────────────────────────────────────────────────────────────────────┘
```

**使用场景**:
- **大功能/新版本**: PRD → User Stories → OpenSpec Proposals
- **中等功能**: User Stories → OpenSpec Proposals (跳过 PRD)
- **小修复**: 直接 OpenSpec Proposal

### 文档数量目标

```
小团队理想文档结构:
├── CLAUDE.md              # 1 个入口
├── README.md              # 1 个说明
├── CHANGELOG.md           # 1 个变更日志
│
├── standards/             # ~10-15 个规范文档
│   ├── core/              # 核心方法论
│   ├── conventions/       # 约定规范
│   ├── summaries/         # 摘要文件
│   └── openspec/          # OpenSpec 框架
│
├── {module}/docs/         # 每模块 3-5 个
│   ├── ARCHITECTURE.md    # 架构说明
│   ├── project-planning/  # UPM
│   └── ...
│
└── shared/                # API 契约
    └── openapi/
```

**总计**: 约 20-30 个核心文档，而非 100+ 个

---

## Target Directory Structure

### standards/ 目录设计

```
standards/
├── README.md                    # 规范总览
├── core/                        # 核心方法论
│   ├── ten-step-cycle/          # 十步循环
│   ├── upm/                     # 进度管理
│   ├── workflow/                # 工作流
│   └── architecture/            # 架构文档模板 (L0/L1/L2)
│
├── conventions/                 # 约定规范
│   ├── naming-conventions.md    # 命名规范 (简化版)
│   ├── git-commit.md            # Git 提交规范
│   ├── content-integrity.md     # 内容真实性
│   └── document-formats.md      # 文档格式规范 (新增/整合)
│
├── templates/                   # 文档模板 (新增)
│   ├── README.md                # 模板使用说明
│   ├── architecture/            # 架构文档模板
│   ├── changelog/               # 变更日志模板
│   └── readme/                  # README 模板
│
├── summaries/                   # 摘要文件
│   └── *.md
│
├── extensions/                  # 模块扩展
│   └── *.md
│
└── openspec/                    # OpenSpec 框架
    ├── templates/               # proposal/tasks 模板
    └── specs/                   # 规范定义
```

### 与 docs/project-standards/ 的关系

```
归属划分:
  standards/          → 通用规范 (可跨项目复用)
  docs/project-standards/ → 项目特定规范 (本项目独有)

迁移规则:
  通用 → 迁移到 standards/
  特定 → 保留在 docs/ 或归档
  重复 → 删除 docs/ 中的副本
```

---

## Simplified Format Standard

### Before (过度设计)

```yaml
# v6 元数据格式
document:
  title: "..."
  type: "specification"
  version: "1.0.0"
  created: "2025-08-11T16:00:00+08:00"
  updated: "2025-08-11T16:30:00+08:00"
  author: "开发团队"
  status: "production"
  standard: "v6.0"
metadata:
  purpose: "..."
  scope: "..."
coverage:
  files: 100
  compliance: "95%"
```

### After (简化版)

**Option A: Markdown 引用块 (推荐)**

```markdown
# Document Title

> **Version**: 1.0.0
> **Status**: active | draft | deprecated
> **Updated**: 2025-12-29

正文内容...
```

**Option B: 最小 YAML (可选)**

```yaml
---
version: 1.0.0
status: active
updated: 2025-12-29
---
```

### 核心原则

1. **必要字段只有 3 个**: Version, Status, Updated
2. **日期格式简化**: YYYY-MM-DD (不需要时分秒)
3. **Author 可选**: 大多数文档不需要
4. **Version History 放文档末尾**: 不重复元数据

---

## Skills Responsibility Mapping

| 文档类型 | 生成 Skill | 验证 Skill | 说明 |
|----------|-----------|-----------|------|
| Git Commit | `commit-msg-generator` | 内置 | 生成时验证 |
| OpenSpec Proposal | `spec-drafter` | `openspec validate` | CLI 验证 |
| OpenSpec Tasks | `spec-drafter` | `openspec validate` | CLI 验证 |
| ARCHITECTURE.md | `arch-update` | 内置 | 更新时验证格式 |
| UPM | `progress-updater` | 内置 | 更新时验证 |
| Changelog | - | - | 暂无 Skill |
| README | - | - | 人工检查 |

### 无 Skill 覆盖的文档

以下文档类型暂无 Skill 支持，依赖人工遵守规范：
- README.md
- Changelog
- Release Notes
- Test Plan
- Dev Notes

**建议**: 为这些类型提供**模板**而非**验证**，降低维护成本。

---

## Migration Strategy

### Phase 0: Inventory (本次重点)

1. 扫描所有文档目录
2. 分类现有文档类型
3. 填充 Document Type Matrix

### Phase 1-2: Analysis & Design

1. 确定缺失/简化/删除列表
2. 设计最终 standards/ 结构
3. 设计简化的格式规范

### Phase 3: Implementation

1. 创建缺失的模板/规范
2. 简化现有规范
3. 迁移通用规范到 standards/
4. 归档废弃文件

### Phase 4-5: Cleanup & Document

1. 更新所有引用
2. 创建文档类型指南

---

## Risks & Mitigations

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| 漏掉某些文档类型 | Medium | Medium | Phase 0 全面扫描 |
| 简化过度导致混乱 | Low | Medium | 保留核心结构，只简化细节 |
| 迁移后引用断裂 | High | Low | grep 全局搜索旧路径 |
| 团队不接受变更 | Low | Low | 渐进式迁移，保持向后兼容 |

---

## Non-Goals

1. **不创建新的验证脚本** - Skills 已足够
2. **不改变 OpenSpec 流程** - 已验证有效
3. **不涉及代码实现** - 纯文档整理
4. **不强制迁移所有项目** - 先在 todo-app 验证

---

## Open Questions

Phase 0 完成后需要回答：

1. 项目中实际有多少种文档类型？
2. 哪些文档类型最常用？
3. 哪些规范从未被遵守？
4. standards/ 是否需要新增 `templates/` 子目录？
