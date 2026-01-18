# Tasks: Backend API Implementation

> **Spec**: changes/backend-api-development/proposal.md
> **Level**: Full (Level 3)
> **Status**: Draft
> **Created**: 2025-12-26
> **Design Source**: mobile/docs/architecture/

---

## 1. Project Setup & Database

- [ ] 1.1 Setup PostgreSQL database connection (SQLAlchemy async)
- [ ] 1.2 Configure Alembic migrations framework
- [ ] 1.3 Create initial migration with all tables from design doc
- [ ] 1.4 Setup pytest with async support and test database

## 2. OpenAPI Contract Sync

- [ ] 2.1 Convert unified-api-layer-design.md to OpenAPI YAML
- [ ] 2.2 Create shared/contracts/openapi/todo-api.yaml
- [ ] 2.3 Generate Pydantic models from OpenAPI spec

## 3. Core Models & Schemas

- [ ] 3.1 Implement User SQLAlchemy model (with benming fields)
- [ ] 3.2 Implement Task SQLAlchemy model (with 四象分类)
- [ ] 3.3 Implement Tag and TaskTag models
- [ ] 3.4 Implement AIMemory model (with agent_type)
- [ ] 3.5 Create all Pydantic request/response schemas

## 4. Authentication System

- [ ] 4.1 Implement password hashing (bcrypt)
- [ ] 4.2 Implement JWT token utilities
- [ ] 4.3 Create POST /auth/register endpoint
- [ ] 4.4 Create POST /auth/login endpoint
- [ ] 4.5 Create POST /auth/refresh endpoint
- [ ] 4.6 Create POST /auth/logout endpoint
- [ ] 4.7 Implement auth middleware (get_current_user)
- [ ] 4.8 Write auth tests (coverage >= 90%)

## 5. Tasks API

- [ ] 5.1 Implement Task repository layer
- [ ] 5.2 Implement Task service layer
- [ ] 5.3 Create GET /tasks endpoint (with pagination & filters)
- [ ] 5.4 Create POST /tasks endpoint
- [ ] 5.5 Create GET /tasks/{id} endpoint
- [ ] 5.6 Create PUT /tasks/{id} endpoint (with version conflict check)
- [ ] 5.7 Create DELETE /tasks/{id} endpoint (soft delete)
- [ ] 5.8 Implement 四象分类 filtering (fire/water/wood/metal)
- [ ] 5.9 Write tasks tests (coverage >= 90%)

## 6. Tags API

- [ ] 6.1 Implement Tag repository and service
- [ ] 6.2 Create CRUD endpoints for /tags
- [ ] 6.3 Implement task-tag association endpoints
- [ ] 6.4 Write tags tests

## 7. Sync Support

- [ ] 7.1 Implement version field handling (optimistic locking)
- [ ] 7.2 Implement 409 Conflict response for version mismatch
- [ ] 7.3 Add sync metadata to responses (version, updated_at)
- [ ] 7.4 Write sync conflict tests

## 8. Integration & Documentation

- [ ] 8.1 Configure Swagger/ReDoc documentation
- [ ] 8.2 Update OpenAPI contract with actual implementation
- [ ] 8.3 Setup CI pipeline (GitHub Actions)
- [ ] 8.4 Integration testing with Mobile client

---

## Summary

| Phase | Tasks | Description |
|-------|-------|-------------|
| 1. Project Setup & Database | 4 | 基础设施配置 |
| 2. OpenAPI Contract Sync | 3 | 契约同步到shared |
| 3. Core Models & Schemas | 5 | 数据模型实现 |
| 4. Authentication System | 8 | 认证系统实现 |
| 5. Tasks API | 9 | 任务API实现 |
| 6. Tags API | 4 | 标签API实现 |
| 7. Sync Support | 4 | 同步支持实现 |
| 8. Integration & Documentation | 4 | 集成和文档 |
| **Total** | **41** | - |

---

## Dependencies

```
Phase 1 ──> Phase 3 ──> Phase 4 ──┬──> Phase 5 ──> Phase 7
    │                             │
    └──> Phase 2                  └──> Phase 6
                                            │
                                            └──> Phase 8
```

---

## Design Document References

每个任务实现时必须参考对应的设计文档：

| 任务范围 | 参考文档 |
|---------|---------|
| 1.x Database | `mobile/docs/architecture/database-unified-design.md` |
| 2.x OpenAPI | `mobile/docs/architecture/unified-api-layer-design.md` |
| 3.x Models | `mobile/docs/architecture/database-unified-design.md` |
| 4.x Auth | `mobile/docs/architecture/unified-api-layer-design.md` (Auth部分) |
| 5.x Tasks | `mobile/docs/architecture/unified-api-layer-design.md` (Tasks部分) |
| 6.x Tags | `mobile/docs/architecture/unified-api-layer-design.md` |
| 7.x Sync | `mobile/lib/core/sync/SYNC_ARCHITECTURE.md` |

---

## Notes

1. **设计优先**: 所有实现必须遵循已有设计文档，不得随意修改
2. **契约同步**: Phase 2 产出的 OpenAPI 契约将成为 shared/ 的正式契约
3. **版本冲突**: Phase 7 的同步支持是与 Mobile 联调的关键
4. **测试覆盖**: Auth 和 Tasks 模块测试覆盖率必须 >= 90%
