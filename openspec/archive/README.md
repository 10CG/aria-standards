# OpenSpec Archive

> **SSOT**: 所有已完成的 OpenSpec 变更规范统一归档于此目录

## 目录结构

```
openspec/
├── changes/          # 活跃的变更 (Draft/Review/Implementing)
│   └── {feature}/
├── archive/          # 已归档的变更 (Archived) ← 当前目录
│   ├── README.md
│   └── {date}-{feature}/
└── project.md
```

## 命名规范

**格式**: `YYYY-MM-DD-{feature-name}/`

| 组成部分 | 说明 | 示例 |
|---------|------|------|
| `YYYY-MM-DD` | 归档日期 | `2025-12-23` |
| `feature-name` | 变更名称 (kebab-case) | `git-commit-convention` |

**示例**:
- `2025-12-23-git-commit-convention/`
- `2025-12-22-optimize-phase-a-with-dual-layer-architecture/`

## 归档流程

### 1. 更新 proposal.md 状态

```markdown
> **Status**: Archived
> **Implemented**: YYYY-MM-DD
> **Archived**: YYYY-MM-DD
```

### 2. 移动到归档目录

```bash
cd standards/openspec
mv changes/{feature} archive/$(date +%Y-%m-%d)-{feature}
```

### 3. 提交变更

```bash
git add -A
git commit -m "docs(openspec): 归档{feature}规范 / Archive {feature} spec"
```

## 归档条件

变更满足以下条件时应归档：

| 条件 | 说明 |
|------|------|
| **Status = Implemented** | 核心功能已实施 |
| **Success Criteria 达成** | 验收标准通过 |
| **无活跃任务** | tasks.md 无进行中任务 |

## 注意事项

1. **唯一归档位置**: 只使用 `openspec/archive/`，禁止在其他位置创建归档
2. **日期前缀必填**: 所有归档目录必须包含日期前缀
3. **保持完整性**: 归档时保留所有相关文件 (proposal.md, tasks.md, design.md 等)
4. **不可逆操作**: 归档后不应再修改内容，如需变更应创建新的 change

---

**Created**: 2025-12-23
**Maintainer**: AI-DDD Development Team
