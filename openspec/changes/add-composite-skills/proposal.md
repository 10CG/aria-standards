# Add Composite Skills

> **Level**: 2 (Minimal)
> **Status**: Draft
> **Module**: standards
> **Created**: 2025-12-24

## Why

当前十步循环的 Skills 设计为单步执行，每个 Skill 只负责一个步骤。这导致：
1. 简单任务也需要手动调用多个 Skills
2. 步骤之间的上下文传递需要人工介入
3. 常见工作流（如"修复 Bug 并提交"）无法一键完成
4. AI 开发效率受限于人工协调

需要创建组合式 Skills，将高频使用的步骤组合自动化。

## What

创建 `workflow-runner` Skill，作为十步循环的组合执行器：

### 1. 预置工作流模板

| 工作流 | 步骤组合 | 使用场景 |
|--------|---------|---------|
| `quick-fix` | B.1 → B.2 → C.1 | 简单 Bug 修复 |
| `feature-dev` | A.2 → A.3 → B.1 → B.2 → B.3 → C.1 | 功能开发 |
| `doc-update` | B.3 → C.1 | 文档更新 |
| `full-cycle` | A.0 → ... → D.2 | 完整十步循环 |

### 2. 自动步骤跳过

根据上下文自动判断是否需要执行某步骤：
- Level 1 任务：跳过 A.1 (Spec)
- 无架构变更：跳过 B.3 (架构同步)
- 单文件修改：跳过分支创建

### 3. 步骤间上下文传递

自动传递关键信息：
- 当前 Phase/Cycle
- 变更文件列表
- 测试结果
- 分支名称

### Key Deliverables

| 产出物 | 路径 | 说明 |
|--------|------|------|
| workflow-runner Skill | `.claude/skills/workflow-runner/SKILL.md` | 核心组合 Skill |
| 工作流模板 | `.claude/skills/workflow-runner/WORKFLOWS.md` | 预置工作流定义 |
| 跳过规则 | `.claude/skills/workflow-runner/SKIP_RULES.md` | 自动跳过规则 |
| Skills README | `.claude/skills/README.md` | 更新 Skill 列表 |

## Impact

### Positive
- 减少手动调用 Skills 次数 50%+
- 常见任务一键完成
- 保持十步循环完整性的同时提升效率
- 降低新手学习曲线

### Risk
- 自动跳过规则可能不适用所有场景
- 需要良好的错误处理和回滚机制
- 用户可能过度依赖自动化

### Dependencies
- 依赖现有所有步骤 Skills 正常工作
- 需要 state-scanner 提供上下文

## Success Criteria

- [ ] workflow-runner 可执行预置工作流模板
- [ ] quick-fix 工作流端到端成功率 >= 90%
- [ ] 自动跳过规则准确率 >= 95%
- [ ] 用户可自定义工作流组合
- [ ] 失败时可回滚到上一成功步骤
