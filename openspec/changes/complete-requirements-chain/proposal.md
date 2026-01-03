# Change Proposal: complete-requirements-chain

> **Status**: Draft
> **Created**: 2026-01-04
> **Author**: AI Assistant
> **Priority**: P0
> **Depends-On**: restructure-doc-architecture (archived)

---

## 1. Summary

完善需求追踪链路，从 PRD 分解 User Stories，建立文档生命周期管理机制，清理文档债务。

---

## 2. Why

### 2.1 背景

`restructure-doc-architecture` 完成后，项目已建立清晰的文档层次：
- L0: PRD (docs/requirements/prd-todo-app-v1.md) ✅
- L1: System Architecture (docs/architecture/system-architecture.md) ✅
- L2: Module Docs (backend/mobile) ✅

但需求链路存在断裂：
- **PRD → User Stories**: 仅 1 个 Story，无法追踪需求到实现
- **文档债务**: 30 个分析文档 + 110 个归档文档未管理

### 2.2 问题

| 问题 | 严重度 | 影响 |
|------|--------|------|
| User Stories 仅 1 个 | P0 | 无法启动十步循环 Phase A |
| Mobile 无专属 PRD | P1 | 模块边界不清 |
| 分析文档无生命周期 | P2 | 临时文档堆积 |
| 归档文档债务 | P3 | 项目混乱感 |

---

## 3. What Changes

### 3.1 User Stories 创建 (P0)

从 PRD 分解用户故事，建立可追踪的需求单元：
- 目标: >= 10 个 User Stories
- 格式: US-XXX.md
- 位置: docs/requirements/user-stories/

### 3.2 文档生命周期管理 (P2)

建立分析文档的清理机制：
- 定义文档状态: draft → active → archived
- 清理规则: 超过 30 天未更新的 draft 自动提醒
- 迁移有价值内容到正式文档

### 3.3 归档文档评估 (P3)

评估 docs/archived/ 中的 110 个文档：
- 分类: 可删除 / 保留 / 迁移
- 清理无价值的历史文档
- 保留有参考价值的内容

---

## 4. Success Criteria

- [ ] User Stories >= 10 个，覆盖 PRD 核心功能
- [ ] 每个 Story 有明确的 Acceptance Criteria
- [ ] 分析文档生命周期规范建立
- [ ] 归档文档评估完成

---

## 5. Out of Scope

- Mobile 专属 PRD (可选，根据团队需求决定)
- Shared 模块文档完善 (独立 Change)
- 代码实现 (本 Change 仅聚焦文档)

---

## 6. References

- Parent: `docs/requirements/prd-todo-app-v1.md`
- Related: `restructure-doc-architecture` (archived)
- Standards: `standards/core/documentation/product-doc-hierarchy.md`
