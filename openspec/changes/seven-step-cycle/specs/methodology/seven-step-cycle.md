# AI-DDD 七步循环

## ADDED Core Concept

### Concept: The Seven-Step Cycle

AI-DDD (AI-Driven Domain Development) 的核心是一个**七步循环工作流**，确保 AI 和人类的结构化协作，并在每个步骤内建质量保证。

**循环概览**:
```
┌─────────────────────────────────────────────────────────┐
│ 1. State Recognition (状态识别)                         │
│    输入: 用户请求 / 系统状态                             │
│    输出: UPM 状态判断                                    │
├─────────────────────────────────────────────────────────┤
│ 2. Context Collection (上下文收集)                      │
│    输入: UPM 状态                                        │
│    输出: 相关文件、依赖、历史                            │
├─────────────────────────────────────────────────────────┤
│ 3. Planning (规划)                                       │
│    输入: 上下文                                          │
│    输出: 任务分解、执行计划                              │
├─────────────────────────────────────────────────────────┤
│ 4. Quality Gates (质量门控)                             │
│    输入: 执行计划                                        │
│    输出: 门控检查结果（通过/失败）                       │
├─────────────────────────────────────────────────────────┤
│ 5. Execution (执行)                                      │
│    输入: 已验证的计划                                    │
│    输出: 代码、文档、配置变更                            │
├─────────────────────────────────────────────────────────┤
│ 6. Update & Tracking (更新与追踪)                       │
│    输入: 执行结果                                        │
│    输出: 更新的 UPM 状态、TodoWrite                      │
├─────────────────────────────────────────────────────────┤
│ 7. Validation (验证)                                     │
│    输入: 所有变更                                        │
│    输出: 验证报告、下一步建议                            │
└─────────────────────────────────────────────────────────┘
         ↓ (循环或完成)
```

### Principle: Structured Yet Flexible

七步循环不是严格的瀑布流程，而是：
- **可合并**: 简单任务可合并前 3 步
- **可迭代**: 复杂任务可多轮循环
- **可回退**: 发现问题时可返回上一步

**适用性**:
```
Simple Task    → Steps 1-3 合并 + 4-7 快速执行
Medium Task    → 完整 7 步，单次迭代
Complex Task   → 完整 7 步，多轮迭代，使用 TodoWrite
```

## ADDED Step Definitions

### Step 1: State Recognition (状态识别)

**目的**: 理解当前系统状态和用户意图

**输入**:
- 用户请求（文本描述）
- 当前系统状态（文件、配置、运行状态）
- 历史上下文（之前的对话、提交）

**处理**:
1. 解析用户请求的核心意图
2. 识别当前 UPM 状态：
   - **Unresolved**: 需求不明确，需要澄清
   - **Pending**: 需求明确，等待实现
   - **Merged**: 已实现，需要验证或优化
3. 判断任务复杂度（Simple / Medium / Complex）

**输出**:
- UPM 状态标识
- 任务复杂度评估
- 澄清问题列表（如果 Unresolved）

**AI 职责**:
- 自动分析请求和系统状态
- 判断 UPM 状态
- 提出澄清问题（必要时）

**人类职责**:
- 提供清晰的需求
- 回答 AI 的澄清问题
- 确认状态判断

**Quality Gate**:
- [ ] 意图理解准确（通过用户确认）
- [ ] UPM 状态判断合理
- [ ] 复杂度评估恰当

**Example**:
```
User: "帮我在 mobile 添加一个任务列表页面"

AI State Recognition:
- Intent: 添加新功能（任务列表 UI）
- UPM Status: Pending (需求明确)
- Complexity: Medium (需要 UI + 数据层集成)
- 澄清: "列表需要支持过滤和排序吗？"
```

### Step 2: Context Collection (上下文收集)

**目的**: 收集执行任务所需的所有上下文信息

**输入**:
- UPM 状态（来自 Step 1）
- 任务描述

**处理**:
1. 识别相关文件和目录
2. 读取相关代码和文档
3. 收集依赖关系
4. 查找相关历史（commits, PRs, issues）
5. 识别跨模块影响

**输出**:
- 相关文件列表
- 关键代码片段
- 依赖关系图
- 历史变更记录
- 跨模块影响分析

**AI 职责**:
- 使用 Glob、Grep、Read 工具收集信息
- 分析代码依赖
- 识别潜在影响范围

**人类职责**:
- 提供额外的上下文（如果 AI 遗漏）
- 确认影响范围

