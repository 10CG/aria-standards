# OpenSpec Change: .claude 目录子模块化架构

> **Status**: 🟢 Implemented
> **Created**: 2025-12-29
> **Implemented**: 2026-01-06
> **Author**: AI Assistant

---

## 背景

当前项目采用 Git Submodule 架构，其中 `standards/` 和 `.claude/agents/` 被标记为"跨项目共享基础设施"（类型C），不绑定特定项目进度。

**问题**: `.claude/skills/` 包含大量与 Aria (AI-DDD) 方法论配套的通用 Skills，但目前不是子模块，无法跨项目复用。

**核心问题**: 如何统一管理跨项目共享的 AI 配置？

---

## 最终决策: 方案E - Plugin Marketplace

**采用 Anthropic 官方 `/plugin` 机制实现 Skills 共享**

通过分析 [Anthropic 官方 Skills 仓库](https://github.com/anthropics/skills)，发现 Claude Code 提供了 Plugin Marketplace 机制，完美解决跨项目 Skills 共享问题。

### 最终架构

```
aria-skills (GitHub Public)              # Plugin Marketplace 仓库
├── .claude-plugin/
│   └── marketplace.json                 # 定义 5 个插件组
├── commit-msg-generator/
├── strategic-commit-orchestrator/
├── ... (共 20 个 Skills)

~/.claude/plugins/cache/                 # Plugin 安装位置
└── 10cg-aria-skills/
    └── all-skills/
        └── unknown/
            ├── commit-msg-generator/
            ├── ...

{project}/.claude/skills/                # Project Skills (优先级高于 Plugin)
├── flutter-test-generator/              # 项目特定
├── test-verifier/                       # 项目特定
└── doc-integrity-validator/             # 项目特定
```

### 安装方式

```bash
# 添加 marketplace (首次)
/plugin marketplace add simonfishgit/aria-skills

# 安装全部 Skills
/plugin install all-skills@10cg-aria-skills

# 或按需安装特定组
/plugin install aria-core@10cg-aria-skills        # 十步循环核心 (9 skills)
/plugin install git-tools@10cg-aria-skills        # Git 工作流 (3 skills)
/plugin install arch-tools@10cg-aria-skills       # 架构文档 (5 skills)
/plugin install requirements-tools@10cg-aria-skills  # 需求管理 (3 skills)
```

### 方案优点

- ✅ 遵循 Anthropic 官方机制，未来兼容性有保障
- ✅ 无需子模块，减少项目复杂度
- ✅ 支持版本化和选择性安装
- ✅ GitHub 公开仓库便于社区共享
- ✅ 用户级安装，一次配置多项目可用

---

## 被否决的方案

### 方案A: 整个 .claude/ 变成子模块
**否决原因**: Claude Code 不支持 `.claude.local/` 覆盖机制

### 方案B: 将 Skills + Agents 合并到 standards/
**否决原因**: Claude Code 不支持 skills.json include 外部路径

### 方案C: 分层子模块 (.claude/shared/)
**否决原因**: Claude Code 不支持嵌套 skills 目录

### 方案D: skills 独立子模块
**否决原因**: Claude Code 只扫描 `.claude/skills/`，无法识别其他路径

---

## 实施记录

### 1. 创建 aria-skills 仓库

**仓库信息:**
- GitHub (公开): https://github.com/simonfishgit/aria-skills
- Forgejo (内部备份): https://forgejo.10cg.pub/10CG/aria-skills

**marketplace.json 配置:**
```json
{
  "name": "10cg-aria-skills",
  "plugins": [
    {"name": "aria-core", "skills": ["./state-scanner", "./workflow-runner", "./phase-*", ...]},
    {"name": "git-tools", "skills": ["./commit-msg-generator", "./strategic-commit-orchestrator", "./branch-manager"]},
    {"name": "arch-tools", "skills": ["./arch-common", "./arch-search", "./arch-update", "./arch-scaffolder", "./api-doc-generator"]},
    {"name": "requirements-tools", "skills": ["./requirements-validator", "./requirements-sync", "./forgejo-sync"]},
    {"name": "all-skills", "skills": [... all 20 skills ...]}
  ]
}
```

### 2. 迁移 Skills

**迁移到 aria-skills 的 20 个通用 Skills:**

| 分类 | Skills |
|------|--------|
| **Git 工具** | commit-msg-generator, strategic-commit-orchestrator, branch-manager |
| **架构文档** | arch-common, arch-search, arch-update, arch-scaffolder, api-doc-generator |
| **十步循环** | phase-a-planner, phase-b-developer, phase-c-integrator, phase-d-closer |
| **进度管理** | progress-updater, spec-drafter, task-planner, state-scanner, workflow-runner |
| **需求管理** | requirements-validator, requirements-sync, forgejo-sync |

**保留在 todo-app 的 3 个项目特定 Skills:**

| Skill | 原因 |
|-------|------|
| flutter-test-generator | 仅 Flutter 项目需要 |
| test-verifier | 已适配特定模块路径 |
| doc-integrity-validator | 项目特定验证规则 |

### 3. 验证安装

```bash
# 验证 marketplace 注册
ls ~/.claude/plugins/marketplaces/
# 输出: 10cg-aria-skills

# 验证 plugin 安装
cat ~/.claude/plugins/installed_plugins.json
# 确认 all-skills@10cg-aria-skills 已安装

# 验证 skills 文件
ls ~/.claude/plugins/cache/10cg-aria-skills/all-skills/unknown/
# 输出: 20 个 skill 目录
```

### 4. 清理重复 Plugins

安装 `all-skills` 后，卸载重复的子集 plugins:
```bash
/plugin uninstall aria-core@10cg-aria-skills
/plugin uninstall git-tools@10cg-aria-skills
/plugin uninstall arch-tools@10cg-aria-skills
/plugin uninstall requirements-tools@10cg-aria-skills
```

### 5. 处理 MCP 与 Plugin 冲突

发现 `context7` 和 `playwright` 同时存在 MCP 和 Plugin 版本:
- MCP: 项目级配置，运行中
- Plugin: 用户级安装，已禁用

**解决方案**: 卸载重复的 Plugin 版本，保留 MCP:
```bash
/plugin uninstall context7@claude-plugins-official
/plugin uninstall playwright@claude-plugins-official
```

---

## 决策记录

| 日期 | 决策 | 原因 |
|------|------|------|
| 2025-12-29 | 创建 proposal 待讨论 | 架构决策需要深入思考 |
| 2026-01-06 | 发现 Plugin 机制 | 分析 Anthropic 官方 skills 仓库 |
| 2026-01-06 | 否决方案 A-D | Claude Code 限制不支持 |
| 2026-01-06 | 采用方案 E | 官方机制，完全支持 |
| 2026-01-06 | 创建 aria-skills 仓库 | GitHub (公开) + Forgejo (备份) |
| 2026-01-06 | 迁移 20 个 Skills | todo-app 保留 3 个项目特定 |
| 2026-01-06 | 验证 Plugin 安装成功 | GitHub 公开仓库可用 |
| 2026-01-06 | 清理重复 Plugins | 避免 all-skills 与子集重复 |
| 2026-01-06 | 处理 MCP/Plugin 冲突 | 卸载重复的 context7/playwright plugins |

---

## 实施检查清单

- [x] 分析 Claude Code skills 发现机制
- [x] 评估方案 A-D 可行性
- [x] 发现并验证 Plugin Marketplace 机制
- [x] 创建 aria-skills 仓库 (GitHub + Forgejo)
- [x] 配置 marketplace.json (5 个插件组)
- [x] 迁移 20 个通用 Skills
- [x] 清理 todo-app 保留 3 个项目特定 Skills
- [x] 更新 todo-app/.claude/skills/README.md
- [x] 验证 `/plugin marketplace add` 成功
- [x] 验证 `/plugin install all-skills` 成功
- [x] 清理重复的子集 plugins
- [x] 处理 MCP 与 Plugin 冲突

---

## 最终配置

### todo-app 当前 Plugin 配置

```json
{
  "all-skills@10cg-aria-skills": true,
  "code-review@claude-plugins-official": true,
  "frontend-design@claude-plugins-official": false
}
```

### todo-app 当前 MCP 配置

```json
{
  "context7": "@upstash/context7-mcp",
  "playwright": "@playwright/mcp@latest",
  "time-mcp": "time-mcp",
  "sequential-thinking": "@modelcontextprotocol/server-sequential-thinking"
}
```

---

## 相关文档

- [aria-skills (GitHub)](https://github.com/simonfishgit/aria-skills) - Plugin Marketplace 仓库
- [aria-skills (Forgejo)](https://forgejo.10cg.pub/10CG/aria-skills) - 内部备份
- [Anthropic Skills](https://github.com/anthropics/skills) - 官方 Skills 参考
- [todo-app/.claude/skills/README.md](/.claude/skills/README.md) - 项目特定 Skills 说明
