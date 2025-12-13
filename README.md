# AI驱动开发标准仓库

> Spec-Enhanced AI-DDD 十步循环 - 融合OpenSpec、AI-DDD、分支管理的完整开发规范体系

## 🎯 核心价值

本仓库提供了一套完整的AI驱动开发规范体系，包括：
- **十步循环模型** - 融合OpenSpec + AI-DDD + 分支管理的完整工作流
- **七步循环模型** - 原有标准化的AI开发工作流
- **进度管理规范** - UPM统一进度管理体系
- **OpenSpec规范** - 规范驱动开发 (Draft → Review → Implement → Archive)
- **最佳实践集合** - 经过验证的开发模式

## 🚀 快速开始

### 1. 集成到项目

#### 使用Git Submodule（推荐）
```bash
git submodule add ssh://forgejo@forgejo.10cg.pub/10CG/ai-dev-standards.git standards
git submodule update --init --recursive
```

#### 使用集成脚本
```bash
./standards/tools/setup/integrate-standards.sh /path/to/your/project
```

### 2. 配置CLAUDE.md

在项目根目录创建或更新`CLAUDE.md`：
```markdown
# 项目AI配置

## 引用标准规范
@standards/core/ten-step-cycle/           # 十步循环 (推荐)
@standards/core/seven-step-cycle/         # 七步循环 (原版)
@standards/core/upm/                      # 统一进度管理
@standards/workflow/branch-management-guide.md
@standards/conventions/
```

### 3. 应用十步循环

参考 [十步循环指南](core/ten-step-cycle/README.md) 开始使用完整工作流：
- Phase A: 规范与规划 (Steps 0-3)
- Phase B: 开发执行 (Steps 4-6)
- Phase C: 提交与集成 (Steps 7-8)
- Phase D: 闭环与归档 (Steps 9-10)

## 📋 仓库结构

```
standards/
├── core/                           # 核心规范体系 (SSOT)
│   ├── ten-step-cycle/             # 十步循环模型 (推荐)
│   │   ├── README.md
│   │   ├── phase-a-spec-planning.md
│   │   ├── phase-b-development.md
│   │   ├── phase-c-integration.md
│   │   └── phase-d-closure.md
│   ├── seven-step-cycle/           # 七步循环模型 (原版)
│   ├── progress-management/        # 进度管理核心
│   ├── state-management/           # 状态管理
│   ├── upm/                        # 统一进度管理规范
│   └── workflow/                   # 工作流规范
│
├── openspec/                       # OpenSpec规范驱动开发
│   ├── project.md                  # 项目配置
│   ├── AGENTS.md                   # Agent定义
│   ├── specs/                      # 稳定规范
│   ├── changes/                    # 变更中规范
│   └── archive/                    # 已归档规范
│
├── extensions/                     # 模块扩展规范
│   ├── backend-ai-ddd-extension.md
│   └── mobile-ai-ddd-extension.md
│
├── conventions/                    # 编码和文档约定
│   ├── git-commit.md
│   └── content-integrity.md
│
├── workflow/                       # 工作流指南
│   ├── branch-management-guide.md
│   ├── ai-workflow-protocol.md
│   └── openspec-pilot-reference.md
│
├── templates/                      # 项目模板
│   └── claude-config/
│
└── tools/                          # 自动化工具
    └── setup/
```

## 🔄 版本管理

- 主版本：重大架构调整
- 次版本：新增规范或工具
- 修订版：bug修复和优化

当前版本：2.0.0

## 📚 文档索引

### 核心文档 (十步循环)
- [十步循环概述](core/ten-step-cycle/README.md) ⭐ 推荐
- [Phase A: 规范与规划](core/ten-step-cycle/phase-a-spec-planning.md)
- [Phase B: 开发执行](core/ten-step-cycle/phase-b-development.md)
- [Phase C: 提交与集成](core/ten-step-cycle/phase-c-integration.md)
- [Phase D: 闭环与归档](core/ten-step-cycle/phase-d-closure.md)

### 核心文档 (原版)
- [七步循环概述](core/seven-step-cycle/README.md)
- [进度管理核心](core/progress-management/ai-ddd-progress-management-core.md)
- [状态管理](core/state-management/ai-ddd-state-management.md)
- [UPM规范](core/upm/unified-progress-management-spec.md)

### OpenSpec
- [OpenSpec项目配置](openspec/project.md)
- [OpenSpec Agent定义](openspec/AGENTS.md)

### 工作流程
- [分支管理指南](workflow/branch-management-guide.md)
- [AI工作流协议](workflow/ai-workflow-protocol.md)
- [OpenSpec试点参考](workflow/openspec-pilot-reference.md)

### 开发约定
- [Git提交规范](conventions/git-commit.md)
- [内容真实性规则](conventions/content-integrity.md)

### 模块扩展
- [Backend扩展规范](extensions/backend-ai-ddd-extension.md)
- [Mobile扩展规范](extensions/mobile-ai-ddd-extension.md)

## 🤝 贡献指南

欢迎提交改进建议和最佳实践案例。

## 📄 许可

MIT License

---

**最后更新**: 2025-12-13
**维护者**: AI-DDD Development Team
