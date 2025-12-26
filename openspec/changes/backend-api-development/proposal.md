# Backend API Implementation

> **Level**: Full (Level 3 Spec)
> **Status**: Draft
> **Created**: 2025-12-26
> **Updated**: 2025-12-26
> **Module**: backend

## Why

Mobile 端应用功能已趋于成熟（Phase 4 Cycle 9），具备完整的离线优先架构和七层同步系统。项目已完成详细的技术设计，包括：
- 三层数据库架构设计（PostgreSQL + ChromaDB + Redis）
- 统一API层设计（RESTful规范）
- 离线同步机制设计

**当前需要的是实现已有设计，而非重新设计。**

## What

基于已有设计文档，实现 Python FastAPI 后端服务。

### 已有设计文档（必读）

| 设计领域 | 文档路径 | 状态 |
|---------|---------|------|
| **数据库设计** | `mobile/docs/architecture/database-unified-design.md` | ✅ 完整SQL Schema |
| **API设计** | `mobile/docs/architecture/unified-api-layer-design.md` | ✅ 完整端点规范 |
| **同步架构** | `mobile/lib/core/sync/SYNC_ARCHITECTURE.md` | ✅ 七层架构定义 |
| **本地AI** | `mobile/docs/ai-local-llm/mo-ai-local-architecture-design.md` | ✅ 8层架构 |

### Key Deliverables

1. **数据库实现** - 按已有SQL Schema创建PostgreSQL表
2. **API端点实现** - 按已有规范实现RESTful API
3. **同步支持** - 实现服务端同步逻辑（配合Mobile七层架构）
4. **契约同步** - 将已有设计转换为 `shared/contracts/openapi/` 格式

## Existing Design Summary

### 数据库Schema（已定义）

```sql
-- 核心表（来自 database-unified-design.md）
users          -- 含 benming_info, de_value, five_elements 特殊字段
tasks          -- 含四象分类 (fire/water/wood/metal)
tags           -- 标签系统
task_tags      -- 多对多关联
ai_memories    -- AI记忆（含 agent_type: benming/qinglong/zhuque/baihu/xuanwu）
user_sessions  -- 会话管理
system_configs -- 系统配置

-- 高级功能
- 全文搜索 (tsvector)
- 时间分区 (ai_memories)
- 统计视图 (user_task_stats)
- 自动更新时间戳触发器
```

### API端点（已定义）

```yaml
# 来自 unified-api-layer-design.md
/api/v1/auth:
  - POST /register
  - POST /login
  - POST /refresh
  - POST /logout

/api/v1/tasks:
  - GET    /                    # 列表（分页、筛选）
  - POST   /                    # 创建
  - GET    /{task_id}           # 详情
  - PUT    /{task_id}           # 更新
  - DELETE /{task_id}           # 删除
  - GET    /{task_id}/subtasks  # 子任务
  - POST   /{task_id}/subtasks
  - GET    /{task_id}/comments  # 评论
  - POST   /{task_id}/comments
  - GET    /{task_id}/attachments # 附件
  - POST   /{task_id}/attachments

/api/v1/tags:
  - CRUD operations

/api/v1/users/{user_id}:
  - GET    /settings
  - PUT    /settings
  - GET    /ai-memories

/api/v1/ai:
  - POST /chat
  - POST /analyze
  - POST /suggest
```

### 同步机制（已定义）

```yaml
# 来自 SYNC_ARCHITECTURE.md
冲突解决策略:
  - clientWins: 客户端优先
  - serverWins: 服务器优先
  - mostRecent: 最新时间优先
  - merge: 智能合并
  - manual: 用户手动选择

同步字段:
  - version: 乐观锁版本号
  - is_synced: 同步状态
  - last_sync_at: 最后同步时间
  - updated_at: 更新时间戳

同步响应码:
  - 200: 同步成功
  - 409: 版本冲突（返回最新数据）
```

### 统一响应格式（已定义）

```python
# 来自 unified-api-layer-design.md
class APIResponse(BaseModel):
    success: bool
    data: Optional[Any] = None
    message: str = ""
    code: int = 200
    timestamp: datetime
    request_id: str

class PaginatedResponse(BaseModel):
    items: List[Any]
    total: int
    page: int
    page_size: int
    has_next: bool
    has_prev: bool
```

## Impact

| Type | Description |
|------|-------------|
| **Positive** | 无需设计，直接实现，大幅缩短开发周期 |
| **Positive** | 设计已验证（Mobile端使用中），降低返工风险 |
| **Risk** | 需要精确遵循已有设计，不能随意修改 |
| **Mitigation** | 任何偏离需更新两端文档并同步 |

## Scope

### Phase 1 - MVP (本次)

| 模块 | 功能 | 来源设计 |
|------|------|---------|
| **Database** | 创建所有表、索引、触发器 | database-unified-design.md |
| **Auth** | 注册/登录/Token管理 | unified-api-layer-design.md |
| **Tasks** | CRUD + 四象分类 | unified-api-layer-design.md |
| **Tags** | CRUD + 关联 | unified-api-layer-design.md |
| **Sync** | 版本冲突检测 | SYNC_ARCHITECTURE.md |

### Phase 2 - Extended

| 模块 | 功能 | 优先级 |
|------|------|--------|
| Subtasks | 子任务CRUD | P1 |
| Comments | 评论CRUD | P1 |
| Attachments | 文件上传/下载 | P1 |
| AI Service | chat/analyze/suggest | P2 |
| ChromaDB | 向量存储集成 | P2 |
| Redis | 缓存层 | P2 |

### Out of Scope

- Mobile端修改（已完成）
- 设计变更（使用已有设计）
- 部署运维（另行规划）

## Technology Stack（已确定）

| Component | Technology | 来源 |
|-----------|------------|------|
| Framework | FastAPI | backend/CLAUDE.md |
| ORM | SQLAlchemy 2.0 | database-unified-design.md |
| Database | PostgreSQL | database-unified-design.md |
| Vector DB | ChromaDB | database-unified-design.md |
| Cache | Redis | database-unified-design.md |
| Validation | Pydantic v2 | unified-api-layer-design.md |
| Auth | JWT | unified-api-layer-design.md |

## Success Criteria

- [ ] 所有数据库表按设计创建，通过迁移验证
- [ ] Auth API 实现，测试覆盖率 >= 90%
- [ ] Tasks CRUD API 实现，测试覆盖率 >= 90%
- [ ] 版本冲突检测正常工作（409响应）
- [ ] 与 Mobile 端联调成功（至少 Auth + Tasks）
- [ ] OpenAPI 契约同步到 `shared/contracts/openapi/`

## References

### 必读设计文档

1. **数据库设计** - `mobile/docs/architecture/database-unified-design.md`
2. **API设计** - `mobile/docs/architecture/unified-api-layer-design.md`
3. **同步架构** - `mobile/lib/core/sync/SYNC_ARCHITECTURE.md`
4. **Backend配置** - `backend/CLAUDE.md`

### 参考文档

- Mobile UPM: `mobile/docs/project-planning/unified-progress-management.md`
- Backend UPM: `backend/project-planning/unified-progress-management.md`
- Mobile架构: `mobile/MOBILE_APP_ARCHITECTURE.md`

---

**重要提醒**: 本提案是"实现已有设计"，不是"创建新设计"。所有实现必须严格遵循已有设计文档。
