# Change Proposal: nexus-platform

> **Status**: Approved
> **Created**: 2026-01-04
> **Updated**: 2026-01-05
> **Author**: AI Assistant
> **Priority**: P0
> **Depends-On**: complete-requirements-chain (blocked until this completes)

---

## 1. Summary

创建 **Nexus** - 通用 AI 认知服务平台，作为独立仓库部署，提供多租户的记忆、对话、知识图谱服务。

> **Aria 定位**: 本 Change 是 **Pre-Cycle 架构决策**，需要在创建 User Stories 之前完成，因为它重新定义了模块边界和服务架构。

### 1.1 产品定位

| 维度 | 定位 |
|------|------|
| **名称** | Nexus (连接点/枢纽) |
| **愿景** | 一站式 AI 认知服务平台 |
| **核心能力** | Memory + Conversation + Knowledge Graph |
| **差异化** | 本地部署、数据主权、完整认知栈 |

### 1.2 技术栈确认 (2026-01-05 Tech-Lead 评审)

| 组件 | 选择 | 理由 |
|------|------|------|
| **Web 框架** | FastAPI | AI/ML 生态 100% Python 原生 |
| **记忆协调** | Mem0 | 用户档案、偏好管理 |
| **对话历史** | Zep | 时序图谱、自动摘要 |
| **知识图谱** | Fast GraphRAG | 轻量、无 Neo4j 依赖、微软支持 |
| **知识提取** | Triplex 3.8B via Ollama | GPU 推理、OpenAI 兼容 |
| **向量存储** | PostgreSQL + pgvector | 统一存储、RLS 多租户 |
| **多租户** | Row Level Security (RLS) | MVP 阶段，<100 租户 |

---

## 2. Why

### 2.1 背景

原计划将 AI 记忆系统作为 Todo App Backend 的内部服务。经 Tech-Lead 评审，确认：
1. **已有其他 AI 项目** 需要类似的记忆服务
2. **通用化设计** 可复用于多个项目
3. **独立仓库** 便于开源/商业化

### 2.2 通用化价值

```
跨项目复用场景:
├── AI 助手类
│   ├── 客服机器人（用户历史、偏好）
│   ├── 个人助理（日程、习惯）
│   └── 教育辅导（学习进度、薄弱点）
├── AI 创作类
│   ├── 写作助手（风格偏好、主题历史）
│   └── 设计助手（设计风格、品牌记忆）
└── AI 分析类
    ├── 健康管理（行为模式、健康档案）
    └── 财务分析（消费习惯、投资偏好）
```

### 2.3 与竞品差异化

| 平台 | 定位 | Nexus 差异 |
|------|------|------------|
| Mem0 Cloud | 通用记忆框架 | Nexus 融合图谱能力 |
| Zep Cloud | 对话历史专注 | Nexus 提供完整认知栈 |
| Pinecone | 向量数据库 | Nexus 是应用层服务 |

---

## 3. What Changes

### 3.1 高阶架构

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              Client Applications                             │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐                    │
│  │   Todo App    │  │  Other AI     │  │   Future      │                    │
│  │   Backend     │  │   Projects    │  │   Clients     │                    │
│  └───────────────┘  └───────────────┘  └───────────────┘                    │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                    HTTPS + API Key (X-API-Key: nx_xxx)
                                    │
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                            Nexus Platform                                    │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                         API Gateway Layer                             │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐      │   │
│  │  │  Auth      │  │  Rate      │  │  Tenant    │  │  Request   │      │   │
│  │  │  Middleware│  │  Limiter   │  │  Context   │  │  Validator │      │   │
│  │  └────────────┘  └────────────┘  └────────────┘  └────────────┘      │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                         Service Layer                                 │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                │   │
│  │  │   Memory     │  │ Conversation │  │  Knowledge   │                │   │
│  │  │   Service    │  │   Service    │  │   Service    │                │   │
│  │  │   (Mem0)     │  │    (Zep)     │  │ (GraphRAG)   │                │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘                │   │
│  │         │                 │                 │                         │   │
│  │  ┌──────────────────────────────────────────────────────────────┐    │   │
│  │  │                  LLM Client (OpenAI Compatible)               │    │   │
│  │  └──────────────────────────────────────────────────────────────┘    │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                         Storage Layer                                 │   │
│  │  ┌──────────────────────────────────────────────────────────────┐    │   │
│  │  │              PostgreSQL + pgvector (RLS 多租户)               │    │   │
│  │  │  tenants | memories | conversations | knowledge_entities      │    │   │
│  │  └──────────────────────────────────────────────────────────────┘    │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                        HTTP (localhost:11434)
                                    │
                                    ↓
                          ┌───────────────────┐
                          │      Ollama       │
                          │  Triplex 3.8B     │
                          │  Embedding Model  │
                          └───────────────────┘
