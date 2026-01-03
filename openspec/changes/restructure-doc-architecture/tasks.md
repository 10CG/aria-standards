# Tasks: Restructure Documentation Architecture

## Task Overview

| Phase | 任务数 | 状态 |
|-------|--------|------|
| Phase 1: AI 记忆系统需求讨论 | 5 | ✅ 完成 |
| Phase 2: 文档架构调整 | 6 | ✅ 完成 |
| Phase 3: 验证与同步 | 3 | ✅ 完成 |
| Phase 4: Standards 集成与术语统一 | 6 | ✅ 完成 |

---

## Phase 1: AI 记忆系统需求讨论

> 目标: 退回需求层，讨论关键问题，形成明确的业务需求

### Task 1.1: 确认业务目标
- [x] 讨论 AI 记忆系统的核心业务价值
- [x] 确定 MVP 范围（选择 Q1 中的选项）
- [x] 记录决策到 design.md D1

**产出**: 业务目标明确文档 ✅

### Task 1.2: 评估技术方案
- [x] 评估 Memos 的适用性 (放弃)
- [x] 考虑替代方案（Mem0 + Zep + HippoRAG + Triplex + pgvector）
- [x] 确定技术方向
- [x] 记录决策到 design.md D2

**产出**: 技术方案决策 ✅

### Task 1.3: 定义本地/云端边界
- [x] 确定本地存储时长 (7-30天可配置)
- [x] 定义数据上传范围和隐私等级
- [x] 确定离线能力范围
- [x] 明确云端依赖和降级方案
- [x] 记录决策到 design.md D3

**产出**: 边界定义文档 ✅

### Task 1.4: 确认隐私合规要求
- [x] 确定数据加密要求 (完全自托管)
- [x] 定义用户授权机制
- [x] 明确数据删除策略
- [x] 确认合规要求（存储脱敏 + LLM API 脱敏）
- [x] 记录决策到 design.md D4

**产出**: 隐私合规要求清单 ✅

### Task 1.5: 确定版本演进路径
- [x] 确认 Phase 1 (MVP) 具体范围
- [x] 评估各阶段依赖关系
- [x] 制定大致时间预期
- [x] 记录决策到 design.md D5

**产出**: 版本演进路径确认 ✅

---

## Phase 2: 文档架构调整

> 目标: 执行文档重构，建立清晰的层次体系

### Task 2.1: 创建系统级 RPD
- [x] 创建 `docs/architecture/system-rpd.md`
- [x] 从 Mobile RPD 抽取以下内容：
  - §1 引言与项目愿景
  - §2.1-2.2 核心组件与架构图
  - §2.3 战略边界
  - §6 数字元神整体设计
- [x] 添加文档层次说明
- [x] 添加子模块引用规范

**产出**: `docs/architecture/system-rpd.md` ✅

### Task 2.2: 创建 Backend PRD
- [x] 创建 `backend/docs/requirements/prd-backend.md`
- [x] 定义模块定位（引用系统 RPD）
- [x] 编写 API 服务需求
- [x] 编写 AI 记忆系统需求（基于 Phase 1 讨论结果）
- [x] 定义非功能需求
- [x] 编写版本路线图

**产出**: `backend/docs/requirements/prd-backend.md` ✅

### Task 2.3: 更新主项目 PRD
- [x] 添加技术架构映射表（指向系统 RPD）
- [x] 添加子模块职责说明
- [x] 对齐版本路线图与各模块 (Phase 1-4)
- [x] 同步 RPD 中的核心概念（数字元神等）
- [x] 添加 AI 技术栈决策
- [x] 添加隐私/脱敏要求

**产出**: 更新后的 `docs/requirements/prd-todo-app-v1.md` ✅ (v2.1.0)

### Task 2.4: 精简 Mobile RPD
- [x] 标注将迁移到系统 RPD 的内容
- [x] 添加对系统 RPD 的引用
- [x] 保留纯客户端架构内容
- [x] 添加迁移说明表格

**产出**: 精简后的 Mobile RPD ✅

### Task 2.5: 创建文档引用规范
- [x] 创建 `docs/DOC_HIERARCHY.md`
- [x] 定义文档层次结构 (L0-L4)
- [x] 定义引用规则 (向上/向下/横向)
- [x] 添加示例和验证清单

**产出**: `docs/DOC_HIERARCHY.md` ✅

### Task 2.6: 迁移 Backend 架构内容
- [x] 将 Mobile RPD §4 迁移到 Backend 模块
- [x] 创建 `backend/docs/ARCHITECTURE.md`
- [x] 确保与新的 Backend PRD 对齐

**产出**: 更新后的 Backend 架构文档 ✅

---

## Phase 3: 验证与同步

> 目标: 确保文档一致性和完整性

### Task 3.1: 验证文档引用
- [x] 检查所有文档的引用是否正确
- [x] 确认无孤立文档
- [x] 确认无循环引用
- [x] 修正 Mobile 架构路径引用

**产出**: 验证报告 ✅

### Task 3.2: 更新 CLAUDE.md 引用
- [x] 更新主项目 CLAUDE.md 的文档路径
- [x] 添加系统级文档引用
- [x] 添加 Backend PRD 到按需加载指南

