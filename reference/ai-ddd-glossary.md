# AI-DDD 方法论术语表

> **文档类型**: 参考文档
> **版本**: 1.0.0
> **最后更新**: 2025-12-28
> **目标受众**: AI 开发代理、项目团队成员

## 概述

本术语表定义了 AI-DDD (AI-Driven Domain-Driven Development) 方法论中使用的核心术语和概念。这些术语是方法论的通用语言，适用于所有采用 AI-DDD 的项目。

## 核心概念

### AI-DDD (AI-Driven Domain-Driven Development)

AI 驱动的领域驱动开发方法论，结合了领域驱动设计原则和 AI 辅助开发实践，通过标准化流程、文档驱动和进度管理实现高质量软件开发。

**核心特征**:
- 契约驱动开发
- 文档先行
- 十步循环工作流
- 统一进度管理 (UPM)
- 单一事实来源 (SSOT)

---

### SSOT (Single Source of Truth)

单一事实来源，确保每个信息只在一个地方权威定义，其他地方通过引用使用。

**应用场景**:
- 设计令牌定义在核心设计系统
- API 契约定义在 `shared/contracts/`
- 通用开发规范定义在 `standards/`

**优势**: 避免不一致、简化维护、确保变更可追溯

---

### 十步循环 (Ten-Step Cycle)

AI-DDD 的核心工作流程，将开发任务分为四个阶段（Phase A/B/C/D）共十个步骤的循环。

**四个阶段**:
1. **Phase A (规划)**: 理解需求、创建规范
2. **Phase B (开发)**: 实施代码、编写测试
3. **Phase C (集成)**: 测试验证、文档更新
4. **Phase D (完成)**: 提交变更、进度记录

**详细规范**: `standards/core/ten-step-cycle/README.md`

---

### UPM (Unified Progress Management)

统一进度管理系统，用于跟踪和记录项目开发进度的标准化文档。

**文件位置**: `{module}/docs/project-planning/unified-progress-management.md`

**核心字段**:
- Phase: A/B/C/D
- Status: planned/in-progress/completed/blocked
- Progress: 百分比进度
- Last Updated: 最后更新时间

**详细规范**: `standards/core/upm/unified-progress-management-spec.md`

---

### OpenSpec

架构变更提案流程和规范格式，用于管理重大功能、架构变更和跨模块改动。

**目录结构**:
```
openspec/
├── changes/
│   └── {feature-name}/
│       ├── proposal.md      # 变更提案
│       ├── implementation.md # 实施计划
│       └── review.md         # 审查记录
└── AGENTS.md                 # AI 代理指南
```

**适用场景**:
- 重大功能添加
- 架构变更
- 破坏性变更
- 跨模块协作

---

### 契约驱动开发 (Contract-Driven Development)

基于 API 契约进行开发的实践，先定义接口契约（OpenAPI/gRPC），再并行开发前后端。

**优势**:
- 前后端并行开发
- 接口规范明确
- 易于测试和 Mock
- 减少集成问题

**契约位置**: `shared/contracts/`

**详细规范**: `standards/conventions/contract-driven.md`

---

### RACI 矩阵

职责分配矩阵，定义团队成员在任务中的角色。

**四种角色**:
- **R (Responsible)**: 负责执行，实际完成工作
- **A (Accountable)**: 承担责任，对结果负责
- **C (Consulted)**: 需要咨询，提供输入
- **I (Informed)**: 需要知情，接收通知

**详细规范**: `standards/conventions/raci.md`

## 工作流术语

### Phase A (规划阶段)

十步循环的第一阶段，包含需求理解、架构设计、规范创建。

**关键步骤**:
1. 理解需求和上下文
2. 设计解决方案
3. 创建技术规范

**产出**: 技术规范文档、OpenSpec 提案（如需要）

---

### Phase B (开发阶段)

十步循环的第二阶段，包含代码实施、单元测试、代码审查。

**关键步骤**:
4. 实施核心功能
5. 编写单元测试
6. 进行代码审查

**产出**: 功能代码、测试代码、审查记录

---

### Phase C (集成阶段)

十步循环的第三阶段，包含集成测试、文档更新、质量验证。

**关键步骤**:
7. 执行集成测试
8. 更新相关文档
9. 质量验证

**产出**: 测试报告、更新后的文档、质量检查记录

---

### Phase D (完成阶段)

十步循环的第四阶段，包含提交变更和进度记录。

**关键步骤**:
10. 提交代码变更
11. 更新 UPM 进度

**产出**: Git Commit、更新后的 UPM 文档

---

### L0/L1/L2 加载策略

AI 上下文的分层加载策略，优化 Token 使用。