```

### 3.2 仓库结构 (独立仓库)

```
nexus/                           # 独立仓库: github.com/xxx/nexus
├── CLAUDE.md                    # AI 配置
├── README.md                    # 项目说明
├── docs/
│   ├── ARCHITECTURE.md          # 架构文档
│   ├── requirements/
│   │   └── prd-nexus.md         # PRD
│   ├── api/
│   │   └── openapi.yaml         # API 规范
│   └── project-planning/
│       └── unified-progress-management.md
├── src/
│   └── nexus/
│       ├── __init__.py
│       ├── main.py              # FastAPI 入口
│       ├── api/
│       │   ├── router.py
│       │   ├── memories.py
│       │   ├── conversations.py
│       │   ├── knowledge.py
│       │   └── tenants.py
│       ├── services/
│       │   ├── memory_service.py
│       │   ├── conversation_service.py
│       │   ├── knowledge_service.py
│       │   └── llm_client.py
│       ├── models/
│       │   ├── memory.py
│       │   ├── conversation.py
│       │   ├── knowledge.py
│       │   └── tenant.py
│       ├── middleware/
│       │   ├── auth.py
│       │   ├── rate_limit.py
│       │   └── tenant_context.py
│       └── config/
│           └── settings.py
├── sdk/
│   └── python/
│       ├── nexus_sdk/
│       │   ├── __init__.py
│       │   ├── client.py
│       │   ├── memories.py
│       │   ├── conversations.py
│       │   └── knowledge.py
│       ├── setup.py
│       └── README.md
├── tests/
├── migrations/                  # Alembic 迁移
├── Dockerfile
├── docker-compose.yml
└── pyproject.toml
```

### 3.3 多租户设计

**隔离策略**: Row Level Security (RLS)

```sql
-- 启用 RLS
ALTER TABLE memories ENABLE ROW LEVEL SECURITY;

-- 创建策略
CREATE POLICY tenant_isolation ON memories
    FOR ALL
    USING (tenant_id = current_setting('app.tenant_id')::uuid);
```

**数据模型核心表**:

| 表 | 职责 | 关键字段 |
|---|------|----------|
| `tenants` | 租户管理 | id, name, tier, settings |
| `api_keys` | API 密钥 | tenant_id, key_hash, scopes |
| `memories` | 记忆存储 | tenant_id, user_id, content, embedding |
| `conversations` | 对话存储 | tenant_id, session_id, messages |
| `knowledge_entities` | 知识实体 | tenant_id, name, entity_type |
| `knowledge_edges` | 知识关系 | tenant_id, source, relation, target |

### 3.4 API 设计

```yaml
Base URL: https://api.nexus.example.com/v1

认证: X-API-Key: nx_live_xxxxxxxxxxxxx

# 记忆管理
POST   /v1/memories              # 创建记忆
GET    /v1/memories              # 列出记忆
POST   /v1/memories/search       # 语义搜索
DELETE /v1/memories/{id}         # 删除记忆

# 对话管理
POST   /v1/conversations         # 创建对话
GET    /v1/conversations/{id}    # 获取对话
POST   /v1/conversations/{id}/messages  # 添加消息
GET    /v1/conversations/{id}/summary   # 获取摘要

# 知识图谱
POST   /v1/knowledge/extract     # 实体提取
GET    /v1/knowledge/entities    # 列出实体
POST   /v1/knowledge/query       # 图谱查询

# 分析
POST   /v1/analyze/patterns      # 行为模式分析
POST   /v1/analyze/insights      # 生成洞察

# 系统
GET    /v1/health                # 健康检查
GET    /v1/tenants/me            # 当前租户信息
```

### 3.5 Python SDK

```python
from nexus import Nexus

client = Nexus(api_key="nx_live_xxx")

# 创建记忆
memory = client.memories.create(
    content="用户喜欢在早上处理重要任务",
    user_id="user_123"
)

# 语义搜索
results = client.memories.search(
    query="用户的工作习惯",
    user_id="user_123"
)

# 知识图谱查询
answer = client.knowledge.query(
    query="谁负责这个项目?"
)
```

### 3.6 部署架构 (MVP)

```yaml
# docker-compose.yml
services:
  nexus:
    build: .
    ports:
      - "8001:8000"
    environment:
      - DATABASE_URL=postgresql://nexus:xxx@postgres:5432/nexus
      - OLLAMA_BASE_URL=http://ollama:11434

  postgres:
    image: pgvector/pgvector:pg16
    volumes:
      - postgres_data:/var/lib/postgresql/data

  ollama:
    image: ollama/ollama
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

### 3.7 分阶段演进路线

```
Phase 1: MVP Core (4-6周)       Phase 2: 认知能力 (4-6周)      Phase 3: 平台化 (4-6周)
─────────────────────           ─────────────────────          ─────────────────────
租户管理 + Memory               Knowledge Graph                 Web 控制台
Conversation 基础               行为模式分析                    计费系统 (Stripe)
Python SDK v0.1                 Python SDK v0.2                 JavaScript SDK
Docker Compose                  对话自动摘要                    自助注册

交付: Todo App 可接入           交付: 完整认知能力              交付: 可对外开放
```

---

## 4. Success Criteria

### 4.1 MVP 阶段

- [ ] 独立仓库创建 (`nexus/`)
- [ ] Nexus PRD 和 ARCHITECTURE.md 创建
- [ ] 多租户数据模型设计完成
- [ ] API 规范 (OpenAPI) 定义
- [ ] 核心 API 实现 (memories, conversations)
- [ ] Python SDK v0.1 发布
- [ ] Docker Compose 部署配置
- [ ] Todo App Backend 集成测试

### 4.2 文档更新

- [ ] 项目 PRD 更新（添加 Nexus 模块）
- [ ] System Architecture 更新（新架构图）
- [ ] Backend PRD 简化（移除 AI 记忆详细描述，添加 Nexus 调用）
- [ ] `complete-requirements-chain` 解除阻塞

---

## 5. Out of Scope

- Knowledge Graph 完整实现（Phase 2）
- Web 管理控制台（Phase 3）
- 计费系统（Phase 3）
- JavaScript/Go SDK（Phase 3+）
- 企业级库隔离（按需）
- Ray Serve / vLLM 集成（规模化阶段）

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
| 后续 User Stories | 需要基于新的 Mobile / Backend / Nexus 架构创建 |
| Backend 开发 | 需要集成 Nexus SDK 调用 |

---

## 8. Appendix: API Key 格式

```
前缀: nx_live_ (生产) / nx_test_ (测试)
长度: 32 字符随机串
示例: nx_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```
