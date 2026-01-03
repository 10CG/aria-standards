# Tasks: fix-aria-requirements-model

> **Status**: Complete
> **Created**: 2026-01-03
> **Updated**: 2026-01-04
> **Total Tasks**: 12
> **Completed Tasks**: 12 (Phase 1: 7, Phase 2: 2, Phase 3: 3, Phase 4: 2)

---

## Phase 1: 文档修正 (必须)

修正所有错误的文档流程描述。

### Task 1.1: 修正 prd-template.md 流程描述 ✅
- **File**: `standards/templates/prd-template.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 定位第129-133行的流程描述
  - [x] 将 `PRD → User Stories → OpenSpec` 修正为完整链路
  - [x] 添加每个环节的职责说明
- **验证**: ✅ 流程描述包含 System Architecture

### Task 1.2: 修正 docs/requirements/README.md ✅
- **File**: `docs/requirements/README.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 定位第26-28行的流程描述
  - [x] 修正为 `PRD → System Architecture → User Stories → OpenSpec`
  - [x] 保持与 prd-template.md 一致
- **验证**: ✅ 两处描述一致

### Task 1.3: 修正 product-doc-hierarchy.md §9.1 ✅
- **File**: `standards/core/documentation/product-doc-hierarchy.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 删除错误的 "Phase A: Create/Update PRD, System Architecture"
  - [x] 添加 "Pre-Cycle: 需求管理" 章节定义
  - [x] 明确 Pre-Cycle 和 Ten-Step Cycle 的边界
  - [x] 更新 §9.2 包含完整的 PRD → Arch → Stories 链路
- **验证**: ✅ Phase A 描述只包含 OpenSpec 相关内容

### Task 1.4: 在 product-doc-hierarchy.md 定义 User Stories 层级 ✅
- **File**: `standards/core/documentation/product-doc-hierarchy.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 在 §2 Documentation Layers 中添加 User Stories 说明 (§2.3)
  - [x] 明确 User Stories 位于 System Architecture (L1) 之后
  - [x] 说明 User Stories 与 L0-L4 架构层次的关系
- **Dependencies**: Task 1.3 完成
- **验证**: ✅ User Stories 层级定义清晰

### Task 1.5: 更新 CLAUDE.md Aria 开发周期模型 ✅
- **File**: `CLAUDE.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 添加 Aria 开发周期模型图 (Pre-Cycle + Ten-Step Cycle)
  - [x] 添加文档流转链路说明
  - [x] 拆分开发流程为 Pre-Cycle 和 Phase A 检查点
  - [x] 添加需求文档入口表
  - [x] 更新版本为 v3.0.2
- **最终复审** (已完成):
  - [x] 与 aria-brand-guide.md v2.0 内容一致性检查
  - [x] 术语和描述统一
  - [x] 添加 Architecture Skills 分类
- **验证**: ✅ CLAUDE.md 正确描述 Pre-Cycle 与 Ten-Step Cycle 边界，与 aria-brand-guide.md 一致

### Task 1.6: 升级 aria-brand-guide.md 为 v2.0 (Aria 方法论主文档) ✅
- **File**: `standards/methodology/aria-brand-guide.md`
- **Status**: **已完成** (2026-01-04)
- **Priority**: 高 (作为 Aria 唯一权威信息源)
- **Changes**:
  - [x] **§3 Aria Core Systems (新增章节)**
    - [x] 3.1 开发周期模型 - 添加 Pre-Cycle + Ten-Step Cycle 图
    - [x] 3.2 状态管理系统 - UPM + UPMv2-STATE 说明
    - [x] 3.3 需求管理系统 - PRD → System Architecture → User Stories 链路
    - [x] 3.4 规范驱动系统 - OpenSpec Framework 说明
  - [x] **§4 Brand Structure (扩展)**
    - [x] 在 Aria Core 中添加 Pre-Cycle 分支
    - [x] 列出 Pre-Cycle 组件: PRD, System Architecture, User Stories
  - [x] **§5 Skill Hierarchy (扩展)**
    - [x] 添加 Pre-Cycle Skills 分类
    - [x] 添加 Architecture Skills 分类 (arch-common, arch-search, arch-update)
    - [x] 为每个 Skill 标注所属阶段
  - [x] **§9 Related Documents (扩展)**
    - [x] 添加系统级文档链接
  - [x] **版本更新**: v1.0.0 → v2.0.0
- **验证**:
  - [x] aria-brand-guide.md 成为 Aria 方法论唯一权威源
  - [x] 包含完整的 Pre-Cycle + Ten-Step Cycle 定义
  - [x] 所有 Skills 按阶段正确分类
  - [x] 与 CLAUDE.md 描述一致

### Task 1.7: 更新 standards/README.md 引用 aria-brand-guide 为主文档 ✅
- **File**: `standards/README.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 添加对 aria-brand-guide.md 的强引用
  - [x] 标注其为 Aria 方法论唯一权威信息源
