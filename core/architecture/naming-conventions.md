# Architecture Documentation Naming Conventions

> **Version**: 1.0.0
> **Created**: 2025-12-28
> **Status**: production

## Overview

命名规范定义了架构文档系统中所有目录、文件和版本的命名标准，确保一致性和可发现性。

## Directory Naming

### Code Directories

代码目录使用项目的常规命名约定（通常是 PascalCase 或 snake_case）。

```
backend/
├── llm_provider/           # snake_case
├── AuthService/            # PascalCase
└── agents/                 # lowercase
```

### Documentation Directories

文档目录统一使用小写字母和连字符。

```
docs/
├── architecture/           # lowercase
├── project-standards/      # lowercase with hyphen
└── api-reference/          # lowercase with hyphen
```

### Module Root Documentation

模块根目录中的架构文档使用大写格式。

```
mobile/
├── ARCHITECTURE.md                 # Module architecture
├── ARCHITECTURE_DOCS_INDEX.md      # Document index
└── ARCHITECTURE_DOCS_TREE.md       # Auto-generated tree
```

---

## File Naming

### Architecture Documents

| Location | Convention | Example |
|----------|------------|---------|
| Code directory | UPPERCASE | `ARCHITECTURE.md` |
| Code subdirectory | UPPERCASE with prefix | `AUTH_ARCHITECTURE.md` |
| docs/ directory | lowercase-hyphen | `auth-architecture.md` |

### Index Documents

| Type | Name | Location |
|------|------|----------|
| Document Index | `ARCHITECTURE_DOCS_INDEX.md` | Module root |
| Document Tree | `ARCHITECTURE_DOCS_TREE.md` | Module root (auto-generated) |

### Special Documents

| Document | Name | Purpose |
|----------|------|---------|
| Module README | `README.md` | Module overview |
| Architecture Overview | `{MODULE}_ARCHITECTURE.md` | L0 architecture |
| Component Architecture | `ARCHITECTURE.md` | L1/L2 architecture |

---

## Version Format

### Semantic Versioning

```
X.Y.Z
│ │ └── Patch: Documentation fixes, minor corrections
│ └──── Minor: New sections, non-breaking additions
└────── Major: Structural changes, breaking updates
```

### Version Examples

| Version | Change Type | Description |
|---------|-------------|-------------|
| 1.0.0 → 2.0.0 | Major | Architecture restructure |
| 1.0.0 → 1.1.0 | Minor | New component added |
| 1.0.0 → 1.0.1 | Patch | Typo fix, format correction |

### Specification Version

规范版本使用 `vX.Y` 格式：

```yaml
format: vX.Y
examples:
  - v4.5  # Current specification
  - v5.0  # Next major version
```

---

## Timestamp Format

### ISO 8601 Standard

所有时间戳使用 ISO 8601 格式，精确到秒：

```
YYYY-MM-DDTHH:mm:ss+TZ

Examples:
  2025-12-28T10:30:00+08:00  # Full format with timezone
  2025-12-28T10:30:00        # Without timezone (local)
```

### Timestamp Usage

| Field | Format | Example |
|-------|--------|---------|
| Created | Full ISO 8601 | `2025-12-28T10:30:00+08:00` |
| Updated | Full ISO 8601 | `2025-12-28T15:45:00+08:00` |
| Version History | ISO 8601 (no TZ) | `2025-12-28T10:30:00` |

---

## Status Values

### Document Status

| Status | Meaning | Visibility |
|--------|---------|------------|
| `draft` | Work in progress | Internal only |
| `production` | Active and maintained | Public |
| `deprecated` | Scheduled for removal | With warning |
| `archived` | No longer maintained | Read-only |

### Status Transitions

```
draft → production → deprecated → archived
          ↓
        (direct delete if never published)
```

---

## Change Markers

### File List Markers

在文档的文件列表中使用标记：

| Marker | Meaning | Example |
|--------|---------|---------|
| ⭐ | New file | `auth_service.dart - 认证服务 ⭐新增` |
| ❌ | Deleted file | `~~old_file.dart~~ ❌已删除` |
| 🔄 | Renamed/moved | `new_name.dart - 重命名自old_name 🔄` |

---

## Naming Rules Summary

### Do's

- Use consistent case within each context
- Use hyphens in documentation file names
- Use underscores or PascalCase in code directories
- Keep names descriptive but concise
- Use UPPERCASE for important architecture files in code directories

### Don'ts

- Don't mix naming conventions within the same directory type
- Don't use spaces in file or directory names
- Don't use special characters except hyphens and underscores
- Don't exceed 50 characters for file names
- Don't use generic names like `doc.md` or `info.md`

---

## Examples

### Complete Module Structure

```
mobile/
├── ARCHITECTURE.md                     # L0 overview (UPPERCASE)
├── ARCHITECTURE_DOCS_INDEX.md          # Index (UPPERCASE)
├── ARCHITECTURE_DOCS_TREE.md           # Tree (UPPERCASE, auto)
├── docs/
│   ├── architecture/
│   │   ├── core-architecture.md        # lowercase-hyphen
│   │   └── features-architecture.md    # lowercase-hyphen
│   └── api/
│       └── auth-api.md                 # lowercase-hyphen
└── app/
    └── lib/
        ├── core/
        │   └── ARCHITECTURE.md         # L1 (UPPERCASE in code)
        └── features/
            └── auth/
                └── ARCHITECTURE.md     # L2 (UPPERCASE in code)
```

