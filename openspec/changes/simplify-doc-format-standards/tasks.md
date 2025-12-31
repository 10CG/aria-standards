# Tasks: Unify Documentation Format Standards

> **Change**: simplify-doc-format-standards
> **Status**: completed
> **Created**: 2025-12-29
> **Completed**: 2025-12-29

## Phase 0: Document Type Inventory (已完成规划)

### Task 0.1: Map complete SDLC to document types
- **Status**: completed
- **Priority**: HIGH
- **Description**: 基于完整 SDLC（不仅是十步循环），梳理所有文档类型
- **Result**: 已在 `design.md` 中完成 7 阶段文档类型映射

### Task 0.2: Determine project scope
- **Status**: completed
- **Priority**: HIGH
- **Description**: 确定本项目实际需要哪些文档类型
- **Result**:
  - 项目规模: **1-3 人小团队**
  - 必需文档: 7 种
  - 推荐文档: 4 种
  - 可省略: PRD/BRD/HLD/LLD/测试计划等

### Task 0.3: Create document type matrix
- **Status**: completed
- **Priority**: HIGH
- **Description**: 创建文档类型与格式规范的对照矩阵
- **Result**: 已在 `proposal.md` 和 `design.md` 中完成

### Task 0.4: Identify gaps
- **Status**: completed
- **Priority**: HIGH
- **Description**: 识别需要补充/整合的格式规范
- **Result**: 识别出 4 个需要处理的规范：
  - README.md - 需创建模板
  - OpenSpec Design - 需创建模板
  - Changelog - 需采用统一格式
  - 代码注释 - 需整合到 conventions/

## Phase 1: Audit Existing Standards (已完成)

### Task 1.1: Audit docs/project-standards/
- **Status**: completed
- **Priority**: HIGH
- **Description**: 审计 `docs/project-standards/` 下所有文件
- **Result**:

#### 文件分类统计
| 分类 | 数量 | 处理方式 |
|------|------|----------|
| 已归档 (archived/) | 16 | 保留在 archived/ |
| 需归档 | 12 | 移动到 archived/ |
| 项目特定 | 5 | 保留在 docs/ |
| 可删除 | 5 | 与 OpenSpec 重复 |
| 需迁移 | 2 | 有价值，迁移到 standards/ |

#### 详细分类

**保留 (项目特定，不属于通用规范)**:
- `data/database-schema.md` - 项目数据库设计
- `design/README.md` - 设计系统入口
- `design/design-system.md` - UI设计系统
- `design/design-system-guide.md` - 设计指南
- `doc-classification-map.json` - 项目元数据

**需归档 (过时/已迁移)**:
- `INDEX.md` - 指向 standards/，内容过时
- `do-ref-standards.md` - 引用断裂，脚本不存在
- `do-ref-style.md` - 组件引用系统过度设计
- `do-ref-glossary.md` - 可整合到 CLAUDE.md
- `do-ref-health.md` - 文档健康度检查未实现
- `do-ref-issue-handling.md` - 未使用
- `do-ref-maintenance.md` - 未使用
- `do-ref-reference.md` - 未使用
- `do-impl-templates-summary.md` - 过时
- `do-impl-templates-update.md` - 过时
- `do-tech-template.md` - 过时
- `do-tech-template-fields.md` - 过时

**可删除 (与 OpenSpec 重复)**:
- `templates/changes/change-request.md` - OpenSpec proposal 替代
- `templates/requirements/*.md` (6个) - 过度设计，PRD/User Story 替代
- `templates/prompts/*.md` (4个) - Skills 替代

**需迁移 (有价值)**:
- `pr-arch-overview.md` - 项目架构概览，可参考
- `advanced-troubleshooting.md` - 故障排查指南，有实用价值

### Task 1.2: Audit standards/ current state
- **Status**: completed
- **Priority**: HIGH
- **Description**: 审计 `standards/` 当前结构和内容
- **Result**:

#### 当前目录结构 (合理)
```
standards/
├── conventions/      # ✅ 命名/代码规范
├── core/            # ✅ AI-DDD 核心
│   ├── progress-management/
│   ├── state-management/
│   ├── ten-step-cycle/
│   ├── upm/
│   └── workflow/
├── extensions/      # ✅ 模块扩展
├── governance/      # ✅ RACI 等治理
├── methodology/     # ✅ 开发方法论
├── openspec/        # ✅ OpenSpec 框架
├── summaries/       # ✅ 摘要文件
├── templates/       # ⚠️ 需补充
└── workflow/        # ✅ 工作流规范
```