- **Dependencies**: Task 1.6 完成
- **验证**: ✅ standards/README.md 正确引导到 aria-brand-guide.md

---

## Phase 2: UPM 扩展 (建议)

扩展 UPM 以追踪 System Architecture 状态。

### Task 2.1: 扩展 upm-requirements-extension.md ✅
- **File**: `standards/core/upm/upm-requirements-extension.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 在 Schema Definition 中添加 `system_architecture` 字段
  - [x] 定义字段类型和约束 (exists, path, status, last_updated, parent_prd)
  - [x] 添加 Status Definitions (draft, active, outdated)
  - [x] 更新 Usage Examples 包含新字段
  - [x] 添加 Validation Rules (Rule 4-6)
- **验证**: ✅ Schema 定义完整且向后兼容

### Task 2.2: 更新 requirements-sync SKILL.md ✅
- **File**: `.claude/skills/requirements-sync/SKILL.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 添加 System Architecture 扫描阶段 (阶段 2.5)
  - [x] 定义 Architecture 状态同步逻辑 (偏差检测、UPM 更新)
  - [x] 更新输出格式包含 architecture 状态
  - [x] 版本更新: 1.0.0 → 1.1.0
- **Dependencies**: Task 2.1 完成
- **验证**: ✅ requirements-sync 能同步 Architecture 状态

---

## Phase 3: Skills 增强 (建议)

增强 Skills 支持完整需求链验证。

### Task 3.1: 增强 state-scanner 架构扫描 ✅
- **File**: `.claude/skills/state-scanner/SKILL.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 添加 "阶段 1.6: 架构状态扫描"
  - [x] 定义 System Architecture 检测逻辑 (检测路径、状态提取、链路完整性)
  - [x] 添加 `architecture_status` 输出字段 (exists, path, status, last_updated, parent_prd, chain_valid)
  - [x] 更新输出格式模板 (存在/不存在/链路不完整)
  - [x] 版本更新: 2.0.0 → 2.1.0
- **验证**: ✅ state-scanner 输出包含架构状态

### Task 3.2: 添加 state-scanner 架构推荐规则 ✅
- **File**: `.claude/skills/state-scanner/RECOMMENDATION_RULES.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 添加 `architecture_missing` 规则 (优先级 1.6)
  - [x] 添加 `architecture_outdated` 规则 (优先级 1.7)
  - [x] 添加 `architecture_chain_broken` 规则 (优先级 1.8)
  - [x] 定义触发条件和推荐动作
  - [x] 添加架构状态检测方法
  - [x] 更新 SKILL.md 规则优先级列表
- **Dependencies**: Task 3.1 完成
- **验证**: ✅ 推荐规则在适当条件下触发

### Task 3.3: 增强 requirements-validator 链路验证 ✅
- **File**: `.claude/skills/requirements-validator/SKILL.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 添加 "阶段 8: 需求链路验证"
  - [x] 定义 PRD → Architecture 检查逻辑 (存在性、引用、时序约束)
  - [x] 定义 Architecture → Stories 检查逻辑 (时序、模块边界)
  - [x] 定义链路完整性检查 (状态一致性、OpenSpec 关联)
  - [x] 更新输出格式包含 chain_validation 字段
  - [x] 添加 `chain` 验证模式
  - [x] 添加链路验证使用示例
  - [x] 版本更新: 2.0.0 → 2.1.0
- **Dependencies**: Task 2.1 完成
- **验证**: ✅ 能检测断裂的需求链路

---

## Phase 4: 模板 (可选)

创建 System Architecture 模板。

### Task 4.1: 创建 system-architecture-template.md ✅
- **File**: `standards/templates/system-architecture-template.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 基于 system-architecture-spec.md 创建模板
  - [x] 包含所有 10 个必需章节 (Executive Summary, System Overview, Architecture Diagram, Module Boundaries, Technology Decisions, Cross-Cutting Concerns, Data Architecture, Integration Patterns, Evolution Roadmap, Related Documents)
  - [x] 添加占位符和说明注释
  - [x] 添加版本头部模板
  - [x] 添加验证清单
