# Optimize Phase A with Dual-Layer Architecture

> **Level**: Full (Level 3 Spec)
> **Status**: Draft
> **Created**: 2025-12-19
> **Module**: standards
> **Context**: 合并 phase-a-integration 和 clarify-phase-a-task-pipeline 的优势

## Why

当前 Phase A 存在两个层面的问题需要同时解决：

### 问题层面 1：概念边界不清（来自 clarify-phase-a-task-pipeline）
1. **职责边界模糊**：A.1、A.2、A.3 之间职责重叠
2. **文档角色混乱**：不清楚哪个文档是执行的"单一事实来源"
3. **粒度转换不明确**：从 tasks.md 的功能项到 TASK-{NNN} 的转换规则缺失

### 问题层面 2：执行效率低下（来自 phase-a-integration）
1. **tasks.md 断层**：spec-drafter 生成的 tasks.md 未被有效利用
2. **重复劳动**：task-planner 重新解析 proposal.md 而非复用 tasks.md
3. **缺乏编排**：Step 0-3 之间需要手动衔接

### 目标：概念清晰 + 执行高效
建立既保持 OpenSpec 兼容性，又能提升 AI 执行效率的 Phase A 架构。

---

## What Changes

### 1. 建立双层任务架构（保持 OpenSpec 兼容）

| 文档 | 层级 | 来源 | 格式 | 目的 | 更新机制 |
|------|------|--------|--------|---------|-----------|
| **tasks.md** | 粗粒度 | A.1 | OpenSpec 标准格式 | 高层进度跟踪，OpenSpec 生态兼容 | B.2 执行时勾选 |
| **detailed-tasks.yaml** | 细粒度 | A.2+A.3 | 结构化 YAML | AI 执行依据，调度基础 | A.2 生成，A.3 增强 |

### 2. 明确步骤职责边界

**A.1 (Spec Management) - OpenSpec 对齐层**
- 职责：创建 OpenSpec 兼容的规范和粗粒度清单
- 输出：`proposal.md` + `tasks.md`（OpenSpec 标准格式）
- 独特价值：
  - OpenSpec 生态兼容性
  - 高层功能视图
  - 非技术干系人可理解

**A.2 (Task Planning) - 执行准备层**
- 职责：将功能清单转换为可执行的原子任务规范
- 输出：`detailed-tasks.yaml`（包含 TASK-{NNN} 和元数据）
- 独特价值：
  - 精确的时间估算和依赖管理
  - 文件级别的交付物规范
  - 支持并行调度和风险评估

**A.3 (Agent Assignment) - 资源匹配层**
- 职责：匹配任务与专业代理，设置验证标准
- 输出：增强的 `detailed-tasks.yaml`（添加 agent 和 verification）
- 独特价值：
  - 基于领域知识的最优匹配
  - 任务特定的验证标准
  - 执行环境和质量门禁准备

### 3. 定义任务转换流水线

```yaml
阶段 1 (A.1 输出) - 粗粒度功能清单
──────────────────────────────────────────────────────
文件: changes/{feature}/tasks.md
格式: OpenSpec checkbox markdown

示例:
  ## 1. Database Setup
  - [ ] 1.1 Add OTP secret column to users table
  - [ ] 1.2 Create OTP verification logs table

  ## 2. Backend Implementation
  - [ ] 2.1 Add OTP generation endpoint
  - [ ] 2.2 Modify login flow to require OTP

特征:
  - 功能清单格式
  - 高层交付物
  - 无依赖关系
  - 无时间估算
  - 符合 OpenSpec 标准


阶段 2 (A.2 输出) - 精炼的可执行任务
────────────────────────────────────────────────────
文件: changes/{feature}/detailed-tasks.yaml
格式: 结构化 YAML

示例:
  tasks:
    - id: TASK-001
      parent: "1.1"  # 链接到 tasks.md 的 1.1 节
      title: Add OTP secret column to users table
      complexity: M (Medium, 2-4h)
      dependencies: []
      deliverables:
        - backend/migrations/add_otp_secret_column.sql
        - backend/src/models/user.py (update User model)

    - id: TASK-002
      parent: "2.1"
      title: Create OTP generation endpoint
      complexity: L (Large, 4-8h)
      dependencies: [TASK-001]
      deliverables:
        - backend/src/routes/otp_routes.py
        - backend/src/services/otp_service.py

特征:
  - TASK-{NNN} 唯一标识
  - 复杂度估算（含小时范围）
  - 显式依赖链
  - 文件级交付物规范
  - 4-8小时原子粒度
  - parent 字段维持可追溯性


阶段 3 (A.3 输出) - 代理分配的任务
──────────────────────────────────────────────
文件: changes/{feature}/detailed-tasks.yaml（增强版）
格式: 结构化 YAML（含代理元数据）

示例:
  tasks:
    - id: TASK-001
      parent: "1.1"
      title: Add OTP secret column to users table
      complexity: M (Medium, 2-4h)
      dependencies: []
      deliverables:
        - backend/migrations/add_otp_secret_column.sql
        - backend/src/models/user.py
      agent: backend-architect
      reason: Database schema design expertise, migration management
      verification:
        - Migration runs successfully
        - Column exists in schema with correct type
        - User model updated and tests pass

特征:
  - 继承 A.2 的所有任务元数据
  - 专业代理分配
  - 基于专业知识的分配理由
  - 任务特定的验证标准
  - 准备好 Phase B 执行
```

### 4. 优化 task-planner Skill（解决执行效率）

**增强功能**：
1. **智能读取策略**：
   ```yaml
   读取优先级:
     1. 检查 changes/{feature}/tasks.md 是否存在
     2. 如果存在 → 解析 tasks.md 作为基础
     3. 如果不存在 → 从 proposal.md 分解任务
     4. 合并/补充来自 proposal.md 的 Success Criteria
   ```

