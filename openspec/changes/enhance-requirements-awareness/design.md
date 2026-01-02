# Design: enhance-requirements-awareness

> **Version**: 1.0.0
> **Created**: 2026-01-02

---

## Architecture Overview

本变更涉及三个层面的改进：

```
┌─────────────────────────────────────────────────────────────────┐
│  Layer 1: Skill 实现层                                           │
│  ├─ state-scanner/SKILL.md (输出格式增强)                        │
│  └─ state-scanner/RECOMMENDATION_RULES.md (规则补全)             │
├─────────────────────────────────────────────────────────────────┤
│  Layer 2: 项目结构层                                             │
│  └─ docs/requirements/ (目录结构建立)                            │
├─────────────────────────────────────────────────────────────────┤
│  Layer 3: 文档层                                                 │
│  ├─ docs/requirements/prd-todo-app-v1.md (初始 PRD)             │
│  └─ UPM requirements 节 (进度文档增强)                           │
└─────────────────────────────────────────────────────────────────┘
```

---

## Design Decisions

### D1: 需求状态输出格式

**决策**: 在 state-scanner 输出中始终包含「需求状态」段落

**格式设计**:

```
📄 需求状态
───────────────────────────────────────────────────────────────
  配置状态: ✅ 已配置 | ❌ 未配置
  PRD: {文件名} ({状态})
  User Stories: {total} 个 (ready: N, in_progress: N, done: N)
  OpenSpec 覆盖: N/{total} ({percentage}%)
  建议: {根据状态给出的操作建议}
```

**未配置时的输出**:

```
📄 需求状态
───────────────────────────────────────────────────────────────
  配置状态: ❌ 未配置需求追踪
  期望路径: docs/requirements/
  建议操作:
    - 如需启用需求追踪，参考 /openspec:proposal 创建 PRD
    - 或使用 OpenSpec 作为轻量替代方案
```

**理由**: 用户应该始终知道需求追踪功能的存在，即使未使用

---

### D2: 路径约定统一

**决策**: 统一使用 `docs/requirements/` 作为需求文档根目录

**路径结构**:

```
docs/requirements/
├── prd-{product}-v{version}.md     # PRD 文件
├── user-stories/                    # User Story 目录
│   ├── README.md                    # 目录说明
│   └── US-{NNN}-{slug}.md          # Story 文件
└── README.md                        # 需求管理说明
```

**检测逻辑**:

```yaml
# state-scanner 检测顺序
1. 检查 docs/requirements/ 是否存在
2. 如果存在，扫描 prd-*.md 文件
3. 如果存在，扫描 user-stories/US-*.md 文件
4. 调用 requirements-validator (check mode)
```

**理由**:
- 与模块内路径区分 (模块使用 `{module}/docs/requirements/`)
- 主项目级别的需求放在根 `docs/` 下

---

### D3: 推荐规则补全

**决策**: 在 RECOMMENDATION_RULES.md 规则概览中添加需求相关规则

**规则列表更新**:

| 规则 ID | 优先级 | 推荐工作流 | 触发条件 |
|---------|--------|-----------|----------|
| `commit_only` | 1 | C.1 only | 已暂存 + 无未暂存 |
| `quick_fix` | 2 | quick-fix | ≤3文件 + 简单修复 |
| `feature_with_spec` | 3 | feature-dev | 有 approved OpenSpec |
| `doc_only` | 4 | doc-update | 仅 *.md 文件 |
| `feature_new` | 5 | full-cycle | Level2+ 无 Spec |
| **`requirements_issues`** | **1.5** | **requirements-check** | **需求验证有错误** |
| **`pending_stories`** | **3.5** | **start-implementation** | **有就绪 Story** |
| **`missing_openspec`** | **3.8** | **create-openspec** | **Story 无技术方案** |

**理由**: 需求相关规则应该在主规则列表中可见，而不是只在文档后面

---

### D4: 初始 PRD 内容

**决策**: 创建 `prd-todo-app-v1.md` 作为项目级 PRD

**内容范围**:
- 涵盖 Todo App 整体产品定位
- 功能范围指向各模块 (Mobile, Backend)
- 关联现有架构文档

**理由**:
- 为后续 User Story 创建提供基础
- 验证 requirements-validator 工作流
- 演示 PRD → Story → OpenSpec 关系

---

## Integration Points

### 与 requirements-validator 集成

```
state-scanner
    │
    │ 调用 (check mode)
    ▼
requirements-validator
    │
    │ 返回
    ▼
validation_result:
  prd_valid: true/false
  stories_valid: true/false
  coverage: {...}
```

### 与 requirements-sync 集成

```
requirements-validator
    │
    │ 验证后
    ▼
requirements-sync
    │
    │ 同步到
    ▼
UPM requirements 节
```

### 与 forgejo-sync 集成 (可选)

```
requirements-sync
    │
    │ 检测 drift
    ▼
forgejo-sync
    │
    │ 同步
    ▼
Forgejo Issues
```

---

## File Changes Summary

| 文件 | 变更类型 | 说明 |
|------|----------|------|
| `.claude/skills/state-scanner/SKILL.md` | MODIFIED | 添加需求状态输出格式 |
| `.claude/skills/state-scanner/RECOMMENDATION_RULES.md` | MODIFIED | 补全规则列表 |
| `docs/requirements/README.md` | ADDED | 需求管理说明 |
| `docs/requirements/prd-todo-app-v1.md` | ADDED | 初始 PRD |
| `docs/requirements/user-stories/README.md` | ADDED | Story 目录说明 |

---

## Backward Compatibility

- **完全兼容**: 所有现有功能保持不变
- **增量增强**: 新增输出段落，不影响现有解析逻辑
- **可选启用**: 需求追踪是可选功能，未配置时仅显示提示

---

## Testing Strategy

1. **验证 state-scanner 输出**: 确认需求状态段落始终显示
2. **验证目录检测**: 测试有/无 `docs/requirements/` 两种情况
3. **验证规则触发**: 测试需求相关规则的匹配
4. **验证集成**: 测试 state-scanner → requirements-validator 调用链
