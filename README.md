# AI驱动开发标准仓库

> **Aria Methodology** (AI-DDD v3.0) - AI + Rhythm + Iteration + Automation
> 融合 OpenSpec、十步循环、需求管理的完整开发规范体系

## 核心价值

本仓库提供了一套完整的AI驱动开发规范体系：

| 模块 | 说明 |
|------|------|
| **十步循环模型** | 融合 OpenSpec + AI-DDD + 分支管理的完整工作流 |
| **统一进度管理 (UPM)** | 单一可信源的进度追踪体系 |
| **OpenSpec 规范** | 规范驱动开发 (Draft → Review → Implement → Archive) |
| **需求管理系统** | PRD/User Story + Forgejo Issue 同步 |
| **摘要文件系统** | Token 优化的分层上下文加载 |

## 快速开始

### 1. 集成到项目

```bash
# 使用 Git Submodule（推荐）
git submodule add ssh://forgejo@forgejo.10cg.pub/10CG/ai-dev-standards.git standards
git submodule update --init --recursive
```

### 2. 配置 CLAUDE.md

```markdown
# 项目AI配置

## 上下文加载策略
L0 (Always): CLAUDE.md + summaries/
L1 (On-Demand): {module}/ARCHITECTURE.md, UPM
L2 (Deep-Dive): 完整规范文档

## 引用标准规范
@standards/core/ten-step-cycle/           # 十步循环
@standards/core/upm/                      # 统一进度管理
@standards/summaries/                     # 摘要文件
@standards/conventions/                   # 开发约定
```

### 3. 应用十步循环

参考 [十步循环指南](core/ten-step-cycle/README.md)：

| Phase | Steps | 说明 |
|-------|-------|------|
| **A** | 0-3 | 规范与规划 |
| **B** | 4-6 | 开发执行 |
| **C** | 7-8 | 提交与集成 |
| **D** | 9-10 | 闭环与归档 |

## 仓库结构

```
standards/
├── core/                           # 核心规范体系 (SSOT)
│   ├── ten-step-cycle/             # 十步循环模型
│   ├── seven-step-cycle/           # 七步循环模型 (原版)
│   ├── upm/                        # 统一进度管理规范
│   ├── architecture/               # 架构文档方法论
│   ├── design-system/              # 设计系统规范
│   ├── progress-management/        # 进度管理核心
│   ├── state-management/           # 状态管理
│   └── workflow/                   # 工作流规范
│
├── methodology/                    # 方法论定义
│   ├── aria-brand-guide.md         # Aria 品牌指南
│   └── contract-driven-development.md
│
├── openspec/                       # OpenSpec 规范驱动开发
│   ├── project.md                  # 项目配置
│   ├── AGENTS.md                   # Agent 定义
│   ├── specs/                      # 稳定规范
│   ├── changes/                    # 变更中规范
│   └── archive/                    # 已归档规范
│
├── summaries/                      # 摘要文件 (Token优化)
│   ├── ten-step-cycle-summary.md
│   ├── workflow-summary.md
│   ├── conventions-summary.md
│   ├── extensions-summary.md
│   ├── upm-summary.md
│   └── requirements-skills-summary.md
│
├── templates/                      # 项目模板
│   ├── prd-template.md             # PRD 模板
│   ├── user-story-template.md      # User Story 模板
│   ├── ai-task-execution.md        # AI任务执行模板
│   └── claude-config/              # CLAUDE.md 配置模板
│
├── extensions/                     # 模块扩展规范
│   ├── backend-ai-ddd-extension.md
│   └── mobile-ai-ddd-extension.md
│
├── conventions/                    # 编码和文档约定
│   ├── git-commit.md               # Git提交规范
│   ├── naming-conventions.md       # 命名规范
│   ├── document-classification.md  # 文档分类
│   └── content-integrity.md        # 内容真实性
│
├── workflow/                       # 工作流指南
│   ├── branch-management-guide.md
│   ├── git-submodule-workflow.md
│   ├── requirements-workflows.md   # 需求工作流
│   └── ai-development-workflow.md
│
├── reference/                      # 参考资料
│   └── ai-ddd-glossary.md          # 术语表
│
├── governance/                     # 治理规范
│   └── raci-standard.md
│
└── tools/                          # 自动化工具
    └── setup/
```

