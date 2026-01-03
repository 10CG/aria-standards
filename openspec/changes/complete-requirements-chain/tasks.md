# Tasks: complete-requirements-chain

## Task Overview

> **注意**: 本 Change 使用 "Stage" 而非 "Phase"，避免与 Aria 十步循环的 Phase A/B/C/D 混淆。

| Stage | 任务数 | 状态 |
|-------|--------|------|
| Stage 1: User Stories 创建 | 4 | ⏳ 待开始 |
| Stage 2: 文档生命周期管理 | 3 | ⏳ 待开始 |
| Stage 3: 归档文档评估 | 2 | ⏳ 待开始 |

---

## Stage 1: User Stories 创建

> 目标: 从 PRD 分解 User Stories，建立需求追踪链路 (受 System Architecture 模块边界约束)

### Task 1.1: 分析 PRD 功能模块
- [ ] 阅读 `docs/requirements/prd-todo-app-v1.md`
- [ ] 阅读 `docs/architecture/system-architecture.md` (模块边界约束)
- [ ] 识别核心功能模块
- [ ] 列出可分解的 User Stories 清单

**产出**: User Stories 清单草稿

### Task 1.2: 创建 Story 模板
- [ ] 参考 `standards/templates/` 中的模板
- [ ] 定义 Story 格式 (Title, Description, Acceptance Criteria)
- [ ] 创建 `docs/requirements/user-stories/US-TEMPLATE.md`

**产出**: Story 模板

### Task 1.3: 批量创建 User Stories
- [ ] 创建 >= 10 个 User Stories
- [ ] 每个 Story 关联到 PRD 章节
- [ ] **每个 Story 尊重 System Architecture 模块边界**
- [ ] 标注优先级 (P0/P1/P2)
- [ ] 标注目标模块 (mobile/backend/shared)

**产出**: `docs/requirements/user-stories/US-*.md`

### Task 1.4: 验证 Story 质量
- [ ] 运行 `requirements-validator` 检查格式
- [ ] 运行 `requirements-validator` 检查链路完整性 (PRD → Architecture → Stories)
- [ ] 确保 Acceptance Criteria 可测试
- [ ] 运行 `requirements-sync` 同步 UPM 状态
- [ ] 更新 `docs/requirements/README.md` 索引

**产出**: 验证报告

---

## Stage 2: 文档生命周期管理

> 目标: 建立分析文档清理机制

### Task 2.1: 定义文档生命周期规范
- [ ] 创建 `standards/core/documentation/doc-lifecycle.md`
- [ ] 定义状态: draft → active → archived → deleted
- [ ] 定义清理规则和提醒机制

**产出**: 文档生命周期规范

### Task 2.2: 评估现有分析文档
- [ ] 扫描 `docs/analysis/` (30 个文件)
- [ ] 分类: 保留 / 迁移 / 清理
- [ ] 创建评估报告

**产出**: 分析文档评估表

### Task 2.3: 执行分析文档清理
- [ ] 迁移有价值内容到正式文档
- [ ] 归档或删除临时文档
- [ ] 更新目录结构

**产出**: 清理后的 `docs/analysis/`

---

## Stage 3: 归档文档评估

> 目标: 清理文档债务

### Task 3.1: 评估归档文档
- [ ] 扫描 `docs/archived/` (110 个文件)
- [ ] 分类: 可删除 / 保留 / 有参考价值
- [ ] 创建评估报告

**产出**: 归档文档评估表

### Task 3.2: 执行归档清理
- [ ] 删除无价值的历史文档
- [ ] 整理保留的参考文档
- [ ] 更新 `docs/archived/README.md`

**产出**: 清理后的 `docs/archived/`

---

## 依赖关系

```
Stage 1 (Stories)
    │
    ├── Task 1.1 → Task 1.2 → Task 1.3 → Task 1.4
    │
    ▼
Stage 2 (Lifecycle) ────────────────────────────────┐
    │                                               │
    ├── Task 2.1 → Task 2.2 → Task 2.3              │
    │                                               │
    ▼                                               │
Stage 3 (Cleanup) ←─────────────────────────────────┘
    │
    └── Task 3.1 → Task 3.2
```

---

## 验证标准

| Stage | 验证项 | 标准 |
|-------|--------|------|
| Stage 1 | Story 数量 | >= 10 个 |
| Stage 1 | 格式验证 | requirements-validator 通过 |
| Stage 1 | 链路完整性 | PRD → Architecture → Stories 验证通过 |
| Stage 2 | 规范创建 | doc-lifecycle.md 存在 |
| Stage 2 | 文档清理 | 分析文档 <= 10 个 |
| Stage 3 | 债务清理 | 归档文档评估完成 |
