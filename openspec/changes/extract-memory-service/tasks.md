# Tasks: extract-memory-service

## Task Overview

> **注意**: 本 Change 使用 "Stage" 而非 "Phase"，避免与 Aria 十步循环混淆。

| Stage | 任务数 | 状态 |
|-------|--------|------|
| Stage 1: Memory 模块创建 | 4 | ⏳ 待开始 |
| Stage 2: 文档更新 | 4 | ⏳ 待开始 |
| Stage 3: 契约定义 | 2 | ⏳ 待开始 |

---

## Stage 1: Memory 模块创建

> 目标: 创建 Memory 模块基础结构和文档

### Task 1.1: 创建模块目录结构
- [ ] 创建 `memory/` 目录
- [ ] 创建 `memory/docs/` 子目录结构
- [ ] 创建 `memory/CLAUDE.md`

**产出**: Memory 模块骨架

### Task 1.2: 创建 Memory PRD
- [ ] 创建 `memory/docs/requirements/prd-memory.md`
- [ ] 定义 Memory 服务职责边界
- [ ] 定义 AI 记忆系统需求（从 Backend PRD 迁移）
- [ ] 定义非功能需求（性能、安全）

**产出**: `memory/docs/requirements/prd-memory.md`

### Task 1.3: 创建 Memory ARCHITECTURE.md
- [ ] 创建 `memory/docs/ARCHITECTURE.md`
- [ ] 定义技术架构（Mem0 + Zep + HippoRAG + Triplex）
- [ ] 定义数据流和存储架构
- [ ] 引用 Parent Documents

**产出**: `memory/docs/ARCHITECTURE.md`

### Task 1.4: 创建 Memory UPM
- [ ] 创建 `memory/docs/project-planning/unified-progress-management.md`
- [ ] 初始化 Phase/Cycle 状态

**产出**: Memory UPM 文档

---

## Stage 2: 文档更新

> 目标: 更新现有文档以反映新架构

### Task 2.1: 更新项目 PRD
- [ ] 在 `docs/requirements/prd-todo-app-v1.md` 添加 Memory 模块
- [ ] 更新模块边界表格
- [ ] 更新架构概览图

**产出**: 更新后的项目 PRD

### Task 2.2: 更新 System Architecture
- [ ] 更新 `docs/architecture/system-architecture.md`
- [ ] 重绘系统架构图（三服务架构）
- [ ] 更新模块职责边界
- [ ] 添加服务间通信说明

**产出**: 更新后的 System Architecture

### Task 2.3: 更新 Backend PRD
- [ ] 简化 `backend/docs/requirements/prd-backend.md`
- [ ] 移除 AI 记忆系统详细描述
- [ ] 添加"调用 Memory Service"说明
- [ ] 更新架构图

**产出**: 简化后的 Backend PRD

### Task 2.4: 更新 Backend ARCHITECTURE.md
- [ ] 更新 `backend/docs/ARCHITECTURE.md`
- [ ] 添加 Memory Client 层
- [ ] 移除 AI Memory Layer 详细描述
- [ ] 更新数据流图

**产出**: 更新后的 Backend 架构

---

## Stage 3: 契约定义

> 目标: 定义服务间 API 契约

### Task 3.1: 定义 Memory API 契约
- [ ] 创建 `shared/contracts/memory-api.yaml`
- [ ] 定义记忆管理 API (upload, query, delete)
- [ ] 定义分析 API (patterns, insights)
- [ ] 定义健康检查 API

**产出**: `shared/contracts/memory-api.yaml`

### Task 3.2: 更新 Shared 文档
- [ ] 更新 `shared/README.md` 添加 memory-api 说明
- [ ] 确保契约格式符合 OpenAPI 3.0

**产出**: 更新后的 Shared 文档

---

## 依赖关系

```
Stage 1 (Memory 模块创建)
    │
    ├── Task 1.1 → Task 1.2 → Task 1.3 → Task 1.4
    │
    ▼
Stage 2 (文档更新) ──────────────────────────────────┐
    │                                                 │
    ├── Task 2.1 ←──┐                                │
    ├── Task 2.2 ←──┤ (可并行)                       │
    ├── Task 2.3 ←──┤                                │
    └── Task 2.4 ←──┘                                │
    │                                                 │
    ▼                                                 │
Stage 3 (契约定义) ←──────────────────────────────────┘
    │
    └── Task 3.1 → Task 3.2
```

---

## 验证标准

| Stage | 验证项 | 标准 |
|-------|--------|------|
| Stage 1 | 模块结构 | memory/ 目录完整 |
| Stage 1 | PRD 存在 | prd-memory.md 创建 |
| Stage 1 | 架构存在 | ARCHITECTURE.md 创建 |
| Stage 2 | PRD 更新 | 项目 PRD 包含 Memory 模块 |
| Stage 2 | 架构更新 | 三服务架构图完成 |
| Stage 3 | 契约定义 | memory-api.yaml 通过 OpenAPI 验证 |

---

## 完成后影响

完成本 Change 后：
1. `complete-requirements-chain` 可以解除阻塞
2. User Stories 可以按新的三模块架构创建
3. 后续开发按 Mobile / Backend / Memory 三条线并行
