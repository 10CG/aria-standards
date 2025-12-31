# OpenSpec Proposal: .claude 目录子模块化架构

> **Status**: 🟡 Draft - 待讨论
> **Created**: 2025-12-29
> **Author**: AI Assistant

---

## 背景

当前项目采用 Git Submodule 架构，其中 `standards/` 和 `.claude/agents/` 被标记为"跨项目共享基础设施"（类型C），不绑定特定项目进度。

**问题**: `.claude/skills/` 包含大量与 AI-DDD 方法论配套的通用 Skills，但目前不是子模块，无法跨项目复用。

**核心问题**: 如何统一管理跨项目共享的 AI 配置？

---

## 当前结构

```
todo-app/
├── standards/           # 子模块 ✓ AI-DDD方法论
├── .claude/
│   ├── agents/          # 子模块 ✓ AI代理配置
│   ├── skills/          # ✗ 不是子模块 (19个Skills)
│   ├── commands/        # ✗ 不是子模块
│   ├── docs/            # ✗ 项目特定文档
│   └── settings.local.json
├── mobile/              # 子模块 - 项目特定
├── backend/             # 子模块 - 项目特定
└── shared/              # 子模块 - 项目特定
```

---

## Skills 分析

### 通用 Skills (16个)

与 AI-DDD 方法论配套，可跨项目复用：

| 分类 | Skills |
|------|--------|
| **Git 工具** | commit-msg-generator, strategic-commit-orchestrator, branch-manager |
| **架构文档** | arch-common, arch-search, arch-update, api-doc-generator |
| **十步循环** | phase-a-planner, phase-b-developer, phase-c-integrator, phase-d-closer |
| **进度管理** | progress-updater, spec-drafter, task-planner, state-scanner, workflow-runner |

### 项目特定 Skills (3个)

| Skill | 原因 |
|-------|------|
| flutter-test-generator | 仅 Flutter 项目需要 |
| test-verifier | 已适配特定模块路径 |
| doc-integrity-validator | 项目特定验证规则 |

---

## 方案对比

### 方案A: 整个 .claude/ 变成子模块

```
.claude/                 # 子模块
├── agents/
├── skills/              # 所有通用 Skills
└── commands/

.claude.local/           # 项目特定 (gitignore)
├── skills/
└── settings.local.json
```

**问题**: Claude Code 不支持 `.claude.local/`

---

### 方案B: 将 Skills + Agents 合并到 standards/

```
standards/               # 子模块 (扩展为完整套件)
├── core/
├── extensions/
├── conventions/
├── agents/              # ← 从 .claude/agents/ 合并
└── skills/              # ← 通用 Skills

.claude/                 # 项目特定
├── skills/              # symlinks 或 include 配置
└── ...
```

**优点**: 方法论 + 工具统一管理
**问题**: 需要 symlink 或 skills.json 配置

---

### 方案C: 分层子模块

```
.claude/
├── shared/              # 新子模块
│   ├── skills/
│   ├── agents/
│   └── commands/
├── skills/              # 项目特定 + 引用 shared
└── ...
```

**优点**: 清晰分层
**问题**: Claude Code 是否支持嵌套？

---

### 方案D: 保持现状，skills 独立子模块

```
.claude/
├── agents/              # 子模块 (保持)
├── skills-shared/       # 新子模块
├── skills/              # 项目特定
└── ...
```

**问题**: skills/ 和 skills-shared/ 如何协同？

---

## 待讨论问题

### 1. standards 仓库的定位

- **选项A**: 纯规范文档 → skills 另建子模块
- **选项B**: 方法论完整套件 → 合并 skills + agents

### 2. Claude Code 发现机制

- `.claude/skills/` 是默认发现路径
- 需要验证 `skills.json` 的 `include` 配置是否支持
- symlink 是否可靠？

### 3. 命名与边界

- `standards/` vs `ai-ddd/` vs `claude-shared/`
- agents 和 skills 的关系是什么？
  - agents = 执行者定义
  - skills = 能力定义
  - 是否应该放在一起？

### 4. 迁移成本

- 现有项目引用如何更新？
- 其他项目如何开始使用？

---

## 临时决策记录

| 日期 | 决策 | 原因 |
|------|------|------|
| 2025-12-29 | 创建 proposal 待讨论 | 架构决策需要深入思考 |

---

## 下一步

1. [ ] 确定 standards 仓库定位
2. [ ] 验证 Claude Code skills.json 配置能力
3. [ ] 确定最终方案
4. [ ] 制定迁移计划

---

## 相关文档

- [CHANGE_TYPES.md](/.claude/skills/strategic-commit-orchestrator/CHANGE_TYPES.md) - 类型C定义
- [SUBMODULE_BOUNDARIES_AND_POSITIONING.md](/.claude/docs/SUBMODULE_BOUNDARIES_AND_POSITIONING.md)
