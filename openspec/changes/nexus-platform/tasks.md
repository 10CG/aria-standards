# Tasks: nexus-platform

## Task Overview

> **注意**: 本 Change 使用 "Stage" 而非 "Phase"，避免与 Aria 十步循环混淆。

| Stage | 任务数 | 状态 | 描述 |
|-------|--------|------|------|
| Stage 0: 架构决策 | 5 | 🔄 进行中 | 确定关键架构决策 |
| Stage 1: 仓库初始化 | 5 | ⏳ 待开始 | 创建独立仓库和文档 |
| Stage 2: 核心服务 | 6 | ⏳ 待开始 | 实现核心 API |
| Stage 3: SDK 与文档 | 4 | ⏳ 待开始 | Python SDK 和 API 文档 |
| Stage 4: 集成与测试 | 7 | ⏳ 待开始 | Todo App 集成 |

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
- [ ] 定义 shared 边界规则文档
- [ ] 设计 Mobile 展示模型 (TodoMemory, TodoConversation)
- [ ] 设计 Backend ACL 转换策略

**产出**: `shared/docs/BOUNDARY_RULES.md`

**依赖**: Task 0.3

---

## Stage 1: 仓库初始化

> 目标: 创建独立仓库，建立项目骨架

### Task 1.1: 创建仓库骨架
- [ ] 初始化 Git 仓库
- [ ] 创建目录结构 (src/, docs/, sdk/, tests/, migrations/)
- [ ] 创建 `pyproject.toml`
- [ ] 创建 `.gitignore`
- [ ] 创建 `README.md`

**产出**: 仓库基础结构

### Task 1.2: 创建 Nexus CLAUDE.md
- [ ] 创建 `CLAUDE.md`
- [ ] 定义项目概述
- [ ] 定义技术栈
- [ ] 定义常用命令
- [ ] 引用 Standards

**产出**: `nexus/CLAUDE.md`

### Task 1.3: 创建 Nexus PRD

> **PRD vs OpenSpec 边界说明**:
> - `proposal.md` = 技术变更提案，关注"如何做" (How)，Change 完成后归档
> - `prd-nexus.md` = 产品需求定义，关注"做什么" (What)，长期维护
> - PRD 通过引用 proposal.md 避免内容重复

#### 1. 产品定位 (扩展 proposal.md)
- [ ] 产品愿景声明
- [ ] 目标用户画像 (租户类型: AI 应用开发团队)
- [ ] 核心价值主张
- [ ] 与竞品差异化 (自托管、数据主权、可定制)

#### 2. 功能需求 (用户故事格式)
- [ ] **Memory Service**
  - 用户故事 (作为租户，我希望...)
  - 使用场景 (记忆创建、语义检索、记忆关联)
  - 验收标准 (AC)
- [ ] **Conversation Service**
  - 用户故事
  - 使用场景 (对话管理、消息追加、摘要生成)
  - 验收标准
- [ ] **Knowledge Service** (Phase 2 占位)
  - 高层描述
  - 预期能力
- [ ] **Tenant Management**
  - 用户故事
  - 使用场景 (租户注册、API Key 管理、配额管理)
  - 验收标准

#### 3. 非功能需求
- [ ] **性能**: P95 延迟 < 200ms, 吞吐量目标
- [ ] **安全**: API 认证、数据加密、审计日志、RLS 隔离
- [ ] **可用性**: SLA 目标、灾备策略
- [ ] **可扩展性**: 水平扩展、租户隔离

#### 4. 路线图
- [ ] MVP 功能清单 (引用 proposal.md Phase 1)
- [ ] Phase 2/3/4 功能预览
- [ ] 长期愿景

#### 5. 关联文档
- [ ] 引用 `openspec/changes/nexus-platform/proposal.md` (架构决策)
- [ ] 引用 `todo-app PRD` (首个租户关系说明)

**产出**: `nexus/docs/requirements/prd-nexus.md`

**依赖**: Task 1.1 (仓库骨架), Stage 0 完成 (架构决策确定)

### Task 1.4: 创建 Nexus ARCHITECTURE.md
- [ ] 创建 `docs/ARCHITECTURE.md`
- [ ] 定义高阶架构图
- [ ] 定义服务层职责
- [ ] 定义数据模型
- [ ] 定义多租户隔离策略
- [ ] 定义分阶段演进路线

**产出**: `docs/ARCHITECTURE.md`

### Task 1.5: 创建数据库迁移脚本
- [ ] 初始化 Alembic
- [ ] 创建 tenants 表迁移
- [ ] 创建 api_keys 表迁移
- [ ] 创建 memories 表迁移 (含 pgvector)
- [ ] 创建 conversations 表迁移
- [ ] 创建 RLS 策略迁移

**产出**: `migrations/versions/*.py`

---

## Stage 2: 核心服务

> 目标: 实现核心 API 功能

### Task 2.1: 项目配置与入口
- [ ] 创建 `src/nexus/config/settings.py`
- [ ] 创建 `src/nexus/main.py` (FastAPI 入口)
- [ ] 配置 CORS, 日志, 错误处理
- [ ] 配置数据库连接池

**产出**: FastAPI 应用骨架

### Task 2.2: 认证中间件
- [ ] 创建 `src/nexus/middleware/auth.py`
- [ ] 实现 API Key 验证
- [ ] 实现租户上下文注入
- [ ] 创建 `src/nexus/middleware/rate_limit.py`

**产出**: 认证和限流中间件