**三层定义**:
- **L0 (Always)**: 始终加载，如 CLAUDE.md、摘要文件
- **L1 (On-Demand)**: 按需加载，如模块 ARCHITECTURE.md、UPM
- **L2 (Deep-Dive)**: 深入加载，如完整规范文档

**目的**: 最小化 Token 消耗，按需深入

## 文档术语

### 摘要文件 (Summary File)

浓缩版的规范文档，提供快速参考，减少 Token 消耗。

**位置**: `standards/summaries/`

**示例**:
- `ten-step-cycle-summary.md`
- `workflow-summary.md`
- `upm-summary.md`

**特点**: <500 tokens，只包含核心概念和决策表

---

### 架构文档 (ARCHITECTURE.md)

模块级别的架构设计文档，描述模块结构、技术选型、关键决策。

**位置**: `{module}/docs/ARCHITECTURE.md`

**内容**:
- 模块概述
- 技术栈
- 目录结构
- 关键组件
- 依赖关系

---

### Skills

AI 代理的可执行技能包，封装特定任务的执行逻辑。

**位置**: `.claude/agents/skills/`

**常见 Skills**:
- `commit-msg-generator`: 生成 Git 提交消息
- `strategic-commit-orchestrator`: 编排批量提交
- `branch-manager`: 管理分支和 PR
- `progress-updater`: 更新 UPM 进度
- `arch-search`: 搜索架构文档
- `arch-update`: 更新架构文档

**调用方式**: `/skill-name` 或通过 Skill 工具

## 技术术语

### Git Submodule

Git 子模块，允许将一个 Git 仓库作为另一个仓库的子目录。

**AI-DDD 应用**:
- `standards/`: 通用规范子模块
- `shared/`: 共享契约子模块
- `mobile/`: 移动端代码子模块
- `backend/`: 后端代码子模块

**详细规范**: `standards/workflow/git-submodule-workflow.md`

---

### Design Tokens

设计令牌，抽象的设计参数（颜色、字体、间距等），独立于具体实现。

**示例**:
```
primary.green: #24D298
font.size.h1: 32px
spacing.md: 16px
```

**详细规范**: `standards/core/design-system/`

---

### 三层文档架构

设计系统的分层文档结构。

**三层定义**:
1. **核心设计系统**: 令牌定义（平台无关）
2. **平台应用规范**: 令牌应用指南（平台特定）
3. **技术实现文档**: 代码实现（技术栈特定）

**详细规范**: `standards/core/design-system/layering-system.md`

## 扩展术语

### Mobile AI-DDD Extension

AI-DDD 方法论在移动端开发的扩展规范。

**包含内容**:
- Flutter 特定工作流
- Widget 测试策略
- 移动端 UPM 格式
- 平台特定 Skills

**详细规范**: `standards/extensions/mobile-ai-ddd-extension.md`

---

### Backend AI-DDD Extension

AI-DDD 方法论在后端开发的扩展规范。

**包含内容**:
- FastAPI 特定工作流
- API 测试策略
- 数据库迁移管理
- 后端特定 Skills

**详细规范**: `standards/extensions/backend-ai-ddd-extension.md`

## 使用指南

### AI 代理使用

AI 代理在开发过程中应：
1. 首先加载 L0 文档（CLAUDE.md、摘要文件）
2. 根据任务类型加载对应模块的 ARCHITECTURE.md 和 UPM
3. 需要详细规范时再加载 L2 完整文档
4. 使用本术语表理解方法论概念

### 人类团队成员使用

团队成员可使用本术语表：
- 快速了解 AI-DDD 核心概念
- 统一团队沟通语言
- 理解文档中的专业术语
- 培训新成员

## 术语更新机制

### 提交新术语

如需添加新术语：
1. 在 `standards/` 仓库创建 Issue
2. 说明术语定义、使用场景、重要性
3. 提交 Pull Request
4. 经 Standards Team 审核后合并

### 修改现有术语

如需修改术语定义：
1. 提交变更提案，说明修改原因
2. 评估对现有文档的影响
3. 更新所有相关文档
4. 通知所有项目团队

## 版本历史

| 版本 | 日期 | 变更说明 |
|------|------|----------|
| 1.0.0 | 2025-12-28 | 初始版本，包含 AI-DDD 核心术语定义 |

## 参考资料

- [AI-DDD 工作流标准](../core/workflow/ai-ddd-workflow-standards.md)
- [十步循环详细规范](../core/ten-step-cycle/README.md)
- [UPM 规范](../core/upm/unified-progress-management-spec.md)
- [命名规范](../conventions/naming-conventions.md)
- [文档分类规范](../conventions/document-classification.md)

---

**维护**: Standards Team
**联系**: standards@ai-ddd.org
**许可**: MIT License
