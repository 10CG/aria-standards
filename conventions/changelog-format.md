# Changelog 格式规范

> **Version**: 1.0.0
> **Status**: Active
> **Standard**: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

---

## 概述

本项目采用 **Keep a Changelog** 格式记录版本变更历史。

---

## 文件命名

| 类型 | 文件名 | 位置 |
|------|--------|------|
| 项目 Changelog | `CHANGELOG.md` | 项目根目录 |
| Skill Changelog | `CHANGELOG.md` | `.claude/skills/{skill}/` |
| 模块 Changelog | `CHANGELOG.md` | `{module}/` |

---

## 基本格式

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- {新增功能描述}

### Changed
- {变更描述}

---

## [X.Y.Z] - YYYY-MM-DD

### Added
- {新增功能}

### Changed
- {修改内容}

### Fixed
- {修复的问题}

### Removed
- {移除的内容}

---

## [X.Y.Z-1] - YYYY-MM-DD

{...}
```

---

## 变更类型

| 类型 | 英文 | 用途 | 示例 |
|------|------|------|------|
| 新增 | `Added` | 新功能 | 添加用户登录功能 |
| 变更 | `Changed` | 现有功能的修改 | 优化查询性能 |
| 废弃 | `Deprecated` | 即将移除的功能 | 废弃旧 API 端点 |
| 移除 | `Removed` | 已移除的功能 | 移除过时的配置项 |
| 修复 | `Fixed` | Bug 修复 | 修复登录超时问题 |
| 安全 | `Security` | 安全相关修复 | 修复 XSS 漏洞 |

---

## 版本号规范

遵循 [Semantic Versioning](https://semver.org/):

```
X.Y.Z
│ │ └── Patch: Bug 修复、小改动 (向后兼容)
│ └──── Minor: 新功能 (向后兼容)
└────── Major: 破坏性变更 (不向后兼容)
```

**示例**:
- `1.0.0` → `1.0.1`: 修复 bug
- `1.0.1` → `1.1.0`: 添加新功能
- `1.1.0` → `2.0.0`: 破坏性 API 变更

---

## 项目示例

参考: `.claude/skills/commit-msg-generator/CHANGELOG.md`

```markdown
# Changelog - commit-msg-generator

All notable changes to the commit-msg-generator skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### ENHANCED_MARKERS_SPEC.md 变更历史

#### v1.3.0 - 2025-12-12

**优化原因**:
- 用户反馈：Cursor Git 界面中增强标记显示为"粘在一起"

**格式优化**:
- ✅ 增强标记之间添加空行
- ✅ 更新所有完整示例使用新格式

---

## [2.0.0] - 2025-12-09

### Added
- ✅ 添加可选参数支持（subagent_type, phase_cycle, module, context）
- ✅ 生成增强标记（🤖 Executed-By, 📋 Context, 🔗 Module）
- ✅ 完全向后兼容v1.0.0

### Changed
- 参数化设计，所有增强参数都是可选的

---

## [1.0.0] - 2025-12-09

### Added
- ✅ 基础 Conventional Commits 规范支持
- ✅ 自动分析 Git 暂存区变更
- ✅ 双语支持（中文/英文）
```

---

## 最佳实践

### DO

- ✅ 每个版本发布时更新 Changelog
- ✅ 使用 `[Unreleased]` 记录开发中的变更
- ✅ 按类型分组 (Added, Changed, Fixed, etc.)
- ✅ 使用清晰的、用户可理解的语言
- ✅ 记录破坏性变更的迁移指南

### DON'T

- ❌ 不要只写 "bug fixes" 或 "minor changes"
- ❌ 不要包含 commit hash (除非必要)
- ❌ 不要使用过于技术性的内部术语
- ❌ 不要省略日期

---

## 与 Git Commit 的关系

```
Git Commits (细粒度)     →    Changelog (版本粒度)
每次提交的记录               面向用户的变更摘要
```

**Changelog 不是 Git log 的复制**:
- Git log: 开发者视角，每次提交
- Changelog: 用户视角，每个版本的重要变更

---

## 自动化建议

可使用工具从 Conventional Commits 生成 Changelog:
- [conventional-changelog](https://github.com/conventional-changelog/conventional-changelog)
- [standard-version](https://github.com/conventional-changelog/standard-version)

但建议人工 review 确保语言清晰、用户友好。

---

## 相关文档

- [Git Commit 规范](./git-commit.md)
- [命名规范](./naming-conventions.md)
- [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
- [Semantic Versioning](https://semver.org/)
