---
created_at: '2026-06-21'
updated_at: '2026-06-21'
---

---
id: STD-GUIDE-003
title: LLM 工具一致性 — 结构性强制优于 Prose
classification: 核心规范文档
subcategory: 开发方法论
status: active
priority: high
created_at: 2026-06-21
updated_at: 2026-06-21
created_by: AI-Team

relationships: {
  "implements": ["AI-DDD指南"],
  "related_to": ["契约驱动开发指南", "MCP/插件工具设计"]
}

ai_development_guide: {
  "architectural_approach": "结构性强制 (hook / server-side 改写) 优于 prose 提示",
  "development_priority": "可靠的 LLM 工具路由与身份一致性",
  "key_principles": ["LLM 行为有方差", "prose 是软建议", "一致性需系统强制", "静默失败先加 edge logging"]
}

ai_memory: {
  "priority": "high",
  "retention_scope": "global",
  "key_concepts": ["结构性强制", "UserPromptSubmit hook", "server-side pin", "prose-insufficiency", "edge request logging"]
}
---

# LLM 工具一致性 — 结构性强制优于 Prose

> **文档类型**：核心规范文档
> **重要级别**：A级
> **创建时间**：2026-06-21
> **RACI**：R/A = tech-lead；C = ai-engineer, backend-architect；I = all-team-members
> **来源**：US-037 MCP server + 插件交付（2026-06；归档 `openspec/archive/2026-06-21-us-037-mcp-server-exposure`）的贯穿教训，经 Wave-4 4-agent 收敛审计 (tech-lead F6) 裁定升级为标准。

## 概述

构建 LLM / MCP / 插件类工具时，**凡是需要大模型跨调用、跨会话"一致地"做的事，不要指望靠文档 / prose / SKILL.md / system-prompt 的"请这样做"约定 —— 必须用结构性手段强制。**

大模型的逐次行为有方差。prose 是"软建议"：模型会按自己的判断、当前上下文、或内置行为绕过它。当某件事**必须每次都对**（选对工具、用稳定标识符、带上必填默认值），软建议不够 —— 要把决策从"求模型配合"挪到"系统强制"。

## 核心原则

### 1. prose 不保证一致性 (prose-insufficiency)

文档描述"应该怎么路由 / 应该用哪个 id"是必要的（人和模型都要能读懂意图），但它**不是强制**。模型在生产中会偏离。判据：如果这件事偏离一次就造成**静默失败**（错误结果、丢数据、对不上），那它需要结构性强制，不能只靠文档。

### 2. 把"必须一致"的点结构性强制

设计工具集时，先列出所有"模型必须每次一致做"的点，逐个问："靠文档够吗？" —— 通常不够，则上结构性强制：

| 不一致点 | 结构性修法 |
|---|---|
| **工具选择 / 路由**（该调哪个工具、该不该调） | `UserPromptSubmit` hook：分类意图 → 注入 **model-facing `additionalContext`** nudge 引导模型调对的工具（不是 user-facing `systemMessage`） |
| **稳定标识符**（user_id、session key 等跨会话必须一致） | **服务器端 pin / override**（opt-in env，如 `NEXUS_DEFAULT_USER_ID`）：服务器改写请求里的值，**不让模型每次自己填** |
| **必填默认值 / 不变量** | 服务器端注入 / 校验，而非"告诉模型记得传 X" |

### 3. 静默失败：先在边缘加 request logging

这类失败往往**静默**（模型选了内置行为、填了不一致的 id、默认值被丢），表面看"按文档应该能工作"。**诊断第一步不是改代码，是在边缘层（代理 / 网关 / 服务入口）加 per-request logging，看真实发出的 method / path / 关键字段值**，再归因。猜测代价远高于 observable。

### 4. 结构性强制有成本，按需用

hook 是一个进程、server-side pin 是配置面 —— 不是零成本。**只在"必须一致"的点用**，不要给所有事都加。还要区分强度：
- **advisory nudge**（`additionalContext`）：steer，不 force —— 模型仍可不听。适合"强烈引导"，不适合硬不变量。
- **server-side 改写 / override**：硬强制 —— 模型填什么都不影响。适合稳定标识符、必填默认这类不能错的。

## 实施清单 (How to apply)

1. 列出工具集里所有"模型必须每次一致做"的点（路由、身份、默认值、不变量）。
2. 每个点判定：偏离一次会不会静默失败？会 → 结构性强制；不会 → 文档足矣。
3. 选强度：advisory（hook nudge）还是 hard（server-side override）。一致性是硬要求的（如跨会话 user_id）用 hard。
4. **不要从 tenant/其他轴派生标识符**（会塌缩 compound key，如 `tenant::tenant`）—— 用显式独立配置。
5. 加 edge request logging 作为这类工具的标配诊断手段（静默失败必需）。
6. 测试：hook 类必须 fail-open（异常不阻断用户）+ 非空洞（能 go red）；server-side override 必须验"模型填了别的值仍被覆盖"这一失败模式。

## 反面教材与证据 (US-037)

一个交付 arc 内，**同一教训踩 3 次**，每次都是"prose 输给模型行为"，靠结构性手段才修好：

| # | 不一致点 | prose 尝试（失败） | 结构性修法 |
|---|---|---|---|
| 1 | "remember X" 该走 `nexus.memory_create` | SKILL.md 路由约定 → 两轮 dogfood 均 1/5，内置 auto-memory 抢路由 | **UserPromptSubmit hook** 确定性 nudge |
| 2 | 召回该走 `nexus.context_retrieve` | 同样 prose 输给内置文件记忆 | **read-intent hook nudge**（同一 hook，两 rule 段） |
| 3 | 跨会话召回要同一 `user_id` | SKILL.md "请用 default" 约定 → 模型每次挑不同 id，存/取对不上，召回静默失败 | **mcp-server server-side user_id pin**（`NEXUS_DEFAULT_USER_ID` override 每次调用） |

dogfood 路由命中率随结构性修复推进：**1/5 → 2/5 → 5/5**。第 3 项的诊断正是靠给 CF 代理加 `user_id` body logging 才确认 pin 是否生效（原则 3）。

## 适用范围

任何把能力暴露给 LLM 客户端的项目：MCP server、Claude Code / 编辑器插件、Agent 工具集、function-calling 后端。原则与具体产品无关。
