# 文档元数据规范

> **文档类型**: 方法论规范
> **版本**: 1.0.0
> **最后更新**: 2025-12-28
> **适用范围**: 所有 AI-DDD 项目

## 概述

本文档定义了 AI-DDD 项目中技术文档应包含的元数据字段标准格式。

## 时间字段

### 必需字段

所有技术文档应包含以下时间字段：

```yaml
created_at: YYYY-MM-DD         # 文档创建日期
updated_at: YYYY-MM-DD HH:MM   # 文档最后更新时间
```

### 格式标准

- **日期格式**: ISO 8601 (`YYYY-MM-DD`)
- **时间格式**: 24小时制 (`HH:MM`)
- **逻辑约束**: `created_at ≤ updated_at`

### 可选时间字段

```yaml
planned_start: YYYY-MM-DD      # 计划开始时间
planned_end: YYYY-MM-DD        # 计划结束时间
archived_at: YYYY-MM-DD        # 归档时间
deprecated_at: YYYY-MM-DD      # 废弃时间
```

## 文档标识字段

### 推荐字段

```yaml
version: 1.0.0                 # 文档版本号
status: draft/active/deprecated # 文档状态
```

## 文档关系字段

### 推荐字段

```yaml
related:
  - path/to/related-doc.md     # 相关文档路径
depends_on:
  - path/to/dependency.md      # 依赖文档路径
```

## 示例

### 完整示例

```markdown
---
created_at: 2025-01-15
updated_at: 2025-01-20 14:30
version: 1.0.0
status: active
related:
  - ../architecture/system-design.md
depends_on:
  - ../standards/api-contract.md
---

# 文档标题
```

## RACI 说明

AI 在编辑文档时应：
1. 创建新文档时添加 `created_at`（使用时间工具获取当前日期）
2. 每次实质性更新时修改 `updated_at`（使用时间工具获取当前时间）
3. 保持 `created_at` 不变

---

**维护**: Standards Team
**参考**: ISO 8601 数据元素和交换格式
