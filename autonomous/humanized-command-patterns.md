# Humanized Command Patterns

<!-- Lab-shareable: this file is in standards/ and may be reused by other 10CG Lab projects. For M6 E2E corpus samples, see aria-orchestrator/evals/m6-prompt-quality/corpus/ (Spec #2 TG-C). -->

**Version**: 1.0.0
**Last Updated**: 2026-05-27
**Source PRD**: `docs/requirements/prd-aria-v2.md §639` (Aria main repo)
**Status**: Approved (Spec #3 `aria-2.0-m6-docs`, Phase B delivery)

---

## Overview

在 AI 自主系统中，Layer 1（AI 主管）需要向人类（owner）发出各类指令、通知和请求。这些"命令"的质量直接影响：

1. **人类信任**：措辞机械的命令让人感觉在与工单系统交互，而非与有经验的团队协作者合作。
2. **执行效率**：高质量命令减少歧义，owner 一次阅读就能决策，无需来回确认。
3. **自主系统的可接受性**：Aria 2.0 最终是否被 Lab 其他项目采用，部分取决于其"是否像一个会说话的工程师"。

本文件提供 ≥10 个经过提炼的命令模式，以 Anti-pattern vs Good practice 的对比形式展示。这是 Lab-shareable 的**精炼指南**，原始 M6 E2E 语料库（含逐样本评分）见 `aria-orchestrator/evals/m6-prompt-quality/corpus/`（Spec #2 TG-C 交付物）。

---

## PRD §639 评分框架

### 7 个评分维度（D1-D7）

本框架来自 PRD §639，其 SoT 为 Spec #2 §C.2（`aria-2.0-m6-e2e-resilience/proposal.md §C.2`）。Spec #3 直接复用相同维度定义，不得与 SoT 发散。

| 维度 | 名称 | 评分说明 |
|------|------|----------|
| **D1** | Naturalness（自然度） | 0 = 机械/模板式语言；10 = 与有经验的人类工程师无法区分 |
| **D2** | Specificity（精确性） | 0 = 模糊、无可操作的步骤；10 = 精确包含具体文件/函数引用的可执行步骤 |
| **D3** | Tone appropriateness（语调匹配度） | 0 = 语调与场景完全不符；10 = 语调与请求的严重程度和协作关系完全匹配 |
| **D4** | Completeness（完整性） | 0 = 缺少开发者需要的关键上下文；10 = 开发者做决策所需的所有上下文均已包含 |
| **D5** | Conciseness（简洁性） | 0 = 冗余填充内容；10 = 用最少的词语完整传达意图 |
| **D6** | Technical accuracy（技术准确性） | 0 = 文件/函数/commit 引用错误；10 = 所有技术引用均正确且可验证 |
| **D7** | Autonomy footprint（自主边界适当性） | 0 = 过度委托（本可自主处理的事情也交给人类）；10 = 恰当范围界定，无不必要的请求 |

### 合格阈值

**单样本合格**：7 个维度分数的**中位数 ≥ 7/10**。

采用中位数而非均值的原因（PRD §656，2026-05-24 `e884e62` 补丁，Q4 owner 锁定）：命令质量分数在实际评测中往往呈双峰分布（某些维度高分、某些维度低分），中位数对极端值更鲁棒，且更符合 Lab 行业惯例对鲁棒性指标的定义。

**语料库合格**：10 个样本的中位数（每个样本的 D1-D7 中位数）的中位数 ≥ 7/10。

---

## 模式目录

| 编号 | 模式名称 | 核心对比维度 |
|------|----------|-------------|
| Pattern 1 | Triage 通知：机械标签 vs 情境化告知 | D1, D3, D4 |
| Pattern 2 | Dispatch 发起：命令式 vs 协作式 | D1, D3, D7 |
| Pattern 3 | 成本告警：数字堆砌 vs 可操作建议 | D2, D4, D5 |
| Pattern 4 | Merge 批准请求：通知式 vs 决策辅助式 | D2, D4, D6 |
| Pattern 5 | 崩溃恢复通知：技术转储 vs 状态摘要 | D1, D3, D5 |
| Pattern 6 | Schema migration 确认：风险罗列 vs 风险评估 | D2, D3, D4 |
| Pattern 7 | Spec 审计反馈：被动列举 vs 主动定位 | D2, D6, D7 |
| Pattern 8 | PR 评论：措辞强硬 vs 建议性表达 | D1, D3, D7 |
| Pattern 9 | 测试失败诊断：原始日志转发 vs 根因摘要 | D1, D4, D5 |
| Pattern 10 | 代码审查礼貌性模式：缺失上下文 vs 充分铺垫 | D1, D3, D4 |
| Pattern 11 | 人工门控请求：过度委托 vs 范围界定清晰 | D4, D7 |
| Pattern 12 | 成本评审：被动响应 vs 预测性告知 | D2, D4, D7 |

---

## 模式详解

### Pattern 1: Triage 通知 — 机械标签 vs 情境化告知

**Anti-pattern** (score < 5):

```
ISSUE #42 LABELED: bug
STATUS: triaged
CONFIDENCE: 0.87
```

**Good practice** (score ≥ 7):

```
已将 Issue #42 分类为 bug（置信度 87%）。

依据：标题包含 "NullPointerException"，且提交者 @alice 在过去 30 天有 3 次类似报告。
我已按照标准 bug 路由将其加入开发队列。

如果你认为分类有误，回复 "retriage: <正确类别>" 即可。
```

**Rationale**: Anti-pattern 是原始数据转储，D1（自然度）和 D3（语调）均接近 0 — 它看起来更像监控日志而非团队沟通。Good practice 解释了**为什么**这样分类（D4 完整性），告知了**已采取的行动**（D7 避免不必要委托），并提供了**纠错路径**（D2 精确性）。这三点共同将 D1-D7 中位数从 2 提升至 8。

---

### Pattern 2: Dispatch 发起 — 命令式 vs 协作式

**Anti-pattern** (score < 5):

```
DISPATCHING: issue-42
JOB_ID: aria-runner-20260527-001
ACTION: execute
```

**Good practice** (score ≥ 7):

```
正在将 Issue #42（数据库连接池泄漏，medium 级别）分配给开发容器处理。

预计完成时间：2-4 小时（参照同类 bug 的历史处理时长）。
Nomad job ID：aria-runner-20260527-001（可用于追踪日志）。

我会在 PR 草稿准备好后通知你进行 review。无需任何操作，我来跟进。
```

**Rationale**: Anti-pattern 仅传递机器状态（D4 完整性极低），缺乏对 owner 有意义的信息。Good practice 补充了**问题背景**（D4）、**时间预期**（D2 精确性，带历史对照）、**可查询的 job ID**（D6 技术准确性），并明确了"你不需要做什么"（D7 自主边界）。

---

### Pattern 3: 成本告警 — 数字堆砌 vs 可操作建议

**Anti-pattern** (score < 5):

```
WARNING: cost threshold reached
zhipu_30d_usd: 56.23
limit: 70.00
usage_pct: 80.33%
action: ALERT
```

**Good practice** (score ≥ 7):

```
本月 Zhipu 计量费用已达 ¥56.23（月度上限 ¥70.00 的 80.3%）。

当前 dispatch 速率（约 8 次/天）预计将在 3 天内触顶。

我已自动降低 dispatch 频率至 5 次/天（保守模式）以争取缓冲时间。

建议你在未来 24 小时内确认以下之一：
1. 维持保守模式，直到月末重置
2. 提高月度上限（在 .aria/config.json 修改 m6.cost_thresholds.zhipu_30d_usd）
3. 本月暂停新 dispatch（发送 "pause dispatch" 命令）

当前 cost.json 快照路径：aria-orchestrator/data/cost.json（freshness: 2 分钟前）
```

**Rationale**: Anti-pattern 是指标转储，D1/D3 接近 0，且 D7 完全错误——它将决策推回给人类但没给出任何决策素材（D4 极低）。Good practice 提供了**时间维度的预测**（D4）、**已自动采取的措施**（D7 自主边界，不需要人类批准降频）、**清晰的三个选项**（D2 精确性），以及**可验证的技术引用**（D6，cost.json 路径和 freshness）。

---

### Pattern 4: Merge 批准请求 — 通知式 vs 决策辅助式

**Anti-pattern** (score < 5):

```
PR #87 需要审批。
CI 状态: passing
请 review。
```

**Good practice** (score ≥ 7):

```
PR #87（修复 Issue #42：数据库连接池泄漏）已准备好 review。

**决策素材摘要**：
- CI：全部通过（38 测试，0 失败，覆盖率 +1.2%）
- Diff 规模：+42 / -18 行（集中在 `backend/src/db/pool.py`）
- 漂移分数：0.12（阈值 0.70；本次变更未引入 spec 漂移）
- 预估合并后影响：仅影响连接池，无 API 接口变更

你只需要查看 `backend/src/db/pool.py:88-112` 这段核心逻辑（约 2 分钟阅读量）。

[在 Forgejo 查看 PR #87](https://forgejo.10cg.pub/10CG/project/pulls/87)

点击上方链接 → Approve → Merge，或回复 "lgtm #87" 由我代为操作。
```

**Rationale**: Anti-pattern 的 D2（精确性）、D4（完整性）、D6（技术准确性）均接近 0——"请 review"是最低信息量的请求。Good practice 明确了**审批所需的最小工作量**（D5 简洁且 D4 完整），量化了**风险信号**（漂移分数，D6 技术准确），并提供了**操作路径**（Forgejo 链接 + 代理操作选项，D2 精确性）。D7 自主边界优秀——所有 AI 可自主准备的信息已准备好，只有 merge 这一不可逆动作需要人类执行（AD10 约束）。

---

### Pattern 5: 崩溃恢复通知 — 技术转储 vs 状态摘要

**Anti-pattern** (score < 5):

```
ERROR: Process aria-hermes killed
Signal: SIGKILL
PID: 14823
Time: 2026-05-27T03:14:15Z
State: S5_AWAIT
Alloc: a1b2c3d4
Recovery: INITIATED
```

**Good practice** (score ≥ 7):

```
Hermes 在凌晨 3:14 意外重启（原因：未知进程终止，非计划重启）。

**影响评估**：系统已自动从 SQLite 恢复了 2 个进行中的 dispatch（Issue #38、#41），
当前状态均为 S5_AWAIT（等待 Layer 2 容器响应）。未发现数据丢失。

**无需任何操作**。我将继续监控 Issue #38 和 #41 的进展。

如果同一进程在接下来 2 小时内再次意外终止，我会发送更紧急的通知并暂停新的 dispatch。

故障诊断日志：`aria-orchestrator/logs/recovery-20260527-031415.log`
```

**Rationale**: Anti-pattern 的 D1 接近 0（纯机器输出），D3 错误（技术崩溃场景需要冷静的状态告知，不是 error 堆栈转储），D4 完全缺失（owner 最关心的是"有没有数据丢失"和"需要我做什么"）。Good practice 首先回答了**对人类最重要的问题**（D4：数据丢失？需要操作？），然后描述了**已自动完成的恢复**（D7：无需委托），最后给出了**条件升级阈值**（D2 精确性：再发才报紧急）和**可查日志**（D6）。

---

### Pattern 6: Schema Migration 确认 — 风险罗列 vs 风险评估

**Anti-pattern** (score < 5):

```
准备执行 schema migration v4→v5。
风险：
- 可能数据丢失
- 可能破坏兼容性
- 可能导致服务中断
请确认是否继续 (yes/no)。
```

**Good practice** (score ≥ 7):

```
Schema migration v4→v5 准备就绪（仅 additive 变更：新增 `eval_score` 列，不删除现有列）。

**我的风险评估**：低风险。
- 变更类型：additive（新增列），不影响现有查询
- 影响范围：仅 `dispatches.db` 表 `dispatch_results`
- 回滚方式：`ALTER TABLE dispatch_results DROP COLUMN eval_score`（标准 SQLite 操作）
- 已完成：SQLite 自动备份至 `dispatches.db.bak.20260527`

**执行计划**：
1. dry-run 验证（无副作用，已完成，结果：OK）
2. 在下一次 dispatch 间隙（预计 14:30–14:45 UTC）执行 migration
3. 执行后运行 `PRAGMA integrity_check` 验证

无需停机。执行完成后我会发送确认消息。

如需延迟到今晚维护窗口再执行，回复 "delay migration"。
```

**Rationale**: Anti-pattern 的"风险罗列"是万能免责声明（D3 语调不当——这不是法律文件），且完全没有评估（D4 缺失）。Good practice 展示了 AI **已经完成的分析工作**（D7 高分：自主评估风险，只在真正需要人类知情时告知），明确了**为什么这是低风险**（D4 完整），提供了**可验证的技术细节**（D6：具体列名、备份路径），并给出了**不阻塞进度的退出路径**（D5 简洁）。

---

### Pattern 7: Spec 审计反馈 — 被动列举 vs 主动定位

**Anti-pattern** (score < 5):

```
审计结果：
- 发现问题 1
- 发现问题 2
- 发现问题 3
请修复上述问题。
```

**Good practice** (score ≥ 7):

```
Phase A.2 R1 审计完成（4 agent，combined sister-Spec 模式）。

**需要修复的问题（按优先级）**：

**Critical（必须修复，影响实现）**：
1. [T3-1] §What A.1 标题"8+1 diffs"与正文 9 个 diff 的列举数量不一致。
   定位：`proposal.md` 第 52 行。修复方式：将标题改为"9 diffs"。

2. [T3-2] Probe 1 的 `head -1` 提取逻辑在 README layout 变更后会静默抽取错误版本号。
   定位：`proposal.md §A.6 Probe 1 command` 字段。建议改用 `grep -m1 -oP` 锚定 badge token。

**Informational（建议修复，不阻塞 Phase B）**：
3. [I3-3] `date -d` 是 GNU-only 语法，在 macOS 上会失败。建议改为 `python3 datetime` 方案（跨平台）。

**已确认无需修复**：§B.4 location（Aria-specific，不进 standards/）与 PRD §568 当前文本一致——这是预期行为。

R2 challenge 将在上述 Critical 问题修复后进行。
```

**Rationale**: Anti-pattern 的 D2/D6 接近 0——"问题 1/2/3"没有任何定位信息。Good practice 提供了**问题 ID 和文件行号**（D2 精确性、D6 技术准确性），区分了**阻塞/非阻塞**（D4 完整性让接收方能优先处理），并包含了**已排除的疑似问题**（D7 自主边界：不把已核实无问题的事情委托给人类确认）。

---

### Pattern 8: PR 评论 — 措辞强硬 vs 建议性表达

**Anti-pattern** (score < 5):

```
这段代码是错的。connection pool 没有正确关闭。必须修复后才能合并。
```

**Good practice** (score ≥ 7):

```
`pool.py:95` 这里的连接在 `finally` 块执行前可能不会被释放——如果 `execute_query()` 在
第 92 行抛出 `OperationalError`，`conn.close()` 会被跳过。

建议用 context manager 模式：
```python
with pool.get_connection() as conn:
    return conn.execute_query(sql, params)
```
`ConnectionPool.__exit__` 已经处理了关闭逻辑（`pool.py:43`），这样改后不需要显式 close。

不确定你这里是否有我没看到的约束？如果有历史原因保留显式 close，加个注释说明一下就好。
```

**Rationale**: Anti-pattern 的 D1（自然度）和 D3（语调）均低——"这段代码是错的"是武断断言，在代码审查中会造成防御性反应。Good practice 首先**定位具体问题**（D2、D6：行号 + 触发条件），然后**给出可操作的修复方案**（D2：代码示例 + 引用现有实现），最后**留出空间**承认可能有未知约束（D3 语调匹配：建议而非命令，D7 自主边界适当）。

---

### Pattern 9: 测试失败诊断 — 原始日志转发 vs 根因摘要

**Anti-pattern** (score < 5):

```
测试失败，日志如下：
[2026-05-27 10:23:45] ERROR test_dispatch_cycle.py:234
[2026-05-27 10:23:45] AssertionError: 47 != 48
[2026-05-27 10:23:45] ...（200 行日志）
```

**Good practice** (score ≥ 7):

```
`test_dispatch_cycle.py:234` 失败，**根因**：`count(state=S9_CLOSE)` 返回 47，期望 48。

**诊断**：Issue #38 的 dispatch 在 S8_MERGED 状态卡住了（SQLite 查询确认：
`SELECT issue_id, state FROM dispatches WHERE state != 'S9_CLOSE'` → Issue #38）。
S8→S9 的状态转移需要 `merge_confirmed_at` 字段不为 NULL，但 `merge_confirmed_at` 在
fixture 中没有被设置（`conftest.py:78` 的 `create_dispatch_fixture()` 缺少该字段）。

**修复建议**：在 `conftest.py:78` 的 fixture 中添加 `merge_confirmed_at=datetime.now()`，
或在测试中显式触发 S8→S9 转移（调用 `state_machine.advance_to_close(issue_id=38)`）。

原始日志：`.aria/logs/test-20260527-102345.log`（如需完整 traceback）
```

**Rationale**: Anti-pattern 的 D1（自然度）和 D5（简洁性）均低——将 200 行日志直接转发给人类，要求人类完成本可由 AI 自动完成的诊断工作（D7 自主边界差）。Good practice 先给出**根因结论**（D4 完整性：告知最重要的信息），然后展示**诊断路径**（D2 精确性：具体查询和文件引用），给出**可操作的修复建议**（D2），并提供**原始日志的访问路径**（D6）供深度调查。

---

### Pattern 10: 代码审查礼貌性模式 — 缺失上下文 vs 充分铺垫

**Anti-pattern** (score < 5):

```
麻烦看一下这个 PR，有问题。
```

**Good practice** (score ≥ 7):

```
PR #91 是 Issue #45 的修复（`ConnectionPool` 泄漏，medium 优先级）。

这是我第一次接触这个模块——我注意到 `pool.py` 里有两种不同的连接关闭模式（显式 `close()` 
vs context manager），我选择了 context manager 方案（`pool.py:88-112`），因为
`ConnectionPool.__exit__` 已经有完整的清理逻辑。

有一处我不确定的地方：`pool.py:95` 的 `max_retries` 参数，文档里没有找到这个参数的
定义，我暂时用了默认值 3。如果有约束，请在 review 时指出，我会立即更新。

非紧急，按你的节奏 review 即可。
```

**Rationale**: Anti-pattern 的 D1-D4 均低，且 D3（语调）不当——"有问题"对 reviewer 没有任何指引价值。Good practice 建立了**问题背景**（D4：issue 编号和优先级），解释了**设计决策**（D2：为什么选 context manager，D6：引用了 `ConnectionPool.__exit__`），**主动标记了不确定点**（D4 完整性，让 reviewer 知道需要重点关注哪里），并用**恰当的语调**（D3）表达了优先级不紧急。

---

### Pattern 11: 人工门控请求 — 过度委托 vs 范围界定清晰

**Anti-pattern** (score < 5):

```
需要你来决定是否继续。
当前 dispatch 状态：5 个 active。
待处理 issue：12 个。
请告知如何处理。
```

**Good practice** (score ≥ 7):

```
当前有 12 个待处理 issue，其中 5 个 dispatch 正在进行中。

**我的建议**：不需要任何操作。当前速率（约 6 次/天）在预算范围内，
active dispatch 数量在正常区间（最大并发 8）。

**需要你决定的只有一件事**：Issue #47（涉及 `auth/` 模块重构，high 优先级）
是否纳入本月的 dispatch 计划？这个 issue 涉及认证逻辑，我判断在没有你明确确认的情况下
不应自动分配。

回复 "yes #47" 或 "skip #47" 即可，我来处理后续。
```

**Rationale**: Anti-pattern 的 D7（自主边界）接近 0——将完全可以自主处理的状态信息（5 个 active dispatch，12 个待处理）全部丢给人类决策，是典型的过度委托。Good practice 主动告知**不需要人类做任何操作的情况**（D7 高分：AI 自主处理常规情况），然后**精确定位需要人类判断的那一件事**（D2 精确性：Issue #47 的具体原因），并提供了**最小操作路径**（D5 简洁性）。

---

### Pattern 12: 成本评审 — 被动响应 vs 预测性告知

**Anti-pattern** (score < 5):

```
本月成本报告：
Zhipu: $42.10
Luxeno: $29.00
总计: $71.10
已超出预算。
```

**Good practice** (score ≥ 7):

```
本月成本快照（2026-05-27，月末还有 4 天）：
- Zhipu 计量：$42.10 / $70.00（60.1%，按当前速率预计月末 $52.40）
- Luxeno 订阅：$29.00（固定费，已含 dispatch volume floor ≥10/day 验证通过）

**本月状态**：Zhipu 在预算范围内，无需操作。

**预警（下月）**：如果 dispatch 量维持当前增长趋势（+15%/月），下月 Zhipu 预计
$60.26——仍在上限内但值得关注。如果你计划在 M6 发布后增加 dispatch 密度，
建议在 `.aria/config.json` 中提前调整 `m6.cost_thresholds.zhipu_30d_usd`。

cost.json freshness：3 分钟前（路径：`aria-orchestrator/data/cost.json`）
```

**Rationale**: Anti-pattern 的 D4（完整性）和 D7（自主边界）均差——"已超出预算"是事后告知，且没有指向性建议（D2 精确性低）。Good practice 提供了**前瞻性预测**（D4 完整性：月末预测值 + 下月趋势）、**清晰的当前状态判断**（D3：本月无需操作）、**有数据依据的预警**（D2 精确性：具体百分比 + 变更建议的具体文件路径），并标注了**数据新鲜度**（D6 技术准确性：cost.json freshness）。

---

## BOTH-Locations Design Note

This file contains Lab-shareable curated patterns. The M6 E2E run corpus samples (raw data with per-sample scoring) are in `aria-orchestrator/evals/m6-prompt-quality/corpus/sample-{01..10}.md` (Spec #2 TG-C). These two locations serve different purposes and do not duplicate content.

| 位置 | 内容 | 目的 |
|------|------|------|
| `standards/autonomous/humanized-command-patterns.md`（本文件） | 精炼的 Anti-pattern vs Good practice 对比，7 维评分框架说明 | Lab 通用指导，帮助任何项目提升 AI 命令质量 |
| `aria-orchestrator/evals/m6-prompt-quality/corpus/sample-{01..10}.md` | M6 E2E 实际运行产生的原始命令样本，附逐维度评分 | Spec #2 TG-C 验收交付物，M6 实证数据 |

两个位置的内容不重叠：standards/ 文件不包含原始语料，aria-orchestrator/evals/ 文件不包含通用模式指导。

---

## Cross-references

See also: `aria-orchestrator/evals/m6-prompt-quality/` for M6 E2E corpus samples and scores (Spec #2 TG-C deliverable).

See `standards/autonomous/decision-autonomy-matrix.md` for the decision types that trigger each category of humanized command (Triage / Dispatch / Merge approval / Cost threshold alarm / Crash recovery correspond to Pattern 1/2/4/3/5 respectively).

See `aria-orchestrator/docs/layer-boundary-contract.md` for the Layer 1 / Layer 2 command format contract (how Layer 1 issues YAML commands to Layer 2, and how Layer 2 structures responses).
