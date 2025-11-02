# Implementation Tasks

## Phase 1: 核心定义 (In Progress)

### Task 1.1: 定义七个步骤
- [ ] Step 1: State Recognition - 定义输入、输出、职责
- [ ] Step 2: Context Collection - 定义收集内容、方法
- [ ] Step 3: Planning - 定义规划方法、工具使用
- [ ] Step 4: Quality Gates - 定义 4 级门控标准
- [ ] Step 5: Execution - 定义执行原则、最佳实践
- [ ] Step 6: Update & Tracking - 定义追踪方法、工具
- [ ] Step 7: Validation - 定义验证层次、标准

### Task 1.2: 定义步骤间转换
- [ ] 正常流转条件（1→2→3→...→7）
- [ ] 回退场景（如发现问题需返回上一步）
- [ ] 跳过场景（简单任务可跳过某些步骤）
- [ ] 循环场景（大任务需多轮迭代）

### Task 1.3: AI 和人类角色划分
- [ ] 明确 AI 自主决策的范围
- [ ] 明确需要人类批准的决策点
- [ ] 定义协作接口（如 AskUserQuestion 工具）

### Task 1.4: UPM 集成
- [ ] 映射七步到 UPM 状态
- [ ] 定义状态转换触发条件
- [ ] 处理状态冲突和异常

### Task 1.5: 编写 Delta Spec
- [ ] 创建 `specs/methodology/seven-step-cycle.md`
- [ ] 使用 ADDED 标记（新规范）
- [ ] 包含详细的每步定义
- [ ] 添加流程图和示例

### Task 1.6: 质量门控自检
- [ ] Simplicity: ≤3 新概念?（7步 + UPM + 质量门控 = 3个核心概念）
- [ ] Clarity: 5分钟理解?（概览清晰，细节可查）
- [ ] Consistency: 与现有标准一致?
- [ ] Enforceability: 可自动化?（部分可通过 TodoWrite 追踪）

## Phase 2: 示例和模板 (Future)

### Task 2.1: 创建简单任务示例
- [ ] 示例：修复一个小 bug
- [ ] 展示轻量级流程（合并前 3 步）
- [ ] 说明何时可以简化

### Task 2.2: 创建中等任务示例
- [ ] 示例：添加一个新功能
- [ ] 展示完整流程但单次迭代
- [ ] 使用 TodoWrite 追踪

### Task 2.3: 创建复杂任务示例
- [ ] 示例：重构一个大模块
- [ ] 展示多轮迭代
- [ ] 详细的 UPM 状态管理
- [ ] 完整的质量门控应用

### Task 2.4: 创建流程图
- [ ] 绘制七步循环流程图
- [ ] 标注决策点和分支
- [ ] 添加到规范文档

## Phase 3: 工具和自动化 (Future)

### Task 3.1: TodoWrite 最佳实践
- [ ] 创建 TodoWrite 使用指南
- [ ] 定义任务命名规范
- [ ] 示例：如何分解复杂任务

### Task 3.2: 质量门控脚本
- [ ] 开发自动化检查脚本
- [ ] 集成到 CI/CD
- [ ] 提供本地检查命令

### Task 3.3: 模板生成工具
- [ ] 创建任务规划模板生成器
- [ ] 根据任务类型选择合适模板
- [ ] 自动填充常见字段

## Phase 4: 文档和培训 (Future)

### Task 4.1: 更新 CLAUDE.md
- [ ] standards/CLAUDE.md
- [ ] mobile/CLAUDE.md
- [ ] backend/CLAUDE.md
- [ ] shared/CLAUDE.md
- [ ] 主仓库 CLAUDE.md

### Task 4.2: 创建快速参考卡
- [ ] 一页纸的七步概览
- [ ] 常见场景速查表
- [ ] 故障排查指南

### Task 4.3: 编写培训材料
- [ ] 新成员入门指南
- [ ] AI 助手配置指南
- [ ] 常见问题解答

## Success Metrics

- [ ] 七步循环规范完整且清晰
- [ ] 至少 3 个不同复杂度的示例
- [ ] TodoWrite 使用率 > 80% (复杂任务)
- [ ] 团队成员理解和应用无障碍

## Notes

**Current Focus**: Phase 1 - 完成核心规范定义

**Next Action**: Task 1.5 - 编写详细的 Delta Spec

**Estimated Time**:
- Phase 1: 2-3 小时
- Phase 2: 1-2 小时
- Phase 3: 3-4 小时 (未来)
- Phase 4: 1-2 小时 (未来)
