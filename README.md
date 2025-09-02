# AI驱动开发标准仓库

> 以七步循环为核心的通用开发规范体系，优化Claude/Cursor使用体验

## 🎯 核心价值

本仓库提供了一套完整的AI驱动开发规范体系，包括：
- **七步循环模型** - 标准化的AI开发工作流
- **双规范协作体系** - 进度管理与代码生命周期的协同
- **架构文档管理** - 统一的文档组织和维护标准
- **最佳实践集合** - 经过验证的开发模式

## 🚀 快速开始

### 1. 集成到项目

#### 使用Git Submodule（推荐）
```bash
git submodule add https://github.com/yourname/ai-dev-standards.git standards
git submodule update --init --recursive
```

#### 使用符号链接
```bash
git clone https://github.com/yourname/ai-dev-standards.git ~/ai-dev-standards
ln -s ~/ai-dev-standards/core ./standards
```

### 2. 配置CLAUDE.md

在项目根目录创建或更新`CLAUDE.md`：
```markdown
# 项目AI配置

## 引用标准规范
@standards/core/seven-step-cycle/
@standards/workflow/ai-workflow-protocol.md
@standards/conventions/
```

### 3. 应用七步循环

参考 [七步循环指南](core/seven-step-cycle/README.md) 开始使用标准化工作流。

## 📋 仓库结构

- **core/** - 核心规范体系
  - seven-step-cycle/ - 七步循环模型
  - dual-standard-system/ - 双规范协作
  - architecture-docs/ - 架构文档管理
- **workflow/** - 工作流规范
- **conventions/** - 编码和文档约定
- **templates/** - 项目和文档模板
- **tools/** - 自动化工具
- **examples/** - 示例和最佳实践

## 🔄 版本管理

- 主版本：重大架构调整
- 次版本：新增规范或工具
- 修订版：bug修复和优化

当前版本：1.0.0

## 📚 文档索引

### 核心文档
- [七步循环概述](core/seven-step-cycle/README.md)
- [双规范协作体系](core/dual-standard-system/README.md)
- [架构文档管理](core/architecture-docs/management-system.md)

### 工作流程
- [AI工作流协议](workflow/ai-workflow-protocol.md)
- [文档驱动开发](workflow/document-driven-dev.md)

### 开发约定
- [Git提交规范](conventions/git-commit.md)
- [内容真实性规则](conventions/content-integrity.md)

## 🤝 贡献指南

欢迎提交改进建议和最佳实践案例。

## 📄 许可

MIT License
