# Optimize Phase A with Dual-Layer Architecture

> **Level**: Full (Level 3 Spec)
> **Status**: Reviewed
> **Created**: 2025-12-19
> **Updated**: 2025-12-20
> **Approved**: 2025-12-20
> **Module**: standards
> **Context**: 合并 phase-a-integration 和 clarify-phase-a-task-pipeline 的优势

---

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

**单一事实来源原则**：
- **进度追踪** → tasks.md（OpenSpec CLI 兼容）
- **执行规范** → detailed-tasks.yaml（AI 执行依据）
- 冲突时：detailed-tasks.yaml 优先用于执行决策

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
  - 编号一旦确定不可更改（保证 parent 字段稳定性）


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
      status: pending

    - id: TASK-002
      parent: "2.1"
      title: Create OTP generation endpoint
      complexity: L (Large, 4-8h)
      dependencies: [TASK-001]
      deliverables:
        - backend/src/routes/otp_routes.py
        - backend/src/services/otp_service.py
      status: pending

特征:
  - TASK-{NNN} 唯一标识
  - 复杂度估算（含小时范围）
  - 显式依赖链
  - 文件级交付物规范
  - 4-8小时原子粒度
  - parent 字段维持可追溯性
  - status 字段跟踪执行状态


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
      status: pending
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

### 5. 同步机制（详细定义）

#### 5.1 前向同步 (A.1 → A.2 → A.3)

```yaml
触发点: task-planner skill 执行时
流程:
  1. 读取 tasks.md，提取功能清单
  2. 为每个功能项生成 TASK-{NNN}
  3. 设置 parent 字段指向 tasks.md 编号
  4. 生成 detailed-tasks.yaml
  5. A.3 增强：添加 agent 和 verification
```

#### 5.2 后向同步 (B.2 → tasks.md)

```yaml
触发点: TASK-{NNN} 完成时（status: pending → completed）
执行者: progress-updater skill（已存在，需扩展）
频率: 每个任务完成后立即同步

流程:
  1. 检测 detailed-tasks.yaml 中 status 变为 completed
  2. 读取该任务的 parent 字段（如 "1.1"）
  3. 在 tasks.md 中找到对应项
  4. 将 [ ] 改为 [x]
  5. 提交同步更新

示例:
  # TASK-001 完成后
  # detailed-tasks.yaml:
  - id: TASK-001
    parent: "1.1"
    status: completed  # pending → completed

  # tasks.md 自动更新:
  - [x] 1.1 Add OTP secret column to users table  # [ ] → [x]
```

#### 5.3 冲突检测与解决

```yaml
检测机制:
  自动检测:
    - progress-updater 运行时对比两者
    - 检查 parent 映射是否有效
    - 检查 status 与 checkbox 状态是否一致

  手动检测:
    - 命令: openspec validate --sync {feature}
    - 输出: 差异报告

冲突类型与解决:
  类型 1 - 进度不同步:
    症状: detailed-tasks.yaml 已 completed 但 tasks.md 未勾选
    原因: 同步失败或手动编辑
    解决: 自动同步（以 detailed-tasks.yaml 为准）

  类型 2 - parent 引用失效:
    症状: parent 指向不存在的 tasks.md 编号
    原因: tasks.md 被手动修改
    解决:
      - 警告用户
      - 建议重新运行 task-planner 重建映射
      - 禁止在 A.1 后修改 tasks.md 编号

  类型 3 - 任务定义冲突:
    症状: 同一任务在两处描述不一致
    原因: 手动修改导致
    解决:
      - 报告冲突详情
      - 提示人工介入
      - detailed-tasks.yaml 优先用于执行决策

优先级原则:
  - 执行决策 → detailed-tasks.yaml 优先
  - 进度展示 → 两者保持同步
  - 冲突发生 → 警告 + 以 detailed-tasks.yaml 为准
```

---

## Complete Example（端到端示例）

### 场景：为用户认证添加 OTP 功能

#### Step A.1: spec-drafter 生成

**tasks.md（初始状态）**：
```markdown
# Tasks: User OTP Authentication

## 1. Database Setup
- [ ] 1.1 Add OTP secret column to users table
- [ ] 1.2 Create OTP verification logs table

## 2. Backend Implementation
- [ ] 2.1 Add OTP generation endpoint
- [ ] 2.2 Modify login flow to require OTP
- [ ] 2.3 Add OTP verification endpoint

## 3. Testing
- [ ] 3.1 Unit tests for OTP service
- [ ] 3.2 Integration tests for auth flow
```

#### Step A.2 + A.3: task-planner 生成

