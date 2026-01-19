# Standards Documentation Sync

> **Level**: Full (Level 3 Spec)
> **Status**: Draft
> **Created**: 2026-01-20
> **Version**: 1.0
> **Module**: standards

## Why

aria-workflow-enhancement 项目已完成实施，为 Aria 添加了以下关键增强：

1. **TDD Enforcer** - 强制 RED-GREEN-REFACTOR 循环
2. **Git Worktrees** - 隔离并行开发环境
3. **自动触发系统** - trigger-rules.json 意图关键词映射
4. **两阶段评审** - 规范合规 + 代码质量
5. **Hooks 系统** - session-start/session-end 拦截验证

这些增强已通过集成测试验证并合并到 master，但 **standards 模块的核心文档尚未同步更新**。

当前问题：
- standards/core/ten-step-cycle/ 文档未反映 TDD 强制要求
- standards/conventions/git-commit.md 缺少增强标记说明
- standards/workflow/ 文档未包含 Hooks 和自动触发机制
- 新用户阅读 standards 文档时无法获得完整的工作流指引

## What

更新 standards 模块的核心文档，确保与 aria-workflow-enhancement 的实现保持一致。

### 更新范围

| 优先级 | 文档 | 更新内容 |
|--------|------|---------|
| **P0** | standards/core/ten-step-cycle/README.md | 添加 TDD、自动触发、Hooks 说明 |
| **P0** | standards/core/ten-step-cycle/phase-b-development.md | B.2 集成 TDD 验证、RED-GREEN-REFACTOR |
| **P0** | standards/conventions/git-commit.md | 添加增强标记、Skill 选择指南 |
| **P1** | standards/workflow/ai-development-workflow.md | TDD 检查、两阶段评审 |
| **P1** | standards/workflow/branch-management-guide.md | 分支策略与 Hooks 集成 |
| **P1** | standards/summaries/workflow-summary.md | 最佳实践摘要 |
| **P2** | standards/summaries/ten-step-cycle-summary.md | 快速参考更新 |
| **P2** | standards/summaries/conventions-summary.md | 提交规范摘要 |
| **P2** | standards/core/workflow/implementation-best-practices.md | TDD/Hooks 最佳实践 |
| **P2** | standards/core/workflow/document-sync-mechanisms.md | Hooks 文档同步机制 |

### Key Deliverables

#### 1. 核心十步循环文档更新 (P0)

**standards/core/ten-step-cycle/README.md**
- 添加 TDD Enforcer 强制 RED-GREEN-REFACTOR 循环说明
- 集成 trigger-rules.json 自动触发系统描述
- 添加 Hooks 系统文档链接
- 更新 Phase B 开发步骤，加入 TDD 验证要求

**standards/core/ten-step-cycle/phase-b-development.md**
- B.2 执行验证章节增加 TDD Enforcer 集成
- 添加 RED-GREEN-REFACTOR 循环的具体步骤
- 说明如何与 trigger-rules.json 配合工作
- 添加 Hooks 在开发阶段的作用

**standards/conventions/git-commit.md**
- 添加增强标记 (Agent/Context/Module) 说明
- 更新 Skill 选择指南，包含新工作流程相关提交
- 补充与 trigger-rules.json 相关的提交规范

#### 2. 工作流文档更新 (P1)

**standards/workflow/ai-development-workflow.md**
- 集成 TDD Enforcer 到开发前检查流程
- 添加 trigger-rules.json 的触发条件说明
- 更新 Hooks 系统在工作流中的作用
- 补充两阶段评审的具体实施步骤

**standards/workflow/branch-management-guide.md**
- 更新分支命名规范支持 TDD Enforcer 分支管理
- 添加与 trigger-rules.json 相关的分支策略
- 说明 Hooks 在分支生命周期管理中的应用

**standards/summaries/workflow-summary.md**
- 添加 TDD Enforcer 和 RED-GREEN-REFACTOR 循环摘要
- 集成 trigger-rules.json 自动触发系统说明
- 更新最佳实践部分

#### 3. 摘要与最佳实践文档更新 (P2)

**standards/summaries/ten-step-cycle-summary.md**
- 快速参考添加 TDD Enforcer 相关步骤
- 补充 trigger-rules.json 触发机制

**standards/summaries/conventions-summary.md**
- 更新 Git Commit 摘要包含增强标记

**standards/core/workflow/implementation-best-practices.md**
- 添加 TDD Enforcer 最佳实践
- 集成 Hooks 系统使用指南
- 说明 trigger-rules.json 配置最佳实践

**standards/core/workflow/document-sync-mechanisms.md**
- 添加与 TDD Enforcer 相关的文档同步
- 更新 Hooks 系统触发文档同步机制

## Impact

### Positive
- **一致性**: Standards 文档与实际实现保持同步
- **可发现性**: 新用户通过文档即可了解完整工作流
- **可维护性**: 文档更新有明确的 Spec 追踪

### Risk
- **文档冗余**: 可能造成与现有文档内容重复
- **维护负担**: 增加文档同步维护成本

### Mitigation
- 采用引用而非重复（链接到 aria/hooks/, .claude/skills/）
- 建立文档与实现的一致性检查机制

## Dependencies

| 依赖项 | 状态 | 说明 |
|--------|------|------|
| `openspec/archived/aria-workflow-enhancement/proposal.md` | ✅ 已完成 | 变更来源 |
| `.claude/skills/tdd-enforcer/SKILL.md` | ✅ 已存在 | TDD 文档 |
| `.claude/trigger-rules.json` | ✅ 已存在 | 触发规则 |
| `aria/hooks/hooks.json` | ✅ 已存在 | Hooks 配置 |

## Success Criteria

### 功能验证
- [ ] P0 文档全部更新完成
- [ ] P1 文档全部更新完成
- [ ] P2 文档全部更新完成（可选）
- [ ] 所有新增内容与 aria-workflow-enhancement 实现一致

### 质量指标
- [ ] 文档中的链接全部有效
- [ ] 代码示例可运行
- [ ] 中英文术语一致

### 兼容性
- [ ] 不破坏现有文档结构
- [ ] 向后兼容（旧文档仍可理解）

## References

### 必读文档

1. **aria-workflow-enhancement** - `openspec/archived/aria-workflow-enhancement/proposal.md`
2. **TDD Enforcer** - `.claude/skills/tdd-enforcer/SKILL.md`
3. **Auto-Trigger** - `.claude/trigger-rules.json`
4. **Hooks** - `aria/hooks/README.md`

### 相关规范

1. **十步循环概览** - `standards/core/ten-step-cycle/README.md`
2. **Phase B: 开发执行** - `standards/core/ten-step-cycle/phase-b-development.md`
3. **Git Commit 规范** - `standards/conventions/git-commit.md`

---

**设计原则**: 保持 Standards 文档的权威性，确保与实际实现同步，为用户提供完整准确的工作流指引。
