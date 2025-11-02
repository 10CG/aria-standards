# AI-DDD 七步循环定义

## Why

AI-DDD (AI-Driven Domain Development) 的核心是一个七步循环工作流。这个循环确保：
- **结构化协作**: AI 和人类有明确的协作界面
- **质量保证**: 每个步骤都有输入验证和输出检查
- **可追溯性**: 所有决策和变更都有清晰的上下文
- **渐进演进**: 支持小步迭代，持续改进
- **UPM 集成**: 与 Unresolved-Pending-Merged 状态管理紧密结合

没有明确定义的七步循环，团队（包括 AI 助手）会陷入：
- 无序的"想到哪做到哪"
- 缺乏质量门控
- 上下文丢失
- 难以追踪进度

## What

定义 AI-DDD 七步循环的完整规范，包括：

1. **每个步骤的定义**
   - 步骤名称和编号
   - 步骤目的
   - 输入要求
   - 输出产物
   - 质量门控

2. **步骤间的转换规则**
   - 何时进入下一步
   - 何时回退到上一步
   - 异常处理

3. **AI 和人类的角色**
   - AI 负责什么
   - 人类负责什么
   - 如何协作

4. **与 UPM 的集成**
   - 如何映射到 Unresolved-Pending-Merged 状态
   - 状态转换触发条件

### 七步概览

```
1. State Recognition (状态识别)
   ↓
2. Context Collection (上下文收集)
   ↓
3. Planning (规划)
   ↓
4. Quality Gates (质量门控)
   ↓
5. Execution (执行)
   ↓
6. Update & Tracking (更新与追踪)
   ↓
7. Validation (验证)
   ↓
[循环或完成]
```

## Impact

### Positive
- ✅ 提供统一的工作流程，所有子模块遵循
- ✅ AI 助手有明确的操作指南
- ✅ 质量内建于流程中，不是事后检查
- ✅ 便于新成员理解和上手
- ✅ 支持复杂任务的分解和追踪

### Negative
- ⚠️ 需要团队学习和适应新流程
- ⚠️ 对简单任务可能显得过于复杂
- ⚠️ 需要工具支持（如 TodoWrite）

### Mitigation
- 为不同复杂度的任务提供简化版本
- 创建示例和模板降低学习成本
- 开发工具自动化部分步骤

## Affected Repositories

### Direct Impact
所有使用 AI-DDD 方法论的仓库：
- `standards` (方法论定义源)
- `shared` (契约开发)
- `mobile` (移动端开发)
- `backend` (后端开发)
- `todo-app` (主仓库协调)

### Required Changes
- 所有 CLAUDE.md 文件需引用此规范
- CI/CD 流程需集成质量门控检查
- 开发文档需更新工作流程说明

## Implementation Strategy

### Phase 1: 核心定义 (This Change)
定义七步循环的详细规范在 `standards/openspec/specs/methodology/seven-step-cycle.md`

### Phase 2: 工具支持
- 创建 TodoWrite 最佳实践指南
- 开发自动化质量门控检查脚本

### Phase 3: 示例和模板
- 为常见场景创建示例
- 提供不同复杂度的模板

### Phase 4: 团队培训
- 更新所有仓库的 CLAUDE.md
- 创建培训文档
- 收集反馈并优化

## Success Criteria

- [ ] 七步循环每个步骤都有清晰定义
- [ ] AI 和人类的角色明确划分
- [ ] 与 UPM 的集成路径清晰
- [ ] 提供至少 3 个不同复杂度的示例
- [ ] 团队成员能够在新任务中正确应用

## References

- 现有 `core/seven-step-cycle/README.md` (待整合)
- UPM 状态管理系统
- TodoWrite 工具文档
- Quality Gates 规范 (待定义)

## Comparison: Simple vs Complex Tasks

### Simple Task (轻量级应用)
```
1-3. 识别+收集+规划: 快速完成，可合并
4. 质量门控: 基础检查（3个质量门）
5. 执行: 直接实现
6-7. 更新+验证: 确认完成
```

### Complex Task (完整应用)
```
1. 状态识别: 详细分析 UPM 状态
2. 上下文收集: 多文件、多依赖
3. 规划: 使用 TodoWrite 分解任务
4. 质量门控: 完整 4 级门控
5. 执行: 分步实现，每步验证
6. 更新追踪: 实时更新 TodoWrite
7. 验证: 多层次验证（单元、集成、端到端）
```

## Notes

此规范是 AI-DDD 方法论的核心，优先级最高。

**Current Status**: Phase 1 In Progress - Defining core specification
**Next Action**: Write detailed Delta spec for each step
