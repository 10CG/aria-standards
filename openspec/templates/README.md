# OpenSpec Templates

本目录包含 OpenSpec 规范的模板文件，用于快速创建符合规范的 Spec 文档。

## 三级 Spec 策略 (v2.0.0)

| 级别 | 模板 | 架构 | 适用场景 |
|------|------|------|---------|
| **Skip (Level 1)** | 无需模板 | 单层 | 简单修复、配置调整、文档格式 |
| **Minimal (Level 2)** | `proposal-minimal.md` | 单层 | 新 Skill、中等功能、单模块变更 |
| **Full (Level 3)** | `proposal-minimal.md` + `tasks.md` | **双层架构** | 重大功能、架构变更、跨模块变更 |

## 双层任务架构 (v2.0.0)

Level 3 Spec 引入了双层任务架构，优化了 AI 执行效率：

### Layer 1: tasks.md (粗粒度)
- **格式**: OpenSpec 标准的 checkbox 格式
- **编号**: 1.1, 1.2, 2.1, 2.2 (Phase.Task)
- **目的**: 人类可读的进度跟踪，OpenSpec CLI 兼容
- **维护**: 人类手动更新进度

### Layer 2: detailed-tasks.yaml (细粒度)
- **格式**: 结构化 YAML，包含完整元数据
- **ID**: TASK-{NNN} (唯一标识符)
- **目的**: AI 执行依据，支持调度和跟踪
- **维护**: AI 自动生成和更新

### 同步机制
- **前向同步**: A.1 → A.2 (tasks.md → detailed-tasks.yaml)
- **后向同步**: B.2 → A.2 (TASK 完成时更新 tasks.md checkbox)
- **冲突检测**: 自动检测和报告不一致

## 模板列表

| 模板文件 | 层级 | 用途 | 适用级别 |
|---------|------|------|---------|
| `proposal-minimal.md` | 单层 | 提案文档 (Why/What/Impact/Tasks) | Level 2, 3 |
| `tasks.md` | Layer 1 | 粗粒度功能清单 (checkbox 格式) | Level 3 |
| `detailed-tasks.yaml` | Layer 2 | 细粒度任务规范 (AI 执行) | 由 task-planner 生成 |

## 使用方法

### Level 2 - Minimal Spec

```bash
# 1. 创建 change 目录
mkdir -p standards/openspec/changes/{feature-name}

# 2. 复制模板
cp standards/openspec/templates/proposal-minimal.md \
   standards/openspec/changes/{feature-name}/proposal.md

# 3. 编辑填写内容
```

### Level 3 - Full Spec (双层架构)

```bash
# 1. 创建 change 目录
mkdir -p standards/openspec/changes/{feature-name}

# 2. 复制模板
cp standards/openspec/templates/proposal-minimal.md \
   standards/openspec/changes/{feature-name}/proposal.md

cp standards/openspec/templates/tasks.md \
   standards/openspec/changes/{feature-name}/tasks.md

# 3. 编辑填写内容
# - proposal.md: 详细提案 (Why/What/Impact/Tasks)
# - tasks.md: 粗粒度功能清单 (checkbox 格式)

# 4. 生成 detailed-tasks.yaml
# 由 task-planner 自动生成，无需手动创建
```

### 生成 detailed-tasks.yaml

```bash
# 使用 task-planner skill
task-planner --spec-path changes/{feature-name}

# 该命令会：
# 1. 读取 tasks.md
# 2. 解析 checkbox 格式
# 3. 生成 detailed-tasks.yaml
# 4. 建立 parent → TASK-{NNN} 映射
```

### tasks.md 格式要点 (Layer 1)

```yaml
格式要求:
  - 使用 checkbox: - [ ] {Phase}.{Task} {Description}
  - 编号格式: 1.1, 1.2, 2.1 (Phase.Task)
  - 粗粒度: 功能层面，避免技术细节
  - 编号不可变：一旦创建不能修改

示例:
  ## 1. Database Setup
  - [ ] 1.1 Add OTP column to users table
  - [ ] 1.2 Create verification logs table

  ## 2. API Implementation
  - [ ] 2.1 Generate OTP endpoint
  - [ ] 2.2 Integrate with login flow
```

### detailed-tasks.yaml 格式要点 (Layer 2)