**detailed-tasks.yaml（生成后）**：
```yaml
# Generated by task-planner
# Spec: changes/user-otp-auth/proposal.md
# Source: changes/user-otp-auth/tasks.md

metadata:
  feature: user-otp-auth
  created: 2025-12-20T10:00:00+08:00
  total_tasks: 7
  estimated_hours: 22-34

tasks:
  - id: TASK-001
    parent: "1.1"
    title: Add OTP secret column to users table
    complexity: M (Medium, 2-4h)
    dependencies: []
    deliverables:
      - backend/migrations/add_otp_secret.sql
      - backend/src/models/user.py
    status: pending
    agent: backend-architect
    reason: Database schema expertise
    verification:
      - Migration runs successfully
      - Column exists with correct type

  - id: TASK-002
    parent: "1.2"
    title: Create OTP verification logs table
    complexity: S (Small, 1-2h)
    dependencies: [TASK-001]
    deliverables:
      - backend/migrations/create_otp_logs.sql
      - backend/src/models/otp_log.py
    status: pending
    agent: backend-architect
    reason: Database schema expertise
    verification:
      - Table created with proper indexes

  - id: TASK-003
    parent: "2.1"
    title: Add OTP generation endpoint
    complexity: L (Large, 4-8h)
    dependencies: [TASK-001]
    deliverables:
      - backend/src/services/otp_service.py
      - backend/src/routes/otp.py
    status: pending
    agent: backend-architect
    reason: API design and security expertise
    verification:
      - Endpoint returns valid OTP
      - OTP expires correctly

  - id: TASK-004
    parent: "2.2"
    title: Modify login flow to require OTP
    complexity: L (Large, 4-8h)
    dependencies: [TASK-003]
    deliverables:
      - backend/src/routes/auth.py (modify)
      - backend/src/services/auth_service.py (modify)
    status: pending
    agent: backend-architect
    reason: Auth flow expertise
    verification:
      - Login requires OTP
      - Existing tests updated

  - id: TASK-005
    parent: "2.3"
    title: Add OTP verification endpoint
    complexity: M (Medium, 2-4h)
    dependencies: [TASK-003]
    deliverables:
      - backend/src/routes/otp.py (extend)
    status: pending
    agent: backend-architect
    reason: API design expertise
    verification:
      - Verification endpoint works
      - Invalid OTP rejected

  - id: TASK-006
    parent: "3.1"
    title: Unit tests for OTP service
    complexity: M (Medium, 2-4h)
    dependencies: [TASK-003, TASK-005]
    deliverables:
      - backend/tests/test_otp_service.py
    status: pending
    agent: qa-engineer
    reason: Test design expertise
    verification:
      - Coverage >= 90% for OTP module

  - id: TASK-007
    parent: "3.2"
    title: Integration tests for auth flow
    complexity: L (Large, 4-8h)
    dependencies: [TASK-004, TASK-006]
    deliverables:
      - backend/tests/integration/test_auth_otp.py
    status: pending
    agent: qa-engineer
    reason: Integration test expertise
    verification:
      - E2E auth flow tested
      - Edge cases covered
```

#### Step B.2: 执行完成 TASK-001 后

**detailed-tasks.yaml（更新）**：
```yaml
  - id: TASK-001
    parent: "1.1"
    title: Add OTP secret column to users table
    # ... other fields ...
    status: completed  # ← 状态更新
    completed_at: 2025-12-20T14:30:00+08:00
```

**tasks.md（自动同步）**：
```markdown
## 1. Database Setup
- [x] 1.1 Add OTP secret column to users table  ← 自动勾选
- [ ] 1.2 Create OTP verification logs table
```

---

## Migration Guide（迁移指南）

### 现有项目迁移

```yaml
场景 1: 已有 tasks.md，无 detailed-tasks.yaml
  操作:
    1. 保持 tasks.md 不变
    2. 运行 task-planner skill
    3. 自动生成 detailed-tasks.yaml
    4. 验证 parent 映射正确性

场景 2: 已有 detailed-tasks.yaml（旧格式）
  操作:
    1. 检查是否有 parent 字段
    2. 如果没有 → 手动添加或重新生成
    3. 如果有 → 验证映射有效性

场景 3: 全新项目
  操作:
    1. 使用 spec-drafter 生成 proposal.md + tasks.md
    2. 使用 task-planner 生成 detailed-tasks.yaml
    3. 自动完成双层架构设置
```

### 编号不可变约束

```yaml
重要约束:
  tasks.md 的编号（1.1, 1.2, 2.1 等）一旦在 A.1 确定：
    - 不可重新排序
    - 不可删除（只能标记为取消）
    - 不可修改编号

  原因:
    - parent 字段依赖这些编号
    - 确保可追溯性
    - 避免同步问题

  如需变更:
    1. 创建新的 Spec（新功能）
    2. 或在 tasks.md 中追加新项（扩展）
    3. 或将旧项标记为 ~~取消~~ 并添加新项
```

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
   - 自动同步减少手动维护负担

### 风险与缓解

| 风险 | 影响 | 缓解措施 |
|------|--------|----------|
| **文档分歧** | tasks.md 和 detailed-tasks.yaml 不同步 | 1. progress-updater 自动同步<br>2. openspec validate --sync 检测差异<br>3. 明确 SSOT 职责 |
| **复杂性增加** | 需要维护两个文档 | 1. Skills 自动化减少手工工作<br>2. 收益（清晰度、兼容性）大于成本 |
| **学习曲线** | 开发者需理解双层模型 | 1. 完整示例和文档<br>2. Phase A 文档中的流程图<br>3. Skills 抽象复杂性 |
| **编号约束** | tasks.md 编号不可变 | 1. 明确文档化约束<br>2. 提供变更替代方案<br>3. 验证工具检测违规 |