**产出**: 更新后的 CLAUDE.md 文件 ✅

### Task 3.3: 归档变更
- [ ] 变更完成，可选择归档
- [ ] 此变更专注于文档架构重构，无代码变更

**产出**: 变更完成，待用户决定是否归档

---

## Phase 4: Standards 集成与术语统一

> 目标: 将产品文档规范集成到 standards 模块，统一术语 (RPD → System Architecture)，扩展验证能力

### Task 4.1: 创建产品文档层次规范
- [x] 创建 `standards/core/documentation/product-doc-hierarchy.md`
- [x] 迁移 `docs/DOC_HIERARCHY.md` 核心内容
- [x] 定义 L0-L4 层次规范
- [x] 定义引用规则和验证清单
- [x] 添加文档生命周期管理

**产出**: `standards/core/documentation/product-doc-hierarchy.md` ✅

### Task 4.2: 创建 System Architecture 规范
- [x] 创建 `standards/core/documentation/system-architecture-spec.md`
- [x] 定义 System Architecture 文档的目的和定位
- [x] 定义必须包含的章节结构
- [x] 定义与 PRD、Module Architecture、OpenSpec 的关系
- [x] 添加验证规则和示例

**产出**: `standards/core/documentation/system-architecture-spec.md` ✅

### Task 4.3: 扩展 requirements-validator Skill
- [x] 更新 `.claude/skills/requirements-validator/SKILL.md`
- [x] 添加 System Architecture 验证模式
- [x] 添加文档层次验证功能
- [x] 添加引用完整性检查
- [x] 更新使用文档

**产出**: 增强的 `requirements-validator` Skill (v2.0.0) ✅

### Task 4.4: 更新 phase-a-spec-planning
- [x] 更新 `standards/core/ten-step-cycle/phase-a-spec-planning.md`
- [x] 添加 "OpenSpec vs System Architecture" 说明章节
- [x] 明确 OpenSpec 专注于功能实现规格
- [x] 明确 System Architecture 专注于技术架构设计
- [x] 添加何时使用哪种文档的决策指南

**产出**: 更新后的 `phase-a-spec-planning.md` (v2.2.0) ✅

### Task 4.5: 术语统一 (RPD → System Architecture)
- [x] 重命名 `docs/architecture/system-rpd.md` → `system-architecture.md`
- [x] 更新所有文档中的 "RPD" 引用为 "System Architecture"
- [x] 更新 `docs/DOC_HIERARCHY.md` 术语
- [x] 更新 `CLAUDE.md` 术语
- [x] 更新 `backend/docs/ARCHITECTURE.md` 术语
- [x] 更新 Mobile RPD 迁移说明中的术语

**产出**: 术语统一完成 ✅

### Task 4.6: 验证与文档
- [x] 验证术语统一后无遗漏 (仅 OpenSpec 历史记录保留旧术语)
- [x] 确保所有引用路径正确
- [x] 完成 Phase 4 验证清单

**产出**: 验证完成 ✅

---

## 依赖关系

```
Phase 1 (讨论) ─────────────────────────────────────────────┐
     │                                                      │
     ↓                                                      │
Task 1.1 → Task 1.2 → Task 1.3 → Task 1.4 → Task 1.5       │
     │         │         │         │         │              │
     └─────────┴─────────┴─────────┴─────────┘              │
                         │                                  │
                         ↓                                  │
Phase 2 (执行) ←────────────────────────────────────────────┘
     │
     ↓
Task 2.1 ────────────────┐
     │                   │
     ↓                   ↓
Task 2.2 ──────────► Task 2.3
     │                   │
     ↓                   ↓
Task 2.4 ◄──────────────┘
     │
     ↓
Task 2.5 ─── Task 2.6
     │
     ↓
Phase 3 (验证)
     │
     ↓
Task 3.1 → Task 3.2 → Task 3.3
                         │
                         ↓
Phase 4 (Standards 集成)
     │
     ├───────────────────┐
     ↓                   ↓
Task 4.1 ──────────► Task 4.2
     │                   │
     └─────────┬─────────┘
               ↓
          Task 4.3
               │
               ↓
          Task 4.4
               │
               ↓
          Task 4.5 ───► Task 4.6
```

---

## 验证标准

| 阶段 | 验证项 | 标准 |
|------|--------|------|
| Phase 1 | 决策完整性 | design.md 中 D1-D5 全部有结论 |
| Phase 2 | 文档创建 | 所有目标文档存在且内容完整 |
| Phase 2 | 引用正确 | 所有引用路径有效 |
| Phase 3 | OpenSpec 验证 | `--strict` 模式无错误 |
| Phase 3 | CLAUDE.md 更新 | AI 代理能正确加载文档 |
| Phase 4 | Standards 集成 | `standards/core/documentation/` 包含规范文件 |
| Phase 4 | 术语统一 | 无 "RPD" 术语残留，统一使用 "System Architecture" |
| Phase 4 | Skill 扩展 | requirements-validator 支持架构文档验证 |
| Phase 4 | 引用完整性 | 所有文档引用路径正确且可访问 |
