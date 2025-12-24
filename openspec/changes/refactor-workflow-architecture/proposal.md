# Proposal: Refactor Workflow Architecture

## Metadata

| Field | Value |
|-------|-------|
| Change ID | refactor-workflow-architecture |
| Status | Draft |
| Level | 2 (Architectural) |
| Author | Claude |
| Created | 2025-12-25 |
| Module | standards / .claude/skills |

## Summary

重构十步循环工作流架构，将 A.0 从被动状态感知升级为智能推荐入口，并将工作流拆分为 Phase 级别的独立 Skills，实现更灵活的组合和更智能的执行引导。

## Motivation

### 当前问题

1. **A.0 定位模糊**: A.0 (state-scanner) 与 A.1-A.3 本质不同，前者是观察性的，后者是生产性的
2. **工作流选择困难**: 用户需要记忆何时使用哪个预置工作流
3. **组合灵活性不足**: 预置工作流是固定的，难以按需自定义
4. **Skills 耦合**: workflow-runner 直接调用步骤 Skills，缺乏中间抽象层

### 目标

1. 将 state-scanner 升级为智能工作流推荐入口
2. 按 Phase 拆分 Skills，提供更细粒度的组合能力
3. 简化用户决策流程，系统推荐最佳实践
4. 保持向后兼容，现有工作流继续可用

## Proposed Solution

### 架构变更

```
Before:
  workflow-runner → [A.0, A.1, A.2, A.3, B.1, B.2, B.3, C.1, C.2, D.1, D.2]

After:
  state-scanner v2.0 (智能入口)
       │
       ▼ 推荐工作流
  workflow-runner v2.0 (轻量编排)
       │
       ├── phase-a-planner (A.1-A.3)
       ├── phase-b-developer (B.1-B.3)
       ├── phase-c-integrator (C.1-C.2)
       └── phase-d-closer (D.1-D.2)
```

### 核心变更

#### 1. state-scanner v2.0

- **新增**: 智能工作流推荐引擎
- **新增**: 推荐理由生成
- **新增**: 用户交互确认
- **保留**: 原有状态感知功能

#### 2. Phase Skills (新增 4 个)

| Skill | 步骤 | 职责 |
|-------|------|------|
| phase-a-planner | A.1-A.3 | 规划阶段执行 |
| phase-b-developer | B.1-B.3 | 开发阶段执行 |
| phase-c-integrator | C.1-C.2 | 集成阶段执行 |
| phase-d-closer | D.1-D.2 | 收尾阶段执行 |

#### 3. workflow-runner v2.0

- **变更**: 从直接调用步骤改为编排 Phase Skills
- **保留**: 预置工作流定义 (quick-fix, feature-dev, doc-update, full-cycle)
- **新增**: 支持 Phase 级别自定义组合

## Scope

### In Scope

- state-scanner Skill 升级
- 4 个 Phase Skills 创建
- workflow-runner Skill 重构
- 相关文档更新

### Out of Scope

- 单步 Skills 修改 (branch-manager, test-verifier 等保持不变)
- 十步循环核心规范修改
- UPM 格式变更

## Acceptance Criteria

1. [ ] state-scanner 能基于项目状态生成工作流推荐
2. [ ] 推荐包含理由说明，帮助用户理解
3. [ ] 用户可确认推荐或选择备选方案
4. [ ] 4 个 Phase Skills 可独立调用
5. [ ] workflow-runner 通过 Phase Skills 执行工作流
6. [ ] 现有预置工作流 (quick-fix 等) 继续可用
7. [ ] 上下文在 Phase 间正确传递

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| 推荐逻辑复杂 | 可能推荐错误 | 提供备选方案，用户可覆盖 |
| Phase 拆分增加复杂度 | 维护成本上升 | 保持单 Phase 简单，职责单一 |
| 向后兼容 | 现有用法失效 | 保留原有工作流名称和行为 |

## Dependencies

- 现有 Skills: branch-manager, test-verifier, arch-update, commit-msg-generator, etc.
- 十步循环规范: standards/core/ten-step-cycle/README.md

## Related Changes

- add-test-verification-skill (已完成)
- add-composite-skills (已完成，将被此变更重构)
