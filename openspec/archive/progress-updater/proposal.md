# Progress Updater Skill

> **Level**: Minimal (Level 2 Spec)
> **Status**: Draft
> **Created**: 2025-12-16

## Why

十步循环中的 Step 9 (进度更新) 是每个开发任务完成后的必要步骤：
- 每次任务完成都需要手动更新 UPM 文档，效率低且容易遗漏
- stateToken 计算繁琐，手动计算易出错
- 缺乏标准化的进度更新接口，导致 UPM 文档格式不一致
- 与 `progress-query-assistant` (Step 1) 形成读写配对，完善闭环

当前 Step 9 覆盖率为 **0%**，是 Phase D 中最关键的缺失环节。

## What

创建 `progress-updater` Skill，提供标准化的项目进度更新能力。

### Key Deliverables
- SKILL.md: 完整的 skill 规范文档
- EXAMPLES.md: 各场景更新示例
- CHANGELOG.md: 版本变更记录 (可选)

### Core Capabilities

```yaml
功能 1 - UPM 状态更新:
  - 更新 UPMv2-STATE YAML 区块
  - 更新 lastUpdateAt, lastUpdateRef
  - 自动重新计算 stateToken
  - 更新 kpiSnapshot (如提供新数据)

功能 2 - 任务状态同步:
  - 标记任务为已完成
  - 更新 nextCycle.candidates
  - 更新 risks 状态

功能 3 - 项目周期文档写入:
  - 创建/更新 progress-report.md
  - 创建/更新 quality-review.md
  - 遵循标准路径: docs/project-lifecycle/week{N}/
```

## Impact

| Type | Description |
|------|-------------|
| **Positive** | 自动化进度更新，确保 UPM 文档准确；与 progress-query-assistant 形成闭环；标准化 stateToken 计算 |
| **Risk** | 并发写入可能导致冲突；风险低，有 stateToken 校验机制 |

## Tasks

- [ ] 设计 UPM 写入逻辑 (包含 stateToken 重新计算)
- [ ] 创建 SKILL.md 定义 Step 9 操作流程
- [ ] 创建 EXAMPLES.md 提供各场景更新示例
- [ ] 实现 stateToken 计算算法
- [ ] 测试对 mobile/backend UPM 的更新
- [ ] 更新 skills README.md 注册新 skill
- [ ] 更新 CLAUDE.md Skills Usage 章节
- [ ] 更新 ten-step-cycle README 反映 skill 覆盖率

## Success Criteria

- [ ] 能正确更新 mobile UPM 的 UPMv2-STATE
- [ ] 能正确更新 backend UPM 的 UPMv2-STATE
- [ ] stateToken 自动重新计算且格式正确
- [ ] 支持创建项目周期文档
- [ ] Skill 已注册到 CLAUDE.md
- [ ] Step 9 覆盖率更新为 90%

## Technical Design

### stateToken 计算规则

```yaml
输入字段:
  - module
  - stage
  - cycleNumber
  - lastUpdateAt
  - kpiSnapshot (序列化)

计算步骤:
  1. 拼接: "{module}|{stage}|{cycleNumber}|{lastUpdateAt}|{kpiJson}"
  2. SHA256 哈希
  3. 取前 12-16 位十六进制
  4. 格式: "sha256:{hash}"
```

### 写入顺序规范

```yaml
Step 1 - 校验当前状态:
  - 读取当前 stateToken
  - 校验是否有并发修改

Step 2 - 写入项目周期文档 (如需):
  - 路径: docs/project-lifecycle/week{N}/
  - 文件: progress-report.md, quality-review.md

Step 3 - 回写 UPM:
  - 更新 UPMv2-STATE 字段
  - 重新计算 stateToken
  - 写入文件

Step 4 - 验证:
  - 确认写入成功
  - 返回新的 stateToken
```

### 输入参数

```yaml
必需参数:
  module: 目标模块 (mobile/backend/shared/standards)

可选参数:
  completed_tasks: 已完成任务列表
  kpi_updates: KPI 更新数据
  risks_updates: 风险状态更新
  next_candidates: 下一循环候选任务
  cycle_doc_content: 周期文档内容
  commit_ref: Git 提交引用
```

## Dependencies

- 依赖 `progress-query-assistant` 读取当前状态
- 被 Step 10 `spec-archiver` 依赖

## References

- [十步循环概览](../../../core/ten-step-cycle/README.md)
- [Phase D: Closure & Archive](../../../core/ten-step-cycle/phase-d-closure.md)
- [UPM 规范](../../../core/upm/unified-progress-management-spec.md)
- [状态管理标准](../../../core/state-management/ai-ddd-state-management.md)
- [progress-query-assistant Skill](../../../../.claude/skills/progress-query-assistant/SKILL.md)
