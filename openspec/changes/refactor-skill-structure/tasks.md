# Tasks: Refactor Skill Structure

> **Spec**: refactor-skill-structure
> **Level**: Full (Level 3)
> **Status**: Draft
> **Created**: 2025-12-23

---

## 1. 分析与准备

- [ ] 1.1 分析 task-planner/SKILL.md 内容，识别可拆分章节
- [ ] 1.2 分析 progress-updater/SKILL.md 内容，识别可拆分章节
- [ ] 1.3 分析 spec-drafter/SKILL.md 内容，识别可拆分章节
- [ ] 1.4 确认拆分策略和目标文件命名

## 2. task-planner 重构

- [ ] 2.1 创建 DUAL_LAYER_SPEC.md (双层架构规范)
- [ ] 2.2 创建 AGENT_MAPPING.md (Agent 分配规则)
- [ ] 2.3 精简 SKILL.md，添加子文件引用
- [ ] 2.4 验证拆分后内容完整性

## 3. progress-updater 重构

- [ ] 3.1 创建 STATETOKEN_SPEC.md (stateToken 规范)
- [ ] 3.2 创建 SYNC_RULES.md (双层同步规则)
- [ ] 3.3 精简 SKILL.md，添加子文件引用
- [ ] 3.4 验证拆分后内容完整性

## 4. spec-drafter 重构

- [ ] 4.1 创建 LEVEL_GUIDE.md (Level 选择指南)
- [ ] 4.2 精简 SKILL.md，添加子文件引用
- [ ] 4.3 验证拆分后内容完整性

## 5. 验收

- [ ] 5.1 所有 SKILL.md ≤350 行
- [ ] 5.2 所有子文件引用正确
- [ ] 5.3 更新 .claude/skills/README.md (如需)
