# Design Document: fix-aria-requirements-model

> **Version**: 1.1.0
> **Created**: 2026-01-03
> **Updated**: 2026-01-03
> **Status**: Draft

---

## 1. Problem Analysis

### 1.1 Current State - 不一致的文档描述

**位置 1: prd-template.md 第129-133行**
```markdown
PRD (What & Why) → User Stories (用户价值) → OpenSpec (How)
```

**位置 2: docs/requirements/README.md 第26-28行**
```markdown
PRD (What & Why) → User Stories (用户价值) → OpenSpec (How)
```

**位置 3: product-doc-hierarchy.md §9.2**
```markdown
PRD (What & Why) → System Architecture (How) → OpenSpec Specs (Detailed How)
```

**问题**: 三处描述不一致，且都遗漏了完整链路。

### 1.2 Current State - Phase A 职责混淆

**product-doc-hierarchy.md §9.1 (错误)**:
```markdown
Phase A: Create/Update PRD, System Architecture
```

**ten-step-cycle/README.md (正确)**:
```markdown
Phase A: Planning (规划)
- A.0 状态感知
- A.1 Spec管理 (OpenSpec)
- A.2 任务规划
- A.3 Agent分配
```

**问题**: PRD 和 System Architecture 不是 Phase A 的职责，而是 Pre-Cycle 的活动。

### 1.3 Current State - UPM 状态追踪不完整

**upm-requirements-extension.md 当前 schema**:
```yaml
requirements:
  prd:           # ✅ 追踪
    id: ...
    status: ...
  user_stories:  # ✅ 追踪
    total: ...
    ready: ...
  # ❌ 缺失: system_architecture
```

**问题**: System Architecture 是 PRD → User Stories 的关键中间环节，但状态不可追踪。

### 1.4 Root Cause Analysis

```
根本原因:
  1. Aria 方法论在不同时期添加了不同的文档
  2. 文档之间缺乏交叉验证
  3. "需求管理" 和 "十步循环" 的边界没有明确定义

具体表现:
  - prd-template 早期编写，未考虑 System Architecture
  - product-doc-hierarchy 后期添加，与 ten-step-cycle 描述冲突
  - UPM 扩展只关注了 PRD 和 Stories
```

---

## 2. Design Decisions

### 2.1 Decision: 正确的文档流程

**选项分析**:

| 选项 | 流程 | 评估 |
|------|------|------|
| A | PRD → User Stories → OpenSpec | ❌ 缺少 System Architecture |
| B | PRD → System Architecture → OpenSpec | ❌ 缺少 User Stories |
| **C** | PRD → System Architecture → User Stories → OpenSpec | ✅ 完整链路 |

**决定**: 选择 **C**

**理由**:
1. PRD 定义产品愿景和功能范围 (What & Why)
2. System Architecture 定义技术实现框架 (How - 系统级)
3. User Stories 是在架构约束下的可实现需求单元 (Who & Value)
4. OpenSpec 是为实现具体 Story 而创建的技术方案 (How - 实现级)

### 2.2 Decision: Pre-Cycle vs Ten-Step Cycle 边界

**选项分析**:

| 选项 | 描述 | 评估 |
|------|------|------|
| A | 将 PRD/Arch 创建放入 Phase A | ❌ 混淆职责，Phase A 应聚焦 OpenSpec |
| **B** | 定义独立的 Pre-Cycle 阶段 | ✅ 清晰分离，符合实际工作流 |
| C | 不做区分 | ❌ 继续混淆 |

**决定**: 选择 **B - 定义独立的 Pre-Cycle 阶段**

**理由**:
1. 需求管理是项目级活动，可能跨越多个十步循环
2. 十步循环是功能实现周期，从选择 Story 开始
3. 保持 Phase A 职责单一：OpenSpec 规划

### 2.3 Decision: UPM 扩展方案

**选项分析**:

