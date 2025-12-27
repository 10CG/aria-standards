# AI Integration Guide for Architecture Documentation

> **Version**: 1.0.0
> **Created**: 2025-12-28
> **Status**: production

## Overview

本指南定义了 AI 系统如何有效地使用和维护架构文档，确保 AI 辅助开发的一致性和质量。

## AI Quick Index Format

### Purpose

AI 快速索引是每个架构文档顶部的标准化元数据区块，使 AI 能快速理解文档内容和范围。

### Required Fields

```markdown
## AI Quick Index
- **Document Type**: [type]           # Required
- **Version**: X.Y.Z                  # Required
- **Created**: YYYY-MM-DDTHH:mm:ss+TZ # Required
- **Updated**: YYYY-MM-DDTHH:mm:ss+TZ # Required
- **Status**: [status]                # Required
```

### Optional Fields

```markdown
- **Author**: [team/person]           # Optional
- **Module Type**: [category]         # Optional for L1/L2
- **Core Function**: [description]    # Optional for L1/L2
- **Key Files**: [list]               # Optional for L1/L2
- **Dependencies**: [list]            # Optional
- **Specification Version**: vX.Y     # Optional
```

### Document Types

| Type | Description | Level |
|------|-------------|-------|
| Architecture Index | Module-level index | L0 |
| Component Architecture | Major component | L1 |
| Sub-Component Architecture | Functional unit | L2 |
| API Documentation | API reference | - |
| Design Document | Design decisions | - |

---

## AI Execution Principles

### Core Rules

1. **Read Before Write**: 永远先阅读现有文档再进行修改
2. **Tool First**: 优先使用自动化工具，避免手动估算
3. **Validate After**: 操作后运行验证工具确认质量
4. **Follow Process**: 完整执行规范流程，不跳步骤

### Mandatory Workflow

```
操作前 → 读取相关规范文档
   ↓
操作中 → 使用标准模板和工具
   ↓
操作后 → 运行验证，确认结果
```

### Prohibited Actions

| Action | Reason | Alternative |
|--------|--------|-------------|
| 手动估算统计数据 | 容易出错 | 使用工具生成 |
| 跳过验证步骤 | 质量无法保证 | 始终运行验证 |
| 直接删除文档内容 | 可能丢失信息 | 标记废弃后归档 |
| 忽略模板格式 | 破坏一致性 | 严格遵循模板 |

---

## Decision Matrix Template

### When to Create Document

```
新目录/模块
    │
    ▼
代码文件数 ≥ 5？
    │
   是 ──► 创建独立架构文档
    │
   否 ──► 在父目录文档中记录
```

### When to Update Document

| Trigger | Action | Priority |
|---------|--------|----------|
| 新增代码文件 | 更新文件列表，标记⭐ | High |
| 删除代码文件 | 标记❌，更新统计 | High |
| 依赖变更 | 更新依赖章节 | High |
| 重构模块 | 更新架构描述 | High |
| 修复Bug | 通常不需要 | Low |
| 配置更改 | 通常不需要 | Low |

### Document Level Selection

| Condition | Level | Document Name |
|-----------|-------|---------------|
| 模块根目录 | L0 | `ARCHITECTURE_DOCS_INDEX.md` |
| 文件数 ≥ 10 | L1 | `ARCHITECTURE.md` |
| 文件数 5-10 | L2 | `ARCHITECTURE.md` |
| 文件数 < 5 | - | 归入父文档 |

---

## Query Strategies

### Finding Architecture Information

```yaml
Step 1: 确定目标模块
  - Mobile? Backend? Frontend?

Step 2: 读取 L0 索引
  - {module}/ARCHITECTURE_DOCS_INDEX.md
  - 获取文档层级结构

Step 3: 根据需求深入
  - 概览 → 保持 L0
  - 组件详情 → 进入 L1
  - 具体实现 → 进入 L2
```

### Information Retrieval Order

```
1. ARCHITECTURE_DOCS_INDEX.md  (全局视图)
2. ARCHITECTURE_DOCS_TREE.md   (文件结构)
3. Component ARCHITECTURE.md   (组件详情)
4. Sub-component docs          (具体实现)
```

### Answering Questions

| Question Type | Start From | Depth |
|---------------|------------|-------|
| "模块做什么？" | L0 Index | Shallow |
| "这个文件属于哪里？" | TREE → Index | Medium |
| "这两个组件如何交互？" | L1 Docs | Deep |
| "这个类的职责？" | L2 Docs | Very Deep |

---

## Conflict Resolution

### Version Conflicts

```yaml
场景: 多个版本信息不一致

解决:
  1. 以 AI Quick Index 中的版本为准
  2. 更新所有冲突位置
  3. 添加版本历史记录
```

### Timestamp Conflicts

```yaml
场景: 时间戳格式不一致

解决:
  1. 统一使用 ISO 8601 格式
  2. 精确到秒: YYYY-MM-DDTHH:mm:ss+TZ
  3. 更新时间必须晚于创建时间
```

### Content Conflicts

```yaml
场景: 文档内容与代码不符

解决:
  1. 以代码为准 (single source of truth)
  2. 运行工具生成最新数据
  3. 更新文档反映实际状态
  4. 记录变更原因
```

### Cross-Reference Conflicts

```yaml
场景: 引用链接断裂

解决:
  1. 运行链接验证工具
  2. 修复或移除断链
  3. 更新相关文档的引用
```

---

## AI Operation Checklist

### Before Any Operation

- [ ] 确认操作目标和范围
- [ ] 读取相关规范文档
- [ ] 了解现有文档结构

### During Document Creation

- [ ] 选择正确的模板 (L0/L1/L2)
- [ ] 填写所有必需字段
- [ ] 使用工具生成统计数据
- [ ] 建立上下级引用链接

### During Document Update

- [ ] 找到正确的归属文档
- [ ] 使用标准变更标记 (⭐❌🔄)
- [ ] 更新版本号和时间戳
- [ ] 添加版本历史记录

### After Any Operation

- [ ] 运行 Level 1 格式验证
- [ ] 检查链接有效性
- [ ] 确认统计数据准确
- [ ] 验证与代码同步提交

---

## Integration with Skills

### Related Skills

| Skill | Purpose | Usage |
|-------|---------|-------|
| arch-common | 共享配置定义 | 被其他 arch Skills 引用 |
| arch-search | 搜索架构文档 | 查找信息时使用 |
| arch-update | 创建/更新架构文档 | 文档操作时使用 |

### Reference Hierarchy

```
@standards/core/architecture/  ← 通用方法论 (本目录)
            ↑
arch-common/SKILL.md           ← 项目共享配置
            ↑
arch-search, arch-update       ← 具体操作 Skills
```

### Skill Invocation Guidelines

```yaml
搜索信息:
  trigger: 需要查找架构相关信息
  use: arch-search
  input: 搜索关键词或问题

更新文档:
  trigger: 代码变更需要同步文档
  use: arch-update
  input: 变更描述和目标模块
```

---

## Best Practices Summary

1. **Always use templates**: 不要从零开始创建文档
2. **Keep AI Index first**: 元数据始终在文档顶部
3. **Single source of truth**: 代码是真相来源
4. **Incremental updates**: 小步更新，频繁验证
5. **Link, don't duplicate**: 使用引用而非复制内容
6. **Validate everything**: 每次操作后运行验证

