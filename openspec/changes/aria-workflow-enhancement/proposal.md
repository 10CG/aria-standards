# Aria Workflow Enhancement

> **Level**: Full (Level 3 Spec)
> **Status**: Draft
> **Created**: 2026-01-17
> **Updated**: 2026-01-17
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

1. **TDD Enforcer Skill** - 强制执行测试驱动开发流程
2. **Git Worktrees 集成** - 在 branch-manager 和 phase-b-developer 中实现 worktree 支持
3. **自动触发系统** - 通过 CLAUDE.md 实现意图识别和技能自动激活
4. **两阶段评审机制** - 在 phase-b-developer 中添加规范→质量递进式检查
5. **Hooks 系统框架** - 创建 aria/hooks/ 目录和基础 hook 脚本

## Impact

| Type | Description |
|------|-------------|
| **Positive** | 提升代码质量和测试覆盖率 |
| **Positive** | 隔离开发环境，主分支保持稳定 |
| **Positive** | 降低用户认知负担，技能自动触发 |
| **Positive** | 双重质量保证，减少返工 |
| **Risk** | 工作流变复杂可能影响开发速度 |
| **Mitigation** | 采用渐进式引入，保持向后兼容 |

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

## Success Criteria

- [ ] tdd-enforcer skill 创建并测试通过
- [ ] branch-manager 支持 worktree 模式
- [ ] phase-b-developer 集成两阶段评审
- [ ] CLAUDE.md 自动触发规则生效
- [ ] hooks/ 目录和 session-start.sh 实现
- [ ] 所有变更向后兼容

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