| 选项 | 描述 | 评估 |
|------|------|------|
| A | 只追踪存在性 | 信息不足 |
| **B** | 追踪状态和关联 | ✅ 完整信息，支持验证 |
| C | 创建独立的架构状态文件 | 过度设计 |

**决定**: 选择 **B**

**Schema 设计**:
```yaml
system_architecture:
  exists: boolean          # 是否存在
  path: string             # 文件路径
  status: enum             # draft | active | outdated
  last_updated: string     # ISO8601 时间戳
  parent_prd: string       # 关联的 PRD id
```

---

## 3. Architecture Design

### 3.1 Aria 开发周期完整模型

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          Aria 开发周期模型                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌───────────────────────────────────────────────────────────────────┐     │
│   │                    Pre-Cycle: 需求管理                             │     │
│   │                                                                    │     │
│   │   ┌─────────┐      ┌──────────────────┐      ┌──────────────┐    │     │
│   │   │  PRD    │ ───▶ │ System           │ ───▶ │ User Stories │    │     │
│   │   │  (L0)   │      │ Architecture(L1) │      │              │    │     │
│   │   └─────────┘      └──────────────────┘      └──────────────┘    │     │
│   │                                                      │            │     │
│   │   Tools:                                             │            │     │
│   │   - arch-scaffolder (可选)                           │            │     │
│   │   - requirements-validator                           │            │     │
│   │   - requirements-sync                                │            │     │
│   │                                                      │            │     │
│   └──────────────────────────────────────────────────────┼────────────┘     │
│                                                          │                   │
│                                         选择 ready Story │                   │
│                                                          ▼                   │
│   ┌───────────────────────────────────────────────────────────────────┐     │
│   │                    Ten-Step Cycle: 实现周期                        │     │
│   │                                                                    │     │
│   │   Phase A          Phase B          Phase C          Phase D      │     │
│   │   ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐    │     │
│   │   │ OpenSpec│ ──▶ │ 开发    │ ──▶ │ 集成    │ ──▶ │ 收尾    │    │     │
│   │   │ 规划    │     │ 验证    │     │ 提交    │     │ 归档    │    │     │
│   │   └─────────┘     └─────────┘     └─────────┘     └─────────┘    │     │
│   │                                                                    │     │
│   │   Tools:                                                           │     │
│   │   - state-scanner (A.0)                                           │     │
│   │   - spec-drafter (A.1)                                            │     │
│   │   - progress-updater (D.1)                                        │     │
│   │                                                                    │     │
│   └────────────────────────────────────────────────────────────────────┘     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 UPM 在系统中的角色

```
┌─────────────────────────────────────────────────────────────────┐
│                        UPM (状态中枢)                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   requirements: (Pre-Cycle 状态)                                │
│   ┌───────────────────────────────────────────────────────┐     │
│   │  prd:                                                  │     │
│   │    id: "prd-v2.1.0"                                   │     │
│   │    status: approved                                    │     │
│   │                                                        │     │
│   │  system_architecture:  ← 新增                          │     │
│   │    exists: true                                        │     │
│   │    status: active                                      │     │
│   │    parent_prd: "prd-v2.1.0"                           │     │
│   │                                                        │     │
│   │  user_stories:                                         │     │
│   │    total: 8, ready: 3, in_progress: 2, done: 3        │     │
│   └───────────────────────────────────────────────────────┘     │
│                                                                  │
│   UPMv2-STATE: (Ten-Step Cycle 状态)                            │
│   ┌───────────────────────────────────────────────────────┐     │
│   │  stage: "Phase 4 - Sprint Development"                │     │
│   │  cycleNumber: 9                                        │     │
│   │  kpiSnapshot: { coverage: "87.2%", build: "green" }   │     │
│   │  nextCycle: { candidates: [...] }                      │     │
│   └───────────────────────────────────────────────────────┘     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 3.3 Skills 增强设计

**state-scanner 增强**:

```yaml
# 新增阶段: 架构状态扫描
阶段 1.6: 架构状态扫描