```yaml
必需字段:
  - id: TASK-{NNN} (唯一标识)
  - parent: "1.1" (链接到 tasks.md)
  - title: 任务标题
  - status: pending/in_progress/completed/blocked
  - complexity: S/M/L/XL
  - estimated_hours: "2-4" (时间估算)
  - dependencies: [] (TASK-ID 列表)
  - deliverables: [] (交付物列表)

A.3 增强字段:
  - agent: backend-architect (分配的 agent)
  - reason: "Database expertise" (分配原因)
  - verification: [] (验收标准)
  - notes: "Additional notes" (可选笔记)

状态字段:
  - pending: 待开始
  - in_progress: 进行中
  - completed: 已完成
  - blocked: 阻塞
```

## 工作流程示例

```yaml
# 1. 创建 Level 3 Spec
spec-drafter "为用户认证添加 OTP 功能" --level 3
  ↓
# 输出:
#   - changes/user-otp/proposal.md
#   - changes/user-otp/tasks.md (checkbox 格式)

# 2. 生成可执行任务
task-planner --spec-path changes/user-otp
  ↓
# 输出:
#   - changes/user-otp/detailed-tasks.yaml
#   - parent → TASK-{NNN} 映射建立

# 3. 执行任务
分支创建 → 开发实现 → 测试验证
  ↓
# 4. 更新进度
progress-updater --complete TASK-001
  ↓
# 自动同步:
#   - detailed-tasks.yaml: TASK-001 status → completed
#   - tasks.md: 1.1 checkbox → [x]

# 5. 验证一致性
openspec validate --sync user-otp
openspec validate --numbering user-otp
```

## 验证命令

```bash
# aria 使用 audit-engine 进行验证，不使用外部 npm CLI
# 以下为规则参考 (非可执行命令):

# 检查双层一致性规则
# → 实际执行: aria:audit-engine

# 验证编号完整性规则
# → 实际执行: aria:audit-engine

# 显示完整概览
# → 实际执行: aria:aria-dashboard
```

