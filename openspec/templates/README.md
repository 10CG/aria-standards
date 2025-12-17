# OpenSpec Templates

本目录包含 OpenSpec 规范的模板文件，用于快速创建符合规范的 Spec 文档。

## 三级 Spec 策略

| 级别 | 模板 | 适用场景 |
|------|------|---------|
| **Skip (Level 1)** | 无需模板 | 简单修复、配置调整、文档格式 |
| **Minimal (Level 2)** | `proposal-minimal.md` | 新 Skill、中等功能、单模块变更 |
| **Full (Level 3)** | `proposal-minimal.md` + `tasks.md` | 重大功能、架构变更、跨模块变更 |

## 模板列表

| 模板文件 | 用途 | 适用级别 |
|---------|------|---------|
| `proposal-minimal.md` | 提案文档 (Why/What/Impact/Tasks/Success Criteria) | Level 2, 3 |
| `tasks.md` | 结构化任务分解 (TASK-{ID} 格式) | Level 3 |

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

# 2. 复制模板
cp standards/openspec/templates/proposal-minimal.md \
   standards/openspec/changes/{feature-name}/proposal.md

cp standards/openspec/templates/tasks.md \
   standards/openspec/changes/{feature-name}/tasks.md

# 3. 编辑填写内容
# - proposal.md: 详细提案 (Why/What/Impact/Tasks)
# - tasks.md: 结构化任务分解 (TASK-{ID} 格式)

# 4. 可选文件
# - specs/ (规范文件目录)
# - design.md (设计文档)
```

### tasks.md 格式要点

```yaml
任务格式:
  ID: TASK-{NNN}  # 如 TASK-001
  必需字段:
    - Description: 任务描述
    - Complexity: S/M/L/XL
    - Estimated: 预估小时数
    - Dependencies: 依赖任务 ID 或 None
    - Agent: 推荐的 Agent 类型
    - Deliverables: 交付物列表
    - Acceptance Criteria: 验收标准

复杂度指南:
  S (Small): 0.5-2h, 单文件修改
  M (Medium): 2-4h, 多文件修改
  L (Large): 4-8h, 复杂功能
  XL (Extra Large): 8-16h, 需进一步拆分
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
- [task-planner Skill](../../../.claude/skills/task-planner/SKILL.md) - 读取 tasks.md 的 Skill
- [spec-drafter Skill](../../../.claude/skills/spec-drafter/SKILL.md) - 生成 tasks.md 的 Skill