检测内容:
  system_architecture:
    path: "docs/architecture/system-architecture.md"
    exists: true/false
    status: active | outdated | draft
    parent_prd_match: true/false
    last_updated: "ISO8601"

# 新增推荐规则
architecture_missing:
  条件:
    - prd_exists: true
    - system_architecture.exists: false
  推荐: create-architecture
  理由: "PRD 已就绪，需要创建 System Architecture"

architecture_outdated:
  条件:
    - system_architecture.exists: true
    - prd.last_updated > system_architecture.last_updated
  推荐: update-architecture
  理由: "PRD 已更新，System Architecture 可能需要同步"
```

**requirements-validator 增强**:

```yaml
# 新增阶段: 需求链路验证
阶段 X: 需求链路验证

检查项:
  prd_to_arch:
    - System Architecture 是否存在
    - System Architecture 是否引用 Parent PRD
    - PRD 版本是否匹配

  arch_to_stories:
    - User Stories 是否在 System Architecture 之后创建
    - Stories 的模块边界是否与 Architecture 一致

  chain_completeness:
    - PRD → Arch → Stories 链路是否完整
    - 是否有孤立的 Stories (无 Architecture)

输出:
  chain_valid: true/false
  chain_issues: [{source, target, issue, severity}]
```

---

## 4. Detailed Changes

### 4.1 prd-template.md 修正

**位置**: `standards/templates/prd-template.md` 第129-133行

```markdown
# 删除
PRD (What & Why) → User Stories (用户价值) → OpenSpec (How)

# 替换为
## 文档关系

PRD (L0) → System Architecture (L1) → User Stories → OpenSpec
产品需求     系统架构设计              可实现需求单元   技术实现方案

- **PRD**: 定义产品愿景、功能范围、成功标准 (What & Why)
- **System Architecture**: 定义系统级技术设计 (How - 系统级)
- **User Stories**: 细粒度的用户价值需求 (Who & Value)
- **OpenSpec**: 具体功能的技术实现方案 (How - 实现级)
```

### 4.2 product-doc-hierarchy.md 修正

**§9.1 修正**:

```markdown
# 删除
Phase A: Create/Update PRD, System Architecture

# 替换为
## 9.1 Development Cycle Integration

### Pre-Cycle: 需求管理 (十步循环之前)

在进入十步循环之前，需要完成需求管理活动：

| 活动 | 输出 | 负责人 |
|------|------|--------|
| 产品需求定义 | PRD (L0) | Product Owner |
| 系统架构设计 | System Architecture (L1) | Tech Lead |
| 需求细化 | User Stories | Product Owner + Dev |

### Ten-Step Cycle: 实现周期

| Phase | 活动 | 输入 |
|-------|------|------|
| Phase A | OpenSpec 规划 | 选择 ready 状态的 User Story |
| Phase B | 开发验证 | OpenSpec + 任务分解 |
| Phase C | 集成提交 | 代码 + 测试 |
| Phase D | 进度归档 | 更新 UPM + 归档 Spec |
```

### 4.3 upm-requirements-extension.md 扩展

**新增 system_architecture 字段**:

```yaml
### System Architecture Section (NEW)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `exists` | boolean | Yes | Whether System Architecture document exists |
| `path` | string | Conditional | File path (required if exists=true) |
| `status` | enum | Conditional | draft | active | outdated |
| `last_updated` | string | No | ISO8601 timestamp of last update |
| `parent_prd` | string | No | Associated PRD id |

### Status Definitions