> 格式结构整体定义见 [project.md](../project.md#与-fission-ai-openspec-的关系) — 注意 aria 与 upstream Fission-AI OpenSpec CLI 已结构性分叉，不使用 `@fission-ai/openspec` validator。

📖 **详细文档**: 参考 [OpenSpec Validation Guide](../VALIDATION.md) 了解完整的验证规则、示例和故障排除指南。

## Change ID 命名约定

Change ID 是 `openspec/changes/` 目录下每个变更的唯一标识，也是文件系统路径的一部分。
跨仓库积累的实践暴露了多种不一致风格，本节给出统一规范。

### 1. Version 前缀

| 场景 | 是否加前缀 | 格式 |
|------|-----------|------|
| 同一仓库存在多个并行 release (e.g. v0.2.0 / v0.2.1 / v0.2.2) | **必须** | `v{major}-{minor}-{patch}-` |
| 首版或单一 feature-scoped 变更 | **跳过** | 直接从 topic 开始 |

格式要求：使用 kebab-case，不用点。`v0-2-1-` 正确，`v0.2.1-` 错误。

### 2. Topic 串联

- **连接符**: 一律用 dash (`-`)，**不推荐** `and` / `with` 等自然语言连词
- **数量上限**: 最多 3 个 topic；超过 3 个时应考虑拆分 change
- **排序原则**: 首 topic = 主要特性，按重要性而非字母序排列

```
# 正确
tam-trigger-polish

# 错误 — 使用了 and 连词
trace-and-sahil
```

### 3. Descriptor Tail (受控枚举)

Descriptor tail 是紧跟 topic 之后的语义修饰词，为**非必填**字段。

| 枚举值 | 语义 |
|--------|------|
| `mvp` | 最小可行实现，功能覆盖面有限 |
| `warmup` | 预热验证，探索性 / 技术预研 |
| `polish` | 打磨迭代，在已有实现上提升质量 |
| `hardening` | 稳健加固，重点在健壮性与容错 |
| `fix` | 缺陷修复，问题驱动而非功能驱动 |
| `migration` | 迁移变更，数据或接口兼容性过渡 |

规则：

- 如果使用 descriptor tail，必须从上表枚举中选取
- **不允许**自由形容词：`improved` / `better` / `new` / `enhanced` 等均不合规
- 不使用时直接省略，不需要占位符

### 4. Slug 长度

| 限制类型 | 字符上限 | 说明 |
|---------|---------|------|
| **硬上限** | 60 字符 | 含 version 前缀；超限必须拆分或精简 |
| **软推荐** | 40 字符 | 跨 CI / filesystem 友好的安全区间 |

超出软推荐时，优先精简 topic 词，其次考虑拆分 change。

### 5. 多 Feature 聚合

- **默认做法**: 拆分成多个独立 change，便于独立归档与审计
- **允许合并的例外**: 同一 release 内存在强耦合依赖（e.g. schema 变更与对应 migration 必须同时上线）
  - 合并时，change ID 的首 topic 应反映核心能力，次要依赖不出现在 ID 中

```
# 合并示例 — 首 topic 反映核心
schema-migration-mvp

# 反例 — 两个不相关 feature 塞入同一 ID
v0-2-2-reflect-carry-forward    (reflect 与 carry-forward 耦合度低，应拆分)
```

### 正例 / 反例对照

| 风格 | Change ID | 问题 |
|------|-----------|------|
| ❌ | `v0-2-warmup-trace-and-sahil` | 使用了 `and` 连词 |
| ❌ | `v0-2-1-tam-trigger-archival-polish` | 含 3 个 topic (`tam-trigger` / `archival` / `polish`) + descriptor，语义堆叠 |
| ❌ | `v0-2-2-reflect-carry-forward` | 两个不相关 feature 塞入同一 ID，`and` 被省略但耦合关系隐式存在 |
| ✅ | `v0-2-2-tam-trigger-polish` | 单 topic + descriptor，< 40 字符，kebab-case 一致 |
| ✅ | `user-otp-mvp` | 无 version 前缀（首版），topic 清晰，descriptor 合规 |
| ✅ | `schema-migration-hardening` | 合并场景，首 topic 反映核心，descriptor 语义准确 |

### Why this convention

本约定的目标受众与价值：

- **brainstorm / spec-drafter**: AI 生成 change ID 时有明确枚举可引用，避免自由发挥产生噪声
- **state-scanner / progress-updater**: ID 作为文件系统键，长度与字符集约束保证跨平台路径安全
- **跨仓一致性**: 同一组织内多仓库采用相同约定，review 与归档工具无需针对风格差异做特殊处理
- **可审计性**: descriptor tail 受控枚举使 ID 本身携带语义，无需打开 proposal.md 即可判断变更性质

## 决策指南

```yaml
问题: 我应该使用哪个级别的 Spec？

检查清单:
  Q1: 是否是简单修复或配置调整？
    是 → Level 1 (Skip)
    否 → 继续

  Q2: 是否只涉及单模块且工作量 < 3 天？
    是 → Level 2 (Minimal)
    否 → 继续

  Q3: 是否涉及架构变更或跨模块？
    是 → Level 3 (Full - 双层架构)
    否 → Level 2 (Minimal)

  额外考虑:
  - 是否需要 AI 协作执行？→ Level 3
  - 是否需要长期跟踪进度？→ Level 3
  - 是否是复杂功能？→ Level 3
```

## 最佳实践

### Numbering (tasks.md)
- ✅ 连续编号：1.1, 1.2, 1.3...
- ✅ Phase 分组：逻辑工作区域
- ❌ 跳号：1.1, 1.3 (缺少 1.2)
- ❌ 重排：创建后不能修改

### Task Descriptions
- ✅ 功能导向："Add user authentication"
- ✅ 简洁清晰："Create OTP endpoints"
- ❌ 技术细节："Implement JWT token in auth.py with PyJWT"

### 双层一致性
- 保持 tasks.md 和 detailed-tasks.yaml 同步
- 使用 `openspec validate --sync` 检查
- 发现差异立即修复

## 迁移指南

### 从旧版 tasks.md (TASK-ID 格式) 迁移

```yaml
旧格式 (v1.x):
  ### TASK-001: Database Setup
  - Description: ...
  - Agent: ...
  - Deliverables: ...

新格式 (v2.0):
  ## 1. Database Setup
  - [ ] 1.1 {Task Description}
  - [ ] 1.2 {Task Description}

迁移步骤:
  1. 备份原 tasks.md
  2. 提取功能描述，转换为 checkbox 格式
  3. 重新编号 (1.1, 1.2...)
  4. 运行 task-planner 重新生成 detailed-tasks.yaml
  5. 验证新旧任务映射关系
```

## 相关文档

- [十步循环 Phase A](../../core/ten-step-cycle/phase-a-spec-planning.md)
- [双层任务架构优化提案](../changes/optimize-phase-a-with-dual-layer-architecture/proposal.md)
- [OpenSpec 项目定义](../project.md)
- [AGENTS.md](../AGENTS.md)
- [task-planner Skill](../../../.claude/skills/task-planner/SKILL.md) - 双层架构实现
- [spec-drafter Skill](../../../.claude/skills/spec-drafter/SKILL.md) - OpenSpec 兼容生成
- [progress-updater Skill](../../../.claude/skills/progress-updater/SKILL.md) - 双层同步机制