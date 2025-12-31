# User Story: {简短标题}

> **Story ID**: US-{XXX}
> **Status**: draft | ready | in_progress | done | blocked
> **Priority**: HIGH | MEDIUM | LOW
> **Created**: {YYYY-MM-DD}
> **Forgejo Issue**: #{issue_number}
> **Forgejo Milestone**: {milestone_name}

---

## User Story

**As a** {用户角色},
**I want** {功能/行为},
**So that** {业务价值/用户收益}.

---

## 验收标准 (Acceptance Criteria)

### Scenario 1: {场景名称}

```gherkin
Given {前置条件}
When {用户操作}
Then {预期结果}
```

### Scenario 2: {场景名称}

```gherkin
Given {前置条件}
And {附加条件}
When {用户操作}
Then {预期结果}
And {附加结果}
```

### Scenario 3: {边界/异常场景}

```gherkin
Given {前置条件}
When {异常操作}
Then {错误处理结果}
```

---

## 功能清单

```yaml
核心功能:
  ✅ {功能点1}
  ✅ {功能点2}
  ✅ {功能点3}

边界处理:
  ✅ {边界情况1}
  ✅ {边界情况2}

明确排除:
  ❌ {不包含的功能}: {原因}
```

---

## 关联信息

| 类型 | 链接 |
|------|------|
| PRD | `{prd-path}` |
| OpenSpec | `openspec/changes/{feature}/` |
| UI 设计 | {链接} |
| API 契约 | `shared/contracts/{api}.yaml` |

---

## 估算 (可选)

| 维度 | 估算 |
|------|------|
| 复杂度 | S / M / L / XL |
| 工作量 | {X} 天 |
| 风险 | LOW / MEDIUM / HIGH |

---

## 备注

{任何补充说明}

---

## Template Usage Notes

**User Story 格式**:
```
As a [角色], I want [功能], so that [价值].
```

**Given/When/Then 格式**:
- **Given**: 前置条件，系统/用户的初始状态
- **When**: 触发动作，用户执行的操作
- **Then**: 预期结果，系统应该的响应

**优先级定义**:
| 优先级 | 含义 |
|--------|------|
| HIGH | 必须在当前迭代完成 |
| MEDIUM | 应该在当前迭代完成 |
| LOW | 可以延后 |

**Status 定义**:
| 状态 | 含义 |
|------|------|
| draft | 草稿，尚未确认 |
| ready | 已确认，可以开始实现 |
| in_progress | 正在实现中 |
| done | 已完成 |
| blocked | 被阻塞，无法继续 |

**Forgejo 字段** (可选):
- `Forgejo Issue`: 关联的 Forgejo Issue 编号，由 `forgejo-sync` Skill 自动填充
- `Forgejo Milestone`: 所属里程碑，用于版本规划

**与项目格式兼容**:
- 使用 `✅/❌` 标记功能状态
- 使用 `gherkin` 代码块编写验收标准
- Story ID 格式: `US-{三位数字}`

**批量 User Story 管理**:
建议在 PRD 中维护 User Story 列表，每个 Story 单独文件或在 PRD 中内联。
