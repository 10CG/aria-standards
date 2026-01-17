# Aria Workflow Enhancement

> **Level**: Full (Level 3 Spec)
> **Status**: Draft
> **Created**: 2026-01-17
> **Updated**: 2026-01-18
> **Version**: 1.1 (Refined by spec-drafter)
> **Module**: skills

## Why

基于对 obra/superpowers (27k stars) 的深度对比分析，Aria 在以下方面可借鉴其成功经验：

1. **TDD 强制执行** - Superpowers 强制 RED-GREEN-REFACTOR 循环，Aria 当前测试为可选步骤
2. **Git Worktrees 隔离** - Superpowers 使用 worktree 实现干净并行开发，Aria 直接在主分支开发
3. **自动触发机制** - Superpowers 技能自动激活，Aria 需要用户显式调用
4. **两阶段评审** - Superpowers 在规范合规性后增加代码质量检查，Aria 仅有单阶段评审
5. **Hooks 系统** - Superpowers 完整的 hooks 在关键节点拦截验证，Aria 缺少此机制

这些改进将显著提升 Aria 的开发质量、效率和企业级可靠性。

## What

基于 Superpowers 的成功实践，为 Aria 添加强制工作流机制，同时保持 Aria 的企业级优势（OpenSpec、UPM、架构文档系统等）。

### Key Deliverables

#### 1. TDD Enforcer Skill
- **位置**: `claude/skills/tdd-enforcer/SKILL.md`
- **核心流程**: RED (失败测试) → GREEN (最小实现) → REFACTOR (重构)
- **强制规则**:
  - 编写业务代码前必须存在失败测试
  - 删除测试前必须验证无业务代码依赖
  - 使用 PreToolUse hook 拦截违反规则的操作
- **参考**: `docs/analysis/superpowers-vs-aria.md#tdd-workflow`

#### 2. Git Worktrees 集成
- **修改文件**:
  - `claude/skills/branch-manager/SKILL.md` - 添加 worktree 创建/清理
  - `claude/skills/phase-b-developer/SKILL.md` - 集成 worktree 路径切换
- **工作目录**: `.git/worktrees/{feature-name}/`
- **隔离级别**: 功能完全独立，主分支保持干净
- **参考**: `docs/analysis/superpowers-vs-aria.md#git-worktrees`

#### 3. 自动触发系统
- **配置文件**: `.claude/CLAUDE.md` (项目级)
- **触发规则**: 意图关键词 → Skill 映射
  ```
  "test" → tdd-enforcer
  "bug fix" → quick-fix
  "new feature" → state-scanner → workflow-runner
  ```
- **匹配策略**: 模糊匹配 + 置信度阈值 (≥0.7)
- **参考**: `docs/analysis/superpowers-vs-aria.md#auto-trigger`

#### 4. 两阶段评审机制
- **修改文件**: `claude/skills/phase-b-developer/SKILL.md`
- **Phase 1 - 规范合规性**: OpenSpec 格式、UPM 状态、架构文档同步
- **Phase 2 - 代码质量**: 测试覆盖率、代码复杂度、安全检查
- **阻塞条件**: 关键问题必须修复后方可继续
- **参考**: `docs/analysis/superpowers-vs-aria.md#two-phase-review`

#### 5. Hooks 系统框架
- **目录结构**:
  ```
  aria/hooks/
  ├── hooks.json           # Hook 配置
  ├── session-start.sh     # 会话初始化
  ├── run-hook.cmd         # Windows 支持
  └── validators/
      ├── spec-compliance.py
      └── code-quality.py
  ```
- **触发点**: SessionStart, PreCommit, TaskComplete
- **参考**: `docs/analysis/superpowers-vs-aria.md#hooks-system`

## Impact

| Type | Description |
|------|-------------|
| **Positive** | 提升代码质量和测试覆盖率 (目标: +30%) |
| **Positive** | 隔离开发环境，主分支保持稳定 |
| **Positive** | 降低用户认知负担，技能自动触发 |
| **Positive** | 双重质量保证，减少返工 |
| **Risk** | 工作流变复杂可能影响开发速度 |
| **Mitigation** | 采用渐进式引入，保持向后兼容 |
| **Risk** | Hooks 系统可能增加故障点 |
| **Mitigation** | Hooks 失败时优雅降级，记录日志不阻塞 |

## Scope

### Phase 1 - MVP (本次)

