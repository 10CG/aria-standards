# Change Proposal: extract-memory-service

> **Status**: Approved
> **Created**: 2026-01-04
> **Updated**: 2026-01-05
> **Author**: AI Assistant
> **Priority**: P0
> **Depends-On**: complete-requirements-chain (blocked until this completes)

---

## 1. Summary

将 AI 记忆系统从 Backend 独立为 Memory 服务，作为独立微服务部署，拥有独立的 PostgreSQL + pgvector 实例。

> **Aria 定位**: 本 Change 是 **Pre-Cycle 架构决策**，需要在创建 User Stories 之前完成，因为它重新定义了模块边界。

### 1.1 技术栈确认 (2026-01-05 Tech-Lead 评审)

| 组件 | MVP 选择 | 理由 |
|------|---------|------|
| **Web 框架** | FastAPI | 团队熟悉，AI/ML 生态完善 |
| **图谱引擎** | Fast GraphRAG | 轻量，无 Neo4j 依赖，微软支持 |
| **用户档案** | Mem0 | 开箱即用的记忆协调 |
| **对话历史** | Zep | 成熟的时序图谱方案 |
| **LLM 部署** | Ollama | 零配置，OpenAI 兼容接口 |
| **向量存储** | pgvector | PostgreSQL 原生，统一存储 |

> **核心结论**: AI/ML 核心组件 100% Python 原生，性能瓶颈在 GPU 推理层（占延迟 80%+），语言选择对总延迟影响 <1%。

---

## 2. Why

### 2.1 背景

当前架构将 AI 记忆系统放在 Backend 模块内：

```
Backend (当前)
├── API 层 (用户、任务 CRUD)
├── 业务逻辑层
├── AI 记忆系统 ← 复杂度高，技术栈差异大
│   ├── Mem0 (记忆协调/用户档案)
│   ├── Zep (时序图谱/对话历史)
│   ├── Fast GraphRAG (知识图谱/多跳检索)
│   └── Triplex 3.8B via Ollama (知识提取) ← 需要 GPU
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
│  │  ┌─────────┐ ┌─────────┐ ┌───────────────┐                  │   │
│  │  │  Mem0   │ │   Zep   │ │ Fast GraphRAG │                  │   │
│  │  │ (用户档案)│ │(对话历史)│ │  (知识图谱)   │                  │   │
│  │  └────┬────┘ └────┬────┘ └───────┬───────┘                  │   │
│  │       └───────────┼──────────────┘                          │   │
│  │                   ▼                                          │   │
│  │           LLMClient (OpenAI 兼容)                            │   │
│  └───────────────────┼─────────────────────────────────────────┘   │
│                      │                                              │
│  ┌───────────────────▼──────────────────────────────────────────┐  │
│  │              PostgreSQL + pgvector (Memory)                   │  │
│  │  memories | vectors | knowledge_graph | temporal_edges        │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
                              │ HTTP (localhost:11434)
                              ↓
                      ┌───────────────┐
                      │    Ollama     │
                      │ Triplex 3.8B  │
                      │    (GPU)      │
                      └───────────────┘
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
| Memory 技术栈 | FastAPI (Python) | AI/ML 生态 100% Python 原生，团队熟悉 |
| 图谱引擎 | Fast GraphRAG | 轻量无 Neo4j 依赖，微软支持，OpenAI 兼容 |
| LLM 推理 | Ollama | 零配置，OpenAI 兼容接口，易调试 |
| PostgreSQL | 独立实例 | 完全隔离，独立优化向量索引 |
| 服务通信 | REST API | 简单可靠，后续可升级 gRPC |
| 服务认证 | API Key | 内部服务间认证 |

**技术栈选择理由 (Tech-Lead 评审)**:

1. **性能瓶颈分析**: 典型请求延迟分解
   - HTTP 解析: ~1ms (语言选择影响)
   - 向量嵌入: ~10-50ms (模型推理)
   - 图谱查询: ~10-50ms (Fast GraphRAG)
   - 知识提取: ~100-500ms (Triplex GPU 推理)
   - **结论**: 语言选择对总延迟影响 <1%

2. **生态兼容性**: Mem0、Zep、Fast GraphRAG 均为 Python 原生库

3. **演进友好**: 架构设计预留扩展点，未来可平滑迁移至 Ray Serve

### 3.4 部署架构 (MVP 阶段)

```yaml
机器 A (普通服务器):
  - Backend Service (:8000)
  - Backend PostgreSQL (:5432)
  - Redis (可选)

机器 B (GPU 服务器):
  - Memory Service (:8001)
  - Memory PostgreSQL + pgvector (:5433)
  - Ollama + Triplex 3.8B (:11434)
```

### 3.5 分阶段演进路线

```
Phase 1: MVP (0-3月)           Phase 2: 成长期 (3-9月)         Phase 3: 规模化 (9-18月)
─────────────────────          ─────────────────────          ─────────────────────
FastAPI 单体                   FastAPI + vLLM 分离            三层分离架构
Ollama 本地推理                Redis 缓存层                    FastAPI → Ray Serve → vLLM
Docker Compose                 K8s 单节点                      KubeRay 集群
单 GPU 服务器                  2-3 台服务器                    K8s 集群 (10+ 节点)
< 1000 用户                    1000-10000 用户                 10万+ 用户
```

**演进触发条件**:

| 信号 | 阈值 | 触发动作 |
|------|------|----------|
| GPU 利用率 | 持续 > 80% | 评估 vLLM 分离部署 |
| 需要多模型 | 第二个 LLM | 评估 vLLM 多模型支持 |
| 日活用户 | > 5000 | 评估 K8s 部署 |
| 团队规模 | > 5 人 | 评估服务拆分 |
| A/B 测试需求 | 模型实验 | 评估 Ray Serve 流量分发 |

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
- Ollama/Triplex 详细部署配置（独立 Change）
- Ray Serve / vLLM 集成（Phase 2/3 演进内容）
- 三层分离架构实现（规模化阶段）

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