### Task 2.3: 租户管理服务
- [ ] 创建 `src/nexus/models/tenant.py`
- [ ] 创建 `src/nexus/services/tenant_service.py`
- [ ] 创建 `src/nexus/api/tenants.py`
- [ ] 实现租户 CRUD
- [ ] 实现 API Key 管理

**产出**: `/v1/tenants/*` API

### Task 2.4: Memory 服务
- [ ] 创建 `src/nexus/models/memory.py`
- [ ] 创建 `src/nexus/services/memory_service.py`
- [ ] 集成 Mem0
- [ ] 创建 `src/nexus/api/memories.py`
- [ ] 实现 CRUD API
- [ ] 实现语义搜索 API

**产出**: `/v1/memories/*` API

### Task 2.5: Conversation 服务
- [ ] 创建 `src/nexus/models/conversation.py`
- [ ] 创建 `src/nexus/services/conversation_service.py`
- [ ] 集成 Zep
- [ ] 创建 `src/nexus/api/conversations.py`
- [ ] 实现对话 CRUD API
- [ ] 实现消息添加 API
- [ ] 实现摘要获取 API

**产出**: `/v1/conversations/*` API

### Task 2.6: LLM Client
- [ ] 创建 `src/nexus/services/llm_client.py`
- [ ] 实现 OpenAI 兼容接口
- [ ] 支持 Ollama 后端
- [ ] 实现 embedding 生成
- [ ] 实现文本摘要

**产出**: LLM 统一客户端

---

## Stage 3: SDK 与文档

> 目标: 创建 Python SDK 和 API 文档

### Task 3.1: Python SDK 核心
- [ ] 创建 `sdk/python/nexus_sdk/client.py`
- [ ] 实现 HTTP 客户端基础
- [ ] 实现认证处理
- [ ] 实现错误处理
- [ ] 实现重试机制

**产出**: SDK 核心模块

### Task 3.2: Python SDK 功能模块
- [ ] 创建 `sdk/python/nexus_sdk/memories.py`
- [ ] 创建 `sdk/python/nexus_sdk/conversations.py`
- [ ] 创建 `sdk/python/nexus_sdk/knowledge.py` (占位)
- [ ] 编写单元测试

**产出**: SDK 功能模块

### Task 3.3: SDK 打包与发布
- [ ] 创建 `sdk/python/setup.py`
- [ ] 创建 `sdk/python/pyproject.toml`
- [ ] 编写 `sdk/python/README.md`
- [ ] 发布到内部 PyPI (可选)

**产出**: `nexus-sdk` 包

### Task 3.4: API 文档
- [ ] 完善 `docs/api/openapi.yaml`
- [ ] 创建 Quick Start Guide
- [ ] 创建 API Reference
- [ ] 创建使用示例

**产出**: 完整 API 文档

---

## Stage 4: 集成与测试

> 目标: 与 Todo App 集成，验证端到端功能

### Task 4.1: Docker 部署配置
- [ ] 创建 `Dockerfile`
- [ ] 创建 `docker-compose.yml`
- [ ] 配置 PostgreSQL + pgvector
- [ ] 配置 Ollama
- [ ] 编写部署文档

**产出**: Docker 部署配置

### Task 4.2: 更新 Todo App 文档
- [ ] 更新 `docs/requirements/prd-todo-app-v1.md` (添加 Nexus)
- [ ] 更新 `docs/architecture/system-architecture.md` (三服务架构)
- [ ] 更新 `backend/docs/requirements/prd-backend.md` (调用 Nexus)
- [ ] 更新 `backend/docs/ARCHITECTURE.md`

**产出**: 更新后的项目文档

### Task 4.3: Backend 集成
- [ ] 在 Backend 添加 `nexus-sdk` 依赖
- [ ] 创建 `backend/app/services/nexus_client.py`
- [ ] 集成 Memory API 调用
- [ ] 集成 Conversation API 调用

**产出**: Backend 与 Nexus 集成

### Task 4.4: 端到端测试
- [ ] 创建集成测试用例
- [ ] 测试租户创建流程
- [ ] 测试 Memory CRUD 流程
- [ ] 测试 Conversation 流程
- [ ] 测试 Backend → Nexus 调用链

**产出**: 集成测试报告

### Task 4.5: Backend AI Adapter Layer 实现
- [ ] 创建 `backend/app/adapters/nexus/` 模块
- [ ] 实现 NexusAdapter 基础类
- [ ] 实现 Memory 适配器 (调用 nexus-sdk)
- [ ] 实现 Conversation 适配器
- [ ] 实现 "数字元神" 人格层接口
- [ ] 实现降级策略 (CircuitBreaker + Fallback)
- [ ] 编写单元测试和集成测试

**产出**: Backend AI Adapter Layer 完整实现

**依赖**: Task 4.3

### Task 4.6: Shared 展示模型定义
- [ ] 创建 `shared/schemas/ai/` 目录
- [ ] 定义 `memory.schema.json` (TodoMemory)
- [ ] 定义 `conversation.schema.json` (TodoConversation)
- [ ] 生成 Dart 模型 (Mobile)
- [ ] 生成 Python 模型 (Backend)
- [ ] 更新 `shared/README.md` 边界说明

**产出**: `shared/schemas/ai/*.schema.json`

**依赖**: Task 0.5

### Task 4.7: Backend Transformer 实现
- [ ] 创建 `backend/app/adapters/nexus/transformers.py`
- [ ] 实现 MemoryTransformer (NexusMemory → TodoMemory)
- [ ] 实现 ConversationTransformer (NexusConversation → TodoConversation)
- [ ] 编写转换器单元测试
- [ ] 集成到 Backend API 响应

**产出**: Backend 模型转换层

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
