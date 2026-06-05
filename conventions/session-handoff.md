# Session Handoff 规范

> **Version**: 1.1.0 (additive: §2.3 机读 frontmatter schema, multi-terminal-coordination v1.21.x+)
> **Status**: Active
> **Source incidents**: 见 §5 (4 dogfood, SilkNode 1 + Aria self 3) + §2.3 (1 跨容器 race incident 2026-05-19)
> **Forgejo Issue**: [10CG/Aria#92](https://forgejo.10cg.pub/10CG/Aria/issues/92) (triage [#6170](https://forgejo.10cg.pub/10CG/Aria/issues/92#issuecomment-6170))
> **Origin Spec**: `openspec/archive/2026-05-15-aria-ten-step-session-handoff-stage/` (archived 2026-05-15)
> **Extension Spec**: `openspec/changes/multi-terminal-coordination/` (Approved 2026-05-19, per [DEC-20260519-001](../../docs/decisions/DEC-20260519-001-multi-terminal-coordination.md))
> **Target release**: aria-plugin v1.21.0+ (Rule #9 core) / v1.22.x+ (§2.3 frontmatter schema)

---

## 1. 核心条款

> **Session handoff documents MUST be written to `docs/handoff/` (canonical).
> `.aria/handoff/` is forbidden.**

### 1.1 Why this split

| Namespace | 语义 | 内容举例 | gitignore? |
|-----------|------|----------|-----------|
| `.aria/` | 机器状态 (machine state) | `workflow-state.json`, `audit-reports/`, `cache/`, `state-snapshot.json` | 大部分 ignore |
| `docs/` | 人类/AI 可读 prose | `requirements/`, `architecture/`, `handoff/`, decision memos | tracked |

Handoff doc 是**人写给下次 session 读的散文叙述** (9 段 narrative, §0-§8), 不是机器状态。语义上属于 `docs/handoff/`。

### 1.2 Forbidden patterns

- ❌ Write/Edit/NotebookEdit 到 `.aria/handoff/*.md` (由 L1 hook `handoff-location-guard.sh` 阻断)
- ❌ 在 `.aria/handoff/` 与 `docs/handoff/` 之间分散写入 (drift)
- ❌ 自定义其他 handoff dir (例如 `notes/`, `sessions/`, `journals/`) — 与跨项目复用 9 段模板的目标冲突
- ❌ 跳过 `docs/handoff/latest.md` pointer 更新 (导致 stale pointer)

---

## 2. Template structure (9-section skeleton)

完整 template: `aria/templates/session-handoff.md` (aria-plugin v1.21.0+)

| § | 内容 | 必含? |
|---|------|------|
| §0 | 入口 (强调下次 session 用 state-scanner 进入) | ✅ |
| §1 | 已完成 (按时间顺序, 含 commit hash + PR/issue 链接) | ✅ |
| §2 | 未完成 / Carry-forward 清单 (H1/H2/H3 高优 + M1/M2 中优 + low cleanup) | ✅ |
| §3 | 关键风险 / 已知陷阱 | ✅ |
| §4 | 实战教训 (memory 沉淀来源) | ✅ |
| §5 | 多维度同步状态 (UPM/Story/OpenSpec/PRD/Standards/Skill/Memory/Decision/Audit/CHANGELOG) | ✅ |
| §6 | Next session 入口 + 优先级建议 | ✅ |
| §7 | 提交清单 (commit hash + multi-remote parity) | ✅ |
| §8 | **Memory entries this session** (auto-memory 新增列表) | ✅ |

### 2.1 触发条件 (任一满足即由 phase-d-closer D.3 prompt)

按 fallback 优先级 (机械信号 → 启发式 → user prompt):

1. **L1 (primary)**: `.aria/workflow-state.json::session.started_at` 显示 `now - started_at > 4h`
2. **L2 (cycles shipped)**: `git log` since last `docs/handoff/*.md` mtime 含 ≥ 2 个 `openspec/archive/{date}-*/` 新增
3. **L3 (phase count)**: 同时间窗内 commit subjects 含 ≥ 2 个 distinct `Phase {A,B,C,D}` markers
4. **L4 (user prompt)**: 上述信号缺失时 prompt user, default `yes` if D.2 archive 已成功 (一般意味 session 完整闭环 ≥ 1 cycle)

### 2.2 Output path (硬编码)

```
docs/handoff/{YYYY-MM-DD}-{slug}.md
```

同日重名:

```
docs/handoff/{YYYY-MM-DD}-{HHMM}-{slug}.md
```

写入后**自动**更新 `docs/handoff/latest.md` pointer(单 track 场景)或 deprecation banner(多 track 场景,见 §2.3 latest.md 派生行为)。文件名遵循项目 [naming-conventions](./naming-conventions.md) 规范 (kebab-case + ISO 日期前缀)。

### 2.2.1 按需收尾 + context 压力触发 (session-closeout-internalization, aria-plugin v1.40.0+)

§2.1 的 4-level fallback 由 phase-d-closer D.3 在**走完十步循环**(D.2 archive)后触发。**按需收尾**补充一条独立路径:任意对话(含未 ship 完 Spec 的探索/调试 session)可由 `session-closeout` skill 随时触发,委托 phase-d-closer 的 `closeout_only=true` 引擎(跳过 D.1/D.2,只跑 D.3 handoff-write)。

**机械化采集**(从手填 prose → 自动回填,根除遗漏):
- §7 ← `snapshot.sync_status[.multi_remote]`(ahead/parity,不同步告警)
- §2 ← `upm.followups[]` + `openspec.carry_forward_inventory` + active `tasks.md` 原始 `- [ ]` + `.claude/subagent-state`("对话上下文" best-effort,不计入机械验证)
- §5 四维一致性 advisory 校验(UPM↔archive / active↔UPM / 高优 US↔§2 / PRD broken ref)
- §8 枚举本 session 新 memory(mtime > started_at)

**context 压力 advisory 触发**:phase-b-developer / phase-c-integrator 在 context-monitor 消费点调 `closeout_trigger`,占用 ≥ 阈值(默认 85%)**且**有未交接成果时 **advise** 现在收尾 —— 赶在 compaction 静默丢早期轮次、handoff 失真之前。**advisory-only,永不自动执行**(承 aria-context-monitor "只给数据不中断" DEC #104);口径不混用(relay→`used_percentage` / transcript→`used_percentage_proxy`)。

幂等写入:仅写未替换 placeholder 段,owner 已手填则跳过。并发安全:多终端并发 closeout 遵 [concurrent-session-write-safety](./concurrent-session-write-safety.md) slug 唯一性。

---

## 2.3 机读 frontmatter schema (multi-terminal-coordination v1.21.x+)

> **Added**: 2026-05-19 by OpenSpec `multi-terminal-coordination` Phase 1.1 (per [DEC-20260519-001](../../docs/decisions/DEC-20260519-001-multi-terminal-coordination.md)).
> **Purpose**: 让 `state-scanner` Phase 1 跨分支 fetch + 重建多 track 看板 (Layer H — 防接错棒),
> 消除单写者 `docs/handoff/latest.md` pointer 的 branch-local siloing 问题。
> **Status**: additive (本 v1.1.0 minor bump,不破坏 v1.0.0 既有 prose 段)。

每个新写出的 session-handoff doc **必须**在文件最顶部加一段 YAML frontmatter,
在现有 prose §0-§8 之上叠加 (不替换 prose)。

### 2.3.1 Schema 字段

| 字段 | 类型 | 必含 | 语义 | 取值范围 / 示例 |
|------|------|------|------|----------------|
| `track-id` | string | ✅ | 确定性派生的工作 ID,与该 handoff 所属的 OpenSpec change / carry-forward 条目 1:1 绑定 | **规范化**: 小写化 → `/._` 替换为 `-` → 最大长度 64 字符 → 超长或含非 ASCII 时 fallback `sha256(原 id)[:16]`。跨容器实现**必须共用**此函数。示例: `multi-terminal-coordination` / `aria-2-0-m5-carryover-layer2-redo-mode-aux` |
| `owner-container` | string | ✅ | `<owner>/<container-id>` 复合标识,显示该 handoff 由谁在哪个容器写出 | `<owner>` = git `user.email` 的 local-part (`@` 之前部分);`<container-id>` = `~/.aria/container-id` 持久 short-UUID + 可选人类标签,缺省回退 hostname。示例: `creationhikari/devbox-A` / `simonfishgit/laptop` |
| `phase` | string | ✅ | 该 handoff 写出时该 track 所处的十步循环阶段 | enum: `A` / `A.1` / `A.2` / `A.3` / `B` / `B.1` / `B.2` / `B.3` / `C` / `C.1` / `C.2` / `D` / `D.1` / `D.2` / `D.3`。允许子阶段 progress 形式如 `B 7/9` |
| `status` | string | ✅ | 该 handoff 写出时该 track 的工作状态 | enum: `active` (在飞,有 carry-forward) / `done` (全 cycle 完成,归档) / `abandoned` (放弃,carry-forward 转他人或废弃) |
| `updated-at` | string | ✅ | 该 handoff 写出 / 最近修订的 UTC ISO 8601 时间戳 (秒精度) | 示例: `2026-05-19T22:31:13Z` |

### 2.3.2 YAML 示例

```yaml
---
track-id: multi-terminal-coordination
owner-container: creationhikari/devbox-A
phase: A.2
status: active
updated-at: 2026-05-19T22:31:13Z
---

# Aria — Session Handoff (2026-05-19) — multi-terminal-coordination Phase A complete

> **Status**: Active — Ready for next session
...

## §0 入口 (新 session 优先读)
...
```

frontmatter 必须紧贴文件顶部 (第 1 行 `---` 开始),与现有 §0 入口 / 主标题之间用一个空行隔开。

### 2.3.3 与 prose 段共存规则

| 角色 | 内容 | 受众 | 权威性 |
|------|------|------|--------|
| **Frontmatter (本 §2.3)** | 5 字段机读 metadata | 机器 (AI / collector / state-scanner) | 机读 SOT |
| **Prose §0-§8 (§2)** | 散文 narrative,跨 session 知识传递 | 人类 + AI | 人读 SOT |

两者**不重复、不冲突**:
- frontmatter 给"是什么 track / 谁在动 / 在哪阶段 / 工作状态 / 何时更新"的**事实**
- prose 给"做了什么 / 待办 / 教训 / 风险 / 提交清单 / memory entries"的**叙述**

同一信息 (如 `phase`) 在两层都出现时,**以 frontmatter 为机读 SOT**;
prose 中允许更详细描述 (如 "Phase B 7/9 tasks done with T2-T8 pending") 作为人类可读补充。

### 2.3.4 向后兼容 (existing docs without frontmatter)

`v1.1.0` 升级前已存在的 handoff doc 没有 frontmatter,**不要求批量回填**。
state-scanner Phase 1 collector (per `multi-terminal-coordination` task 1.4) 按以下
fallback 处理:

1. **有完整 frontmatter** → 解析为机读 track 行,渲染到多 track 看板
2. **无 frontmatter / schema 不全** → 标记为 `legacy` track,使用 mtime + filename
   parsing fallback (对齐 §3.2 `latest_path` H5 mtime fallback 语义),
   不阻塞看板渲染

这一 fallback 行为与现有 `docs/handoff/latest.md` pointer 语义授权一致 (`latest.md`
仍为 prose-level navigation pointer;frontmatter 为 machine-level metadata)。

**latest.md 派生行为** (per `multi-terminal-coordination` task 1.6):
- **单 track 场景** (1 active track in 看板): `latest.md` 写当前 track 指针,向后兼容老 session 读
- **多 track 场景** (≥2 active tracks): `latest.md` 不写真实指针,仅含 deprecation banner 指引读看板;L2 collector 语义权威仍以 frontmatter 为准

新写出的 handoff doc 由 `aria/templates/session-handoff.md` (L5 template) 硬编码
frontmatter 段,确保所有 v1.21.x+ session-handoff 输出含完整 schema。

### 2.3.5 多 owner / 多 container 语义 (collision 类型)

`owner-container` 字段在跨容器 / 多人协作场景下需区分两类 collision:

| Collision 类型 | 触发条件 | 看板渲染 | 含义 |
|----------------|---------|---------|------|
| **cross-owner** | 同一 track-id 出现 ≥2 个 distinct `<owner>` | 🔴 强提示,需 reconcile 协议确定性裁决 (per `multi-terminal-coordination` Layer L 早 `claimed_at` 胜) | 多人共抢同一工作,真冲突 |
| **self-multi-container** | 同一 track-id 出现 ≥2 个 distinct `<container-id>` 但同 `<owner>` | 🟡 soft hint,可能是同一人多容器开了多 session,或容器迁移 | 同一人在多环境工作,通常无需 yield |

详见 [Spec proposal.md §Impact "same-owner-multi-container 语义"](../../openspec/changes/multi-terminal-coordination/proposal.md)。

### 2.3.6 与 Layer L claim schema 的区别

> 本 §2.3 是 **Layer H** (handoff doc 自身的机读 frontmatter,人也可读);
> `multi-terminal-coordination` 还有 **Layer L** claim schema (orphan ref `refs/aria/coordination` 内的 `claims/<container-id>/<session-id>.yaml`,纯机器),两者**目的不同**:

| 维度 | Layer H frontmatter (本 §2.3) | Layer L claim (Spec proposal §What) |
|------|-------------------------------|--------------------------------------|
| 位置 | `docs/handoff/{date}-{slug}.md` 顶部 | `refs/aria/coordination` orphan ref 内 |
| 字段数 | 5 (track-id / owner-container / phase / status / updated-at) | 8+ (含 schema_version / claimed_at / heartbeat_at / superseded_from 等) |
| 写入频度 | session 结束时一次 (D.3) | 开工前 1 次 + 周期 heartbeat (10min) + phase 切换 + release |
| 受众 | 人类 + AI 都读 | 仅机器 (state-scanner Phase 1 reader) |
| 目的 | 防接错棒 (knowledge handoff) | 防重复劳动 (work claim) |

---

## 3. Enforcement matrix (5-layer defense-in-depth)

源自 OpenSpec `aria-ten-step-session-handoff-stage` proposal §Layered defense matrix。

| Layer | 机制 | 触发时机 | 实施位置 | 失效时谁兜底 |
|-------|------|----------|----------|--------------|
| **L1** | PreToolUse hook 阻断 `.aria/handoff/*.md` 写入 | AI 写入时 | `aria/hooks/handoff-location-guard.sh` | L2 detect + L3 推荐 |
| **L2** | `scan.py` collector 检测 `.aria/handoff/*.md` 存在 → `misplaced_files` 字段 | 每次 `/state-scanner` | `aria/skills/state-scanner/scripts/collectors/handoff.py` | L3 surface 给 AI |
| **L3** | state-scanner 推荐 `migrate-handoff-drift` workflow | 推荐 Phase 2 | `aria/skills/state-scanner/RECOMMENDATION_RULES.md` (rule 1.91) | 人类 review |
| **L4** | Convention SOT (本文档) | 引用源 | `standards/conventions/session-handoff.md` | 工具实施引用 |
| **L5** | `phase-d-closer` D.3 template 硬编码 `docs/handoff/` | session 结束写 | `aria/skills/phase-d-closer/SKILL.md` + `aria/templates/session-handoff.md` | L1 hook 阻断异常 |

### 3.1 Layer 1 details

`handoff-location-guard.sh` 在 PreToolUse 事件:
- 匹配 `tool_name` ∈ {`Write`, `Edit`, `NotebookEdit`}
- Path matcher: regex `(?:^|[/\\])\.aria[/\\]handoff[/\\][^/\\]+\.md$` (跨平台 / Windows backslash 兼容)
- Symlink 解析: `Path.resolve()` 防绕过
- Deny mechanism: JSON payload `{"decision": "block", "reason": "..."}` 到 stdout (preferred per Claude Code hook spec); `ARIA_HOOK_DENY_MODE=exit2` 时降级为 exit 2 + stderr

### 3.2 Layer 2 details

`collectors/handoff.py` 返回 snapshot 顶层 `handoff` 字段 (schema 1.0 additive, 不 bump per Aria v1.18.0 G2/G3/G4 precedent — additive top-level field 在 schema 1.0 内引入):

```yaml
handoff:
  exists: bool                    # docs/handoff/*.md has files?
  latest_path: str | null         # pointer-first (latest.md target), mtime fallback
  latest_filename: str | null
  last_modified_iso: str | null   # UTC ISO 8601
  age_hours: float | null         # time.time() - mtime (avoid timezone)
  latest_source: str | null       # "pointer" | "mtime" | null (H5 transparency)
  misplaced_files: list[str]      # .aria/handoff/*.md paths
  canonical_dir: "docs/handoff/"
```

**Latest detection (H5 fix 2026-05-16)**: `latest_path` 优先取 `docs/handoff/latest.md` pointer target (人维护的语义 "Latest"),raw mtime-max 仅 fallback (pointer 缺失/无法解析/指向不存在文件时)。`latest.md` pointer 是语义权威,mtime 是脆弱信号 (predecessor handoff 被 post-hoc 编辑 — closeout/rebase — 会获得最新 mtime 而 shadow 真 latest)。stale pointer → `soft_error("handoff_pointer_target_missing")` + mtime fallback。

### 3.3 Layer 3 details

`RECOMMENDATION_RULES.md` 规则 `handoff_drift` (priority 1.91, 在 audit_unconverged 1.9 之后, custom_check_failed 1.95 之前):

- Condition: `snapshot.handoff.misplaced_files != []`
- Workflow: `migrate-handoff-drift`
- Steps: `git mv .aria/handoff/*.md docs/handoff/` → update `latest.md` pointer → `rmdir .aria/handoff/` → commit
- Confidence: 95%
- Auto-execute: No — file move 涉及 git history,需用户 confirm

### 3.4 Layer 4 details (本文档)

本规范是 L4 的具体内容。canonical normative source: §1 (核心条款) + §2 (template) + §4 (Exception) + §5 (Source incidents)。下游工具实施 (L1/L2/L3/L5) 引用本文档作为规则单一真相源。

- 引用位置: aria-plugin (L1 hook 错误消息 / L2 collector docstring / L3 rule rationale / L5 template instructions)
- 引用位置: 项目 CLAUDE.md (Rule #9 详细规范 ref)
- 修订流程: 通过 OpenSpec cycle 修订 (e.g. `aria-ten-step-session-handoff-stage` 是 v1.0.0 origin); 微调通过 PR 直接修改本文件,版本号 (header) 同步 bump

### 3.5 Layer 5 details

`phase-d-closer` D.3 step (新增 2026-05-14 by H0 spec, SKILL 1.0.0 → 1.1.0):
- Template path: `aria/templates/session-handoff.md`
- 触发条件: 见 §2.1
- 输出路径硬编码: `docs/handoff/{YYYY-MM-DD}-{slug}.md` — 不接受 dir 参数
- Latest pointer 自动更新

---

## 4. Exception

**零 exception**。与 [secret-hygiene](./secret-hygiene.md) 不同 (后者有隔离环境 debug 用途), handoff 路径选择无 ambiguity 边缘场景。任何 `.aria/handoff/*.md` 写入企图都应 redirect 到 `docs/handoff/`。

如下游项目有充分理由使用其他 dir (e.g. 历史遗留, 跨项目工具约束), 须通过 OpenSpec cycle 显式 fork 本规范并记录 rationale, 而非临时绕过。

---

## 5. Source incidents

支撑本规范创建的 4 起 dogfood 实证 (对齐 [secret-hygiene](./secret-hygiene.md) §header incident 引用 pattern):

| # | Date | Project | Incident | Root cause |
|---|------|---------|----------|------------|
| 1 | 2026-05-09 | SilkNode (US-095 cycle) | `/aria:state-scanner` 推荐 "随便挑一个 ready story", 用户反问 "你是不是没读交接文档?" 后才补读 | session 开始 AI 看不到 handoff 文档作为优先级信号源 |
| 2 | 2026-05-13 | Aria self (#101 closeout) | 双 dir 共存 — `docs/handoff/` (5 files) + `.aria/handoff/` (5 files), spec 作者本人也漂移到 `.aria/handoff/` | 缺 canonical 决策, 缺主动 enforcement, 缺 L1 写入阻断 |
| 3 | 2026-05-13 | Aria self (M5 phase-a-b1) | `latest.md` pointer stale, 指 May 13 00:26 而非真正最新 May 13 20:31 | 写新 handoff 时未更新 pointer (L5 模板未硬编码 latest 更新) |
| 4 | 2026-05-13 | Aria self (H0 spec 起草本 session) | AI 跑完 state-scanner 直接出推荐, 用户问 "有查看 handoff 文档吗?" 才读 latest | 同 #1, 但发生在本 spec 的 dogfood 起草过程中, 是 H0 必须的元论证 |

**§2.3 frontmatter schema 扩展**支撑的 1 起跨容器 race 实证:

| # | Date | Project | Incident | Root cause |
|---|------|---------|----------|------------|
| 5 | 2026-05-19 | Aria self (multi-terminal-coordination spec 起草本 session) | 两终端同期工作 — 本 session 在做 multi-terminal-coordination Phase A,另一终端在 master 上 ship Spec Y T2-T8 + closeout + issue triage,首次 `git push origin master` 被 reject 为 non-fast-forward;`docs/handoff/latest.md` 单 pointer branch-local,master 视角看不到 feature 分支 handoff (`2026-05-17-evening-spec-y-phase-b-core-5-tasks.md` 仅 feature 分支可见) | 单写者 pointer + 无 cross-branch 重建 → 接错棒;无 work-claim 登记 → 重复劳动风险;本规范 §2.3 frontmatter + Layer L claim 共同解决 |

---

## 6. Migration notes (downstream projects)

升级 aria-plugin 到 v1.21.0+ 后:

### 6.1 已有 `docs/handoff/` 项目 (e.g. SilkNode)

- ✅ 无需迁移 — 已是 canonical
- L2 collector 会自动 surface 给 AI
- 下次 phase-d-closer 运行时 D.3 step 可用

### 6.2 已有 `.aria/handoff/` 或其他 ad-hoc dir 项目

如 Aria 自身 (本 spec 实施前):

1. 运行 `/state-scanner` — `snapshot.handoff.misplaced_files` 会列出漂移文件
2. 接受推荐 [1] `migrate-handoff-drift` workflow
3. 执行: `git mv .aria/handoff/*.md docs/handoff/`
4. 手动检查 `docs/handoff/latest.md` pointer 是否指向真正最新 (按 mtime)
5. `rmdir .aria/handoff/` (空 dir 由 git 删除)
6. Commit: `chore(handoff): migrate misplaced files to canonical docs/handoff/`

### 6.3 模板 customization

`aria/templates/session-handoff.md` 是**起点**, 不是硬约束。下游项目可:
- ✅ 删除不适用的 §5 维度 (e.g. 无 UPM 时删除该行)
- ✅ 在 §5 加项目特有维度 (e.g. Aether 加 `aether-handoff.yaml` 维度)
- ❌ 不要删除 §0 §6 §8 (是跨 session 信号传递的核心)
- ❌ 不要换 dir (违反 §1 核心条款)

---

## 7. 与既有规范的关系

| 规范 | 关系 |
|------|------|
| [secret-hygiene](./secret-hygiene.md) (Rule #7) | **结构同构**: L1 hook + L4 convention 双层。session-handoff 是第二个采用此 pattern 的 convention |
| [git-commit](./git-commit.md) | handoff doc 的 §7 提交清单引用 commit hash, 须符合 Conventional Commits |
| [naming-conventions](./naming-conventions.md) | handoff 文件名 `{YYYY-MM-DD}-{slug}.md` 遵循 kebab-case + ISO date 前缀 |
| [document-classification](./document-classification.md) | handoff doc 属于 "operational records" 类, 跨 session 复用 |
| [version-management](./version-management.md) | 引入 D.3 step 触发 phase-d-closer SKILL 版本 bump (1.0.0 → 1.1.0) |

---

## 8. 在 ten-step cycle 中的位置

```
A. 规划 (Spec & Planning)
├── A.0 状态扫描 → 读 docs/handoff/latest.md (L2 collector auto-surface) ◄── handoff 影响入口
├── A.1 规范创建
├── A.2 规范审计
└── A.3 准入

B. 开发 (Development) — handoff 不直接介入

C. 集成 (Integration) — handoff 不直接介入

D. 收尾 (Closure)
├── D.1 进度更新
├── D.2 归档
└── D.3 session-handoff ◄── 触发条件满足时写 docs/handoff/{date}-{slug}.md
```

---

## 9. References

- Trigger: Forgejo Aria [#92](https://forgejo.10cg.pub/10CG/Aria/issues/92)
- Triage SOP: [issue-triage convention](./issue-triage.md)
- Real-world handoff examples (Aria self):
  - `docs/handoff/2026-05-13-us025-m5-phase-a-b1-done.md`
  - `docs/handoff/2026-05-10-phase-c-integrator-pre-merge-gate-cycle-done.md`
  - `docs/handoff/2026-05-09-track-a-deploy-done.md`
- OpenSpec (Rule #9 origin): `openspec/archive/2026-05-15-aria-ten-step-session-handoff-stage/`
- OpenSpec (§2.3 frontmatter schema 扩展): `openspec/changes/multi-terminal-coordination/` (Approved 2026-05-19, per [DEC-20260519-001](../../docs/decisions/DEC-20260519-001-multi-terminal-coordination.md))
- aria-plugin Skills referenced:
  - state-scanner (Phase 1.15 handoff collector + Phase 1 多 track 看板 per multi-terminal-coordination tasks 1.3-1.5)
  - phase-d-closer (D.3 step)
- CLAUDE.md Rule #9 (本规范在 Aria 项目 CLAUDE.md 中的硬约束体现)

---

**Last updated**: 2026-05-20 (v1.1.0 — §2.3 frontmatter schema additive)
**Maintainer**: Aria methodology team