---

## Implementation Plan

### Phase 1: 架构文档更新（2-3小时）
- [ ] 更新 `phase-a-spec-planning.md`，添加任务转换流水线章节
- [ ] 明确定义 A.1/A.2/A.3 的职责边界
- [ ] 添加 tasks.md 和 detailed-tasks.yaml 的示例
- [ ] 添加同步机制文档
- [ ] 更新十步循环概览文档

### Phase 2: Skills 实现（6-8小时）
- [ ] 更新 `task-planner` skill：
  - 添加 tasks.md 检测和解析逻辑
  - 实现 detailed-tasks.yaml 生成
  - 添加 parent 字段和 status 字段
  - 集成 agent 分配功能
- [ ] 更新 `spec-drafter` skill：
  - 使用标准 OpenSpec tasks.md 模板
  - 确保生成的编号格式一致
- [ ] 扩展 `progress-updater` skill：
  - 添加后向同步逻辑（TASK 完成 → tasks.md 勾选）
  - 添加冲突检测和警告

### Phase 3: 模板和工具（2-3小时）
- [ ] 创建 `templates/tasks.md` 模板
- [ ] 创建 `templates/detailed-tasks.yaml` 模板
- [ ] 更新 OpenSpec templates 文档
- [ ] 添加 `openspec validate --sync` 命令说明

### Phase 4: 验证和测试（2-3小时）
- [ ] 创建端到端测试用例
- [ ] 验证 AI 能正确理解和使用双层架构
- [ ] 测试同步机制的正确性
- [ ] 验证冲突检测和解决流程
- [ ] 测试迁移场景

### Phase 5: 增强 - 编号变更检测验证（2-3小时）
- [ ] 在 task-planner 中实现编号不可变验证器
- [ ] 在 progress-updater 中添加预同步验证，检测 parent 引用失效
- [ ] 创建 `openspec validate --numbering` 命令用于手动验证
- [ ] 添加编号违规的警告/错误输出
- [ ] 在 phase-a-spec-planning.md 中文档化编号约束和违规处理

**总计工作量**：14-20小时

---

## Success Criteria

### 文档完整性
- [x] Phase A 文档清晰定义了 A.1/A.2/A.3 边界
- [x] 任务转换流水线章节已添加到 phase-a-spec-planning.md
- [x] 提供了 tasks.md 和 detailed-tasks.yaml 的完整示例
- [x] 同步机制已文档化
- [x] 迁移指南已提供

### Skills 功能
- [x] task-planner 支持读取 tasks.md 并生成 detailed-tasks.yaml
- [x] task-planner 生成的 YAML 包含 parent 和 status 字段
- [x] progress-updater 支持后向同步（TASK → checkbox）
- [x] 冲突检测机制正常工作

### 验证测试
- [x] AI 助手能正确识别每个文档的使用场景
- [x] 使用新流水线成功实现示例变更
- [x] 后向同步正确更新 tasks.md
- [x] 冲突场景正确检测和报告

### 增强功能验证
- [x] 编号不可变验证器在检测到编号变更时正确报错
- [x] parent 引用失效时给出清晰的警告信息
- [ ] `openspec validate --numbering` 命令正常工作 (deferred - CLI tool)
- [x] 文档中包含编号约束和违规处理说明

---

## Decision Record

### 为什么选择双层架构而非单一增强文档

1. **OpenSpec 生态兼容性**：tasks.md 必须保持标准格式
2. **关注点分离**：进度跟踪 vs 执行细节，服务于不同目的
3. **渐进式采用**：可以先理解概念，再优化执行

### 为什么 A.2+A.3 保持概念独立

1. **教学价值**：清晰的步骤有助于理解规划过程
2. **调试价值**：问题定位更容易（任务分解问题 vs 代理分配问题）
3. **灵活性**：未来可能需要不同的代理分配策略

### 为什么使用编号（1.1, 2.1）而非其他标识

1. **简洁性**：编号简短易读
2. **层次性**：自然表达章节-任务关系
3. **OpenSpec 兼容**：符合现有 tasks.md 格式习惯
4. **约束明确**：通过"编号不可变"约束保证稳定性

---

## Related Documents

- [十步循环概览](../../../core/ten-step-cycle/README.md)
- [Phase A: 规范与规划](../../../core/ten-step-cycle/phase-a-spec-planning.md)
- [spec-drafter SKILL.md](../../../../.claude/skills/spec-drafter/SKILL.md)
- [task-planner SKILL.md](../../../../.claude/skills/task-planner/SKILL.md)
- [progress-updater SKILL.md](../../../../.claude/skills/progress-updater/SKILL.md)
- [OpenSpec Project](../../project.md)

---

**审阅人**: _待分配_
**审阅日期**: _待定_
**优先级**: 高（解决 Phase A 核心痛点）