**Quality Gate**:
- [ ] 所有相关文件已识别
- [ ] 依赖关系清晰
- [ ] 跨模块影响已评估
- [ ] 没有遗漏关键上下文

**Tool Usage**:
```bash
# 文件查找
Glob: "mobile/lib/features/**/*.dart"

# 代码搜索
Grep: "class TaskList" in mobile/

# 读取关键文件
Read: mobile/lib/features/tasks/task_list_page.dart
```

**Example**:
```
Task: 添加任务列表页面

Context Collection:
- Related Files:
  * mobile/lib/features/tasks/ (目标目录)
  * shared/contracts/openapi/tasks.yaml (API 契约)
  * mobile/lib/data/repositories/task_repository.dart (数据层)

- Dependencies:
  * Flutter widgets (列表、卡片)
  * Task model (来自 shared)
  * API client (网络请求)

- Cross-Module Impact:
  * 需要 backend API 已实现
  * 需要 shared 中有 Task model
```

### Step 3: Planning (规划)

**目的**: 制定详细的执行计划

**输入**:
- 上下文信息（来自 Step 2）
- 任务复杂度

**处理**:
1. 分解任务为子任务
2. 确定执行顺序
3. 识别风险和依赖
4. 使用 TodoWrite（如果 Medium/Complex）
5. 估算时间和资源

**输出**:
- 任务分解列表（TodoWrite 格式）
- 执行顺序
- 风险评估
- 时间估算

**AI 职责**:
- 自动分解任务
- 创建 TodoWrite 任务列表
- 识别风险

**人类职责**:
- 审核和调整计划
- 确认优先级
- 批准风险应对

**Quality Gate**:
- [ ] 任务分解清晰、完整
- [ ] 执行顺序合理
- [ ] 风险已识别
- [ ] 使用 TodoWrite（Medium/Complex 任务）

**TodoWrite Best Practice**:
```markdown
## Complex Task 示例
[
  {"content": "创建任务列表 UI 组件", "status": "pending", "activeForm": "正在创建 UI"},
  {"content": "实现数据仓库层", "status": "pending", "activeForm": "正在实现数据层"},
  {"content": "集成 API 调用", "status": "pending", "activeForm": "正在集成 API"},
  {"content": "添加加载和错误状态", "status": "pending", "activeForm": "正在添加状态处理"},
  {"content": "编写单元测试", "status": "pending", "activeForm": "正在编写测试"}
]
```

**Example**:
```
Task: 添加任务列表页面

Planning:
1. 创建 TaskListPage Widget
2. 实现 TaskListViewModel (状态管理)
3. 创建 TaskCard 组件
4. 集成 TaskRepository
5. 添加加载、错误、空状态
6. 编写单元测试
7. 集成到导航

Risks:
- API 可能未实现 → 使用 Mock 数据先行
- 设计规范未确定 → 使用临时样式，后续优化

Estimated Time: 4-6 小时
```

### Step 4: Quality Gates (质量门控)

**目的**: 在执行前验证计划质量

**输入**:
- 执行计划（来自 Step 3）

**处理**: 检查四级质量门控

**Four-Level Gates**:

#### Level 1: Simplicity (简洁性)
- [ ] 引入的新概念 ≤ 3 个
- [ ] 解决方案直接、不过度设计
- [ ] 避免不必要的抽象

#### Level 2: Clarity (清晰性)
- [ ] 代码/文档易于理解
- [ ] 命名清晰、一致
- [ ] 注释解释"为什么"而非"什么"

#### Level 3: Consistency (一致性)
- [ ] 符合现有架构和模式
- [ ] 遵循项目编码规范
- [ ] 与 shared 契约一致

#### Level 4: Enforceability (可执行性)
- [ ] 规则可以自动化检查
- [ ] 有明确的验收标准
- [ ] 可测试、可验证

**输出**:
- 质量门控检查结果（Pass / Fail）
- 失败原因和改进建议

**AI 职责**:
- 自动检查门控条件
- 标记潜在问题

**人类职责**:
- 最终判断（特别是主观门控）
- 决定是否继续或调整计划

**Decision**:
- 全部通过 → 进入 Step 5 (Execution)
- 部分失败 → 返回 Step 3 调整计划
- 严重失败 → 返回 Step 1 重新理解需求

**Example**:
```
Task: 添加任务列表页面

Quality Gates Check:
✅ Simplicity: 新概念 = 2 (TaskListPage, TaskListViewModel)
✅ Clarity: 清晰的 Widget 树结构
✅ Consistency: 遵循 Flutter BLoC 模式
✅ Enforceability: 有单元测试计划

Result: PASS - 进入 Execution
```

