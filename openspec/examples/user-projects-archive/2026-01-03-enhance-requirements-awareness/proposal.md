# enhance-requirements-awareness

> **Status**: Complete
> **Created**: 2026-01-02
> **Author**: AI Assistant
> **Type**: Enhancement

---

## Summary

增强 state-scanner 需求感知能力，建立项目需求追踪体系，确保 Skill 实现与 OpenSpec 规范一致。

---

## Problem Statement

### 现状问题

1. **Spec 与实现不一致**: `intelligent-state-scanner` spec 定义了完整的 Requirements Awareness 要求，但 `state-scanner` SKILL.md 执行时未完全实现这些要求。

2. **需求目录不存在**: 项目缺少 `docs/requirements/` 目录结构，导致需求感知功能无法触发。

3. **静默跳过问题**: 当需求体系未配置时，state-scanner 静默跳过需求收集，没有给用户明确提示。

4. **推荐规则缺失**: `RECOMMENDATION_RULES.md` 中定义的需求相关规则 (5-9) 没有在主规则列表中体现。

### 影响范围

- state-scanner Skill 输出不完整
- 用户无法感知需求追踪功能的存在
- PRD → Story → OpenSpec 工作流未建立

---

## Proposed Solution

### 改进方向 A: 完善 state-scanner 输出

修改 `state-scanner` SKILL.md，确保：
1. 即使需求目录不存在，也输出 `📄 需求状态` 段落
2. 明确显示 `配置状态: ❌ 未配置` 或 `✅ 已配置`
3. 提供建议操作指引

### 改进方向 B: 更新推荐规则

修改 `RECOMMENDATION_RULES.md`：
1. 在规则概览表中添加需求相关规则 (5-9)
2. 增加 `requirements_not_configured` 信息提示规则
3. 明确路径约定为 `{module}/docs/requirements/`

### 改进方向 C: 建立项目需求目录

1. 在主项目创建 `docs/requirements/` 目录结构
2. 创建初始 PRD 文件 (基于模板)
3. 创建 `user-stories/` 子目录和 README

---

## Scope

### In Scope

- 修改 `.claude/skills/state-scanner/SKILL.md`
- 修改 `.claude/skills/state-scanner/RECOMMENDATION_RULES.md`
- 创建 `docs/requirements/` 目录结构
- 创建初始 PRD 文件
- 更新 UPM 文档添加 requirements 节

### Out of Scope

- 修改 `requirements-validator` Skill (已完整)
- 修改 `requirements-sync` Skill (已完整)
- 创建具体的 User Story 文件 (后续按需)
- Forgejo 集成配置 (已有 forgejo-sync skill)

---

## Success Criteria

1. [x] state-scanner 执行时始终输出需求状态段落
2. [x] 需求未配置时给出明确提示和建议
3. [x] `docs/requirements/` 目录结构存在
4. [x] PRD 模板文件可用
5. [x] RECOMMENDATION_RULES.md 包含完整规则列表

---

## Dependencies

- 现有规范: `openspec/specs/intelligent-state-scanner/spec.md`
- 现有规范: `openspec/specs/requirements-validator/spec.md`
- 模板文件: `standards/templates/prd-template.md`

---

## Risks

| 风险 | 级别 | 缓解措施 |
|------|------|----------|
| 增加 state-scanner 输出复杂度 | Low | 使用清晰的段落分隔 |
| 用户可能不需要需求追踪 | Low | 提供建议但不强制 |

---

## Related Changes

- 无前置依赖变更
- 后续可关联: 具体功能的 PRD 和 User Story 创建

---

## Approval

- [x] Technical Review
- [x] User Confirmation (实施完成)
