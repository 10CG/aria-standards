# spec-drafter Skill

> **Level**: Minimal (Level 2 Spec)
> **Status**: Implemented
> **Created**: 2025-12-17

## Why

填补十步循环 Step 0 (Spec定义) 的工具空白。当前 Step 0 没有对应的 Skill 支持，开发者需要手动创建 OpenSpec proposal.md 文档，效率低且格式不一致。

## What

创建 `spec-drafter` Skill，用于辅助生成 OpenSpec proposal.md 文档。支持三级 Spec 策略的自动判断和模板生成。

### Key Deliverables
- `.claude/skills/spec-drafter/SKILL.md` - 主 Skill 文档
- `.claude/skills/spec-drafter/LEVEL3_TEMPLATE.md` - Level 3 tasks.md 模板

## Impact

| Type | Description |
|------|-------------|
| **Positive** | 加速 Spec 创建流程，确保格式一致，降低 OpenSpec 使用门槛 |
| **Risk** | 模板质量依赖输入信息质量；可通过交互模式缓解 |

## Tasks

- [x] 实现 Level 判断算法 (1/2/3 三级策略)
- [x] 实现信息提取引擎 (Why/What/Tasks等)
- [x] 实现交互模式 (逐章节确认)
- [x] 集成 progress-query-assistant 上下文增强
- [x] 创建 SKILL.md 主文档
- [x] 创建 LEVEL3_TEMPLATE.md 模板

## Success Criteria

- [x] 能正确判断 Level 1/2/3 并给出建议
- [x] 生成的 proposal.md 符合 OpenSpec 模板格式
- [x] Level 3 能额外生成 tasks.md
- [x] 交互模式允许逐章节编辑确认
- [x] 上下文增强能获取当前 Phase/Cycle 信息
