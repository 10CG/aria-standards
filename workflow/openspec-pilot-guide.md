---
created_at: '2025-11-02'
updated_at: '2025-11-02'
classification: 开发规范
subcategory: 工作流程
status: active
version: 1.0.0
document_type: 试点指南
priority_level: S级
---

# OpenSpec 试点集成指南

> **文档类型**: 试点指南
> **重要级别**: S级
> **创建时间**: 2025-11-02
> **适用范围**: Standards 子模块开发团队

## 📋 目录

1. [文档目的](#文档目的)
2. [核心概念梳理](#核心概念梳理)
3. [工作目录管理](#工作目录管理)
4. [与 Subagents 的兼容性](#与-subagents-的兼容性)
5. [试点行动方案](#试点行动方案)
6. [评估标准](#评估标准)

---

## 文档目的

本文档回答了在 standards 子模块试点 OpenSpec 框架时的**四个核心问题**：

1. ✅ **回退能力**: 如果方向不对，是否可以完整回退？
2. ⚠️ **工作目录**: 使用 OpenSpec CLI 时是否需要切换目录？
3. 🔄 **兼容性**: OpenSpec 与当前的 `.claude/agents` 子代理系统是否匹配？
4. 💡 **概念关系**: AI-DDD、OpenSpec、Standards 三者的关系是什么？

本文档为这些问题提供明确的分析和解决方案，确保试点工作有据可依。

---

## 核心概念梳理

### 问题 4 分析：三者本质关系

很多困惑源于对 AI-DDD、OpenSpec、Standards 三者关系的误解。让我们用清晰的层次图来理解：

```
┌─────────────────────────────────────────────────────────┐
│ 层次1: 方法论（Methodology） - "思想体系"              │
├─────────────────────────────────────────────────────────┤
│ AI-DDD                                                  │
│ - 七步循环（如何工作）                                  │
│ - UPM状态管理（如何追踪）                               │
│ - 三级验证（如何保证质量）                              │
│ - Contract-First（核心原则）                            │
│                                                         │
│ 本质：一套开发哲学和最佳实践                            │
└─────────────────────────────────────────────────────────┘
                        ↓ 需要承载
┌─────────────────────────────────────────────────────────┐
│ 层次2: 组织框架（Framework） - "容器结构"              │
├─────────────────────────────────────────────────────────┤
│ OpenSpec                                                │
│ - specs/ vs changes/ 目录结构                           │
│ - Delta 机制（ADDED/MODIFIED/REMOVED）                  │
│ - CLI 工具链（validate, archive等）                     │
│ - proposal.md + tasks.md 模板                           │
│                                                         │
│ 本质：一套组织和管理规范的方式                          │
└─────────────────────────────────────────────────────────┘
                        ↓ 实例化为
┌─────────────────────────────────────────────────────────┐
│ 层次3: 具体仓库（Repository） - "实际存储"             │
├─────────────────────────────────────────────────────────┤
│ standards 子模块                                        │
│ openspec/                                               │
│ ├── project.md    ← 描述AI-DDD方法论                    │
│ ├── AGENTS.md     ← 定义七步循环执行方式                │
│ └── specs/        ← 存储具体的标准内容                  │
│     ├── architecture/    ← Contract-First等原则        │
│     ├── workflow/        ← 七步循环的详细步骤          │
│     └── quality-gates/   ← 三级验证的定义              │
│                                                         │
│ 本质：使用OpenSpec框架存储AI-DDD内容的实例             │
└─────────────────────────────────────────────────────────┘
```

### 关键理解

**核心问题**: AI-DDD 本质上是否就是 OpenSpec 同类型的规则系统？

**答案**: ❌ **不是同类型！**

```
AI-DDD ≠ OpenSpec

正确的关系：
AI-DDD  = 内容（你的开发方法论）
OpenSpec = 容器（组织内容的框架）
Standards = 实例（用OpenSpec组织AI-DDD）

类比理解：
AI-DDD  = 一本书的内容（思想、原则、方法）
OpenSpec = Markdown格式（如何组织章节、引用、索引）
Standards = 一个具体的.md文件（实际的书）
```

### Standards 子模块的定位

```markdown
standards 不是"规则系统"本身
standards 是"存放你的规则的仓库"

更准确的说：
┌──────────────────────────────────────────────┐
│ standards = AI-DDD方法论的权威定义库         │
│                                              │
│ 使用 OpenSpec 结构组织                       │
│ 存储 AI-DDD 的所有规则、流程、原则           │
│ 服务 mobile、backend、shared等子模块         │
└──────────────────────────────────────────────┘

对比：
- shared子模块 = 存放API契约和数据模型
- standards子模块 = 存放开发规范和流程定义

两者都使用OpenSpec组织，但内容完全不同
```

### 融合后的完整架构

```
todo-app/                           (主仓库)
├── openspec/                       (可选：跨仓库协调)
│   └── changes/cross-repo/
│
├── standards/                      (子模块：规则定义)
│   └── openspec/
│       ├── project.md
│       │   「本仓库存储AI-DDD方法论的规范定义」
│       ├── AGENTS.md
│       │   「七步循环、质量门控等执行指令」
│       └── specs/
│           ├── methodology/
│           │   └── ai-ddd-cycle.md      # 七步循环定义
│           ├── architecture/
│           │   └── contract-first.md    # 原则
│           ├── workflow/
│           │   └── git-standards.md     # Git规范
│           └── quality/
│               └── validation-gates.md  # 质量门控
│
├── shared/                         (子模块：契约定义)
│   └── openspec/
│       ├── project.md
│       │   「本仓库存储API契约和数据模型」
│       └── specs/
│           ├── api/                # OpenAPI规范
│           └── models/             # JSON Schema
│
├── mobile/                         (子模块：移动端)
│   └── openspec/
│       ├── project.md
│       │   「遵循：@../../standards/openspec/specs/」
│       └── specs/
│           └── flutter-arch/       # 移动端特有规范
│
└── backend/                        (子模块：后端)
    └── openspec/
        ├── project.md
        │   「遵循：@../../standards/openspec/specs/」
        └── specs/
            └── api-impl/           # 后端特有规范
```

---

## 工作目录管理

### 问题 2 分析：OpenSpec CLI 的目录依赖

#### OpenSpec 工作目录要求

OpenSpec CLI 需要在包含 `openspec/` 目录的**父目录**中执行：

```bash
# OpenSpec CLI 寻找这个结构
project-root/
└── openspec/          # OpenSpec寻找这个目录
    ├── project.md
    └── specs/

# 正确的使用方式：
cd project-root
openspec list              # ✅ 正确
openspec validate [change] # ✅ 正确

# 错误的方式：
cd project-root/openspec
openspec list              # ❌ 找不到openspec/目录
```

#### 在子模块场景下的实际影响

**场景1：在 standards 子模块工作**

```bash
# 当前位置：todo-app/ (主仓库根目录)

# 方式A：切换到子模块目录（推荐）
cd standards              # 进入子模块
pwd  # → /f/work2025/cursor/todo-app/standards
openspec list             # ✅ 读取 standards/openspec/

# 方式B：从主仓库操作（不推荐，会混淆）
cd todo-app
openspec list             # ❌ 会读取 todo-app/openspec/（如果有的话）
```

**场景2：AI 执行命令时**

AI 需要明确知道在哪个目录执行命令：

```markdown
用户：「帮我在 standards 子模块中创建一个新的规范」

AI 应该执行：
1. cd standards
2. openspec proposal [...]
3. 完成后回到主目录：cd ..

而不是：
openspec proposal [...]  # ❌ 可能在错误的目录
```

### 解决方案

#### 方案 1：明确的工作流程规范

在团队内部（或 AI 指令中）明确规则：

```markdown
## 工作目录匹配原则

**在哪个仓库工作，就cd到那个仓库的根目录**

- 修改 standards 规范 → `cd standards && openspec ...`
- 修改 mobile 规范 → `cd mobile && openspec ...`
- 修改 backend 规范 → `cd backend && openspec ...`
```

#### 方案 2：辅助脚本封装

创建便捷脚本减少手动切换：

```bash
# todo-app/scripts/openspec-standards.sh
#!/bin/bash
cd "$(dirname "$0")/../standards"
openspec "$@"

# 使用：
./scripts/openspec-standards.sh list
./scripts/openspec-standards.sh validate [change]
```

#### 方案 3：在 AGENTS.md 中明确说明

在 `standards/openspec/AGENTS.md` 中为 AI 提供明确指令：

```markdown
## Working Directory Protocol

When executing OpenSpec commands in this repository, you MUST:

1. Change to the standards directory first:
   ```bash
   cd standards
   ```

2. Execute OpenSpec commands:
   ```bash
   openspec list
   openspec validate [change]
   ```

3. Return to main directory when done:
   ```bash
   cd ..
   ```

NEVER execute `openspec` commands from the main repository root
unless explicitly intended for the main repository's openspec/.
```

### 实际影响评估

✅ **可管理**: 虽然需要切换目录，但规则明确
✅ **可自动化**: 可通过脚本减少手动操作
⚠️ **需要训练**: AI 需要明确理解这个要求

---

## 与 Subagents 的兼容性

### 问题 3 分析：两个系统的关系

#### 当前的两个系统

```
系统1：.claude/agents/ (Claude Code Subagent系统)
└── 专门化AI助手（knowledge-manager, tech-lead, qa-engineer等）
    功能：执行特定角色任务
    触发：用户通过Task工具调用特定agent
    范围：整个项目的多角色协作

系统2：OpenSpec的AGENTS.md
└── 项目级AI指令文档
    功能：定义项目上下文、工作流程、规则
    触发：AI读取作为全局指导
    范围：单个仓库的规范遵守
```

#### 两者关系：分层互补

```markdown
┌─────────────────────────────────────────────────────┐
│ 层次1: Claude Code Subagents (.claude/agents/)     │
│        - 角色专门化（谁来做）                        │
│        - 跨项目通用能力                              │
│        - 示例：knowledge-manager知道如何管理文档     │
└─────────────────────────────────────────────────────┘
                        ↓ 读取并遵守
┌─────────────────────────────────────────────────────┐
│ 层次2: OpenSpec AGENTS.md (项目规则)               │
│        - 项目特定规则（怎么做）                      │
│        - 本项目的工作流程                            │
│        - 示例：本项目遵循七步循环、使用Delta机制     │
└─────────────────────────────────────────────────────┘
```

### 实际协作示例

```
场景：用户要求在standards中添加新的编码规范

Step 1: Claude主AI识别需要专门化处理
  → 调用 knowledge-manager agent

Step 2: knowledge-manager agent 激活
  → 读取 standards/openspec/AGENTS.md
  → 了解到：本项目使用OpenSpec + 七步循环

Step 3: knowledge-manager 按规则工作
  → 执行：/openspec:proposal "Add TypeScript coding standards"
  → 生成：changes/typescript-standards/
  → 遵循：AGENTS.md中定义的质量门控

Step 4: 完成后交还控制权
  → 向用户报告完成情况
```

### OpenSpec AGENTS.md 示例内容

```markdown
<!-- standards/openspec/AGENTS.md -->

# AI Agents Instructions for Standards Repository

## Project Context
This repository defines the **shared standards** for the Todo App
multi-repository project using the **AI-DDD methodology** organized
with **OpenSpec structure**.

## Workflow Instructions

### When creating a new standard:
1. Use `/openspec:proposal [description]` to create a change proposal
2. AI MUST generate Delta-based specs using ADDED/MODIFIED/REMOVED markers
3. Validate using `openspec validate [change] --strict`
4. Apply changes using `/openspec:apply [change]`
5. Archive when complete using `openspec archive [change]`

### Quality Gates (MUST check before archiving):
- [ ] Simplicity: Using ≤3 new concepts?
- [ ] Clarity: Can a new developer understand in 5 minutes?
- [ ] Consistency: Aligned with existing standards?
- [ ] Enforceability: Can be automatically checked?

### Seven-Step Cycle Mapping:
1-3. State Recognition → Planning: `/openspec:proposal`
4. Quality Gates: `openspec validate --gates`
5. Execution: `/openspec:apply`
6-7. Update & Validation: `openspec archive`

## Agent-Specific Instructions

### For knowledge-manager agent:
When managing standards documentation, you MUST:
- Create all specs in `openspec/specs/` using capability-based organization
- Use Delta markers (ADDED/MODIFIED/REMOVED) for all changes
- Update `openspec/project.md` when scope changes

### For tech-lead agent:
When reviewing architectural decisions:
- Reference standards from `openspec/specs/architecture/`
- Enforce Contract-First principle
- Ensure changes have cross-repo impact assessment

## Reference to .claude/agents
This AGENTS.md complements (not replaces) the specialized agents
defined in `.claude/agents/`. Those agents provide role expertise;
this document provides project-specific workflow rules.
```

### 兼容性结论

✅ **完全兼容**: 两个系统分层工作，不冲突
✅ **相互增强**: subagents提供角色能力，AGENTS.md提供项目规则
✅ **清晰分工**:
- `.claude/agents/` → 定义"谁"（角色能力）
- `openspec/AGENTS.md` → 定义"如何"（项目规则）

---

## 试点行动方案

### 试点目标

在 standards 子模块验证 OpenSpec 框架是否适合存储和管理 AI-DDD 方法论。

### 试点范围

**最小可验证范围**（1-2天）：

1. 在实验分支初始化 OpenSpec
2. 创建一个小的规范定义（如：Git Commit Convention）
3. 走完整个 OpenSpec 流程
4. 评估体验和效果

### 详细步骤

#### 步骤 1：准备实验环境

```bash
# 进入 standards 子模块
cd standards

# 创建实验分支（保护master分支）
git checkout -b experiment/openspec

# 验证当前状态
git status
git log --oneline -5
```

#### 步骤 2：初始化 OpenSpec 结构

**选项 A：使用 OpenSpec CLI（如果已安装）**

```bash
# 安装 OpenSpec CLI（如果尚未安装）
npm install -g @fission-codes/openspec
# 或
pip install openspec-cli

# 初始化
openspec init
```

**选项 B：手动创建结构（推荐，更可控）**

```bash
# 创建基础结构
mkdir -p openspec/{specs,changes}
mkdir -p openspec/specs/{methodology,architecture,workflow,quality}

# 创建核心文件
touch openspec/project.md
touch openspec/AGENTS.md
touch openspec/.gitkeep
```

#### 步骤 3：编写核心配置文件

**创建 `openspec/project.md`**：

```markdown
# Standards Repository - Project Context

## Purpose
This repository is the **authoritative source** for development standards,
processes, and quality gates for the Todo App multi-repository project.

It stores the **AI-DDD methodology** using the **OpenSpec framework**.

## Scope

### In Scope
- AI-DDD methodology definitions (seven-step cycle, UPM, validation)
- Architecture principles (Contract-First, Single Source of Truth)
- Coding standards (language-specific conventions)
- Workflow standards (Git, PR, review processes)
- Quality gates (Spec-Kit inspired gates)

### Out of Scope
- Feature-specific specifications (belong in mobile/backend/shared)
- API contracts (belong in shared)
- Implementation code

## Organization Principle

Specs are organized by **capability domain**, not by feature:
- `methodology/` - AI-DDD core concepts
- `architecture/` - Architectural principles
- `workflow/` - Process and workflow standards
- `quality/` - Quality gates and validation rules

## Standards Version
Current: v1.0.0
```

**创建 `openspec/AGENTS.md`**：

```markdown
# AI Agent Instructions for Standards Repository

## Working Directory Protocol
When executing OpenSpec commands, you MUST:
1. `cd standards` first
2. Execute `openspec` commands
3. `cd ..` when done

## Workflow

### Creating a new standard:
1. `/openspec:proposal [description]`
2. Generate Delta-based specs (ADDED/MODIFIED/REMOVED)
3. `openspec validate [change] --strict`
4. `/openspec:apply [change]`
5. `openspec archive [change]`

## Quality Gates
Before archiving, check:
- [ ] Simplicity: ≤3 new concepts?
- [ ] Clarity: Understandable in 5 minutes?
- [ ] Consistency: Aligned with existing standards?

## Seven-Step Cycle Integration
1-3. Recognition & Planning → `/openspec:proposal`
4. Quality Gates → `openspec validate`
5. Execution → `/openspec:apply`
6-7. Update & Validation → `openspec archive`
```

#### 步骤 4：创建第一个试点规范

**目标**: 定义 Git Commit Message Convention

```bash
# 创建变更提案目录
mkdir -p openspec/changes/git-commit-convention

# 创建提案文件
touch openspec/changes/git-commit-convention/proposal.md
touch openspec/changes/git-commit-convention/tasks.md
```

**编写 `proposal.md`**：

```markdown
# Git Commit Message Convention

## Why
Consistent commit messages improve:
- Automated changelog generation
- Code review efficiency
- Git history readability
- CI/CD automation (e.g., semantic versioning)

## What
Define and enforce a conventional commits format for all repositories:
- Main repo (todo-app)
- Standards
- Shared
- Mobile
- Backend

## Impact

### Positive
- Clearer git history
- Automated tooling becomes possible
- Better team collaboration

### Negative
- Learning curve for team members
- Requires pre-commit hook setup

## Affected Repositories
- All repositories must adopt this standard
- CI/CD pipelines need update for validation
```

**编写 `tasks.md`**：

```markdown
# Implementation Tasks

## Phase 1: Definition
- [ ] Research Conventional Commits specification
- [ ] Define allowed types (feat, fix, docs, etc.)
- [ ] Define allowed scopes (optional vs required)
- [ ] Create examples for each type

## Phase 2: Tooling
- [ ] Create commit-msg validation script
- [ ] Test script with valid/invalid examples
- [ ] Document installation process

## Phase 3: Rollout
- [ ] Update standards/tools/ with validation script
- [ ] Create installation guide
- [ ] Update all CONTRIBUTING.md files
- [ ] Announce to team (if applicable)
```

**创建 Delta spec**：

```bash
mkdir -p openspec/changes/git-commit-convention/specs/workflow
touch openspec/changes/git-commit-convention/specs/workflow/git-standards.md
```

**编写 Delta spec**：

```markdown
# Git Standards

## ADDED Requirements

### Requirement: Conventional Commits Format
All git commit messages MUST follow the Conventional Commits specification.

#### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Allowed Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Build process or tooling changes

#### Scope (Optional)
- Component or module name
- Examples: `api`, `ui`, `database`, `auth`

#### Examples
```
feat(auth): add two-factor authentication

Implements TOTP-based 2FA using authenticator apps.

Closes #123
```

```
fix(api): handle null values in task response

Previously threw NullPointerException when task
description was null.
```

### Requirement: Commit Message Validation
Projects MUST use automated validation to enforce the format.

#### Implementation
A pre-commit hook script SHALL be provided in `standards/tools/`.

#### Validation Rules
- Type must be in allowed list
- Subject must be lowercase
- Subject must not end with period
- Subject length ≤ 72 characters
```

#### 步骤 5：验证试点流程

```bash
# 如果有 OpenSpec CLI
cd standards
openspec validate git-commit-convention

# 手动验证检查清单：
# ✓ proposal.md 结构完整？
# ✓ tasks.md 清单明确？
# ✓ Delta 标记清晰？（ADDED/MODIFIED/REMOVED）
# ✓ 符合 AGENTS.md 中的质量门控？
```

#### 步骤 6：评估试点效果

创建评估清单：

```markdown
## OpenSpec 试点评估

### AI 生成质量
- [ ] AI 能准确理解 proposal 格式？
- [ ] AI 能正确生成 Delta 标记？
- [ ] AI 生成的内容需要多少人工修正？（目标<20%）

### 流程顺畅度
- [ ] 从 proposal 到 spec 的流程是否清晰？
- [ ] 与传统 markdown 文档相比是否更高效？
- [ ] 是否存在明显的痛点或阻塞？

### 工具链体验
- [ ] OpenSpec CLI（如果使用）是否稳定？
- [ ] 目录切换是否造成困扰？
- [ ] 文档组织是否比传统方式更清晰？

### 整体价值
- [ ] OpenSpec 是否带来实际价值？
- [ ] 是否值得在其他子模块推广？
- [ ] 如果不继续，是否有可提取的思路？
```

### 决策点

**试点成功标准**（满足 ≥ 80%）：

- ✅ AI 生成 Delta 准确率 > 85%
- ✅ 流程比传统方式更清晰
- ✅ 没有明显的工具链障碍
- ✅ 团队（或AI）理解成本 < 2小时

**行动决策**：

```
如果成功标准达成：
→ 合并 experiment/openspec 到 master
→ 继续完善 standards 的其他规范
→ 为 shared、mobile、backend 推广做准备

如果未达成：
→ 分析具体失败原因
→ 决定是否调整后重试
→ 或回退到传统方式，保留学习成果
```

---

## 评估标准

### 量化指标

| 指标 | 目标值 | 测量方法 |
|------|--------|---------|
| AI Delta 生成准确率 | > 85% | 人工审查生成的 Delta 标记 |
| 人工修正比例 | < 20% | 修改行数 / 总行数 |
| 流程完成时间 | < 传统方式 | 记录从提议到归档的时间 |
| 工具错误率 | < 10% | CLI 命令失败次数 / 总次数 |

### 定性评估

- **清晰度**: 结构是否比传统 markdown 更清晰？
- **可维护性**: 长期维护是否更容易？
- **可扩展性**: 是否便于添加新规范？
- **AI 友好性**: AI 是否能更准确理解意图？

### 决策矩阵

| 场景 | 行动 |
|------|------|
| 所有指标达标 + 定性评估优秀 | ✅ 全面采用，推广到其他模块 |
| 大部分指标达标，部分定性优秀 | 🟡 继续优化，局部使用 |
| 指标未达标但发现有价值思路 | 🟠 回退，但保留学习成果 |
| 完全不适合 | 🔴 完全回退，总结经验教训 |

---

## 附录：快速参考

### 常用命令

```bash
# 切换到 standards 并初始化
cd standards
git checkout -b experiment/openspec
mkdir -p openspec/{specs,changes}

# 创建变更提案
mkdir -p openspec/changes/[change-name]
touch openspec/changes/[change-name]/{proposal.md,tasks.md}

# 如果成功，合并到 master
git checkout master
git merge experiment/openspec
git tag v2.0.0-openspec

# 如果失败，回退
git checkout master
git branch -D experiment/openspec
```

### 关键文件位置

```
standards/
├── openspec/
│   ├── project.md          # 项目上下文
│   ├── AGENTS.md           # AI 工作流指令
│   ├── specs/              # 当前真相源
│   │   ├── methodology/
│   │   ├── architecture/
│   │   ├── workflow/
│   │   └── quality/
│   └── changes/            # 变更提案
│       └── [change-name]/
│           ├── proposal.md
│           ├── tasks.md
│           └── specs/
└── workflow/
    ├── submodule-development-roadmap.md  # 开发路线图
    └── openspec-pilot-guide.md           # 本文档
```

---

**最后更新**: 2025-11-02
**维护者**: 技术团队
**版本**: v1.0.0
