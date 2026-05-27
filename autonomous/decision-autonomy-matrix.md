# Autonomy Decision Matrix

<!-- Lab-shareable: this file is in standards/ and may be reused by other 10CG Lab projects. See aria-orchestrator/docs/layer-boundary-contract.md for Aria-specific implementation. -->

**Version**: 1.0.0
**Last Updated**: 2026-05-27
**Source PRD**: `docs/requirements/prd-aria-v2.md §553` (Aria main repo)
**Status**: Approved (Spec #3 `aria-2.0-m6-docs`, Phase B delivery)

---

## Overview

### 什么是自主决策矩阵

自主决策矩阵（Autonomy Decision Matrix）是一个结构化框架，用于系统性地回答：**"对于这类决策，AI 应该完全自主执行、带审计日志执行，还是必须暂停等待人类批准？"**

在 AI 自主运行系统中，并非所有决策都应以相同方式处理。某些操作风险低、可逆且高频，适合完全自主；另一些操作影响不可逆或涉及外部可见的变更，需要人类参与。矩阵的价值在于提前明确每种决策类型的边界，避免运行时的歧义。

### 何时使用此矩阵

在以下场景引用或扩展此矩阵：

1. **设计新的 AI 自主系统**：在起草 OpenSpec 或架构文档前，先用此矩阵确定每类操作的自主级别。
2. **审查现有系统的自主边界**：系统升级（如从交互模式迁移到自主模式）时，核对每个决策点是否达到合适的自主级别。
3. **与 Stakeholder 对齐期望**：在演示或评审中，用矩阵展示"哪些事情 AI 会自动做，哪些需要人类介入"，建立可核查的信任基础。
4. **信任建立阶段**：新项目初期可将更多决策设为 `human-gate-required`，随着观测数据积累逐步降级为 `auto-with-audit-log` 或 `fully-auto`。

### PRD §553 来源说明

本矩阵源自 Aria 2.0 PRD（`docs/requirements/prd-aria-v2.md`，行 553 区域）对方法论文档的要求：

> `decision-autonomy-matrix.md` — 自主/审批/禁止决策矩阵，位于 `standards/autonomous/`

PRD 将其定位为 **Lab-shareable** 的方法论资产，因此放置于 `standards/` 子模块而非 Aria 特定仓库。Aria 的具体实现（状态机边界、cost.json 契约等）记录在 `aria-orchestrator/docs/layer-boundary-contract.md`（Aria-specific，不进入 `standards/`）。

---

## 核心决策矩阵

自主级别定义：

| 级别 | 标识 | 含义 |
|------|------|------|
| **Fully-auto** | A | 无需人工介入；系统决策并直接执行；事后审计可选但非必须 |
| **Auto-with-audit-log** | B | 系统决策并执行，但**必须**写入不可篡改的审计行；人类可异步复查 |
| **Human-gate-required** | C | 系统在执行前暂停并通知人类（如 Feishu 消息卡片）；等待显式批准后继续 |

### 主矩阵

| 决策类型 | Fully-auto (A) | Auto-with-audit-log (B) | Human-gate-required (C) |
|----------|---------------|------------------------|------------------------|
| **Triage** — 传入 issue/请求的分类 | 信心度 > 90% 且不涉及 PR 变更 → 自动路由至对应类别。**理由**：分类操作高频、低风险；误分类可通过重新分类恢复，无不可逆后果。 | 信心度 70%–90% 或存在边界场景（issue 标签缺失、描述模糊）→ 自动分类并写审计行，标注置信度和分类依据。**理由**：需要可追溯性以便人类抽查，但不阻塞主流程。 | 信心度 < 70% 或标记为 `needs-human-triage` → 暂停并向 owner 发送通知。**理由**：低置信分类强行执行会浪费 Layer 2 算力并产生噪音 issue。 |
| **Dispatch** — 将任务分配给 Layer 2 | issue 已通过 Triage（状态 = S1_TRIAGED）且类型已知（bug/feature/stale-reopen）→ 自动选择 dispatcher 和 prompt 模板并发起 Nomad dispatch。**理由**：这是主干路径；dispatch 失败由 S_FAIL 处理，可重试。 | Dispatch 参数需要非默认覆盖（如自定义超时、特殊模型路由）→ 记录覆盖原因到审计日志后自动执行。**理由**：参数覆盖是技术决策，值得留存以备回溯，但不需人工批准。 | 涉及生产基础设施的 dispatch（如 schema migration dispatch）或 cost gate 接近软限 → 人工确认后再发起。**理由**：高风险或成本敏感操作不应在无人知晓的情况下执行。 |
| **Merge approval** — 接受 Phase C PR | 不适用（Aria 2.0 AD10 明确：merge approval 是唯一的强制人工参与点，不降级为 fully-auto）。 | 不适用（见 Human-gate 列）。CI 通过后生成审计摘要（测试覆盖、diff 规模、漂移分数）并附入 Feishu 卡片供 owner 决策参考。**理由**：审计摘要让人类的批准决策有数据依据，而非盲批。 | **所有 PR merge 操作**均需人工批准（AD10 硬约束）。Feishu 卡片展示：CI 状态、diff 摘要、漂移分数、成本预估。Owner 点击"Approve"后系统执行合并。**理由**：merge 是代码进入 main 的不可逆操作；自主 merge 在信任建立阶段过早，且违背 AD10。 |
| **Cost threshold alarm** — 计量用量触达月度上限 80% | 不适用（任何 cost gate 触发都必须通知人类）。 | 用量触达 50%–79% → 自动降低 dispatch 频率（进入保守模式）并记录审计行（当前用量、预测达顶时间、降频系数）。**理由**：轻量的自动保护措施；人类可通过审计日志复查决策过程，无需实时介入。 | 用量触达 80% 软限或 90% 硬限 → 暂停新 dispatch 并立即向 owner 发送 Feishu 告警卡片（包含当前用量、剩余配额、建议操作）。**理由**：成本超支是不可逆的财务影响；Spec #1 (`aria-2.0-m6-cost-acceptance`) 将此设计为强制人工门控。 |
| **Schema migration** — DB schema 版本升级 | 不适用（schema migration 属于不可逆基础设施变更，不允许无审计的完全自主执行）。 | 向后兼容的 additive migration（仅新增列或表，不删除已有列）→ 可在 maintenance window 内自动执行，但必须写审计行（migration 版本号、前置 backup 路径、执行时间戳、integrity_check 结果）。**理由**：additive migration 可回滚（新列可 DROP）；审计日志提供故障排查的起点。 | 非 additive migration（删除列、修改数据类型、重命名表）或在生产流量期间执行 → 必须人工批准。**理由**：非 additive migration 存在数据丢失风险；M5 实践（schema v3→v4）表明 migration 错误可导致 active dispatch 数据静默丢失（`getattr` 返回 None 的经典问题）。 |
| **Crash recovery escalation** — Layer 2 进程 kill / OOM / WAL corruption | 已知可自愈的故障（S5_AWAIT 重启自动恢复、Nomad alloc OOM → 自动 reschedule）→ 直接执行恢复流程，无需人工介入。**理由**：这些场景在 M3/M5 中已经过验证；自动恢复是系统弹性的核心价值；不打扰人类是"可信任自主"的衡量标准。 | 恢复成功但故障原因未知（如无 OOM 日志的进程消失）→ 执行恢复并写详细审计行（故障时间戳、最后已知状态、恢复操作序列、推测原因）。**理由**：未知原因故障需要留痕以便事后分析和模式识别，但不能因诊断未完成而阻塞服务恢复。 | WAL corruption（SQLite `integrity_check` 返回非 ok）或连续 3 次相同故障模式触发 → 拒绝自动恢复，向 owner 发送 Feishu 告警并等待人工介入。**理由**：WAL corruption 可能意味着更深层的存储问题；强行恢复可能掩盖数据完整性问题（M5 3 重 safeguard 经验）。连续故障表明自动恢复逻辑本身可能有缺陷。 |

---

## 决策类型详细说明

### Triage（传入请求分类）

Triage 是系统接收到新 issue 或请求时的第一道分类操作，决定 issue 是否进入开发流程，以及进入哪个类别（bug / feature / stale-reopen / spam / out-of-scope）。

Aria 2.0 的 Triage 由 Layer 1（Hermes + Luxeno-routed GLM 模型）执行，采用确定性规则（标签、关键词、提交者权限）为主、LLM 辅助为辅的策略（PRD 状态机 S1_SCAN）。确定性规则输出的信心度可量化，因此 Triage 是最适合 Fully-auto 的决策类型之一。

### Dispatch（向 Layer 2 分配任务）

Dispatch 是 Layer 1 将已分类的 issue 包装为参数化 Nomad job 并提交执行的操作。Dispatch 本身是幂等的（重复 dispatch 同一 issue 会被去重），因此可自动执行。

区别对待点：dispatch 的**参数选择**（特别是 prompt 模板和模型路由）涉及影响输出质量的决策，在需要覆盖默认值时应记录审计。

### Merge Approval（PR 合并批准）

这是 Aria 2.0 **唯一的强制人工参与点**（AD10，PRD 状态机 S7_AWAITING_MERGE）。Aria 2.0 的设计哲学是：在信任建立阶段，**代码合并到 main 分支必须有人类的显式决策**。AI 可以准备所有决策素材（CI 结果、diff 摘要、漂移分数），但 approve 动作由人类执行。

### Cost Threshold Alarm（成本阈值告警）

成本控制是 AI 自主系统的关键治理维度。Spec #1（`aria-2.0-m6-cost-acceptance`）定义了双路成本门控（Luxeno 订阅 + Zhipu 计量）。自主系统在接近配额时的合理行为是：先自动降速（50%–79% 区间），在触达告警线时强制暂停并通知人类。

### Schema Migration（数据库 Schema 升级）

Schema migration 的风险与操作类型强相关：additive 操作（新增列/表）通常可逆，non-additive 操作（删列、改类型）存在数据丢失风险。M5 的 schema v3→v4 迁移实践（参见 `[[feedback_schema_migration_3_safeguard_pattern]]`）提供了三重 safeguard 模式：SQLite backup + dry-run + apply + integrity_check。此矩阵将非 additive migration 设为 `human-gate-required` 是对 M5 经验的直接应用。

### Crash Recovery Escalation（崩溃恢复升级）

crash recovery 的自主级别取决于"是否已知如何恢复"和"恢复是否安全"。M3/M5 已验证的恢复路径（S5_AWAIT 重启自动续poll、Nomad OOM reschedule）属于系统弹性能力，应完全自主。未知原因的消失和存储层腐坏则需要人类介入，因为自动恢复可能掩盖更深层的问题。

---

## How to Adapt for Your Project

本节面向 10CG Lab 内其他项目（如 Kairos、SilkNode）采用此矩阵时的指引。

### 第一步：识别你的项目决策类型

从以下问题出发枚举决策类型：

1. **你的系统会自动触发哪些操作？** 列出所有无需用户交互即可发生的系统行为。
2. **哪些操作有不可逆后果？** 例如：删除数据、发送通知、触发外部 API、修改生产配置。
3. **哪些操作有明显的成本或安全影响？** 例如：API 调用计费、权限变更、凭证使用。
4. **哪些操作的错误难以被发现？** 静默失败（silent failure）的场景尤其需要审计日志。

### 第二步：为每种决策类型选择自主级别

使用以下决策树：

```
操作是否不可逆（删除、合并、生产配置变更）？
├─ 是 → human-gate-required（除非有明确的自动回滚机制）
└─ 否 →
    操作频率是否高（>10次/天）且误操作影响是否可快速纠正？
    ├─ 是 → fully-auto（对于核心路径）
    └─ 否 →
        是否需要事后审查或合规要求？
        ├─ 是 → auto-with-audit-log
        └─ 否 → fully-auto（低风险低频操作）
```

### 第三步：何时使用 Human-gate

以下任一条件触发时，应将决策设为 `human-gate-required`：

- **高风险操作**：merge 到主分支、删除生产数据、修改访问控制
- **不可逆操作**：没有自动回滚机制的操作
- **信任建立阶段**：新功能上线初期，观测数据不足以确认自动判断的准确率
- **合规要求**：受监管的操作（金融、医疗等场景）可能要求强制人工审批记录
- **成本影响超过阈值**：单次操作成本超过预设上限

### 第四步：配置审计日志

对于 `auto-with-audit-log` 级别的决策，审计行应包含：

```yaml
audit_entry:
  timestamp: "ISO-8601"
  decision_type: "triage|dispatch|cost_alarm|schema_migration|crash_recovery"
  autonomy_level: "auto-with-audit-log"
  input_context: {}          # 触发决策的输入摘要（不含 secrets）
  decision_output: {}        # 决策结果
  confidence_score: 0.0      # 如适用
  rationale: ""              # 决策依据（1-2句）
  reversible: true           # 此决策是否可撤销
  reviewer_notified: false   # 是否已通知人类复查
```

### 第五步：演进自主级别

矩阵不是静态的。建议在以下时机重新评估：

- 系统运行 30 天后，用实际数据验证自动决策的准确率
- 重大版本升级后，新能力可能改变风险评估
- 发生 incident 后，复盘确定是否需要将某类决策升级为 `human-gate-required`

---

## 与 Aria 2.0 实现的映射

下表展示本矩阵中的决策类型如何映射到 Aria 2.0 的状态机状态（S0-S9）：

| 决策类型 | Aria 2.0 状态 | 执行层 |
|----------|--------------|--------|
| Triage | S0_NEW → S1_TRIAGED | Layer 1 |
| Dispatch | S1_TRIAGED → S4_LAUNCH | Layer 1 |
| Merge approval | S7_AWAITING_MERGE | Human (owner via Feishu) |
| Cost threshold alarm | 跨状态（全局 guard） | Layer 1 cost gate |
| Schema migration | 维护窗口操作（非状态机内） | 运维人员 / 自动化脚本 |
| Crash recovery escalation | S_FAIL → recovery | Layer 1 + Layer 2 协同 |

---

## Cross-references

See `aria-orchestrator/docs/layer-boundary-contract.md` for how Aria implements this matrix in the Layer 1 / Layer 2 boundary. That file documents:
- The cost.json schema (locked at Spec #1 `c29a800`) underpinning the Cost threshold alarm row
- The exact state machine states (S0-S9) and their ownership (Layer 1 vs Layer 2)
- The S7_AWAITING_MERGE human gate implementation (Feishu card format + AD10 rationale)

For the humanized command patterns that Layer 1 uses when notifying humans at the `human-gate-required` decision points, see `standards/autonomous/humanized-command-patterns.md`.
