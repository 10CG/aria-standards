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

## 8. Backend 功能边界影响分析

> **重要**: Nexus 从 Todo App 专用服务升级为通用平台后，Backend 的功能边界需要重新定义。

### 8.1 边界变化对比

| 维度 | 原设计 (专用服务) | 新设计 (通用平台) |
|------|-------------------|-------------------|
| **关系** | 紧耦合，内部组件 | 松耦合，SDK 调用 |
| **用户身份** | 共享 user_id | tenant + user_id 映射 |
| **业务逻辑** | 可能混在 Memory | 必须分离到 Backend |
| **故障影响** | 单体故障 | 需要降级策略 |

### 8.2 AI 功能层次划分

```
┌─────────────────────────────────────────────────────────────────┐
│                    Todo App Backend                              │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              AI Adapter Layer (Todo-Specific)              │  │
│  │                                                            │  │
│  │  ┌─────────────────┐  ┌─────────────────────────────────┐ │  │
│  │  │ 业务 AI 逻辑     │  │ "数字元神" 人格层               │ │  │
│  │  │ - 任务优先级分析 │  │ - 用户画像构建                  │ │  │
│  │  │ - 效率模式识别   │  │ - 个性化交互风格                │ │  │
│  │  │ - 智能提醒生成   │  │ - 情感理解与回应                │ │  │
│  │  │ - 截止日期预测   │  │ - 成长轨迹追踪                  │ │  │
│  │  └─────────────────┘  └─────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              │                                   │
│                    nexus-sdk (通用认知能力)                      │
│                              │                                   │
└──────────────────────────────┼───────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                         Nexus Platform                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   Memory    │  │Conversation │  │  Knowledge  │              │
│  │  (通用存储)  │  │  (通用历史)  │  │  (通用图谱)  │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│                                                                  │
│  提供: 存储、检索、摘要、实体提取 (不含业务逻辑)                  │
└─────────────────────────────────────────────────────────────────┘
```

### 8.3 功能归属决策

| 功能 | 归属 | 理由 |
|------|------|------|
| 记忆存储 | **Nexus** | 通用能力，多项目复用 |
| 语义检索 | **Nexus** | 通用能力 |
| 对话摘要 | **Nexus** | 通用能力 |
| 实体提取 | **Nexus** | 通用能力 |
| 任务优先级分析 | **Backend** | Todo App 特定业务逻辑 |
| 效率模式识别 | **Backend** | Todo App 特定业务逻辑 |
| 智能提醒生成 | **Backend** | Todo App 特定业务逻辑 |
| **"数字元神"人格** | **Backend** | 产品核心差异化，见下方决策 |

### 8.4 "数字元神"归属决策

**决策**: "数字元神"人格层归属 **Backend**

**理由**:
1. **产品差异化**: 这是 Todo App 的核心竞争力，不应通用化
2. **个性化程度**: 每个产品的"元神"性格、交互风格不同
3. **业务耦合**: 人格表现与具体业务场景紧密相关
4. **灵活性**: Backend 控制人格层可以快速迭代

**实现方式**:
```python
# Backend: AI Adapter Layer
class DigitalSoulAdapter:
    def __init__(self, nexus_client: NexusClient):
        self.nexus = nexus_client

    def understand_user(self, user_id: str, context: dict) -> UserProfile:
        # 调用 Nexus 获取原始记忆
        memories = self.nexus.memories.search(user_id=user_id, query=context)
        conversations = self.nexus.conversations.get_recent(user_id=user_id)

        # Backend 构建用户画像 (业务逻辑)
        return self._build_profile(memories, conversations)

    def generate_response(self, user_id: str, input: str) -> Response:
        profile = self.understand_user(user_id, {"input": input})

        # Backend 实现人格化回应 (核心差异化)
        return self._personalized_response(profile, input)
```

### 8.5 用户身份映射策略

```python
# Backend 配置
NEXUS_TENANT_ID = "todo-app"

# 用户映射: Todo App user_id → Nexus user_id
def map_user_id(todo_user_id: int) -> str:
    return f"todo_user_{todo_user_id}"

# 使用示例
nexus_client.memories.create(
    user_id=map_user_id(current_user.id),  # "todo_user_123"
    content="用户偏好..."
)
```