| 模块 | 功能 | 来源 |
|------|------|------|
| **TDD Enforcer** | 强制 RED-GREEN-REFACTOR 流程 | docs/analysis/superpowers-vs-aria.md |
| **Worktrees** | branch-manager 使用 worktree | docs/analysis/superpowers-vs-aria.md |
| **Auto-Trigger** | CLAUDE.md 意图规则配置 | docs/analysis/superpowers-vs-aria.md |
| **Two-Phase Review** | phase-b-developer 评审增强 | docs/analysis/superpowers-vs-aria.md |
| **Hooks** | session-start.sh 基础框架 | docs/analysis/superpowers-vs-aria.md |

### Phase 2 - Extended

| 模块 | 功能 | 优先级 |
|------|------|--------|
| Pre-Commit Hook | 提交前自动测试 | P1 |
| Task-Complete Hook | 任务完成检查 | P1 |
| YAGNI Validator | 过度设计检测 | P2 |
| Brainstorming Skill | 交互式需求澄清 | P2 |

### Out of Scope

- 技能目录结构重构（已确认符合官方规范，无需变更）
- Agent 继承机制（低优先级）
- 架构文档系统变更

## Technology Stack

| Component | Technology | 来源 |
|-----------|------------|------|
| Git Worktrees | git worktree | Superpowers reference |
| Hooks | Shell scripts | Superpowers reference |
| Auto-Trigger | Claude Code CLAUDE.md | Claude Code docs |

## Dependencies

| 依赖项 | 类型 | 状态 | 说明 |
|--------|------|------|------|
| `docs/analysis/superpowers-vs-aria.md` | 文档 | ✅ 已完成 | 对比分析，需求来源 |
| `claude/skills/branch-manager/SKILL.md` | 现有 Skill | ✅ 存在 | 需扩展 worktree 功能 |
| `claude/skills/phase-b-developer/SKILL.md` | 现有 Skill | ✅ 存在 | 需添加两阶段评审 |
| Agent Skills 规范 | 外部规范 | ✅ 已验证 | 目录结构无需变更 |
| Git 2.30+ | 系统依赖 | ✅ 已满足 | worktree 支持 |

## Rollback Plan

| 场景 | 回滚步骤 | 验证方法 |
|------|----------|----------|
| **TDD Enforcer 阻塞开发** | 1. 重命名 `tdd-enforcer/SKILL.md` → `tdd-enforcer/SKILL.md.disabled`<br>2. 更新 CLAUDE.md 移除自动触发 | 恢复原有开发流程 |
| **Worktree 路径问题** | 1. 删除 `.git/worktrees/` 下相关目录<br>2. `git worktree prune` 清理 | `git worktree list` 验证清理 |
| **Hooks 执行失败** | 1. 在 `hooks.json` 中设置 `"enabled": false`<br>2. 重命名 `aria/hooks/` → `aria/hooks.bak/` | 正常 Session 可启动 |
| **自动触发误判** | 1. 编辑 `.claude/CLAUDE.md` 移除问题规则<br>2. 重启 Claude Code | Skill 不再自动激活 |

## Success Criteria

### 功能验证
- [ ] tdd-enforcer skill 创建并能正确拦截违反 TDD 的操作
- [ ] branch-manager 支持 `--worktree` 参数，worktree 创建/清理正常
- [ ] phase-b-developer 两阶段评审流程可独立启用/禁用
- [ ] CLAUDE.md 意图规则匹配准确率 >= 80%
- [ ] hooks/ 目录和 session-start.sh 在 Windows/Linux 上均可执行

### 质量指标
- [ ] 新增代码测试覆盖率 >= 85%
- [ ] 所有 Skill 文档通过 OpenSpec Lint 检查
- [ ] 回滚方案测试验证通过（4个场景）

### 兼容性
- [ ] 现有 skills 目录结构保持不变（符合 Agent Skills 规范）
- [ ] 所有新功能可选启用，默认行为不变
- [ ] 向后兼容性测试通过（mobile + backend + standards 模块）

## References

### 必读文档

1. **对比分析** - `docs/analysis/superpowers-vs-aria.md`
2. **Superpowers** - https://github.com/obra/superpowers
3. **Agent Skills 规范** - https://agentskills.io/specification

### 参考技能

1. **test-driven-development** - obra/superpowers/skills/test-driven-development
2. **using-git-worktrees** - obra/superpowers/skills/using-git-worktrees
3. **branch-manager** - claude/skills/branch-manager/SKILL.md
4. **phase-b-developer** - claude/skills/phase-b-developer/SKILL.md

---

**设计原则**: 保持 Aria 企业级优势的同时，借鉴 Superpowers 的简洁性和强制最佳实践，形成"Superpowers 的简单直接 + Aria 的完整体系"的混合优势。
