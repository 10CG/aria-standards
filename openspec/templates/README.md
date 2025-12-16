# OpenSpec Templates

本目录包含 OpenSpec 规范的模板文件，用于快速创建符合规范的 Spec 文档。

## 三级 Spec 策略

| 级别 | 模板 | 适用场景 |
|------|------|---------|
| **Skip (Level 1)** | 无需模板 | 简单修复、配置调整、文档格式 |
| **Minimal (Level 2)** | `proposal-minimal.md` | 新 Skill、中等功能、单模块变更 |
| **Full (Level 3)** | `proposal.md` + `tasks.md` | 重大功能、架构变更、跨模块变更 |

## 使用方法

### Level 2 - Minimal Spec

```bash
# 1. 创建 change 目录
mkdir -p standards/openspec/changes/{feature-name}

# 2. 复制模板
cp standards/openspec/templates/proposal-minimal.md \
   standards/openspec/changes/{feature-name}/proposal.md

# 3. 编辑填写内容
```

### Level 3 - Full Spec

```bash
# 1. 创建 change 目录
mkdir -p standards/openspec/changes/{feature-name}

# 2. 创建完整文件结构
# - proposal.md (详细提案)
# - tasks.md (任务分解)
# - specs/ (规范文件目录，可选)
# - design.md (设计文档，可选)
```

## 决策指南

```yaml
问题: 我应该使用哪个级别的 Spec？

检查清单:
  Q1: 是否是简单修复或配置调整？
    是 → Level 1 (Skip)
    否 → 继续

  Q2: 是否只涉及单模块且工作量 < 3 天？
    是 → Level 2 (Minimal)
    否 → 继续

  Q3: 是否涉及架构变更或跨模块？
    是 → Level 3 (Full)
    否 → Level 2 (Minimal)
```

## 相关文档

- [十步循环 Phase A](../../core/ten-step-cycle/phase-a-spec-planning.md)
- [OpenSpec 项目定义](../project.md)
- [AGENTS.md](../AGENTS.md)