### 8.6 降级策略

| 场景 | Backend 行为 |
|------|-------------|
| Nexus 不可用 | 基础 CRUD 正常，AI 功能返回默认值/缓存 |
| Nexus 响应超时 (>3s) | 异步处理，先返回基础响应 |
| Nexus 数据不一致 | 日志告警，使用本地缓存 |

**实现要求**:
```python
# Backend: Nexus Client Wrapper
class ResilientNexusClient:
    def __init__(self, client: NexusClient):
        self.client = client
        self.cache = RedisCache()

    async def search_memories(self, user_id: str, query: str):
        try:
            result = await asyncio.wait_for(
                self.client.memories.search(user_id, query),
                timeout=3.0
            )
            self.cache.set(f"memories:{user_id}:{query}", result)
            return result
        except (TimeoutError, ConnectionError):
            # 降级: 返回缓存或空结果
            return self.cache.get(f"memories:{user_id}:{query}") or []
```

### 8.7 Backend PRD 更新要点

本 Change 完成后，`backend/docs/requirements/prd-backend.md` 需要更新：

1. **移除**: AI 记忆系统详细实现描述
2. **新增**: AI Adapter Layer 职责定义
3. **新增**: Nexus 集成边界说明
4. **新增**: "数字元神"人格层设计
5. **新增**: 降级策略要求
6. **更新**: 架构图 (Backend → Nexus 调用关系)

---

## 9. Shared 子模块边界决策

> **核心结论**: Nexus API 契约**不应该**放入 todo-app 的 shared 子模块。

### 9.1 边界规则

```
┌─────────────────────────────────────────────────────────────────┐
│                       shared 边界定义                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ✅ 包含:                                                        │
│     - Mobile 直接调用 Backend 的 API 契约                        │
│     - Mobile 和 Backend 共享的数据模型                           │
│     - Mobile 需要展示的 Nexus 数据的「展示模型」                  │
│                                                                  │
│  ❌ 不包含:                                                      │
│     - Nexus 原生 API 契约 (在 nexus/docs/api/openapi.yaml)      │
│     - Backend 与外部系统的集成接口                               │
│     - nexus-sdk 的类型定义                                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 9.2 决策理由

| 评估维度 | 放入 shared | 保持独立 |
|----------|-------------|----------|
| **独立性** | ❌ 耦合增加 | ✅ 清晰边界 |
| **可复用性** | ❌ 其他项目需依赖 todo-app | ✅ nexus 独立分发 |
| **版本管理** | ❌ 耦合版本 | ✅ 独立演进 |
| **维护成本** | ❌ 双重维护 | ✅ 单点维护 |

### 9.3 Mobile 展示 Nexus 数据的方案

**Backend 作为 Anti-Corruption Layer (ACL)**:

```
┌─────────────────────────────────────────────────────────────────┐
│                    数据流转与模型转换                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Mobile              Backend (ACL)              Nexus           │
│   (Dart)              (Python)                   (Python)        │
│                                                                  │
│   ┌─────────────┐    ┌───────────────────┐    ┌─────────────┐   │
│   │ TodoMemory  │    │   Transformer     │    │ NexusMemory │   │
│   │ (shared)    │<───│ nexus_to_todo()   │<───│ (nexus-sdk) │   │
│   │             │    │                   │    │             │   │
│   │ - id        │    │                   │    │ - id        │   │
│   │ - summary   │    │                   │    │ - content   │   │
│   │ - type      │    │                   │    │ - memory_type│  │
│   │ - createdAt │    │                   │    │ - score     │   │
│   └─────────────┘    └───────────────────┘    │ - metadata  │   │
│                                                │ - embedding │   │
│                                                └─────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**设计原则**:
1. **薄接口**: shared 只定义 Mobile 实际需要的字段
2. **Backend 负责转换**: 将 Nexus 复杂模型转换为简化的展示模型
3. **隐藏实现细节**: Mobile 不感知 Nexus 的存在
4. **版本隔离**: Nexus 模型变化只影响 Backend 转换层

