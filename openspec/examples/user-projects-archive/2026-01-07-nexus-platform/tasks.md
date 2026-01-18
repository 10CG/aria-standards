# Tasks: nexus-platform

## Task Overview

> **注意**: 本 Change 使用 "Stage" 而非 "Phase"，避免与 Aria 十步循环混淆。

| Stage | 任务数 | 状态 | 描述 |
|-------|--------|------|------|
| Stage 0: 架构决策 | 5 | ✅ 完成 | 确定关键架构决策 |
| Stage 1: 仓库初始化 | 5 | ✅ 完成 | 创建独立仓库和文档 |
| Stage 2: 核心服务 | 6 | ✅ 完成 | 实现核心 API |
| Stage 3: SDK 与文档 | 4 | ✅ 完成 | Python SDK 和 API 文档 |
| Stage 4: 集成与测试 | 7 | ✅ 完成 | Todo App 集成 |

**总计**: 27 个任务

---

## Stage 0: 架构决策

> 目标: 确定关键架构决策，为后续开发奠定基础

### Task 0.1: 确定仓库结构
- [x] 决定独立仓库 vs 子目录 → **独立仓库**
- [x] 确定仓库名称 → **nexus**
- [x] 创建 GitHub/Forgejo 仓库 → **https://forgejo.10cg.pub/10CG/nexus**

**产出**: 仓库 `nexus/` (已创建，含 README.md 和 .gitignore)

### Task 0.2: 多租户数据模型设计
- [x] 设计核心表结构 (tenants, api_keys, memories, etc.)
- [x] 设计 RLS 策略
- [x] 设计向量索引策略
- [x] 创建 ERD 图

**产出**: `docs/architecture/data-model.md` ✅

### Task 0.3: API 规范评审
- [x] 评审 API 端点设计
- [x] 确定认证机制 (API Key 格式)
- [x] 确定 Rate Limiting 策略
- [x] 创建 OpenAPI 初稿

**产出**: `docs/api/openapi.yaml` ✅

### Task 0.4: Backend 功能边界定义
- [x] 定义 AI Adapter Layer 职责边界
- [x] 确认 "数字元神" 人格层归属 Backend
- [x] 设计 Nexus 降级策略
- [x] 定义 Backend ↔ Nexus 用户 ID 映射方案
- [x] 创建 Backend AI 功能分层文档

**产出**: `backend/docs/architecture/nexus-integration.md`

**依赖**: Task 0.2, Task 0.3

### Task 0.5: Shared 边界决策
- [x] 确定 Nexus API 契约不放入 shared → **保持独立**
- [x] 定义 shared 边界规则文档
- [x] 设计 Mobile 展示模型 (TodoMemory, TodoConversation)
- [x] 设计 Backend ACL 转换策略

**产出**: `shared/docs/BOUNDARY_RULES.md`

**依赖**: Task 0.3

---

## Stage 1: 仓库初始化

> 目标: 创建独立仓库，建立项目骨架
> **状态**: ✅ 完成

### Task 1.1: 创建仓库骨架
- [x] 初始化 Git 仓库
- [x] 创建目录结构 (src/, docs/, sdk/, tests/, migrations/)
- [x] 创建 `pyproject.toml`
- [x] 创建 `.gitignore`
- [x] 创建 `README.md`

**产出**: 仓库基础结构 ✅

### Task 1.2: 创建 Nexus CLAUDE.md
- [x] 创建 `CLAUDE.md`
- [x] 定义项目概述
- [x] 定义技术栈
- [x] 定义常用命令
- [x] 引用 Standards

**产出**: `nexus/CLAUDE.md` ✅

### Task 1.3: 创建 Nexus PRD

> **PRD vs OpenSpec 边界说明**:
> - `proposal.md` = 技术变更提案，关注"如何做" (How)，Change 完成后归档
> - `prd-nexus.md` = 产品需求定义，关注"做什么" (What)，长期维护
> - PRD 通过引用 proposal.md 避免内容重复

