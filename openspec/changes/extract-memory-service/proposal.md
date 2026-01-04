# Change Proposal: extract-memory-service

> **Status**: Approved
> **Created**: 2026-01-04
> **Author**: AI Assistant
> **Priority**: P0
> **Depends-On**: complete-requirements-chain (blocked until this completes)

---

## 1. Summary

将 AI 记忆系统从 Backend 独立为 Memory 服务，作为独立微服务部署，拥有独立的 PostgreSQL + pgvector 实例。

> **Aria 定位**: 本 Change 是 **Pre-Cycle 架构决策**，需要在创建 User Stories 之前完成，因为它重新定义了模块边界。

---

## 2. Why

### 2.1 背景

当前架构将 AI 记忆系统放在 Backend 模块内：

```
Backend (当前)
├── API 层 (用户、任务 CRUD)
├── 业务逻辑层
├── AI 记忆系统 ← 复杂度高，技术栈差异大
│   ├── Mem0 (记忆协调)
│   ├── Zep/Graphiti (时序图谱)
│   ├── HippoRAG (多跳检索)
│   └── Triplex 3.8B (知识提取) ← 需要 GPU
└── PostgreSQL + pgvector
```

### 2.2 问题

| 问题 | 严重度 | 影响 |
|------|--------|------|
| **部署耦合** | P0 | Triplex 需要 GPU，业务 API 不需要 |
| **扩展困难** | P0 | AI 记忆无法独立扩展 |
| **故障级联** | P1 | AI 组件故障影响基础 CRUD |
| **资源竞争** | P1 | GPU/CPU 资源混用 |
| **未来重构成本** | P1 | 现在 Backend 代码量少，拆分成本最低 |

### 2.3 决策理由

1. **时机最佳** - Backend 尚未深度开发，无重构成本
2. **产品定位** - "数字元神"是核心差异化，值得独立服务
3. **技术需求** - Triplex GPU 部署支持独立架构
4. **降级能力** - Memory 故障时 Backend 可继续提供基础功能

---

## 3. What Changes

### 3.1 目标架构

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Mobile App (Flutter)                         │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              │ RESTful API
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│                    Backend Service                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────────┐  │
│  │  API 层     │  │  业务逻辑    │  │   Memory Client             │  │
│  │  FastAPI    │  │  Services   │  │   (调用 Memory Service)     │  │
│  └─────────────┘  └─────────────┘  └─────────────────────────────┘  │
│                              │                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │              PostgreSQL (Backend)                             │   │
│  │  users | tasks | sync_logs | settings                         │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              │ Internal API (REST)
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│                    Memory Service (独立服务)                         │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                   AI Memory Core                             │   │
│  │  Mem0 (协调) + Zep (时序) + HippoRAG (检索) + Triplex (提取) │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │              PostgreSQL + pgvector (Memory)                   │   │
│  │  memories | vectors | knowledge_graph | temporal_edges        │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ↓ (脱敏数据)
                        Cloud LLM API
```

### 3.2 新模块结构

```
todo-app/
├── mobile/
├── backend/                   # 简化：移除 AI 记忆详细实现
├── memory/                    # 新模块：AI 记忆服务
│   ├── CLAUDE.md
│   ├── docs/
│   │   ├── ARCHITECTURE.md
│   │   ├── requirements/
│   │   │   └── prd-memory.md
│   │   └── project-planning/
│   │       └── unified-progress-management.md
│   ├── app/
│   │   ├── main.py
│   │   ├── api/
│   │   ├── services/
│   │   └── models/
│   ├── Dockerfile
│   └── docker-compose.yml
├── shared/
│   └── contracts/
│       ├── backend-api.yaml
│       └── memory-api.yaml    # 新：Memory 服务 API 契约
└── standards/
```

### 3.3 技术决策

| 决策 | 选择 | 理由 |
|------|------|------|
| Memory 技术栈 | FastAPI | 与 Backend 一致，先完成拆分 |
| PostgreSQL | 独立实例 | 完全隔离，独立优化 |
| 服务通信 | REST API | 简单可靠，后续可升级 gRPC |
| 服务认证 | API Key | 内部服务间认证 |

### 3.4 部署架构

```yaml
机器 A (普通服务器):
  - Backend Service (:8000)
  - Backend PostgreSQL (:5432)
  - Redis (可选)

机器 B (GPU 服务器):
  - Memory Service (:8001)
  - Memory PostgreSQL + pgvector (:5433)
  - Triplex 3.8B (GPU)
```

---

## 4. Success Criteria

- [ ] Memory 模块结构创建完成
- [ ] Memory PRD 和 ARCHITECTURE.md 创建
- [ ] 项目 PRD 更新（添加 Memory 模块）
- [ ] System Architecture 更新（新架构图）
- [ ] Backend PRD 简化（移除 AI 记忆详细描述）
- [ ] Memory API 契约定义 (OpenAPI)
- [ ] **complete-requirements-chain 解除阻塞**

---

## 5. Out of Scope

- Memory 服务代码实现（本 Change 仅聚焦架构文档）
- Docker Compose 配置（独立 Change）
- 技术栈替换讨论（FastAPI → Go/Rust，后续评估）
- Triplex 部署配置

---

## 6. References

- Parent PRD: `docs/requirements/prd-todo-app-v1.md`
- System Architecture: `docs/architecture/system-architecture.md`
- Backend PRD: `backend/docs/requirements/prd-backend.md`
- Standards:
  - `standards/core/documentation/product-doc-hierarchy.md`
  - `standards/core/documentation/system-architecture-spec.md`
  - `standards/methodology/aria-brand-guide.md`

---

## 7. Impact on Other Changes

| Change | 影响 |
|--------|------|
| `complete-requirements-chain` | **阻塞** - 需要先完成本 Change 以确定模块边界 |
| 后续 User Stories | 需要基于新的三模块架构创建 |
