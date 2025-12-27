# Architecture Documentation Layering System

> **Version**: 1.0.0
> **Created**: 2025-12-27
> **Status**: production

## Overview

三层架构文档体系 (L0/L1/L2) 定义了架构文档的层级划分标准，确保文档粒度合适、导航清晰。

## Layer Definitions

| Layer | Name | Scope | Threshold | Location |
|-------|------|-------|-----------|----------|
| **L0** | Module Level | 整个模块的总体架构 | 整个模块 | 模块根目录 |
| **L1** | Major Component | 主要组件架构 | ≥10 files | 一级子目录 |
| **L2** | Sub-Component | 功能组件架构 | 5-10 files | 二级子目录 |

## Layer Characteristics

### L0 - Module Level Architecture

**Purpose**: 提供模块级的总体架构视图

**Content**:
- 模块目录结构概览
- 子模块/组件列表
- 跨组件依赖关系
- 技术栈说明

**Naming**: `ARCHITECTURE_DOCS_INDEX.md` 或 `{MODULE}_ARCHITECTURE.md`

**Example**:
```
mobile/
├── ARCHITECTURE_DOCS_INDEX.md   # L0: Mobile module overview
├── app/
│   ├── lib/
│   │   ├── core/                # L1 candidate
│   │   └── features/            # L1 candidate
```

### L1 - Major Component Architecture

**Purpose**: 描述主要组件的内部结构

**Threshold**: ≥10 代码文件

**Content**:
- 组件职责边界
- 内部子模块划分
- 关键设计决策
- 外部依赖关系

**Naming**: `ARCHITECTURE.md` in component directory

**Example**:
```
lib/core/                        # L1: Core component
├── ARCHITECTURE.md              # L1 document
├── services/                    # L2 candidate
├── models/                      # L2 candidate
└── utils/
```

### L2 - Sub-Component Architecture

**Purpose**: 详细描述功能组件

**Threshold**: 5-10 代码文件

**Content**:
- 文件清单 (100% coverage)
- 类/函数职责
- 数据流说明
- 测试覆盖

**Naming**: `ARCHITECTURE.md` in sub-component directory

**Example**:
```
lib/features/auth/               # L2: Auth feature
├── ARCHITECTURE.md              # L2 document
├── login_screen.dart
├── auth_service.dart
└── auth_state.dart
```

## Decision Flowchart

```
新模块/目录
    │
    ▼
是模块根目录？ ──是──► L0 (创建索引文档)
    │
    否
    ▼
文件数 ≥ 10？ ──是──► L1 (创建架构文档)
    │
    否
    ▼
文件数 ≥ 5？ ──是──► L2 (创建架构文档)
    │
    否
    ▼
归入父级文档 (在父目录的 ARCHITECTURE.md 中列出)
```

## File Counting Rules

### Counted Files

```yaml
included:
  - "*.dart"
  - "*.ts"
  - "*.js"
  - "*.py"
  - "*.go"
  - "*.java"
  - "*.kt"
  - "*.swift"
```

### Excluded Files

```yaml
excluded:
  - "*.md"           # Documentation
  - "*.json"         # Configuration
  - "*.yaml"         # Configuration
  - "*.yml"          # Configuration
  - "*.css"          # Styles
  - "*.html"         # Templates
  - "*_test.dart"    # Test files (counted separately)
  - "*.g.dart"       # Generated files
```

## Naming Conventions

### Directory Names

| Context | Convention | Example |
|---------|------------|---------|
| Code directories | PascalCase or snake_case | `AuthService/`, `auth_service/` |
| Documentation directories | lowercase | `docs/`, `architecture/` |

### Document Names

| Type | Name |
|------|------|
| L0 Index | `ARCHITECTURE_DOCS_INDEX.md` |
| L0 Overview | `{MODULE}_ARCHITECTURE.md` |
| L1/L2 Detail | `ARCHITECTURE.md` |
| Document Tree | `ARCHITECTURE_DOCS_TREE.md` (auto-generated) |

## Cross-Layer References

### Upward References (Child → Parent)

```markdown
## Parent Module
See [Core Architecture](../ARCHITECTURE.md) for overall context.
```

### Downward References (Parent → Child)

```markdown
## Sub-Components
| Component | Description | Document |
|-----------|-------------|----------|
| Auth | Authentication | [ARCHITECTURE.md](auth/ARCHITECTURE.md) |
```

### Peer References (Sibling → Sibling)

```markdown
## Dependencies
- **Auth Service**: [../auth/ARCHITECTURE.md](../auth/ARCHITECTURE.md)
```

## Best Practices

1. **Start with L0**: Always create module-level index first
2. **Grow organically**: Create L1/L2 as modules grow past thresholds
3. **Avoid over-documentation**: Don't create L2 for <5 files
4. **Keep depth ≤3**: Avoid L3 or deeper; merge into L2 if needed
5. **Update on change**: Modify documents when code structure changes

## Migration Guide

When restructuring existing documentation:

1. Identify all existing ARCHITECTURE.md files
2. Classify each as L0/L1/L2 based on location and scope
3. Rename if necessary to follow conventions
4. Create missing L0 indexes
5. Update cross-references