- [x] 产品定位
- [x] 功能需求 (用户故事格式)
- [x] 非功能需求
- [x] 路线图
- [x] 关联文档

**产出**: `nexus/docs/requirements/prd-nexus.md` ✅

### Task 1.4: 创建 Nexus ARCHITECTURE.md
- [x] 创建 `docs/ARCHITECTURE.md`
- [x] 定义高阶架构图
- [x] 定义服务层职责
- [x] 定义数据模型
- [x] 定义多租户隔离策略
- [x] 定义分阶段演进路线

**产出**: `docs/ARCHITECTURE.md` ✅

### Task 1.5: 创建数据库迁移脚本
- [x] 初始化 Alembic
- [x] 创建 tenants 表迁移
- [x] 创建 api_keys 表迁移
- [x] 创建 memories 表迁移 (含 pgvector)
- [x] 创建 conversations 表迁移
- [x] 创建 graph_nodes/edges 表迁移
- [x] 创建 usage_logs/failed_tasks 表迁移

**产出**: `migrations/versions/001_initial_schema.py` ✅

---

## Stage 2: 核心服务

> 目标: 实现核心 API 功能
> **状态**: ✅ 完成

### Task 2.1: 项目配置与入口
- [x] 创建 `src/nexus/config/settings.py`
- [x] 创建 `src/nexus/main.py` (FastAPI 入口)
- [x] 配置 CORS, 日志, 错误处理
- [x] 配置数据库连接池

**产出**: FastAPI 应用骨架 ✅

### Task 2.2: 认证中间件
- [x] 创建 `src/nexus/middleware/auth.py`
- [x] 实现 API Key 验证
- [x] 实现租户上下文注入
- [x] 创建 `src/nexus/middleware/rate_limit.py`

**产出**: 认证和限流中间件 ✅

### Task 2.3: 租户管理服务
- [x] 创建 `src/nexus/schemas/tenant.py`
- [x] 创建 `src/nexus/services/tenant_service.py`
- [x] 创建 `src/nexus/api/tenants.py`
- [x] 实现租户 CRUD
- [x] 实现 API Key 管理

**产出**: `/v1/tenants/*` API ✅

### Task 2.4: Memory 服务
- [x] 创建 `src/nexus/schemas/memory.py`
- [x] 创建 `src/nexus/services/memory_service.py`
- [x] 创建 `src/nexus/api/memories.py`
- [x] 实现 CRUD API
- [x] 实现全文搜索 API (语义搜索待集成 embedding)

**产出**: `/v1/memories/*` API ✅

### Task 2.5: Conversation 服务
- [x] 创建 `src/nexus/schemas/conversation.py`
- [x] 创建 `src/nexus/services/conversation_service.py`
- [x] 创建 `src/nexus/api/conversations.py`
- [x] 实现对话 CRUD API
- [x] 实现消息添加 API

**产出**: `/v1/conversations/*` API ✅

### Task 2.6: Context 服务 (核心聚合 API)
- [x] 创建 `src/nexus/schemas/context.py`
- [x] 创建 `src/nexus/services/context_service.py`
- [x] 创建 `src/nexus/api/context.py`
- [x] 实现 `/v1/context/retrieve` 聚合 API

**产出**: `/v1/context/retrieve` API ✅

---

## Stage 3: SDK 与文档

> 目标: 创建 Python SDK 和 API 文档
> **状态**: ✅ 完成

### Task 3.1: Python SDK 核心
- [x] 创建 `sdk/python/nexus_sdk/client.py`
- [x] 实现 HTTP 客户端基础
- [x] 实现认证处理
- [x] 实现错误处理
- [x] 实现重试机制

**产出**: SDK 核心模块 ✅

### Task 3.2: Python SDK 功能模块
- [x] 创建 `sdk/python/nexus_sdk/memories.py`
- [x] 创建 `sdk/python/nexus_sdk/conversations.py`
- [x] 创建 `sdk/python/nexus_sdk/context.py`

