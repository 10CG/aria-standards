# OpenSpec - Format Definition

> **Version**: 2.1.0
> **Status**: Active
> **Purpose**: OpenSpec Format Specification

## Purpose

This document defines the **OpenSpec format** - a standardized specification format for AI-driven development projects using the Aria methodology.

## 什么是 OpenSpec？

OpenSpec 是一种基于 Markdown 的规范格式，用于：

- **结构化需求捕获** - proposal.md 和 tasks.md 模板
- **AI 可读规范** - 为 Claude Code 等 AI 助手优化
- **可追溯开发** - 从 PRD → 系统架构 → 实现

---

## ⚠️ 重要说明：两个不同的 "openspec/" 目录

| | **standards/openspec/** | **{project}/openspec/** |
|---|---|---|
| **位置** | standards 子模块内部 | 项目根目录 |
| **用途** | **格式定义** (只读参考) | **项目工作区** (读写) |
| **内容** | templates/, specs/, VALIDATION.md | changes/, archive/ |
| **职责** | 定义 OpenSpec 是什么 | 跟踪项目的变更和规范 |

### 1. standards/openspec/ (格式定义库)

```
standards/
└── openspec/                    # 方法定义，不存储项目变更
    ├── project.md               # 本文件 - 格式定义
    ├── templates/               # 规范模板
    │   ├── proposal-minimal.md
    │   └── tasks.md
    ├── specs/                   # 格式规范文档
    ├── VALIDATION.md            # 验证规则
    └── AGENTS.md                # Agent 能力定义
```

**职责**: 定义 OpenSpec 格式的规范、模板和验证规则。作为 Git submodule 供各项目引用。

### 2. {project}/openspec/ (项目工作区)

```
your-project/                    # 任何使用 Aria 方法的项目
├── openspec/                    # 项目的 OpenSpec 工作区
│   ├── changes/                 # 活跃变更 (Draft/Review)
│   │   └── {feature}/
│   │       ├── proposal.md
│   │       ├── tasks.md
│   │       └── detailed-tasks.yaml
│   └── archive/                 # 已完成变更
│       └── {YYYY-MM-DD}-{feature}/
└── standards/                   # Git submodule → aria-standards
    └── openspec/                # 引用格式定义库
```

**职责**: 跟踪该项目的需求变更、任务分解和完成归档。

### Integration with aria-standards

Projects include aria-standards as a Git submodule:

```bash
# In your project
git submodule add ssh://forgejo@forgejo.10cg.pub/10CG/aria-standards.git standards
```

This provides:
- OpenSpec format definitions (via `standards/openspec/`)
- Template files for creating new specs
- Validation rules
- Aria methodology documentation

## OpenSpec Levels

| Level | Name | When to Use | Output |
|-------|------|-------------|--------|
| 1 | Skip | Simple fixes, typos | No spec needed |
| 2 | Minimal | Medium features (1-3 days) | proposal.md |
| 3 | Full | Architecture changes | proposal.md + tasks.md |

## Specification Lifecycle

```
Draft → Review → Approved → Implementing → Implemented
                                                           ↓
                                              Move to openspec/archive/
                                              命名格式: {YYYY-MM-DD}-{feature}/
```

## Related Resources

- **Aria Methodology**: https://forgejo.10cg.pub/10CG/Aria
- **OpenSpec Validation**: VALIDATION.md
- **Agent Capabilities**: AGENTS.md

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.1.0 | 2026-01-20 | 明确区分格式定义库和项目工作区；删除 changes/ 和 archive/ 目录 |
| 2.0.0 | 2026-01-19 | Restructured as methodology definition only |
| 1.0.0 | 2025-12-17 | Initial version |

---

**Maintained By**: 10CG Lab
**Repository**: https://forgejo@forgejo.10cg.pub/10CG/aria-standards.git
