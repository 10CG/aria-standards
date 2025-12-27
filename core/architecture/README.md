# Architecture Documentation Standards

> **Version**: 1.1.0
> **Created**: 2025-12-27
> **Updated**: 2025-12-28
> **Status**: production

## Overview

本规范定义了架构文档管理的通用方法论，适用于任何多模块项目。

## Core Documents

| Document | Purpose |
|----------|---------|
| [layering-system.md](layering-system.md) | L0/L1/L2 三层架构体系 |
| [document-templates.md](document-templates.md) | 架构文档标准模板 |
| [validation-levels.md](validation-levels.md) | 三级验证体系 |
| [naming-conventions.md](naming-conventions.md) | 命名规范 (目录/文件/版本) |
| [lifecycle-management.md](lifecycle-management.md) | 文档生命周期管理 |
| [ai-integration-guide.md](ai-integration-guide.md) | AI 集成使用指南 |

## Quick Reference

### Three-Layer Architecture (L0/L1/L2)

```
L0 - Module Level    : 整个模块的总体架构 (根目录)
L1 - Major Component : 主要组件架构 (≥10 files)
L2 - Sub-Component   : 功能组件架构 (5-10 files)
```

### Document Threshold

| Condition | Action |
|-----------|--------|
| Files ≥ 5 | Create independent ARCHITECTURE.md |
| Files < 5 | Include in parent document |

### Validation Levels

```
Level 1 (Auto)     : Format, structure, completeness
Level 2 (Semi-Auto): Coverage, links, dependencies
Level 3 (Manual)   : Clarity, design quality
```

## Usage

This methodology can be applied to any project by:

1. Defining module boundaries (e.g., mobile/, backend/, frontend/)
2. Creating L0 index at each module root
3. Creating L1/L2 documents as modules grow
4. Running three-level validation

## Document Index

### Core Methodology

| Document | Description | Audience |
|----------|-------------|----------|
| **layering-system.md** | L0/L1/L2 层级定义、阈值规则、决策流程 | All |
| **document-templates.md** | 各层级文档模板、元数据标准 | Developers |
| **validation-levels.md** | 三级验证体系、检查清单 | Developers, CI |

### Supporting Standards

| Document | Description | Audience |
|----------|-------------|----------|
| **naming-conventions.md** | 目录/文件/版本命名规范 | Developers |
| **lifecycle-management.md** | 创建/更新/废弃/归档流程 | Tech Leads |
| **ai-integration-guide.md** | AI 使用规范、决策矩阵 | AI Systems |

## Related

- Project implementations extend these standards with specific configurations
- See project's `docs/project-standards/` for project-specific implementations
- Skills reference this directory via `@standards/core/architecture/`

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.1.0 | 2025-12-28 | Added naming-conventions, lifecycle-management, ai-integration-guide |
| 1.0.0 | 2025-12-27 | Initial creation with core documents |
