# Documentation Consolidation

> **Level**: Full (Level 3 Spec)
> **Status**: Draft
> **Created**: 2025-12-26
> **Module**: docs (跨模块)
> **Blocker For**: backend-api-development

## Why

项目经过多次版本迭代后，文档体系出现严重的**结构性混乱**问题：

1. **文档完全重复** - `mobile/docs/` 与 `docs/maintained/development/mobile/` 存在 MD5 相同的重复文档
2. **版本管理混乱** - RPD 文档有 7 个版本，无法确定当前有效版本
3. **缺少跨模块进度管理** - 各子模块有独立 UPM，但根项目缺少总控

**这是 Backend 开发的阻塞任务** - 必须先明确"设计真相源"，才能基于正确的设计进行开发。

## What

整治项目文档体系，建立统一的文档治理机制。

### Key Deliverables

1. **移除重复文档** - 建立单一信息源
2. **明确当前版本** - RPD/设计文档版本标记
3. **创建根 UPM** - 跨模块进度管理
4. **清理过期文档** - 归档或删除过期备份
5. **建立文档规范** - 防止未来混乱

## Analysis Summary

基于 `docs/analysis/documentation-chaos-analysis-2025-12-26.md` 的分析：

### 核心问题

| 问题 | 严重性 | 影响 |
|------|--------|------|
| `mobile/docs/` ↔ `docs/maintained/` 重复 | P0 | 双倍维护成本，更新不同步 |
| RPD 版本混乱 (7个文档) | P0 | 无法确定当前设计 |
| 缺少根 UPM | P0 | 无跨模块进度视图 |
| `backups/` 过期未清理 | P1 | 搜索干扰，存储浪费 |

### 文档分布现状

```
当前问题结构:
├── mobile/docs/                    ← 主要文档位置
│   ├── architecture/              (6个架构文档)
│   └── project-planning/architecture/  (7个RPD，版本混乱)
│
├── docs/maintained/development/mobile/  ← 完全重复！
│   ├── architecture/              (与上面 MD5 相同)
│   └── project-planning/          (更新时间滞后2个月)
│
├── backups/time-fix-2025-06-30/   ← 6个月前，应清理
│
└── [无根 UPM]                      ← 缺失！
```

## Solution Design

### 目标结构

```
整治后结构:
todo-app/
├── mobile/docs/                   ← 唯一 Mobile 文档位置
│   ├── architecture/
│   └── project-planning/
│       ├── unified-progress-management.md
│       └── architecture/
│           ├── mo-unified-rpd.md  ← 当前版本 (v4.0.0)
│           └── _archive/          ← 历史版本归档
│               ├── mo-v2.0.0-rpd.md
│               └── mo-v3.0.0-rpd.md
│
├── backend/docs/                  ← 唯一 Backend 文档位置
│   └── project-planning/
│       └── unified-progress-management.md
│
├── docs/                          ← 跨模块文档
│   ├── project-planning/
│   │   └── unified-progress-management.md  ← 根 UPM (新增)
│   ├── analysis/                  ← 分析报告
│   └── archived/                  ← 归档目录
│       └── maintained-backup-2025-12/  ← docs/maintained 备份
│
└── [删除] docs/maintained/development/mobile/  ← 移除重复
└── [删除] backups/time-fix-2025-06-30/        ← 清理过期
```

### 核心原则

1. **单一信息源 (SSOT)** - 每个文档只存在于一个位置
2. **边界清晰** - 子模块文档在子模块目录，根目录仅存跨模块文档
3. **版本可追溯** - 明确当前版本，历史版本归档到 `_archive/`
4. **AI 友好** - 保留索引和摘要文件

## Impact

| Type | Description |
|------|-------------|
| **Positive** | 消除文档重复，降低维护成本 |
| **Positive** | 明确设计真相源，支持正确开发 |
| **Positive** | 建立跨模块进度视图 |
| **Risk** | 移动/删除文档可能破坏现有链接 |
| **Mitigation** | 先备份，逐步迁移，更新所有引用 |

## Scope

### In Scope

- 移除 `docs/maintained/development/mobile/` 重复文档
- 归档历史 RPD 版本
- 创建根 UPM
- 清理过期备份
- 更新 CLAUDE.md 文档引用

### Out of Scope

- 文档内容修改（仅结构调整）
- 新增文档（除根 UPM）
- CI/CD 文档生成流程（后续优化）

## Success Criteria

- [ ] `docs/maintained/development/mobile/` 已删除或备份
- [ ] RPD 历史版本归档到 `_archive/`，当前版本明确
- [ ] 根 UPM 创建并包含 Mobile/Backend 状态链接
- [ ] `backups/time-fix-2025-06-30/` 已归档或删除
- [ ] 所有 CLAUDE.md 文档引用已更新
- [ ] `git status` 干净，所有变更已提交

## References

- 分析报告: `docs/analysis/documentation-chaos-analysis-2025-12-26.md`
- AI-DDD 文档规范: `standards/conventions/document-classification.md`
- Mobile UPM: `mobile/docs/project-planning/unified-progress-management.md`
- Backend UPM: `backend/project-planning/unified-progress-management.md`

---

**重要**: 本任务完成后，才能开始 `backend-api-development` OpenSpec 的执行。