## 文档索引

### 核心文档

| 文档 | 路径 | 说明 |
|------|------|------|
| 十步循环概述 | [core/ten-step-cycle/README.md](core/ten-step-cycle/README.md) | 推荐入口 |
| Phase A: 规范与规划 | [core/ten-step-cycle/phase-a-spec-planning.md](core/ten-step-cycle/phase-a-spec-planning.md) | Steps 0-3 |
| Phase B: 开发执行 | [core/ten-step-cycle/phase-b-development.md](core/ten-step-cycle/phase-b-development.md) | Steps 4-6 |
| Phase C: 提交与集成 | [core/ten-step-cycle/phase-c-integration.md](core/ten-step-cycle/phase-c-integration.md) | Steps 7-8 |
| Phase D: 闭环与归档 | [core/ten-step-cycle/phase-d-closure.md](core/ten-step-cycle/phase-d-closure.md) | Steps 9-10 |

### 进度管理

| 文档 | 路径 |
|------|------|
| UPM 规范 | [core/upm/unified-progress-management-spec.md](core/upm/unified-progress-management-spec.md) |
| UPM 需求扩展 | [core/upm/upm-requirements-extension.md](core/upm/upm-requirements-extension.md) |
| 进度管理核心 | [core/progress-management/ai-ddd-progress-management-core.md](core/progress-management/ai-ddd-progress-management-core.md) |

### 架构文档

| 文档 | 路径 |
|------|------|
| 架构文档方法论 | [core/architecture/README.md](core/architecture/README.md) |
| 分层系统 | [core/architecture/layering-system.md](core/architecture/layering-system.md) |
| 文档模板 | [core/architecture/document-templates.md](core/architecture/document-templates.md) |

### 方法论

| 文档 | 路径 |
|------|------|
| Aria 品牌指南 | [methodology/aria-brand-guide.md](methodology/aria-brand-guide.md) |
| 契约驱动开发 | [methodology/contract-driven-development.md](methodology/contract-driven-development.md) |

### OpenSpec

| 文档 | 路径 |
|------|------|
| Agent 定义 | [openspec/AGENTS.md](openspec/AGENTS.md) |
| 归档变更 | [openspec/archive/](openspec/archive/) |

### 工作流程

| 文档 | 路径 |
|------|------|
| 分支管理指南 | [workflow/branch-management-guide.md](workflow/branch-management-guide.md) |
| Git Submodule 工作流 | [workflow/git-submodule-workflow.md](workflow/git-submodule-workflow.md) |
| 需求工作流 | [workflow/requirements-workflows.md](workflow/requirements-workflows.md) |
| AI 开发工作流 | [workflow/ai-development-workflow.md](workflow/ai-development-workflow.md) |

### 开发约定

| 文档 | 路径 |
|------|------|
| Git 提交规范 | [conventions/git-commit.md](conventions/git-commit.md) |
| 命名规范 | [conventions/naming-conventions.md](conventions/naming-conventions.md) |
| 文档分类 | [conventions/document-classification.md](conventions/document-classification.md) |

### 模块扩展

| 文档 | 路径 |
|------|------|
| Backend 扩展规范 | [extensions/backend-ai-ddd-extension.md](extensions/backend-ai-ddd-extension.md) |
| Mobile 扩展规范 | [extensions/mobile-ai-ddd-extension.md](extensions/mobile-ai-ddd-extension.md) |

### 参考资料

| 文档 | 路径 |
|------|------|
| AI-DDD 术语表 | [reference/ai-ddd-glossary.md](reference/ai-ddd-glossary.md) |

## 版本管理

| 版本 | 说明 |
|------|------|
| 主版本 | 重大架构调整 |
| 次版本 | 新增规范或工具 |
| 修订版 | bug修复和优化 |

**当前版本**: 3.0.0 (Aria Methodology)

## 贡献指南

欢迎提交改进建议和最佳实践案例。

## 许可

MIT License

---

**最后更新**: 2026-01-02
**维护者**: AI-DDD Development Team