**产出**: SDK 功能模块 ✅

### Task 3.3: SDK 打包与发布
- [x] 创建 `sdk/python/pyproject.toml`
- [x] 编写 `sdk/python/README.md`

**产出**: `nexus-sdk` 包 ✅

### Task 3.4: API 文档
- [x] 创建 Quick Start Guide (`docs/guides/quick-start.md`)

**产出**: Quick Start 文档 ✅

---

## Stage 4: 集成与测试

> 目标: 与 Todo App 集成，验证端到端功能
> **状态**: ✅ 完成

### Task 4.1: Docker 部署配置
- [x] 创建 `Dockerfile`
- [x] 创建 `docker-compose.yml`
- [x] 配置 PostgreSQL + pgvector
- [x] 配置 Ollama
- [x] 创建 `.dockerignore`

**产出**: Docker 部署配置 ✅

### Task 4.2: 更新 Todo App 文档
- [x] 更新 `docs/architecture/system-architecture.md` (三服务架构)
- [ ] 更新 `docs/requirements/prd-todo-app-v1.md` (添加 Nexus)
- [ ] 更新 `backend/docs/requirements/prd-backend.md` (调用 Nexus)
- [ ] 更新 `backend/docs/ARCHITECTURE.md`

**产出**: 更新后的项目文档 (部分完成)

### Task 4.3: Backend 集成
- [x] 添加 Nexus 配置到 `backend/app/core/config.py`
- [x] 创建 `backend/app/adapters/nexus/` 模块
- [x] 创建 NexusAdapter 基础类 (含 CircuitBreaker)
- [x] 集成 Memory API 调用
- [x] 集成 Conversation API 调用
- [x] 集成 Context API 调用

**产出**: Backend Nexus Adapter ✅

### Task 4.4: 端到端测试
- [x] 创建集成测试用例
- [x] 测试租户创建流程
- [x] 测试 Memory CRUD 流程
- [x] 测试 Conversation 流程
- [x] 测试 Backend → Nexus 调用链

**产出**: `nexus/tests/integration/test_api.py` ✅

### Task 4.5: Backend AI Adapter Layer 实现
- [x] 创建 `backend/app/adapters/nexus/` 模块
- [x] 实现 NexusAdapter 基础类
- [x] 实现 Memory 适配器 (调用 nexus-sdk)
- [x] 实现 Conversation 适配器
- [x] 实现 "数字元神" 人格层接口
- [x] 实现降级策略 (CircuitBreaker + Fallback)
- [x] 编写单元测试和集成测试

**产出**: `backend/app/adapters/nexus/personality.py` ✅

**依赖**: Task 4.3

### Task 4.6: Shared 展示模型定义
- [x] 创建 `shared/schemas/ai/` 目录
- [x] 定义 `memory.schema.json` (TodoMemory)
- [x] 定义 `conversation.schema.json` (TodoConversation)
- [ ] 生成 Dart 模型 (Mobile) - 待 Mobile 集成时完成
- [x] 生成 Python 模型 (Backend)
- [ ] 更新 `shared/README.md` 边界说明

**产出**: `shared/schemas/ai/*.schema.json` ✅

**依赖**: Task 0.5

### Task 4.7: Backend Transformer 实现
- [x] 创建 `backend/app/adapters/nexus/transformers.py`
- [x] 实现 MemoryTransformer (NexusMemory → TodoMemory)
- [x] 实现 ConversationTransformer (NexusConversation → TodoConversation)
- [x] 编写转换器单元测试
- [ ] 集成到 Backend API 响应 - 待 API 端点实现时完成

**产出**: `backend/app/adapters/nexus/transformers.py` ✅

**依赖**: Task 4.5, Task 4.6

---

## 依赖关系