- **验证**: ✅ 模板符合 system-architecture-spec.md 规范

### Task 4.2: 创建 arch-scaffolder skill ✅
- **File**: `.claude/skills/arch-scaffolder/SKILL.md`
- **Status**: **已完成** (2026-01-04)
- **Changes**:
  - [x] 定义 skill 基础结构 (4 阶段执行流程)
  - [x] 定义从 PRD 提取信息的规则 (basic_info, goals, scope, constraints, stakeholders)
  - [x] 定义骨架生成流程 (10 个章节自动填充)
  - [x] 添加智能建议功能 (tech decisions, missing info, next steps)
  - [x] 添加使用示例 (主项目和模块级)
  - [x] 定义与其他 Skills 的关系
- **Dependencies**: Task 4.1 完成
- **验证**: ✅ 能从 PRD 生成架构骨架

---

## Execution Order

```
Phase 1 (部分并行):
  Task 1.1 ─┬─►
  Task 1.2 ─┤
  Task 1.3 ─┤
  Task 1.4 ─┤ (依赖 1.3)
  Task 1.5 ─┤ (初版完成，待最终复审)
  Task 1.6 ─┤ (核心任务 - aria-brand-guide v2.0)
  Task 1.7 ─┤ (依赖 1.6)
       └───► Task 1.5 复审 (依赖 1.6) ─► 文档修正完成

Phase 2 (串行):
  Task 2.1 → Task 2.2

Phase 3 (部分并行):
  Task 3.1 → Task 3.2
       └───► Task 3.3 (依赖 2.1)

Phase 4 (可选，串行):
  Task 4.1 → Task 4.2

依赖关系图:
  Phase 1 ──────────────────────────────────┐
                                            ▼
  Phase 2 ─────────────────────────────► Phase 3
                                            │
                                            ▼
                                        Phase 4

关键路径:
  Task 1.6 (aria-brand-guide v2.0) 是 Phase 1 的核心任务
  → 确立 Aria 方法论唯一权威信息源
  → 其他文档统一引用此文档
```

---

## Verification Checklist

### Post-Implementation

**Phase 1 验证**: ✅ 全部完成 (2026-01-04)
- [x] `grep -r "PRD.*User Stories.*OpenSpec"` 无匹配
- [x] 所有文档流程描述一致
- [x] product-doc-hierarchy.md 包含 Pre-Cycle 定义
- [x] Phase A 描述只包含 OpenSpec 内容
- [x] CLAUDE.md 包含 Aria 开发周期模型
- [x] aria-brand-guide.md 升级为 v2.0，成为 Aria 唯一权威源
- [x] aria-brand-guide.md 包含 §3 Aria Core Systems
- [x] aria-brand-guide.md 包含 Pre-Cycle 和 Architecture Skills
- [x] standards/README.md 正确引用 aria-brand-guide.md
- [x] CLAUDE.md 与 aria-brand-guide.md 一致性复审通过

**Phase 2 验证**: ✅ 全部完成 (2026-01-04)
- [x] upm-requirements-extension.md 包含 system_architecture 字段
- [x] 新字段向后兼容 (system_architecture 为可选字段)
- [x] requirements-sync 能同步 Architecture 状态 (阶段 2.5)

**Phase 3 验证**: ✅ 全部完成 (2026-01-04)
- [x] state-scanner 输出包含 architecture_status (阶段 1.6)
- [x] 推荐规则在适当条件下触发 (architecture_missing/outdated/chain_broken)
- [x] requirements-validator 能验证需求链路 (阶段 8)

**Phase 4 验证**: ✅ 全部完成 (2026-01-04)
- [x] system-architecture-template.md 存在
- [x] 模板符合 spec 规范 (10 个必需章节 + 验证清单)
- [x] arch-scaffolder skill 创建完成

---

## Notes

1. **优先级**: Phase 1 必须完成，Phase 2-4 建议完成
2. **向后兼容**: 所有变更保持向后兼容
3. **被替代的变更**:
   - `upgrade-doc-skills` → 功能合并到 Phase 1 + Phase 3
   - `add-arch-scaffolder` → 精简为 Phase 4 可选任务
4. **执行建议**: 可分批实施，Phase 1 优先