#### 需要简化的文件
| 文件 | 问题 | 简化方向 |
|------|------|----------|
| `conventions/naming-conventions.md` | 四段式命名强制 | 改为推荐 |
| `core/architecture/document-templates.md` | 时间戳精确到秒 | 简化元数据 |

#### 缺失的模板
| 模板 | 位置 | 优先级 |
|------|------|--------|
| PRD (轻量版) | `templates/prd-template.md` | HIGH |
| User Story | `templates/user-story-template.md` | HIGH |
| README.md | `templates/readme-template.md` | HIGH |
| OpenSpec Design | `openspec/templates/design.md` | MEDIUM |

### Task 1.3: Identify over-designed standards
- **Status**: completed
- **Description**: 识别过度设计的现有规范
- **Result**:

#### 确认的过度设计

| 问题 | 位置 | 严重程度 | 说明 |
|------|------|----------|------|
| **元数据格式 v6** | `archived/architecture-doc-metadata-format-v6.md` | 已归档 | 时间戳精确到秒、多层嵌套 YAML |
| **四段式命名强制** | `conventions/naming-conventions.md` | 中 | 应改为"推荐"，保留灵活性 |
| **组件引用系统** | `do-ref-style.md` | 高 | `<!-- BEGIN:COMPONENT_REFERENCE -->` 从未使用 |
| **需求模板** | `templates/requirements/requirement.md` | 高 | 75行 YAML 前置元数据，AI memory 等 |
| **RACI 过度细化** | 多个模板 | 中 | 小团队不需要每个文档都定义 RACI |

#### 新发现的问题

1. **脚本引用断裂**: `do-ref-standards.md` 引用的脚本 (`scripts/check-doc-classification.js` 等) 不存在
2. **模板膨胀**: `templates/requirements/requirement.md` 包含 AI 专用字段 (`ai_directives`, `ai_memory`)，过于复杂
3. **分类系统过时**: 四分类系统 (规范性/被动更新/主动维护/导航) 与当前结构不符

## Phase 2: Create Missing Templates

### 已找到的参考文档

| 模板 | 参考文档 | 兼容性 |
|------|---------|--------|
| PRD | `mobile/docs/project-planning/architecture/mo-v2.0.0-mvp-scope-definition.md` | ✅ 优秀 |
| User Story | 无直接模板，参考现有 `✅/❌` 功能清单格式 | ⚠️ 需创建 |
| README | `mobile/CLAUDE.md` (简洁版) + `README.md` (完整版) | ✅ 两种风格 |
| OpenSpec Design | 当前 change 已创建 `design.md` | ✅ 已有 |
| Changelog | `.claude/skills/commit-msg-generator/CHANGELOG.md` | ✅ Keep a Changelog |

### Task 2.1: Create PRD (轻量版) template
- **Status**: completed
- **Priority**: HIGH
- **Description**: 创建轻量版 PRD 模板
- **Location**: `standards/templates/prd-template.md`
- **Reference**: `mobile/docs/project-planning/architecture/mo-v2.0.0-mvp-scope-definition.md`
- **策略**: 基于参考文档简化，保留功能清单格式 (yaml + ✅/❌)
- **Acceptance**:
  - [ ] 包含：📌 文档目的、🎯 核心定位、📋 功能清单、成功标准
  - [ ] 简洁版，适合小团队（1-2 页）
  - [ ] 功能按优先级分组 (Must-have / Nice-to-have)
  - [ ] 关联 User Stories 列表

### Task 2.2: Create User Story template
- **Status**: completed
- **Priority**: HIGH
- **Description**: 创建 User Story 模板
- **Location**: `standards/templates/user-story-template.md`
- **Reference**: 无直接参考，新建
- **策略**: 采用标准 User Story 格式，验收标准使用 Given/When/Then
- **Acceptance**:
  - [ ] 标准格式：As a [role], I want [feature], so that [value]
  - [ ] 验收标准：Given/When/Then 格式
  - [ ] 可选字段：优先级、估算、关联 PRD/OpenSpec
  - [ ] 与项目现有 `✅/❌` 标记风格兼容

### Task 2.3: Create README.md template
- **Status**: completed
- **Priority**: HIGH
- **Description**: 创建 README.md 通用模板
- **Location**: `standards/templates/readme-template.md`
- **Reference**:
  - 完整版: `README.md` (项目级)
  - 简洁版: `mobile/CLAUDE.md` (模块级)
