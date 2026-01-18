# Change Proposal: Restructure Documentation Architecture

## Change ID
`restructure-doc-architecture`

## Status
**Complete** | Created: 2026-01-02 | Completed: 2026-01-02

## Summary

重构项目文档架构，解决当前 PRD/RPD 文档边界混乱问题，建立清晰的层次化文档体系，并重新梳理 AI 记忆系统的业务需求。

**扩展目标 (Phase 4)**: 将产品文档层次规范集成到 standards 模块，统一术语 (RPD → System Architecture)，扩展验证工具支持。

## Problem Statement

### 当前问题

1. **Mobile RPD 越界**
   - `mobile/docs/.../mo-unified-architecture-system-design-rpd.md` 包含了整个系统架构
   - 包含 Backend 架构设计、AI 记忆系统、数据库设计、商业模式等
   - 这些内容应该在主项目或 Backend 模块中

2. **Backend 文档缺失**
   - 只有技术实现文档（LLM Provider）
   - 缺少 PRD（业务需求）
   - 缺少系统级 RPD
   - AI 记忆系统在 Mobile RPD 中设计，但实际需要 Backend 实现

3. **版本路线图不对齐**
   - PRD 的 v3.0/v4.0 与 RPD 的演进路线缺乏映射关系
   - 缺少技术可行性支撑

4. **AI 记忆系统需求模糊**
   - 在 Mobile RPD 中定义了 Memos 云端服务
   - 但 Backend 没有对应的 PRD 确认这个设计
   - 需要从需求层面重新讨论

## Proposed Solution

### 文档架构调整

```
todo-app/
├── docs/
│   ├── requirements/
│   │   └── prd-todo-app.md           # 主 PRD（增强）
│   └── architecture/
│       └── system-rpd.md             # 【新建】系统级 RPD
│
├── mobile/
│   └── docs/architecture/
│       └── mobile-rpd.md             # 【重构】纯客户端 RPD
│
├── backend/
│   └── docs/
│       ├── requirements/
│       │   └── prd-backend.md        # 【新建】Backend PRD
│       └── architecture/
│           └── backend-rpd.md        # 【待建】Backend RPD
│
└── shared/
    └── contracts/                    # 契约定义（已有）
```

### 核心交付物

1. **系统级 RPD** - 从 Mobile RPD 抽取系统架构部分
2. **Backend PRD** - 定义后端业务需求，特别是 AI 记忆系统
3. **AI 记忆系统需求讨论框架** - 退回需求层，讨论关键问题
4. **文档引用关系规范** - 建立清晰的层次和引用

## Scope

### In Scope
- 创建系统级 System Architecture（从 Mobile RPD 抽取）
- 创建 Backend PRD 框架
- 梳理 AI 记忆系统需求讨论框架
- 更新主项目 PRD 的技术映射
- 建立文档层次规范
- **[Phase 4]** 将产品文档层次规范集成到 standards 模块
- **[Phase 4]** 创建 System Architecture 规范 (统一术语，替代 RPD)
- **[Phase 4]** 扩展 requirements-validator 支持架构文档验证
- **[Phase 4]** 更新 phase-a-spec-planning 区分 Spec 与 Architecture

### Out of Scope
- 具体的 AI 记忆系统技术实现
- Backend 代码开发
- Mobile RPD 的完整重构（仅标注待移除部分）

## Success Criteria

1. 系统级 System Architecture 文档创建并包含核心架构内容
2. Backend PRD 框架建立，AI 记忆系统需求清晰定义
3. 文档层次和引用关系有明确规范
4. AI 记忆系统关键问题有讨论结论或明确的待决项
5. **[Phase 4]** 产品文档层次规范集成到 standards 模块
6. **[Phase 4]** requirements-validator 支持架构文档验证
7. **[Phase 4]** 所有文档术语统一 (RPD → System Architecture)

## Related Changes

- `enhance-requirements-awareness` - 需求追踪体系增强

## Stakeholders

- Product Owner: 确认业务需求
- Tech Lead: 确认架构设计
- AI Engineer: 确认 AI 记忆系统技术方向

## References

- 当前 PRD: `docs/requirements/prd-todo-app-v1.md`
- Mobile RPD: `mobile/docs/project-planning/architecture/mo-unified-architecture-system-design-rpd.md`
- Backend 架构: `backend/docs/architecture/backend-overview.md`
