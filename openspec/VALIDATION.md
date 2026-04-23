# OpenSpec Validation Commands Guide

> **Version**: 1.1.0
> **Created**: 2025-12-20
> **Updated**: 2026-04-23
> **Purpose**: Guide for validating OpenSpec dual-layer architecture consistency

---

> **历史注记**: aria OpenSpec 格式早期参考了 Fission-AI OpenSpec CLI 设计，
> 但从 v2.0 起 aria 选择保留双层任务架构 (proposal.md + tasks.md + detailed-tasks.yaml)，
> 而 upstream Fission-AI CLI (`@fission-ai/openspec` v1.3.0+) 迁移到了
> delta-based workflow (`specs/{capability}/spec.md` + delta headers + Scenario blocks)。
> **两者已结构性不兼容**。aria 不使用也不跟随 upstream CLI。
>
> **aria 原生 validator**: `aria:audit-engine` (3-agent 审计编排) — 不依赖 npm。
> 详见 [project.md - 与 Fission-AI OpenSpec 的关系](project.md#与-fission-ai-openspec-的关系)。

---

## Overview

aria OpenSpec 通过 **`aria:audit-engine`** 验证双层任务架构 (tasks.md + detailed-tasks.yaml) 的完整性与一致性。以下文档保留了历史 CLI 子命令描述，供理解 aria 自有验证规则时参考，但这些命令已不适用于任何外部 npm CLI。

## Validation Rules (aria 内部规则参考)

> **注意**: 以下章节描述的是 aria OpenSpec 的验证逻辑规则，而非可执行的外部 CLI 命令。
> 实际验证通过 `aria:audit-engine` 执行，不通过 `openspec` 命令行。

### 1. 双层一致性检查 (已不适用 upstream CLI; aria 使用 audit-engine 替代)

验证 tasks.md 与 detailed-tasks.yaml 之间的同步状态。

**规则内容:**
1. **Parent Reference 有效性**
   - 每个 TASK-{NNN} 必须在 tasks.md 中有对应的 parent 引用
   - Parent 格式须匹配: `{phase}.{task}` (例如 "1.1", "2.3")

2. **任务状态同步**
   - detailed-tasks.yaml 中 completed 的任务，tasks.md 对应 checkbox 须已勾选
   - detailed-tasks.yaml 中 in_progress 的任务，tasks.md 对应 checkbox 须未勾选

3. **标题一致性**
   - 两层之间任务标题须匹配 (允许小幅编辑差异)
   - 重大标题不匹配须人工审阅

4. **完整性**
   - tasks.md 所有条目须在 detailed-tasks.yaml 中有对应项
   - detailed-tasks.yaml 所有条目须在 tasks.md 中有对应项

### 2. 编号完整性检查 (已不适用 upstream CLI; aria 使用 audit-engine 替代)

确保 tasks.md 遵循编号约定与不可变性规则。

**规则内容:**
1. **编号格式**
   - 有效格式: `{phase}.{task}`，其中两部分均为正整数
   - 同一 Phase 内不得有编号间隙
   - 不得有重复编号

2. **Phase 组织**
   - 任务须正确归属于各 Phase 标题下
   - Phase 编号须连续 (1, 2, 3...)

3. **不可变性**
   - 编号一旦创建不得修改 (破坏 parent 引用)
   - audit-engine 会检测编号变化并告警

### 3. show: Display Complete Overview

Shows a comprehensive view of both layers and their relationships.

```bash
openspec show {feature-name}
```

#### Example Output:

```bash
$ openspec show user-authentication

📋 OpenSpec Overview: user-authentication
==========================================

Layer 1: tasks.md (Human-readable)
--------------------------------
## 1. Database Setup
- [x] 1.1 Add OTP column to users table
- [x] 1.2 Create verification logs table
- [x] 1.3 Add indexes for performance

## 2. API Implementation
- [x] 2.1 Generate OTP endpoint
- [x] 2.2 Verify OTP endpoint
- [ ] 2.3 Refresh token endpoint

Layer 2: detailed-tasks.yaml (AI-executable)
-------------------------------------------
TASK-001 (parent: 1.1)
  ├─ Status: completed
  ├─ Agent: backend-architect
  └─ Deliverable: migrations/add_otp_column.sql

TASK-002 (parent: 1.2)
  ├─ Status: completed
  ├─ Agent: backend-architect
  └─ Deliverable: migrations/create_logs_table.sql

TASK-005 (parent: 2.3)
  ├─ Status: pending
  ├─ Agent: backend-architect
  ├─ Dependencies: [TASK-004]
  └─ Deliverable: backend/src/routes/auth.py

📊 Progress Summary:
- Completed: 5/8 (62.5%)
- In Progress: 0
- Pending: 3
- Blocked: 0
```

## Advanced Usage

### Combining Validations

Run multiple validations in sequence:

```bash
# Full validation suite
for feature in user-authentication api-versioning; do
  echo "=== Validating $feature ==="
  openspec validate --sync $feature
  openspec validate --numbering $feature
  echo ""
done
```

### CI/CD Integration

> **已不适用 upstream CLI**: 以下 CI 配置引用了 `@openspec/cli`，该包对应的是早期设计参考，
> 实际不存在此 npm 包。aria 不使用 npm CLI 进行验证。
> **aria 项目的验证通过 `aria:audit-engine` 执行**，不需要 CI YAML 步骤中的 npm 安装。

```yaml
# 仅作历史参考 — 此配置在 aria 项目中不适用
# aria 使用 audit-engine 多轮收敛审计，而非 npm CLI
# .github/workflows/openspec-validate.yml (DEPRECATED REFERENCE)
name: OpenSpec Validation (历史参考, 不适用于 aria)

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      # 以下步骤不适用: @openspec/cli 不存在, aria 使用 audit-engine
      # - name: Setup OpenSpec CLI
      #   run: npm install -g @openspec/cli  # 此包不存在
```

### Automated Fixing

> **已不适用 upstream CLI**: `--fix` 标志是历史规则描述，不对应任何可执行命令。
> aria 的双层同步通过 `aria:progress-updater` skill 处理。

以下为规则描述 (非可执行命令):

```
# aria 双层同步通过 progress-updater skill 处理:
# - detailed-tasks.yaml: TASK-NNN status → completed
# - tasks.md: 对应 checkbox → [x]
# - 冲突检测: audit-engine 多轮收敛审计
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Parent Reference Not Found

```
Error: TASK-003.parent "1.4" not found in tasks.md
```

**Solution**:
- Check if the task was deleted or renumbered in tasks.md
- Update the parent reference in detailed-tasks.yaml
- Or restore the missing task in tasks.md

#### 2. Status Mismatch

```
Warning: TASK-002 marked as completed but 1.2 is unchecked
```

**Solution**:
- Run `openspec validate --sync {feature} --fix` to auto-sync
- Or manually update the checkbox in tasks.md

#### 3. Numbering Gaps Detected

```
Error: Gap detected in Phase 1: missing 1.2
```

**Solution**:
- Add the missing task with numbering 1.2
- Or renumber existing tasks (not recommended if already linked)

#### 4. Duplicate Numbers

```
Error: Duplicate number "2.1" found in tasks.md
```

**Solution**:
- Renumber one of the duplicate tasks
- Ensure each number is unique within its phase

## Best Practices

### 1. Regular Validation

- Run validation after each task completion
- Include validation in CI/CD pipeline
- Validate before major milestones

### 2. Consistent Updates

- Always update both layers together
- Use progress-updater skill for automatic synchronization
- Avoid manual editing of parent references

### 3. Version Control

- Commit both layers together
- Include validation output in commit messages
- Tag major milestones

### 4. Documentation

- Document any numbering exceptions
- Record reasons for task cancellations
- Keep change logs for major restructuring

## Integration with Skills

> **注意**: 以下 skill 集成描述的是 aria 内部验证规则触发逻辑，已不适用 upstream CLI 命令。
> aria skills 通过 `aria:audit-engine` 执行多轮收敛审计，而非调用 `openspec` CLI。

### task-planner

```yaml
# task-planner 生成 detailed-tasks.yaml 后触发的验证规则:
# - 检查编号完整性 (Phase.Task 格式、无间隙、无重复)
# - 验证 parent 引用有效性
# (已不适用 upstream CLI; aria 使用 audit-engine 替代)
```

### progress-updater

```yaml
# progress-updater 更新任务状态后触发的同步规则:
# - 同步 detailed-tasks.yaml 状态到 tasks.md checkbox
# - 检测并报告双层不一致
# (已不适用 upstream CLI; aria 使用 audit-engine 替代)
```

### spec-drafter

```yaml
# spec-drafter 创建 tasks.md 后触发的验证规则:
# - 验证编号格式与完整性
# - 检查 Phase 组织是否合规
# (已不适用 upstream CLI; aria 使用 audit-engine 替代)
```

## Reference

### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success, no issues |
| 1 | Validation failed |
| 2 | Feature not found |
| 3 | Invalid command usage |

### Configuration File

Create `.openspec/config.yaml` for default settings:

```yaml
validation:
  auto_fix: false
  title_similarity_threshold: 0.8
  strict_numbering: true
  ignore_warnings: []
```

---

**Version**: 1.1.0
**Last Updated**: 2026-04-23
**Related Documents**:
- [OpenSpec Templates](templates/README.md)
- [与 Fission-AI OpenSpec 的关系](project.md#与-fission-ai-openspec-的关系)
- [Dual-Layer Architecture](changes/optimize-phase-a-with-dual-layer-architecture/proposal.md)