### Step 5: Execution (执行)

**目的**: 按计划实现变更

**输入**:
- 已验证的执行计划
- 质量门控通过

**处理**:
1. 按 TodoWrite 顺序执行任务
2. 每完成一个子任务，立即标记为 completed
3. 遇到问题时记录，必要时返回 Planning
4. 保持代码提交小而频繁

**输出**:
- 代码变更（使用 Edit/Write 工具）
- 配置文件更新
- 文档更新
- 测试代码

**AI 职责**:
- 自动生成代码
- 更新 TodoWrite 状态
- 遵循编码规范

**人类职责**:
- 审核生成的代码
- 测试功能
- 批准重大变更

**Best Practices**:
1. **小步提交**: 每完成一个逻辑单元就 commit
2. **实时更新 TodoWrite**: 不要批量更新
3. **遵循规范**: 使用 Edit 而非 Write (如果文件存在)
4. **保持专注**: 一次只做一个 todo，完成再进行下一个

**Example**:
```
Execution Flow:

[1. 创建 TaskListPage] → in_progress
- Write: mobile/lib/features/tasks/task_list_page.dart
- 基本 Scaffold 结构
→ completed

[2. 实现 ViewModel] → in_progress
- Write: mobile/lib/features/tasks/task_list_viewmodel.dart
- 状态管理逻辑
→ completed

[3. 创建 TaskCard] → in_progress
- Write: mobile/lib/features/tasks/widgets/task_card.dart
- UI 组件
→ completed

... (继续其他任务)
```

### Step 6: Update & Tracking (更新与追踪)

**目的**: 更新项目状态，保持可追溯性

**输入**:
- 执行结果（代码、文档变更）

**处理**:
1. 更新 UPM 状态
2. 标记所有 TodoWrite 任务为 completed
3. 记录变更日志
4. 更新相关文档（如 CHANGELOG.md）

**输出**:
- 更新的 UPM 状态
- 完成的 TodoWrite 列表
- 变更记录

**AI 职责**:
- 自动更新 TodoWrite 状态
- 生成变更摘要
- 建议文档更新

**人类职责**:
- 确认状态转换
- 审核变更记录

**UPM State Transition**:
```
Pending (实现前)
  ↓
[Execution]
  ↓
Merged (实现完成，待验证)
```

**Example**:
```
Update & Tracking:

UPM: Pending → Merged

TodoWrite: All 7 tasks → completed

Changes:
- Added: mobile/lib/features/tasks/task_list_page.dart
- Added: mobile/lib/features/tasks/task_list_viewmodel.dart
- Added: mobile/lib/features/tasks/widgets/task_card.dart
- Modified: mobile/lib/routes.dart (添加路由)
- Added: mobile/test/features/tasks/task_list_test.dart
```

### Step 7: Validation (验证)

**目的**: 确保变更正确且完整

**输入**:
- 所有变更（代码、文档）
- 测试结果

**处理**: 多层次验证

**Validation Levels**:

#### 1. Syntax Validation (语法验证)
- [ ] 代码编译通过
- [ ] 无语法错误
- [ ] Linter 检查通过

#### 2. Unit Validation (单元验证)
- [ ] 单元测试通过
- [ ] 边界条件覆盖
- [ ] 异常处理正确

#### 3. Integration Validation (集成验证)
- [ ] 与其他模块集成正常
- [ ] API 调用成功
- [ ] 数据流正确

#### 4. End-to-End Validation (端到端验证)
- [ ] 用户流程可完成
- [ ] UI/UX 符合预期
- [ ] 性能可接受

**输出**:
- 验证报告（Pass / Fail）
- 发现的问题列表
- 下一步建议

**AI 职责**:
- 运行自动化测试
- 分析测试结果
- 生成验证报告

**人类职责**:
- 手动测试（UI/UX）
- 确认质量可接受
- 决定是否需要迭代

**Decision**:
- 全部通过 → 任务完成，准备 PR/Commit
- 部分失败 → 返回 Step 5 修复问题
- 严重失败 → 返回 Step 3 重新规划

**Example**:
```
Validation Results:

✅ Syntax: flutter analyze → No issues
✅ Unit: flutter test → All 15 tests passed
✅ Integration: API mock test → Success
⚠️  E2E: UI loading state 显示时间过长

Action: 返回 Step 5，优化加载状态
```

## ADDED Integration: Seven Steps ↔ UPM

### Mapping: Steps to UPM States