- **策略**: 提供两个版本，简洁版使用表格式快速参考
- **Acceptance**:
  - [ ] 完整版：目录结构、技术栈、部署说明、环境变量
  - [ ] 简洁版：表格式快速参考、常用命令、质量门禁
  - [ ] 适用于项目级和模块级 README

### Task 2.4: Create OpenSpec Design template
- **Status**: completed
- **Priority**: MEDIUM
- **Description**: 创建 OpenSpec Design 文档模板
- **Location**: `standards/openspec/templates/design.md`
- **Reference**: 当前 change 的 `design.md`
- **策略**: 从当前 design.md 提取通用结构
- **Acceptance**:
  - [ ] 包含：Problem Statement、Options、Decision、Risks
  - [ ] 与现有 proposal/tasks 模板风格一致
  - [ ] 支持图表 (Mermaid)

### Task 2.5: Create Changelog format guide
- **Status**: completed
- **Priority**: MEDIUM
- **Description**: 采用 Keep a Changelog 格式
- **Location**: `standards/conventions/changelog-format.md`
- **Reference**: `.claude/skills/commit-msg-generator/CHANGELOG.md`
- **策略**: 直接采用 Keep a Changelog 标准，提供项目示例
- **Acceptance**:
  - [ ] 定义 Changelog 格式（Added/Changed/Fixed/Removed）
  - [ ] 版本格式：`[X.Y.Z] - YYYY-MM-DD`
  - [ ] 提供项目示例（参考 Skills CHANGELOG）

## Phase 3: Simplify & Migrate

### Task 3.1: Simplify naming-conventions.md
- **Status**: completed
- **Priority**: HIGH
- **Description**: 简化命名规范
- **Acceptance**:
  - [x] 四段式命名改为"推荐"而非"必须"
  - [x] 移除未使用的复杂规则
  - [x] 保留核心规则（snake_case, PascalCase 等）

### Task 3.2: Simplify document-templates.md
- **Status**: completed
- **Priority**: HIGH
- **Description**: 简化架构文档模板
- **Acceptance**:
  - [x] 元数据简化为 Version, Status, Updated
  - [x] 移除精确到秒的时间要求
  - [x] 保持 L0/L1/L2 核心结构

### Task 3.3: Archive docs/project-standards/
- **Status**: completed
- **Depends**: 3.1, 3.2
- **Description**: 归档过时的规范文件
- **Acceptance**:
  - [x] 有价值的保留在原位 (pr-arch-overview.md, advanced-troubleshooting.md)
  - [x] 过时的移动到 archived/ (17 个文件 + templates/)
  - [x] 保留项目特定文件 (data/, design/)

### Task 3.4: Consolidate code comment standards
- **Status**: completed (skipped)
- **Priority**: LOW
- **Description**: 整合代码注释规范
- **Result**: 现有 naming-conventions.md 已包含基本规则，无需单独整合

## Phase 4: Update References & Validate

### Task 4.1: Update CLAUDE.md
- **Status**: completed
- **Depends**: 3.3
- **Description**: 更新 CLAUDE.md 的上下文加载策略
- **Result**: CLAUDE.md 无直接引用 project-standards，无需更新

### Task 4.2: Update summaries
- **Status**: completed
- **Depends**: 3.1, 3.2
- **Description**: 更新摘要文件
- **Acceptance**:
  - [x] 更新 conventions-summary.md (四段式标记为 recommended)
  - [x] 确保摘要与完整规范一致

### Task 4.3: Verify no broken references
- **Status**: completed
- **Depends**: 4.1, 4.2
- **Description**: 验证所有文档引用有效
- **Result**: 所有引用有效，无断裂引用

---

## Execution Order

```
Phase 0 ✅ (文档类型清单)
    ↓
Phase 1 ✅ (审计完成)
    ↓
Phase 2 ✅ (模板创建完成)
    ↓
Phase 3 ✅ (简化 & 迁移完成)
    ↓
Phase 4 ✅ (引用验证完成)
```

## Summary

| Phase | 任务数 | 状态 |
|-------|--------|------|
| Phase 0 | 4 | ✅ 已完成 |
| Phase 1 | 3 | ✅ 已完成 |
| Phase 2 | 5 | ✅ 已完成 |
| Phase 3 | 4 | ✅ 已完成 |
| Phase 4 | 3 | ✅ 已完成 |
| **Total** | **19** | ✅ ALL DONE |

