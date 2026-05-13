# Issue Triage SOP

> **Convention ID**: `issue-triage`
> **Version**: 1.0.0
> **Status**: Active
> **Scope**: How the Aria team (and any project using Aria methodology) triages issues filed via any channel — before recommending a fix or starting a new development cycle.
> **Source incident**: [Forgejo Aria #101](https://forgejo.10cg.pub/10CG/Aria/issues/101) (2026-05-13)
> **Canonical case study**: [issuecomment-5972](https://forgejo.10cg.pub/10CG/Aria/issues/101#issuecomment-5972)

---

## 1. Why This Convention Exists

### The anti-pattern

收到 issue 后，**直接进推荐解决方案**是反模式。常见后果：

- 报告版本已过期，issue 在新版本已修 → 起了一个不必要的 cycle
- 引用的 file:line 已重构，基于错误的代码路径设计方案
- 已有 in-flight branch / PR 修复同一问题，新开 cycle = 重复劳动
- 复现与 issue 描述不一致，基于错误的 bug 描述设计错误的修复

### Forgejo Aria #101 触发

2026-05-13 手工处理 [Forgejo Aria #101](https://forgejo.10cg.pub/10CG/Aria/issues/101) 时识别到 triage 流程缺位。该 issue 报告 state-scanner `_normalize_status` 子串匹配产生假阳性。完整手工 triage 过程见 [issuecomment-5972](https://forgejo.10cg.pub/10CG/Aria/issues/101#issuecomment-5972)。

关键发现：issue 自报 4/4 命中率，实测 2/4 命中主 bug + 2/4 命中次生 bug（与描述实质偏离），导致 `partial-repro` verdict 的诞生。如无系统化 triage，可能基于"4/4 全命中"的错误假设设计修复方案。

### Convention 的价值

把"先核对再推荐"沉淀为**可执行的标准流程**，具体价值：

- 每个 issue 留 audit trail（verdict comment），可回溯
- 新人 / cross-project 也能正确执行 triage，不依赖当事人记忆
- 机械步骤 (Steps 1-5) 约 70% 可自动化（见 `§Tooling`）
- `partial-repro` verdict 强制结构化记录偏差，防止基于错误假设起 cycle

---

## 2. Trigger Scenarios (何时执行 triage)

任一条件满足即应执行完整 triage：

- 收到 bug report（任何渠道）
- 收到 feature request，需要核实当前状态
- 收到 question，需要核实代码/版本现状
- 在起新 OpenSpec / 新 branch 之前（Rule #1 要求）
- issue 长期未处理，重新拾起时需重新核对

**可跳过部分步骤的例外**: 见 `§Exception Template`（typo/docs-only 修复等简单 issue）。

---

## 3. The 6-Step SOP

> **这是 SOT**: 以下步骤定义是整个 Aria 项目中 issue triage 步骤的唯一权威来源。`aria/skills/issue-triage/SKILL.md` 引用本节，不复制。

---

### Step 1: Read Issue

**Purpose**: 获取 issue 的完整上下文，避免基于标题或片段做假设。

**What to check**:
- Issue title、body、labels、所有 comments（含后续讨论，可能有重要补充）
- 报告者的版本声明（通常在 body 中，格式见 Step 2）
- Issue 中引用的文件路径 / 行号（用于 Step 3）
- 是否有 "duplicate of #N" 或 "fixed in X" 类型的既有 comment

**Output fields** (triage-report.json):
```json
{
  "step1_issue": {
    "collection_status": "ok | error | skipped",
    "title": "...",
    "body": "...",
    "labels": [],
    "comments": [],
    "state": "open | closed"
  }
}
```

**Failure modes**:
- Forgejo API 401/403 → `collection_status: error`；整体 triage 不可继续（需凭证）
- Issue 不存在 (404) → `collection_status: error`；检查仓库名和 issue 编号

**Exit condition**: `collection_status: ok` 方可继续；`error` 时整体 `steps_with_data` 无法达到 ≥2 → exit 30。

---

### Step 2: Version Check

**Purpose**: 核实 issue 报告的版本与当前版本的差距，判断是否已修复 / 是否为 outdated report。

**What to check** (fail-soft chain — 按序尝试，首个命中即用):

| 优先级 | 路径 | 适用项目 |
|--------|------|---------|
| 1 | `{project_root}/aria/.claude-plugin/plugin.json` | Aria meta-repo |
| 2 | `{project_root}/.claude-plugin/plugin.json` | Aria plugin 独立仓库 |
| 3 | `{project_root}/VERSION` | SilkNode + 通用 |
| 4 | `{project_root}/package.json` | JS 项目 |
| 5 | `{project_root}/pyproject.toml` | Python 项目 |

全失败 → `version.current: "unknown"`，`version.gap: null`（不阻断 triage，继续后续步骤）。

Issue body 中报告版本抽取：regex `version:\s*(\S+)` / `Plugin:\s*(\S+)` / `v(\d+\.\d+\.\d+)`。

**Output fields**:
```json
{
  "step2_version": {
    "collection_status": "ok | error | skipped",
    "reported": "1.18.0",
    "current": "1.19.0",
    "gap": "+1 minor"
  }
}
```

**Failure modes**:
- 所有路径不存在 → `current: "unknown"`，`gap: null`（soft，不阻断）
- Issue body 无版本声明 → `reported: "unknown"`

**Exit condition**: Soft step，`collection_status: error` 不阻断后续步骤。

---

### Step 3: Code Path Verification

**Purpose**: 验证 issue 中引用的文件路径是否存在，以及引用的代码片段是否与描述一致，防止基于已重构代码设计修复。

**What to check**:

支持 3 种 citation format：

| Format | 示例 |
|--------|------|
| Backtick inline | `` `aria/skills/state-scanner/scripts/scan.py:42` `` |
| Prose | `aria/skills/state-scanner/scripts/scan.py line 42` / `scan.py L42` |
| Markdown link | `[scan.py](https://forgejo.../blob/master/path/scan.py#L42)` |

对每个 cited path：
1. 验证文件是否存在
2. 若有行号，读取该行及上下文（±5 行），确认代码与 issue 描述是否对应
3. `matches_description: true/false`

**Output fields**:
```json
{
  "step3_code": {
    "collection_status": "ok | error | skipped",
    "cited_paths": [
      {"path": "...", "exists": true, "line": 42, "context_snippet": "..."}
    ],
    "matches_description": true
  }
}
```

**Failure modes**:
- 文件不存在 → `exists: false`，`matches_description: false`（重要信号：issue 可能基于过期代码）
- Issue body 无 file 引用 → `cited_paths: []`（空 array，非 null；继续后续步骤）
- Line 号超出文件范围 → flag warning，`context_snippet: "line out of range"`

---

### Step 4: Git Log on Cited Files

**Purpose**: 检查 cited files 的近期提交历史，看是否已有 commit 修复了该 bug（even if not yet in a release）。

**What to check**:

```bash
git log -n 20 --oneline -- <cited_file>
```

对每个提交，关键词匹配（任一命中 = `match_reason`）：
- `fix`, `resolve`, `close #<issue>`, `closes #<issue>`, normalize`, `bugfix`
- Issue title 中的核心关键词

**Output fields**:
```json
{
  "step4_history": {
    "collection_status": "ok | error | skipped",
    "likely_fix_candidates": [
      {
        "sha": "abc1234",
        "message": "fix: resolve normalize false positive",
        "match_reason": "keyword:fix + keyword:normalize"
      }
    ]
  }
}
```

`likely_fix_candidates: []`（空 array）= 无命中。布尔值在读取时从 array 是否为空派生，schema 不存储单独 boolean。

**Failure modes**:
- git repo 不可用 → `collection_status: error`（exit 10）
- 无 cited files → `likely_fix_candidates: []`（空 array，不阻断）

---

### Step 5: In-flight Check

**Purpose**: 检查是否已有处理此 issue 的 in-flight work（remote PR / local branch / worktree），防止起重复 cycle。

**What to check** (三段独立，各段独立 `collection_status`):

**5a — Remote PRs**:
```
forgejo GET /repos/<owner>/<repo>/pulls?state=open
```
对每个 PR，keyword 匹配：issue 编号、cited file 名、title 关键词（normalize 等）

**5b — Local branches**:
```bash
git branch -a --list "*<keyword>*"
```
keyword 从 issue title 抽取（主名词/动词）

**5c — Worktrees**:
```bash
git worktree list --porcelain
```
解析每个 worktree 的 `branch` + `path`，过滤含关键词的

**Output fields**:
```json
{
  "step5_inflight": {
    "collection_status": "ok | error | skipped",
    "remote_prs": [{"number": 98, "title": "...", "state": "open"}],
    "local_branches": ["feature/issue-101-normalize-fix"],
    "worktrees": [{"path": "/home/dev/Aria-fix", "branch": "issue-101"}]
  }
}
```

**Failure modes**:
- Forgejo API 失败 → `remote_prs: []`，`collection_status: error`（不阻断,soft-error 进 top-level `errors[]`)
- 非 git repo → 5b/5c `collection_status: error`（exit 10）

**Rule #7 合规**: 所有 `forgejo` CLI 调用必须 `subprocess.run(..., capture_output=True)`，不得打印 stdout/stderr。见 `standards/conventions/secret-hygiene.md §3.1`。

---

### Step 6: Reproduction

**Purpose**: 实际尝试复现 issue 描述的 bug 或验证 feature request 的缺失，在 verdict 前取得第一手证据。

**Three exit modes**:

| exit_mode | 触发条件 | Verdict 路径 |
|-----------|---------|------------|
| `auto` | AI 可独立完成复现 (有足够 env/data) | 完成所有 `cases[]`，进 verdict 计算 |
| `pause` | 需要用户提供 env / 认证 / 交互操作 | Skill 暂停，等待用户补充后 resume |
| `skip` | 无法复现（缺资源 / 环境 / 凭证，且无法 pause 等待） | verdict **强制** = `needs-info` |

**每个 case 的结构化 schema** (无论 verdict 如何，`cases[]` 不得为空):

```json
{
  "case_id": "string",
  "input": "描述触发条件/输入",
  "expected_behavior": "issue 描述的预期行为",
  "actual_behavior": "实际观察到的行为",
  "match": true | false | null,
  "notes": "补充说明，超时 / 环境限制 / 偏差说明"
}
```

`match: null` = 未能执行（超时、环境缺失等）。

**hit_rate 双格式**（schema 两字段并存）:
```json
{
  "repro": {
    "exit_mode": "auto",
    "hit_count": 2,
    "total_count": 4,
    "hit_rate": "2/4",
    "cases": [...]
  }
}
```

**Failure modes**:
- 复现命令超时 → `match: null`，`notes: "timeout after Ns"`
- 环境/凭证缺失 → exit_mode 改为 `pause` 或 `skip`
- issue 描述模糊，无法构造 `input` → `notes` 记录，建议 `needs-info`

---

## 4. Verdict Dictionary (SOT)

> 以下 7 个 verdict 值是整个 Aria 项目的权威定义。任何工具、文档、comment 中使用的 verdict 必须来自此表。

| Verdict | 定义 | 典型场景 |
|---------|------|---------|
| `confirmed` | 复现成功，bug 真实，症状与 issue 描述**一致** | Step 6 `hit_rate: N/N`，描述与实际完全匹配 |
| `partial-repro` | 复现显示真实 defect，但症状 / hit-rate 与 issue 描述**实质偏离**；**必须携带 `deviation_note` 字段** | #101 案例：自报 4/4，实测 2/4 主因 + 2/4 次生 bug，后者 issue 未描述 |
| `not-reproducible` | 跑不出报告的症状 | Step 6 所有 case `match: false` |
| `fixed-in-X` | 在 commit SHA `X` 或版本 `X` 已修（Step 4 命中） | `likely_fix_candidates` 非空 + 版本 gap 确认 |
| `duplicate-of-#N` | 另一 issue `#N` 已完整覆盖此 issue | Step 1 comments 或手工核查 |
| `needs-info` | 报告信息不足，无法完成 triage / Step 6 exit_mode=skip | issue body 缺少复现步骤 / 凭证缺失 |
| `wont-fix` | 确认是 by-design / out-of-scope | 架构决策、scope 边界 |

**`partial-repro` deviation_note 要求**（R1 QA-C1）:
- `deviation_note` 是 `partial-repro` verdict 的**必填字段**
- 内容：实际复现与 issue 描述的具体偏差（hit-rate 差异、症状描述偏差、次生 bug 未被描述等）
- 格式：自然语言，1-3 句，包含量化数据（如 "自报 4/4，实测 2/4"）

---

## 5. Orthogonal Fields

Verdict 外的正交字段，用于优先级决策（与 verdict 解耦，防止混用）：

### severity

| Value | 定义 | 参考指标 |
|-------|------|---------|
| `critical` | 数据损坏 / 核心功能完全不可用 / 安全漏洞 | 影响所有用户，无 workaround |
| `major` | 主要功能受损 / 用户需要 workaround | 影响 >50% 用户，有 workaround |
| `minor` | 边缘功能受影响 / 偶发 | 影响少数用户，不影响核心流程 |
| `trivial` | UI 瑕疵 / typo / 文档 | 无功能影响 |

`severity` 由 AI 在 Step 6 后基于以下因素判断（不机械化）：
- commit blast radius（涉及多少核心路径）
- `hit_rate`（N/M 触发比例）
- data corruption 风险
- 是否有 workaround

### recommended_action

| Value | 适用场景 |
|-------|---------|
| `hotfix` | `severity: critical`，需立即修复 |
| `next-cycle` | `severity: major`，计划下一迭代处理 |
| `backlog` | `severity: minor / trivial`，低优先级 |
| `close` | verdict=`fixed-in-X` / `duplicate-of-#N` / `wont-fix` / `needs-info`（等待补充后重开） |

`recommended_action` 可由 AI 根据 `verdict + severity` 推断，但最终由人类确认。

---

## 6. Case Study: Forgejo Aria #101

> **Issue**: [Forgejo Aria #101](https://forgejo.10cg.pub/10CG/Aria/issues/101) — state-scanner `_normalize_status` 子串匹配 `done` 假阳性
> **Canonical triage**: [issuecomment-5972](https://forgejo.10cg.pub/10CG/Aria/issues/101#issuecomment-5972)
> **Date**: 2026-05-13

### Triage 过程摘要

**Step 1**: Issue 描述 `_normalize_status` 用 `in <str>` 子串匹配，`"done"` 会命中 `"abandoned"` / `"undone"` 等含 `done` 子串的状态，导致假阳性。报告者列举了 4 个复现 case。

**Step 2**: 版本核查 → current=plugin v1.19.0，reported=v1.19.0，gap=0。不是 outdated report。

**Step 3**: cited path `aria/skills/state-scanner/scripts/scan.py` 存在，`_normalize_status` 函数可定位。代码与描述一致（substring match pattern 确认存在）。

**Step 4**: `git log -n 20 -- scan.py` → `likely_fix_candidates: []`（近期无相关修复提交）。

**Step 5**: in-flight 检查 → `remote_prs: []`，`local_branches: []`，`worktrees: []`。无重复工作。

**Step 6 (复现)**:

| case_id | input | expected | actual | match |
|---------|-------|----------|--------|-------|
| C1 | state="abandoned" | not normalized to "done" | normalized to "done" (substring hit) | false (bug confirmed) |
| C2 | state="undone-pending" | not normalized to "done" | normalized to "done" | false (bug confirmed) |
| C3 | state="done-reviewing" | not normalized to "done" | normalized to "done" | false (bug confirmed — but not described in issue!) |
| C4 | state="complete" | not normalized to "done" | not normalized to "done" | true (no bug here) |

**关键发现**: Issue 报告 4/4 全命中，实测结果：
- C1/C2: 与 issue 描述完全一致 (2/4 主因 bug)
- C3: 真实 defect，但 issue **未描述** `done-reviewing` case（次生 bug）
- C4: 不复现（issue 描述中 C4 case 是错误的）

hit_rate: `2/4`（与 issue 自报 `4/4` 实质偏离）→ **`partial-repro`** verdict 诞生

**deviation_note**: "Issue 自报 4/4 全命中，实测 2/4 命中主 bug (abandoned/undone substring)，1/4 命中次生 bug (done-reviewing，issue 未描述)，1/4 不复现 (complete case)。实际 hit-rate 与描述有实质偏差，建议修复时同时覆盖 done-reviewing case。"

**Final verdict**: `partial-repro` | **severity**: `minor` | **recommended_action**: `next-cycle`

### 此案例带来的规范变化

- 新增 `partial-repro` verdict（此前字典无此值）
- 强制 `partial-repro` 携带 `deviation_note`（防止基于错误假设设计修复）
- 将手工 triage 流程系统化为本 SOP

---

## 7. Exception Template

某些简单 issue 允许跳过部分步骤，但必须使用以下模板在 triage comment 中声明：

```markdown
## Triage Note (Abbreviated)

**Verdict**: {verdict}

**Exception justification**:
- Skipped steps: {step numbers, e.g., "Step 2, Step 5"}
- Reason: {e.g., "Docs-only typo fix, no code path or version dependency"}
- Approved by: {triage-person} on {date}
```

**允许跳步的条件**（所有条件必须同时满足）：

| 条件 | 说明 |
|------|------|
| 无代码变更 | Issue 仅涉及文档 / typo / 注释 |
| 无版本依赖 | 问题与版本无关（格式错误、错别字等） |
| 无 in-flight 风险 | 明显无重复劳动风险 |
| 低复现成本 | 问题描述自明，1 步即可验证 |

**不允许跳步**：
- 任何涉及运行时行为 / 代码逻辑 / API 行为的 bug report
- `severity: critical` 或 `major` 的 issue（必须完整 triage）
- `partial-repro` 路径（deviation_note 必填，不可跳）

---

## 8. Tooling

本 SOP 的自动化实现：

- **`/issue-triage` Skill** — `aria/skills/issue-triage/SKILL.md`
  - Steps 1-5：`scripts/triage.py` 机械执行，产出 `triage-report.json`
  - Step 6：AI 辅助复现（三模式 exit）
  - 综合输出：`triage-comment.md` 草稿

手工执行 SOP（无 Skill 时）：按本文 §Steps 逐步执行，最终在 issue 下 POST comment，内容覆盖 `triage-comment.md` 模板中的所有节。

---

## 9. Source Incident

| 日期 | Issue | 触发 | 影响 | 规范产出 |
|------|-------|------|------|---------|
| 2026-05-13 | [Forgejo Aria #101](https://forgejo.10cg.pub/10CG/Aria/issues/101) | 手工 triage 发现流程缺位；hit-rate 偏差揭示 verdict 字典不完整 | 无直接功能影响；潜在：基于错误假设起错误的修复 cycle | 本 SOP 创建；`partial-repro` verdict 新增；issue-triage Skill 立项 |

---

## 10. Related Rules

| 规则 | 关系 |
|------|------|
| **Rule #1** (OpenSpec for changes) | triage verdict=`confirmed` / `partial-repro` 且 `recommended_action: hotfix/next-cycle` 时，起修复 cycle 必须有 OpenSpec。本 SOP 是 Rule #1 的前置步骤。 |
| **Rule #6** (skill-creator benchmark) | `/issue-triage` Skill 发版前必须通过 skill-creator AB benchmark（见 tasks.md T8）。benchmark 结果存入 `aria-plugin-benchmarks/ab-results/`。 |
| **Rule #7** (secret-hygiene) | Step 5 中所有 `forgejo` CLI 调用必须 `subprocess.run(..., capture_output=True)`，不得打印 token 相关 stdout/stderr。详见 `standards/conventions/secret-hygiene.md`. |
| **Rule #8** (pre-merge gate) | 本 SOP 变更（及 Skill 实现）合并前必须通过 phase-c-integrator C.2.4 pre-merge gate。 |

---

## 11. Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-05-13 | 初版。6 步 SOP 定义；7 verdict（含新增 `partial-repro`）；orthogonal fields（severity / recommended_action）；#101 case study；exception template；tooling 指向 issue-triage Skill。来源：Forgejo Issue #101 + issuecomment-5972 手工 triage 经验。 |