```
Stage 0 (架构决策)
    │
    ├── Task 0.1 ──┐
    ├── Task 0.2 ──┤ (可并行)
    ├── Task 0.3 ──┘
    │              │
    ├── Task 0.4 ←─┤ (依赖 0.2, 0.3)
    └── Task 0.5 ←─┘ (依赖 0.3)
    │
    ▼
Stage 1 (仓库初始化)
    │
    ├── Task 1.1 → Task 1.2 ──┐
    │                         │
    ├── Task 1.3 ←────────────┤ (依赖 1.1)
    ├── Task 1.4 ←────────────┤
    └── Task 1.5 ←────────────┘
    │
    ▼
Stage 2 (核心服务)
    │
    ├── Task 2.1 → Task 2.2 ──┐
    │                         │
    ├── Task 2.3 ←────────────┤ (依赖 2.2)
    ├── Task 2.4 ←────────────┤
    ├── Task 2.5 ←────────────┤
    └── Task 2.6 ←────────────┘
    │
    ▼
Stage 3 (SDK 与文档) ←─────────────────────────┐
    │                                           │
    ├── Task 3.1 → Task 3.2 → Task 3.3         │
    └── Task 3.4 (可与 3.1-3.3 并行)            │
    │                                           │
    ▼                                           │
Stage 4 (集成与测试) ←──────────────────────────┘
    │
    ├── Task 4.1 ──┐
    ├── Task 4.2 ──┤ (可并行)
    │              │
    ├── Task 4.3 ←─┘
    │         │
    ├── Task 4.4
    │
    ├── Task 4.5 ←── Task 4.3
    │         │
    ├── Task 4.6 ←── Task 0.5
    │         │
    └── Task 4.7 ←── Task 4.5 + Task 4.6
```

---

## 验证标准

| Stage | 验证项 | 标准 |
|-------|--------|------|
| Stage 0 | 仓库创建 | GitHub/Forgejo 仓库存在 |
| Stage 0 | 数据模型 | ERD 图完成 |
| Stage 0 | Backend 边界 | nexus-integration.md 文档完成 |
| Stage 0 | Shared 边界 | BOUNDARY_RULES.md 文档完成 |
| Stage 1 | 项目骨架 | 目录结构完整 |
| Stage 1 | 文档完整 | PRD + ARCHITECTURE 存在 |
| Stage 1 | 迁移脚本 | Alembic 可执行 |
| Stage 2 | API 可用 | `/v1/health` 返回 200 |
| Stage 2 | 认证工作 | API Key 验证通过 |
| Stage 2 | Memory API | CRUD + 搜索功能正常 |
| Stage 3 | SDK 可用 | `pip install nexus-sdk` 成功 |
| Stage 3 | 文档完整 | OpenAPI 验证通过 |
| Stage 4 | Docker 部署 | `docker-compose up` 成功 |
| Stage 4 | 集成测试 | Backend → Nexus 调用成功 |
| Stage 4 | AI Adapter | 降级策略测试通过 |
| Stage 4 | 展示模型 | shared/schemas/ai/*.schema.json 存在 |
| Stage 4 | Transformer | 模型转换单元测试通过 |

---

## 完成后影响

完成本 Change 后：
1. `complete-requirements-chain` 可以解除阻塞
2. User Stories 可以按新的 Mobile / Backend / Nexus 架构创建
3. 后续开发按三条线并行:
   - Mobile: Flutter 客户端
   - Backend: FastAPI 业务服务
   - Nexus: AI 认知平台
4. Nexus 可被其他 AI 项目复用

---

## 资源估算

| 阶段 | 预估工时 | 说明 |
|------|----------|------|
| Stage 0 | 1 周 | 决策 + Backend/Shared 边界定义 |
| Stage 1 | 1 周 | 仓库和文档 |
| Stage 2 | 2-3 周 | 核心服务实现 |
| Stage 3 | 1 周 | SDK 和文档 |
| Stage 4 | 2 周 | 集成、测试 + AI Adapter + Transformer |
| **总计** | **7-8 周** | MVP 阶段 |
