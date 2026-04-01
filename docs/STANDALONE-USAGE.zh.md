[English](STANDALONE-USAGE.md) | **中文**

# 独立使用 aria-standards（不依赖 aria-plugin）

aria-standards 是一个独立的方法论库。你可以在不安装 Aria 插件或 Aria 主项目的情况下使用它。本指南说明如何操作。

## 你会获得什么

aria-standards 提供**方法论定义** — 告诉你的 AI 助手如何工作的文档：

| 内容 | 位置 | 用途 |
|------|------|------|
| 十步循环 | `core/ten-step-cycle/` | 结构化开发工作流 |
| OpenSpec | `openspec/templates/` | 规范驱动的需求格式 |
| 约定 | `conventions/` | Git 提交、命名、版本管理 |
| 模板 | `templates/` | PRD、User Story、架构文档 |
| 进度管理 | `core/upm/` | 统一进度追踪 |

## 安装

```bash
cd your-project
git submodule add https://github.com/10CG/aria-standards.git standards
```

## 最小配置

你只需要一个 `CLAUDE.md`（或等价的 AI 配置文件）引用这些标准：

```markdown
# 项目 AI 配置

## 工作流
遵循十步循环: @standards/core/ten-step-cycle/README.md

## 约定
- Git 提交: @standards/conventions/git-commit.md
- 命名: @standards/conventions/naming-conventions.md

## 规范
使用 OpenSpec 管理需求: @standards/openspec/templates/
```

就这样。你的 AI 助手读取 `CLAUDE.md`，跟随链接，应用标准。

## 按需选用

不必全部使用。常见组合：

### 仅工作流
```markdown
@standards/core/ten-step-cycle/README.md
@standards/summaries/ten-step-cycle-summary.md
```

### 仅规范格式
```markdown
功能使用 OpenSpec Level 2: @standards/openspec/templates/
完成的规范归档到 openspec/archive/
```

### 仅约定
```markdown
@standards/conventions/git-commit.md
@standards/conventions/naming-conventions.md
@standards/conventions/changelog-format.md
```

### 工作流 + 约定（推荐最小组合）
```markdown
@standards/summaries/ten-step-cycle-summary.md
@standards/conventions/git-commit.md
OpenSpec Level 2 用于功能，Level 1 用于 bug 修复。
模板: @standards/openspec/templates/
```

## Token 优化

对上下文有限的 AI 助手，使用摘要文件代替完整文档：

| 完整文档 | 摘要替代 |
|----------|---------|
| `core/ten-step-cycle/README.md` | `summaries/ten-step-cycle-summary.md` |
| `core/upm/` | `summaries/upm-summary.md` |
| 全部约定 | `summaries/conventions-summary.md` |

## 与使用 aria-plugin 的区别

| 功能 | 仅 Standards | 配合 aria-plugin |
|------|-------------|-----------------|
| 十步循环定义 | 手动参考 | Skills 自动化 |
| OpenSpec 模板 | 手动复制 | `/aria:spec-drafter` |
| Git 提交格式 | 手动遵守 | `/aria:commit-msg-generator` |
| 状态扫描 | 不可用 | `/aria:state-scanner` |
| 任务规划 | 手动 | `/aria:task-planner` |

仅使用 Standards 适合想要方法论但不需要 Claude Code 插件自动化层的团队。

## 更新

```bash
git submodule update --remote standards
```

## 兼容性

- 适用于任何能读取项目文档的 AI 助手
- 不依赖 Claude Code、aria-plugin 或 Aria 主项目
- 纯 Markdown 文件 — 无运行时、无构建步骤
