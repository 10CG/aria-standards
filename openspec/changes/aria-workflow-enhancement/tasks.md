# Aria Workflow Enhancement - Tasks

> **提案**: aria-workflow-enhancement
> **状态**: Draft
> **更新日期**: 2026-01-17

---

## 1. TDD Enforcer Skill

- [ ] 1.1 创建 `claude/skills/tdd-enforcer/SKILL.md`
- [ ] 1.2 定义 RED-GREEN-REFACTOR 工作流程
- [ ] 1.3 实现测试先于代码的强制检查
- [ ] 1.4 添加删除测试前代码的验证规则
- [ ] 1.5 编写测试示例和使用文档

## 2. Git Worktrees 集成

- [ ] 2.1 更新 `claude/skills/branch-manager/SKILL.md`
- [ ] 2.2 添加 worktree 创建逻辑
- [ ] 2.3 添加 worktree 清理功能
- [ ] 2.4 更新 `claude/skills/phase-b-developer/SKILL.md`
- [ ] 2.5 集成 worktree 路径切换
- [ ] 2.6 添加 worktree 状态检查

## 3. 自动触发系统

- [ ] 3.1 创建 `.claude/CLAUDE.md` 配置
- [ ] 3.2 定义意图关键词映射规则
- [ ] 3.3 实现 skill 自动激活逻辑
- [ ] 3.4 添加触发规则测试
- [ ] 3.5 编写用户指南

## 4. 两阶段评审机制

- [ ] 4.1 扩展 `phase-b-developer/SKILL.md` 评审流程
- [ ] 4.2 定义 Phase 1: 规范合规性检查
- [ ] 4.3 定义 Phase 2: 代码质量检查
- [ ] 4.4 实现阻塞机制（关键问题）
- [ ] 4.5 添加评审报告生成

## 5. Hooks 系统框架

- [ ] 5.1 创建 `aria/hooks/` 目录
- [ ] 5.2 创建 `hooks.json` 配置文件
- [ ] 5.3 实现 `session-start.sh` 脚本
- [ ] 5.4 创建 `run-hook.cmd` Windows 支持
- [ ] 5.5 添加 hook 验证测试

## 6. 文档与验证

- [ ] 6.1 更新 `docs/analysis/superpowers-vs-aria.md`
- [ ] 6.2 创建 migration guide
- [ ] 6.3 编写向后兼容性说明
- [ ] 6.4 集成测试覆盖
- [ ] 6.5 用户验收测试

---

**任务估算**: 总计 28 个子任务，预计 2-3 周完成

**推荐 Agent 分配**:
- Tasks 1.x → qa-engineer (测试专家)
- Tasks 2.x, 5.x → backend-architect (Git/脚本)
- Tasks 3.x, 4.x → tech-lead (系统设计)
- Tasks 6.x → knowledge-manager (文档)