```
UPM: Unresolved
├─ Step 1: State Recognition (识别为 Unresolved)
├─ AI/Human: 澄清需求
└─ → 转换为 Pending

UPM: Pending
├─ Step 1: State Recognition (识别为 Pending)
├─ Step 2: Context Collection
├─ Step 3: Planning
├─ Step 4: Quality Gates
├─ Step 5: Execution
├─ Step 6: Update & Tracking
└─ → 转换为 Merged

UPM: Merged
├─ Step 7: Validation
├─ 如果通过 → 任务完成
└─ 如果失败 → 返回 Pending (修复)
```

### State Transition Triggers

| From | To | Trigger | Steps Involved |
|------|----|---------| ---------------|
| Unresolved | Pending | 需求澄清完成 | Step 1 |
| Pending | Merged | 代码变更完成 | Steps 2-6 |
| Merged | Completed | 验证通过 | Step 7 |
| Merged | Pending | 验证失败 | Step 7 → Step 5/3 |

## ADDED Usage Guidelines

### When to Use Full 7-Step Cycle

使用完整七步循环当：
- 任务复杂度 = Medium 或 Complex
- 涉及多个文件或模块
- 需要跨仓库协调
- 质量要求高（如核心功能）

### When to Simplify

可简化流程当：
- 任务复杂度 = Simple
- 单文件小修改
- 低风险变更（如文档更新、注释修改）

**Simplified Flow**:
```
Steps 1-3: 快速完成（无需 TodoWrite）
Step 4: 基础检查（只检查 Simplicity & Clarity）
Step 5: 直接执行
Steps 6-7: 快速验证
```

### Common Pitfalls to Avoid

1. **跳过质量门控**: 即使简单任务也要快速检查
2. **不使用 TodoWrite**: Medium/Complex 任务必须使用
3. **批量更新状态**: 应实时更新每个 todo
4. **忽略验证**: Step 7 不可省略

## ADDED Examples

### Example 1: Simple Task (修复拼写错误)

```
Step 1: 识别 → Simple, Pending
Step 2-3: 快速收集上下文 + 规划（无 TodoWrite）
Step 4: 快速门控检查 ✅
Step 5: Edit 文件修正拼写
Step 6: 简单记录
Step 7: 快速验证 ✅

Total Time: < 5 分钟
```

### Example 2: Medium Task (添加新 API 端点)

```
Step 1: 识别 → Medium, Pending
Step 2: 收集契约、相关代码
Step 3: 分解为 5 个子任务 (TodoWrite)
Step 4: 完整门控检查 ✅
Step 5: 按 todo 执行（实时更新状态）
  [1] 定义路由 → completed
  [2] 实现 handler → completed
  [3] 添加验证 → completed
  [4] 编写测试 → completed
  [5] 更新文档 → completed
Step 6: UPM: Pending → Merged
Step 7: 单元 + 集成测试 ✅

Total Time: 2-3 小时
```

### Example 3: Complex Task (重构认证模块)

```
Step 1: 识别 → Complex, Pending
Step 2: 收集所有相关代码、契约、依赖
Step 3: 分解为 15+ 子任务 (TodoWrite)
        分 3 个阶段（设计、实现、测试）
Step 4: 完整门控 + 架构审查 ✅

[第一轮循环: 设计阶段]
Step 5: 执行设计任务 (1-5)
Step 6: 更新状态
Step 7: 设计验证 ✅ → 进入第二轮

[第二轮循环: 实现阶段]
Step 5: 执行实现任务 (6-12)
Step 6: 更新状态
Step 7: 单元测试 ✅ → 进入第三轮

[第三轮循环: 集成测试]
Step 5: 执行测试任务 (13-15)
Step 6: UPM: Pending → Merged
Step 7: E2E 验证 ✅ → 完成

Total Time: 2-3 天，多轮迭代
```

## Quality Gate Checklist

- [x] **Simplicity**: 引入 3 个核心概念（七步、UPM集成、质量门控）
- [x] **Clarity**: 每步定义清晰，有输入/输出/职责
- [x] **Consistency**: 与现有 AI-DDD 理念一致
- [x] **Enforceability**: 部分可自动化（TodoWrite、测试）

## Implementation Status

- [x] 规范定义完成
- [ ] 创建示例（简单、中等、复杂）
- [ ] 工具支持（TodoWrite 指南）
- [ ] 团队培训
- [ ] 应用到所有子模块

## References

- UPM 状态管理系统
- TodoWrite 工具
- Quality Gates 规范
- Contract-First 原则