2. **生成 detailed-tasks.yaml**：
   - 自动创建结构化 YAML 输出
   - 包含 parent 字段链接到 tasks.md
   - 添加 TASK-{NNN} ID 和所有元数据

3. **集成 Agent 分配**：
   - 在同一次调用中完成 A.2 和 A.3
   - 保持概念上的步骤独立性，执行上的高效性

### 5. 同步机制

**前向同步 (A.1 → A.2 → A.3)**：
- A.2 的 task-planner 读取 tasks.md 并生成 detailed-tasks.yaml
- A.3 增强 detailed-tasks.yaml 的代理分配
- detailed-tasks.yaml 中的 parent 字段维持可追溯性

**后向同步 (B.2 → tasks.md)**：
- Phase B 中 TASK-{NNN} 完成时，对应的 tasks.md 项被勾选
- Skills（如 task-progress-updater）处理此同步
- OpenSpec CLI (`openspec list`) 可从 tasks.md 显示进度

**冲突解决**：
- tasks.md 是"进度视图"（checkboxes）
- detailed-tasks.yaml 是"执行规范"（实施的单一事实来源）
- 如果出现差异，detailed-tasks.yaml 对执行决策有优先权

---

## Impact

### 正面影响

1. **概念清晰**：
   - 每个步骤（A.1, A.2, A.3）有明确、不重叠的职责
   - 减少 AI 助手和开发人员的困惑

2. **OpenSpec 兼容**：
   - 保持 tasks.md 的标准 OpenSpec 格式
   - 兼容 `openspec` CLI 工具（list, validate, show）

3. **执行效率**：
   - 消除重复劳动，tasks.md 被有效利用
   - task-planner 一次调用完成 A.2+A.3
   - 减少手动衔接步骤

4. **增强可追溯性**：
   - parent 字段链接详细任务到高层清单
   - 更容易理解原子任务分解的"为什么"

5. **自动化友好**：
   - 清晰的边界使 skills 能够自动化转换
   - 减少手动同步负担

### 风险与缓解

| 风险 | 影响 | 缓解措施 |
|------|--------|----------|
| **文档分歧** | tasks.md 和 detailed-tasks.yaml 不同步 | 1. Skills 自动处理同步<br>2. 验证检查检测差异<br>3. 明确文档的"单一事实来源"职责 |
| **复杂性增加** | 需要维护两个文档而非一个 | 1. 每个文档有明确目的<br>2. Skills 自动化减少手工工作<br>3. 收益（清晰度、兼容性）大于成本 |
| **学习曲线** | 开发者需理解双层模型 | 1. 清晰文档和示例<br>2. Phase A 文档中的可视化图表<br>3. Skills 对大多数用户抽象复杂性 |

---

## Implementation Plan

### Phase 1: 架构文档更新（2-3小时）
- [ ] 更新 `phase-a-spec-planning.md`，添加任务转换流水线章节
- [ ] 明确定义 A.1/A.2/A.3 的职责边界
- [ ] 添加 tasks.md 和 detailed-tasks.yaml 的示例
- [ ] 更新十步循环概览文档

### Phase 2: Skills 实现（4-6小时）
- [ ] 更新 `task-planner` skill：
  - 添加 tasks.md 检测和解析逻辑
  - 实现 detailed-tasks.yaml 生成
  - 集成 agent 分配功能
- [ ] 更新 `spec-drafter` skill：
  - 使用标准 OpenSpec tasks.md 模板
  - 确保生成的 tasks.md 格式一致

### Phase 3: 模板和工具（1-2小时）
- [ ] 创建 `templates/tasks.md` 模板
- [ ] 创建 `templates/detailed-tasks.yaml` 模板
- [ ] 更新 OpenSpec templates 文档

### Phase 4: 验证和测试（1-2小时）
- [ ] 创建端到端测试用例
- [ ] 验证 AI 能正确理解和使用双层架构
- [ ] 测试同步机制的正确性

**总计工作量**：8-13小时

---

## Success Criteria

- [ ] Phase A 文档清晰定义了 A.1/A.2/A.3 边界
- [ ] 任务转换流水线章节已添加到 phase-a-spec-planning.md
- [ ] 提供了 tasks.md 和 detailed-tasks.yaml 的完整示例
- [ ] 同步机制已文档化
- [ ] task-planner skill 支持读取 tasks.md 并生成 detailed-tasks.yaml
- [ ] 验证：AI 助手能正确识别每个文档的使用场景
- [ ] 验证：使用新流水线成功实现示例变更

---

## Decision Record

### 为什么选择双层架构而非单一增强文档

1. **OpenSpec 生态兼容性**：tasks.md 必须保持标准格式
2. **关注点分离**：进度跟踪 vs 执行细节，服务于不同目的
3. **渐进式采用**：可以先理解概念，再优化执行

### 为什么 Step 2+3 保持概念独立

1. **教学价值**：清晰的步骤有助于理解规划过程
2. **调试价值**：问题定位更容易（任务分解问题 vs 代理分配问题）
3. **灵活性**：未来可能需要不同的代理分配策略

---

## Related Documents

- [十步循环概览](../../../standards/core/ten-step-cycle/README.md)
- [Phase A: 规范与规划](../../../standards/core/ten-step-cycle/phase-a-spec-planning.md)
- [spec-drafter SKILL.md](../../../.claude/skills/spec-drafter/SKILL.md)
- [task-planner SKILL.md](../../../.claude/skills/task-planner/SKILL.md)
- [OpenSpec Project](../../../openspec/project.md)

---

**审阅人**: _待分配_
**审阅日期**: _待定_
**优先级**: 高（解决 Phase A 核心痛点）