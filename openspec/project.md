# OpenSpec - Format Definition

> **Version**: 2.2.0
> **Status**: Active
> **Updated**: 2026-04-23
> **Purpose**: OpenSpec Format Specification

## Purpose

This document defines the **OpenSpec format** - a standardized specification format for AI-driven development projects using the Aria methodology.

---

## 与 Fission-AI OpenSpec 的关系

aria 的 OpenSpec 方法论源于早期对 [Fission-AI OpenSpec](https://github.com/Fission-AI/OpenSpec) 的参考，但从 2026-04 起两者已**结构性分叉**：

| 维度 | aria OpenSpec | Fission-AI OpenSpec (v1.3.0+) |
|------|---------------|-------------------------------|
| 变更单元 | `openspec/changes/{change_id}/` 目录 | `specs/{capability}/spec.md` 单文件 |
| 任务表达 | Level 3: `proposal.md` + `tasks.md` + `detailed-tasks.yaml` (双层) | `## ADDED / MODIFIED / REMOVED Requirements` delta headers |
| 场景表达 | tasks.md 自由格式 checkbox | `#### Scenario:` block 结构化 |
| Validator | `aria:audit-engine` 3-agent 多轮收敛审计 | `@fission-ai/openspec` CLI `validate --strict` |
| 归档 | `openspec/archive/YYYY-MM-DD-{change_id}/` | spec history via Git + capability 累积 |
| 适用场景 | AI-DDD 协作，保留人类可读 tasks.md | greenfield + artifact-guided LLM workflow |

### 为何 aria 不跟随 upstream

1. **兼容性成本**: aria 项目已有多个 archive (如 `openspec/archive/2026-*`)，迁移破坏性高
2. **方法论差异**: aria 强调 tasks.md 的人类 checklist 属性 + detailed-tasks.yaml 的机读精度，delta-based 在 AI-DDD 上下文下失去"里程碑可视化"能力
3. **原生 validator 已成熟**: audit-engine 多轮收敛审计 + change_id 锚点校验 + checkpoint 完整性检查，比单轮 CLI validate 更适合 AI 协作
4. **包管理独立**: aria 作为 Claude Code plugin 分发，不依赖 npm 生态；Fission-AI CLI 适合 CLI-first 用户

### 使用者行动指南

- **aria 项目内**: 使用 aria 格式 + `/audit-engine` 验证，不安装 npm CLI
- **已用 Fission-AI 的项目**: 可保留现状，不建议迁移到 aria (两者设计哲学不同)
- **新项目选型**: 需要 AI 深度协作 + 人类审阅 → aria；需要 greenfield spec generation + capability 演化追踪 → Fission-AI upstream

> **Backward-compat 保证**: 已有 `openspec/changes/*` + `openspec/archive/*` 全部合法，本分叉声明不引入任何破坏性变更。

---

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
git submodule add https://github.com/10CG/aria-standards.git standards
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

- **Aria Methodology**: https://github.com/10CG/Aria
- **OpenSpec Validation**: VALIDATION.md
- **Agent Capabilities**: AGENTS.md

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.2.0 | 2026-04-23 | 新增"与 Fission-AI OpenSpec 的关系"章节，声明结构性分叉，修复 Issue #25 |
| 2.1.0 | 2026-01-20 | 明确区分格式定义库和项目工作区；删除 changes/ 和 archive/ 目录 |
| 2.0.0 | 2026-01-19 | Restructured as methodology definition only |
| 1.0.0 | 2025-12-17 | Initial version |

---

**Maintained By**: 10CG Lab
**Repository**: https://github.com/10CG/aria-standards