| Status | Meaning | Allowed Actions |
|--------|---------|-----------------|
| `draft` | Architecture is being designed | Edit, not ready for Stories |
| `active` | Architecture is finalized | Create Stories, start implementation |
| `outdated` | PRD updated, Arch needs review | Review and update |
```

### 4.4 aria-brand-guide.md 升级为 v2.0

**位置**: `standards/methodology/aria-brand-guide.md`

**当前问题**:
1. 只有 Skills 分类，缺少系统级定义
2. 完全没有 Pre-Cycle 概念
3. 缺少 Architecture Skills (arch-search, arch-update, arch-common)
4. 缺少完整开发周期模型说明

**升级方案 - 新文档结构**:

```
aria-brand-guide.md v2.0
├── 1. Overview (现有，保留)
├── 2. Brand Name (现有，保留)
├── 3. Aria Core Systems (新增)
│   ├── 3.1 开发周期模型
│   │   ├── Pre-Cycle: 需求管理
│   │   └── Ten-Step Cycle: 实现周期
│   ├── 3.2 状态管理系统
│   │   ├── UPM (Unified Progress Management)
│   │   └── UPMv2-STATE
│   ├── 3.3 需求管理系统
│   │   ├── PRD (L0)
│   │   ├── System Architecture (L1)
│   │   └── User Stories
│   └── 3.4 规范驱动系统
│       └── OpenSpec Framework
├── 4. Brand Structure (扩展)
│   └── 添加 Pre-Cycle 分支
├── 5. Skill Hierarchy (扩展)
│   ├── 按阶段分类
│   │   ├── Pre-Cycle Skills
│   │   └── Ten-Step Cycle Skills
│   └── 添加 Architecture Skills
│       ├── arch-common
│       ├── arch-search
│       └── arch-update
├── 6. Naming Conventions (现有，保留)
├── 7. Usage Guidelines (现有，保留)
├── 8. Brand Application Examples (现有，保留)
└── 9. Related Documents (扩展)
```

**新增内容详细设计**:

**§3 Aria Core Systems**:

```markdown
## 3. Aria Core Systems

Aria 方法论由四个核心系统组成：

### 3.1 开发周期模型

┌─────────────────────────────────────────────────────────────────┐
│           Pre-Cycle: 需求管理 (十步循环之前)                     │
│                                                                  │
│   PRD (L0) ──▶ System Architecture (L1) ──▶ User Stories        │
│   产品需求      系统架构设计                 可实现需求单元       │
│                                                                  │
│   Tools: requirements-validator, requirements-sync, arch-*      │
└──────────────────────────┬──────────────────────────────────────┘
                           │ 选择 ready 状态的 Story
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│           Ten-Step Cycle: 实现周期                               │
│                                                                  │
│   Phase A: 规划 ──▶ Phase B: 开发 ──▶ Phase C: 集成 ──▶ Phase D │
│   (OpenSpec)       (验证)           (提交)           (收尾)     │
│                                                                  │
│   Tools: state-scanner, spec-drafter, progress-updater          │
└─────────────────────────────────────────────────────────────────┘

**文档流转链路**:
PRD (L0) → System Architecture (L1) → User Stories → OpenSpec
产品需求     系统架构设计              可实现需求       技术方案

### 3.2 状态管理系统

| 组件 | 职责 | 文档 |
|------|------|------|
| UPM | 统一进度管理 | `{module}/docs/project-planning/unified-progress-management.md` |
| UPMv2-STATE | 十步循环状态追踪 | 嵌入 UPM |
| requirements section | 需求状态追踪 | upm-requirements-extension.md |

### 3.3 需求管理系统

| 层级 | 文档 | 职责 |
|------|------|------|
| L0 | PRD | 产品愿景、功能范围、成功标准 |
| L1 | System Architecture | 系统级技术设计、模块边界 |
| - | User Stories | 细粒度可实现需求单元 |

### 3.4 规范驱动系统

