# Tasks: enhance-requirements-awareness

> **Status**: Complete
> **Created**: 2026-01-02

---

## Task Overview

| # | Task | Priority | Effort | Dependencies |
|---|------|----------|--------|--------------|
| 1 | 创建项目需求目录结构 | HIGH | S | - |
| 2 | 创建初始 PRD 文件 | HIGH | M | 1 |
| 3 | 更新 state-scanner SKILL.md | HIGH | M | - |
| 4 | 更新 RECOMMENDATION_RULES.md | MEDIUM | S | 3 |
| 5 | 验证 state-scanner 输出 | HIGH | S | 3, 4 |

---

## Detailed Tasks

### Task 1: 创建项目需求目录结构

**优先级**: HIGH | **工作量**: S (Small)

**描述**: 创建 `docs/requirements/` 目录结构

**步骤**:
1. 创建 `docs/requirements/` 目录
2. 创建 `docs/requirements/user-stories/` 子目录
3. 创建 `docs/requirements/README.md` 说明文件
4. 创建 `docs/requirements/user-stories/README.md`

**验收标准**:
- [x] 目录结构存在
- [x] README 文件说明清晰

**交付物**:
```
docs/requirements/
├── README.md
└── user-stories/
    └── README.md
```

---

### Task 2: 创建初始 PRD 文件

**优先级**: HIGH | **工作量**: M (Medium)

**描述**: 基于模板创建 Todo App 项目级 PRD

**步骤**:
1. 复制 `standards/templates/prd-template.md`
2. 填充 Todo App 产品信息
3. 定义功能范围 (指向 Mobile/Backend 模块)
4. 添加 User Story 占位表

**验收标准**:
- [x] PRD 文件符合模板格式
- [x] 包含核心必需节 (文档目的、产品定位、功能范围)
- [x] requirements-validator 验证通过

**交付物**:
- `docs/requirements/prd-todo-app-v1.md`

---

### Task 3: 更新 state-scanner SKILL.md

**优先级**: HIGH | **工作量**: M (Medium)

**描述**: 增强 state-scanner 输出格式，始终显示需求状态

**步骤**:
1. 在「阶段 1: 状态收集」后添加需求状态输出模板
2. 定义「已配置」和「未配置」两种输出格式
3. 添加需求状态检测逻辑说明
4. 更新输出格式示例

**修改文件**: `.claude/skills/state-scanner/SKILL.md`

**验收标准**:
- [x] 输出格式包含「需求状态」段落
- [x] 未配置时显示明确提示
- [x] 已配置时显示统计信息

**关键变更**:

```markdown
### 阶段 1.5: 需求状态收集

始终执行此阶段，即使需求目录不存在。

检测路径:
  - docs/requirements/ (主项目)
  - {module}/docs/requirements/ (模块级)

输出:
  已配置:
    📄 需求状态
    ───────────────────────────────────────────────────────────────
      配置状态: ✅ 已配置
      PRD: prd-todo-app-v1.md (approved)
      User Stories: 8 个 (ready: 3, in_progress: 2, done: 3)
      ...

  未配置:
    📄 需求状态
    ───────────────────────────────────────────────────────────────
      配置状态: ❌ 未配置需求追踪
      期望路径: docs/requirements/
      建议: 如需启用需求追踪，创建 PRD 文件或使用 OpenSpec
```

---

### Task 4: 更新 RECOMMENDATION_RULES.md

**优先级**: MEDIUM | **工作量**: S (Small)

**描述**: 在规则概览表中添加需求相关规则

**步骤**:
1. 更新规则概览表，添加规则 5-9
2. 为每个新规则添加详细定义
3. 调整优先级数值确保正确排序

**修改文件**: `.claude/skills/state-scanner/RECOMMENDATION_RULES.md`

**验收标准**:
- [x] 规则表包含需求相关规则
- [x] 每个规则有详细定义
- [x] 优先级逻辑正确

**新增规则**:

```yaml
# 规则 5.5 (信息提示，不阻塞)
requirements_not_configured:
  priority: 5.5
  conditions:
    - requirements_directory_missing: true
  recommendation:
    workflow: null
    info: "提示: 如需使用需求追踪，可创建 docs/requirements/ 目录"

# 规则 1.5 (高优先级)
requirements_issues:
  priority: 1.5
  conditions:
    - requirements_validation_errors: true
  recommendation:
    workflow: requirements-check
    reason: "需求文档存在问题，建议先修复"
```

---

### Task 5: 验证 state-scanner 输出

**优先级**: HIGH | **工作量**: S (Small)

**描述**: 执行 state-scanner 验证输出格式正确

**步骤**:
1. 执行 `/state-scanner`
2. 验证输出包含「需求状态」段落
3. 验证需求状态显示正确
4. 验证推荐规则包含需求相关选项

**验收标准**:
- [x] 需求状态段落显示
- [x] 内容与实际目录结构一致
- [x] 无错误或异常

---

## Parallel Execution

以下任务可以并行执行:

```
Task 1 ─┬─▶ Task 2
        │
Task 3 ─┴─▶ Task 4 ─▶ Task 5
```

- Task 1 + Task 3 可并行
- Task 2 依赖 Task 1
- Task 4 依赖 Task 3
- Task 5 依赖 Task 2, Task 4

---

## Estimated Total Effort

| 工作量 | 数量 | 说明 |
|--------|------|------|
| S (Small) | 3 | 10-30 分钟 |
| M (Medium) | 2 | 30-60 分钟 |
| L (Large) | 0 | - |

**总估计**: 约 2-3 小时工作量
