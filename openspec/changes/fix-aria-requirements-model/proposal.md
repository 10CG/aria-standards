# Change Proposal: fix-aria-requirements-model

> **Status**: Complete
> **Created**: 2026-01-03
> **Updated**: 2026-01-04
> **Author**: AI Assistant
> **Priority**: P0
> **Supersedes**: upgrade-doc-skills, add-arch-scaffolder

---

## 1. Summary

统一修正 Aria 需求管理模型的所有不一致，建立正确的文档流程定义，**升级 `aria-brand-guide.md` 为 Aria 方法论唯一权威信息源**，完善 UPM 状态追踪，增强相关 Skills 能力。

### 1.1 Background

Aria 方法论存在以下核心不一致：

1. **文档流程描述错误**：多处文档将流程描述为 `PRD → User Stories → OpenSpec`，但正确的流程应该是 `PRD → System Architecture → User Stories`

2. **Pre-Cycle vs Ten-Step Cycle 混淆**：`product-doc-hierarchy.md` 错误地将 PRD/System Architecture 创建归入 Phase A，但实际上需求管理是十步循环之前的活动

3. **UPM 状态追踪不完整**：`upm-requirements-extension.md` 追踪 PRD 和 User Stories，但缺少 System Architecture 状态

4. **Skills 不支持完整需求链**：`state-scanner` 和 `requirements-validator` 不验证 PRD → System Architecture → User Stories 的完整链路

5. **aria-brand-guide.md 不完整**：作为方法论品牌文档，缺少核心系统定义、Pre-Cycle 概念、Architecture Skills 分类

### 1.2 Correct Model

```
┌─────────────────────────────────────────────────────────────────┐
│           Pre-Cycle: 需求管理 (十步循环之前)                     │
│                                                                  │
│   PRD (L0) ──▶ System Architecture (L1) ──▶ User Stories        │
│   产品需求      系统架构设计                 可实现需求单元       │
│                                                                  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ 选择 ready 状态的 Story
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│           Ten-Step Cycle: 实现周期                               │
│                                                                  │
│   Phase A: 规划 (OpenSpec) ──▶ Phase B-D: 实现/集成/收尾        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Goals

### 2.1 Primary Goals

1. **修正文档流程描述**：统一修正所有错误的流程描述
2. **明确 Pre-Cycle 定义**：在规范中明确需求管理是十步循环之前的阶段
3. **扩展 UPM 状态追踪**：添加 System Architecture 状态字段
4. **增强 Skills 能力**：支持完整需求链路验证

### 2.2 Non-Goals

- 创建完全自动化的需求生成工具（保持人工决策）
- 将 Pre-Cycle 工具集成到 Phase A（保持职责分离）
- 重构现有 Skills 的核心架构（仅增强功能）

---

## 3. Scope

### 3.1 Affected Files

| 文件 | 变更类型 | 说明 |
|------|---------|------|
| `CLAUDE.md` | **已更新** | ✅ 添加 Aria 开发周期模型图 |
| `standards/methodology/aria-brand-guide.md` | 更新 | **核心：升级为 v2.0，Aria 唯一权威源** |
| `standards/README.md` | 更新 | 引用 aria-brand-guide 为主文档 |
| `standards/templates/prd-template.md` | 更新 | 修正流程描述 |
| `docs/requirements/README.md` | 更新 | 修正流程描述 |
| `standards/core/documentation/product-doc-hierarchy.md` | 更新 | 修正 §9.1，添加 Pre-Cycle 定义 |
| `standards/core/upm/upm-requirements-extension.md` | 更新 | 添加 system_architecture 字段 |
| `.claude/skills/state-scanner/SKILL.md` | 更新 | 添加 System Architecture 扫描 |
| `.claude/skills/requirements-validator/SKILL.md` | 更新 | 添加链路验证 |
| `.claude/skills/requirements-sync/SKILL.md` | 更新 | 同步 Architecture 状态 |
| `standards/templates/system-architecture-template.md` | 新建 | 可选：架构模板 |

### 3.2 Out of Scope

- 十步循环核心流程（不修改）
- Phase Skills 的职责（不修改）
- OpenSpec 流程（不修改）

---

## 4. Solution Overview

### 4.1 Phase 1: 文档修正 (核心任务：aria-brand-guide v2.0)

**升级 aria-brand-guide.md 为 Aria 唯一权威源** (Task 1.6):

```
aria-brand-guide.md v2.0 新增内容:
├── §3 Aria Core Systems (新增)
│   ├── 3.1 开发周期模型 (Pre-Cycle + Ten-Step Cycle)
│   ├── 3.2 状态管理系统 (UPM + UPMv2-STATE)
│   ├── 3.3 需求管理系统 (PRD → Arch → Stories)
│   └── 3.4 规范驱动系统 (OpenSpec)
├── §4 Brand Structure (扩展 - 添加 Pre-Cycle)
├── §5 Skill Hierarchy (扩展 - 添加 Architecture Skills)
└── §9 Related Documents (扩展)
```

**修正流程描述**：

```markdown
# 错误描述 (当前)
PRD (What & Why) → User Stories (用户价值) → OpenSpec (How)