## Key Outputs

已完成产出：
1. **5 个新模板**: PRD, User Story, README, OpenSpec Design, Changelog
2. **2 个简化规范**: naming-conventions (四段式改为推荐), document-templates (日期格式简化)
3. **整理后的 docs/project-standards/**: 归档 17 个过时文件 + templates/
4. **更新的 summaries**: conventions-summary.md

## Phase 2 Key Outputs (已完成)

创建的模板文件:

| 模板 | 位置 | 说明 |
|------|------|------|
| PRD (轻量版) | `standards/templates/prd-template.md` | 功能清单格式 (yaml + ✅/❌) |
| User Story | `standards/templates/user-story-template.md` | Given/When/Then 验收标准 |
| README | `standards/templates/readme-template.md` | 完整版 + 简洁版两种风格 |
| OpenSpec Design | `standards/openspec/templates/design.md` | Options/Decision/Risks 结构 |
| Changelog | `standards/conventions/changelog-format.md` | Keep a Changelog 标准 |

## Phase 3 & 4 Key Outputs (已完成)

### 简化的规范

| 文件 | 简化内容 |
|------|---------|
| `conventions/naming-conventions.md` | 四段式命名改为"推荐" |
| `core/architecture/document-templates.md` | 时间戳简化为 `YYYY-MM-DD` |
| `summaries/conventions-summary.md` | 同步更新四段式为 recommended |

### 归档的文件 (17 个)

移动到 `docs/project-standards/archived/`:
- `INDEX.md`, `do-ref-*.md` (7个), `do-impl-*.md` (2个), `do-tech-*.md` (2个)
- `ai-ddd-promptx-guide.md`, `automated-tool-binding-strategy.md`
- `detailed-scripts.md`, `implementation-examples.md`, `to-tech-docker-tagging.md`
- `templates/` → `archived/templates-legacy/`

### 保留的项目特定文件

| 文件 | 说明 |
|------|------|
| `pr-arch-overview.md` | 项目架构概览 |
| `advanced-troubleshooting.md` | 故障排查指南 |
| `doc-classification-map.json` | 项目元数据 |
| `data/` | 数据库设计 |
| `design/` | UI 设计系统 |

## Phase 1 Key Findings

### docs/project-standards/ 处理建议
- **归档 12 个**: INDEX.md, do-ref-*.md, do-impl-*.md, do-tech-*.md
- **删除 5 个**: templates/ 下与 OpenSpec 重复的模板
- **保留 5 个**: data/, design/ 下项目特定文件
- **迁移 2 个**: pr-arch-overview.md, advanced-troubleshooting.md

### 过度设计确认
1. ✅ 元数据格式 v6 - 已归档
2. ⚠️ 四段式命名强制 - 需简化
3. ⚠️ 组件引用系统 - 需归档
4. ⚠️ 需求模板 75 行 YAML - 需删除

## Notes

- **风险控制**: 所有删除操作前先归档
- **并行执行**: Phase 2 的模板创建可立即开始
- **可选任务**: Task 3.4 (代码注释) 优先级低，可后续处理

## 项目已有格式约定 (模板需遵循)

```yaml
元数据格式:
  - YAML front matter (简化版，非 v6 复杂格式)
  - 必需字段: status, version, created_at
  - 可选字段: updated_at, priority_level, document_type

标题格式:
  - 一级标题: # 中文标题
  - 引用块元数据: > **字段**: 值

强调与标记:
  - 粗体: **重要内容**
  - 代码: `代码或路径`
  - 状态标记: ✅ 完成, ❌ 未完成, ⚠️ 警告

列表格式:
  - 无序: - 项目
  - 有序: 1. 步骤
  - 功能清单: yaml 代码块 + ✅/❌ 标记

表格格式:
  | 列1 | 列2 | 列3 |
  |-----|-----|-----|

代码块:
  - 指定语言: ```yaml, ```bash, ```dart
  - 结构图: ```mermaid
```

## 近一周 Git 变更摘要

主要变更 (2025-12-22 ~ 2025-12-29):
- `docs/project-standards/archived/` - 归档了 16 个过时文档
- `.claude/skills/` - 更新了 strategic-commit-orchestrator 文档结构
- `standards/` - 子模块更新多次
- `docs/analysis/` - 添加了规范清理计划分析