### 9.4 Shared 新增模型定义

```json
// shared/schemas/ai/memory.schema.json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "TodoMemory",
  "description": "Mobile 端展示的记忆模型 (源自 Nexus)",
  "type": "object",
  "properties": {
    "id": { "type": "string" },
    "summary": { "type": "string", "description": "记忆摘要 (截取自 content)" },
    "type": { "enum": ["episodic", "semantic", "procedural"] },
    "relevance_score": { "type": "number", "minimum": 0, "maximum": 1 },
    "created_at": { "type": "string", "format": "date-time" }
  },
  "required": ["id", "summary", "type", "created_at"]
}
```

```json
// shared/schemas/ai/conversation.schema.json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "TodoConversation",
  "description": "Mobile 端展示的对话模型 (源自 Nexus)",
  "type": "object",
  "properties": {
    "id": { "type": "string" },
    "title": { "type": "string", "description": "对话标题 (自动生成)" },
    "last_message": { "type": "string", "description": "最后一条消息预览" },
    "message_count": { "type": "integer" },
    "updated_at": { "type": "string", "format": "date-time" }
  },
  "required": ["id", "title", "updated_at"]
}
```

### 9.5 Backend Transformer 示例

```python
# backend/app/adapters/nexus/transformers.py
from nexus_sdk.models import NexusMemory, NexusConversation
from shared.models.ai import TodoMemory, TodoConversation

class MemoryTransformer:
    @staticmethod
    def to_todo_memory(nexus_memory: NexusMemory) -> TodoMemory:
        """将 Nexus 记忆模型转换为 Todo 应用的展示模型"""
        return TodoMemory(
            id=str(nexus_memory.id),
            summary=nexus_memory.content[:200] + "..." if len(nexus_memory.content) > 200 else nexus_memory.content,
            type=nexus_memory.memory_type.value,
            relevance_score=nexus_memory.score or 0.0,
            created_at=nexus_memory.created_at.isoformat()
        )

    @staticmethod
    def to_todo_memories(nexus_memories: list[NexusMemory]) -> list[TodoMemory]:
        return [MemoryTransformer.to_todo_memory(m) for m in nexus_memories]


class ConversationTransformer:
    @staticmethod
    def to_todo_conversation(nexus_conv: NexusConversation) -> TodoConversation:
        """将 Nexus 对话模型转换为 Todo 应用的展示模型"""
        return TodoConversation(
            id=str(nexus_conv.id),
            title=nexus_conv.summary or f"对话 {nexus_conv.id[:8]}",
            last_message=nexus_conv.messages[-1].content[:100] if nexus_conv.messages else "",
            message_count=len(nexus_conv.messages),
            updated_at=nexus_conv.updated_at.isoformat()
        )
```

### 9.6 其他项目使用 Nexus

```
┌─────────────────────────────────────────────────────────────────┐
│                    多项目共享 Nexus 的架构                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐       │
│  │ todo-app     │    │ project-B    │    │ project-C    │       │
│  │ (Backend)    │    │ (Backend)    │    │ (Backend)    │       │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘       │
│         │                   │                   │                │
│         │ pip install       │ pip install       │ pip install    │
│         │ nexus-sdk         │ nexus-sdk         │ nexus-sdk      │
│         │                   │                   │                │
│         └───────────────────┼───────────────────┘                │
│                             ↓                                    │
│               ┌─────────────────────────┐                        │
│               │       nexus-sdk          │                        │
│               │   (PyPI Package)         │                        │
│               └─────────────┬───────────┘                        │
│                             │ HTTP                                │
│                             ↓                                    │
│               ┌─────────────────────────┐                        │
│               │    Nexus Platform        │                        │
│               │   (Self-hosted)          │                        │
│               └─────────────────────────┘                        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**优势**:
- 每个项目独立依赖 nexus-sdk，无需引用 todo-app 的 shared
- Nexus 可独立演进，发布新版本
- 各项目自行定义展示模型，互不影响

---

## 10. Appendix: API Key 格式

```
前缀: nx_live_ (生产) / nx_test_ (测试)
长度: 32 字符随机串
示例: nx_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```
