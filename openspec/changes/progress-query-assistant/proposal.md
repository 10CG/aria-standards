# Progress Query Assistant Skill

> **Level**: Minimal (Level 2 Spec)
> **Status**: Draft
> **Created**: 2025-12-16

## Why

十步循环中的 Step 1 (状态感知) 是整个开发流程的基础：
- AI 需要快速了解当前项目状态才能做出正确决策
- 手动读取和解析 UPM 文档效率低、容易遗漏关键信息
- 缺乏标准化的状态查询接口，导致状态感知不一致

当前 Step 1 覆盖率为 **0%**，是十步循环中最关键的缺失环节。

## What

创建 `progress-query-assistant` Skill，提供标准化的项目状态查询能力。

### Key Deliverables
- SKILL.md: 完整的 skill 规范文档
- EXAMPLES.md: 各模块查询示例
- CHANGELOG.md: 版本变更记录

### Core Capabilities

```yaml
功能 1 - UPM 状态解析:
  - 读取 UPMv2-STATE YAML 区块
  - 解析 module/stage/cycleNumber
  - 提取 kpiSnapshot 质量指标
  - 识别 risks 风险列表

功能 2 - 多模块支持:
  - 自动识别模块 UPM 路径
  - 支持 mobile/backend/shared/standards 模块
  - 处理不同模块的路径差异

功能 3 - 格式化输出:
  - 生成结构化状态摘要
  - 提供风险预警信息
  - 列出待处理 Specs
```

## Impact

| Type | Description |
|------|-------------|
| **Positive** | 统一状态查询流程，确保 AI 决策基于准确信息；为后续 task-planner 提供基础 |
| **Risk** | UPM 文档格式不一致可能导致解析失败；风险低，有容错处理 |

## Tasks

- [ ] 设计 UPM 路径解析逻辑 (处理 mobile 和其他模块的路径差异)
- [ ] 创建 SKILL.md 定义 Step 1 操作流程
- [ ] 创建 EXAMPLES.md 提供各模块查询示例
- [ ] 测试对现有 mobile/backend UPM 的解析
- [ ] 更新 skills README.md 注册新 skill
- [ ] 更新 CLAUDE.md Skills Usage 章节
- [ ] 更新 ten-step-cycle README 反映 skill 覆盖率

## Success Criteria

- [ ] 能正确解析 mobile UPM 的 UPMv2-STATE
- [ ] 能正确解析 backend UPM 的 UPMv2-STATE
- [ ] 输出格式清晰、包含所有关键信息
- [ ] Skill 已注册到 CLAUDE.md
- [ ] Step 1 覆盖率更新为 90%

## Technical Design

### UPM 路径规则

```yaml
路径模式:
  mobile: mobile/docs/project-planning/unified-progress-management.md
  backend: backend/project-planning/unified-progress-management.md
  shared: shared/project-planning/unified-progress-management.md (如存在)
  standards: standards/project-planning/unified-progress-management.md (如存在)

路径解析逻辑:
  1. 检查 {module}/docs/project-planning/unified-progress-management.md
  2. 若不存在，检查 {module}/project-planning/unified-progress-management.md
  3. 若都不存在，返回错误信息
```

### 输出格式

```yaml
Status Summary:
  Module: {module}
  Stage: {stage}
  Cycle: Cycle {cycleNumber}
  Last Update: {lastUpdateAt}
  State Token: {stateToken}

KPI Snapshot:
  Coverage: {coverage}
  Build: {build}
  Lint Errors: {lintErrors}
  Type Errors: {typeErrors}

Active Risks:
  - {risk.id}: {risk.level} - {risk.mitigation}

Next Cycle:
  Intent: {nextCycle.intent}
  Candidates:
    - {candidate.id}: {candidate.rationale}
```

## Dependencies

- 无外部依赖
- 被 `task-planner` (Step 2) 依赖

## References

- [十步循环概览](../../../core/ten-step-cycle/README.md)
- [UPM 规范](../../../core/upm/unified-progress-management-spec.md)
- [状态管理标准](../../../core/state-management/ai-ddd-state-management.md)