# 正确描述 (修正后)
PRD (L0) → System Architecture (L1) → User Stories → OpenSpec
产品需求     系统架构设计              可实现需求单元   技术实现方案
```

**修正 Phase A 职责描述**：

```markdown
# 错误描述 (product-doc-hierarchy.md §9.1)
Phase A: Create/Update PRD, System Architecture

# 正确描述
Pre-Cycle: 需求管理
  - 创建/更新 PRD
  - 创建/更新 System Architecture
  - 创建/细化 User Stories

Phase A: OpenSpec 规划
  - 选择待实现的 User Story
  - 创建 OpenSpec (proposal.md, tasks.md)
  - 任务分解和 Agent 分配
```

### 4.2 Phase 2: UPM 扩展

```yaml
# 扩展 upm-requirements-extension.md
requirements:
  prd:
    id: "prd-v2.1.0"
    status: approved
    path: "docs/requirements/prd-*.md"

  system_architecture:          # 新增字段
    exists: true
    path: "docs/architecture/system-architecture.md"
    status: active              # draft | active | outdated
    last_updated: "2026-01-03"
    parent_prd: "prd-v2.1.0"    # 关联的 PRD

  user_stories:
    total: 8
    ready: 3
    in_progress: 2
    done: 3
```

### 4.3 Phase 3: Skills 增强

**state-scanner 增强**：

```yaml
# 新增扫描内容
architecture_status:
  exists: true/false
  path: "docs/architecture/system-architecture.md"
  status: active
  parent_prd_match: true/false  # PRD 引用是否匹配

# 新增推荐规则
architecture_missing:
  条件: PRD 存在但 System Architecture 不存在
  推荐: create-architecture
  理由: "PRD 已就绪，需要创建 System Architecture"
```

**requirements-validator 增强**：

```yaml
# 新增验证
阶段 X: 需求链路验证
  检查项:
    - System Architecture 是否引用 Parent PRD
    - User Stories 是否在 System Architecture 之后创建
    - Stories 的模块边界是否与 Architecture 一致
```

### 4.4 Phase 4: 模板 (可选)

创建 `system-architecture-template.md`，基于 `system-architecture-spec.md` 规范。

---

## 5. Risks & Mitigations

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| 文档修正可能遗漏 | 中 | 全局搜索验证 |
| UPM 扩展向后兼容 | 低 | 新字段可选 |
| Skills 增强影响性能 | 低 | 新增扫描仅在需要时执行 |

---

## 6. Success Criteria

- [x] `CLAUDE.md` 包含 Aria 开发周期模型 **(已完成)**
- [x] `aria-brand-guide.md` 升级为 v2.0，成为 Aria 唯一权威信息源 **(已完成)**
- [x] `CLAUDE.md` 与 `aria-brand-guide.md` 一致性复审通过 **(已完成)**
- [x] `aria-brand-guide.md` 包含 §3 Aria Core Systems **(已完成)**
- [x] `standards/README.md` 正确引用 aria-brand-guide.md 为主文档 **(已完成)**
- [x] 所有文档的流程描述一致为 `PRD → System Architecture → User Stories` **(已完成)**
- [x] `product-doc-hierarchy.md` 明确区分 Pre-Cycle 和 Phase A **(已完成)**
- [x] UPM 能追踪 System Architecture 状态 **(已完成 - upm-requirements-extension v1.1.0)**
- [x] `state-scanner` 能扫描完整需求链 **(已完成 - state-scanner v2.1.0)**
- [x] `requirements-validator` 能验证链路完整性 **(已完成 - requirements-validator v2.1.0)**

---

## 7. Related Documents

- **被替代的变更**:
  - `openspec/changes/upgrade-doc-skills/` (已删除)
  - `openspec/changes/add-arch-scaffolder/` (已删除)
- **Aria 方法论主文档**:
  - `standards/methodology/aria-brand-guide.md` (核心 - 升级为 v2.0)
  - `CLAUDE.md` (已更新 - 包含开发周期模型)
- **核心规范**:
  - `standards/core/documentation/product-doc-hierarchy.md`
  - `standards/core/documentation/system-architecture-spec.md`
  - `standards/core/upm/upm-requirements-extension.md`
  - `standards/core/ten-step-cycle/README.md`