OpenSpec Framework 提供变更管理：
- Change Proposals → Technical Designs → Task Lists → Implementation
```

**§4 Brand Structure 扩展**:

```markdown
Aria Methodology v3.0
├── Aria Core
│   ├── Pre-Cycle              # 需求管理阶段 (NEW)
│   │   ├── PRD Management
│   │   ├── System Architecture
│   │   └── User Stories
│   ├── Ten-Step Cycle         # 开发实现周期
│   ├── UPM                    # Unified Progress Management
│   ├── OpenSpec               # Specification-driven development
│   └── Validation Gates       # Quality checkpoints
│
├── Aria Skills
│   ├── Entry Skills           # User-facing entry points
│   ├── Pre-Cycle Skills       # 需求管理 (NEW category)
│   │   ├── requirements-validator
│   │   ├── requirements-sync
│   │   └── forgejo-sync
│   ├── Architecture Skills    # 架构管理 (NEW category)
│   │   ├── arch-common
│   │   ├── arch-search
│   │   └── arch-update
│   ├── Commit Skills          # Git commit management
│   └── Spec Skills            # Specification management
```

**§5 Skill Hierarchy 扩展**:

```markdown
### Layer 2: Business Skills (扩展分类)

#### Pre-Cycle Skills (需求管理阶段)

| Skill | Purpose | 阶段 |
|-------|---------|------|
| `requirements-validator` | PRD/Story 格式验证 | Pre-Cycle |
| `requirements-sync` | Story ↔ UPM 状态同步 | Pre-Cycle |
| `forgejo-sync` | Story ↔ Issue 同步 | Pre-Cycle |

#### Architecture Skills (架构管理)

| Skill | Purpose | 阶段 |
|-------|---------|------|
| `arch-common` | 架构工具共享组件 | Pre-Cycle / Ten-Step |
| `arch-search` | 架构文档搜索 | Pre-Cycle / Ten-Step |
| `arch-update` | 架构文档更新 | Pre-Cycle |

#### Ten-Step Cycle Skills (开发实现阶段)

| Skill | Purpose | 阶段 |
|-------|---------|------|
| `state-scanner` | 项目状态扫描 | Phase A |
| `spec-drafter` | OpenSpec 起草 | Phase A |
| `progress-updater` | UPM 状态更新 | Phase D |
| `commit-msg-generator` | 提交消息生成 | Phase C |
| `strategic-commit-orchestrator` | 批量提交编排 | Phase C |
```

---

## 5. Validation Plan

### 5.1 文档修正验证

```bash
# 验证流程描述一致性
grep -r "PRD.*User Stories.*OpenSpec" standards/ docs/
# 期望: 无匹配（已修正）

grep -r "PRD.*System Architecture.*User Stories" standards/ docs/
# 期望: 有匹配（修正后的描述）

# 验证 Phase A 描述
grep -A5 "Phase A" standards/core/documentation/product-doc-hierarchy.md
# 期望: 不包含 "PRD" 或 "System Architecture"
```

### 5.2 UPM 扩展验证

```yaml
测试用例:
  1. 新字段向后兼容
     - 无 system_architecture 字段的 UPM 能正常解析

  2. 字段验证
     - exists=true 时 path 必须存在
     - status 必须是 draft|active|outdated

  3. Skills 能正确读取
     - state-scanner 能读取 system_architecture 状态
     - requirements-sync 能更新 system_architecture 状态
```

### 5.3 Skills 增强验证

```yaml
测试用例:
  1. state-scanner 扫描架构
     - 检测 System Architecture 存在性
     - 检测 PRD 匹配性

  2. requirements-validator 链路验证
     - 检测 PRD → Arch 链路
     - 检测 Arch → Stories 链路

  3. 推荐规则
     - PRD 存在但 Arch 不存在时推荐创建
```

---

## 6. Migration Notes

本次变更的兼容性考虑：

1. **文档修正**: 无破坏性，仅修正描述
2. **UPM 扩展**: 新字段可选，不影响现有 UPM
3. **Skills 增强**: 新增扫描，不影响现有功能

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-03 | Initial design - 统一修正 Aria 需求管理模型 |
