# 并发 Session 写入安全约定 (Concurrent-Session Write Safety)

> **状态**: Active | **引入**: aria-plugin v1.37.0 (#133 concurrent-session-upm-safety)
> **适用**: 所有使用 Aria 方法论的项目 (主仓 + 子模块 + 下游项目)
> **最后更新**: 2026-05-30 (#133 — convention 主解药)
> **既定哲学约束**: advisory-over-hardlock (DEC-20260519-001) — 本约定是**写法结构**层面的 forcing function, 不引入任何硬锁

---

## TL;DR (决策表)

当**多个 session/容器并发**编辑同一份共享文档 (UPM 进度 / handoff / latest.md) 时:

| 共享区 | 旧写法 (产生冲突) | 新约定 (concurrent-safe) |
|--------|------------------|--------------------------|
| `latest.md` line-3 pointer | 多 session 改同一行 | **bare pointer 单写者 + 看板权威** (§3.1) |
| `latest.md` History 段 | prepend 新条目 (**保持不动, L5**) | prepend-descending 不变 — 见 §3.2 为何天然安全 |
| UPM body / 进度叙述 | 多 session 改同一段 | **append-friendly 或 per-session 隔离段** (§3.3) |
| followup `#NNN` 跟进表 | 多 session 改同一 row | **per-session sub-row / 轻量标记** (§3.4) |
| 记录外部系统状态 (prod/DB) | 用 `updated_at` 软代理 | **引硬证据 (RETURNING / 显式 timestamp)** (§4, TASK-003) |

**核心原则 (Problem-1 因果定位)**: PR merge thrash 是 **write-time git 冲突**。
scan 时点的 advisory 检测**拦不住它** (SilkNode 已有 Layer L 1.51-1.53 advisory 仍 thrash = 被实证证伪)。
**消除 thrash 的唯一 forcing function = convention 结构改写** —— 让两次编辑不再 textual 重叠。
检测 (切口2) / fetch (切口1) 是 advisory 辅助早发现, **非解药**。

---

## 1. 问题本质

### Problem-1: 并发改同一区 → PR merge thrash

#133 真实 dogfood (SilkNode 双 session):两个 session 并发编辑同一 UPM/handoff 共享区
→ 反复 `mergeable: false` → 反复 rebase → "merge thrash"。

根因是 **git 文本冲突**:两次编辑落在同一行/同一段,git 三路合并无法自动调和。
本 session (dev-claude) 自身也多次实证:`latest.md` pointer prepend 冲突 + 5 SOT 反复冲突 + 4× stale `index.lock`。

> **为什么 advisory 检测拦不住**: advisory 在 **scan 时点**提示"有并发",但冲突发生在 **write/merge 时点**。
> 即使 AI 看到提示,只要两个 session 仍写同一行,git 冲突照样产生。
> 解药必须作用在**写法结构**上 (让编辑不重叠),而非提示上。

### Problem-2: 软代理时间戳 → 矛盾记录 (见 §4 / TASK-003)

对同一外部系统状态 (如 prod 部署归属) 写相反结论,根因 = 用 `updated_at` 软代理判断"谁更新"
(如 Prisma `@updatedAt` 不被 raw SQL 触发 → 软代理误判)。

---

## 2. 适用边界 (不可违背的复用约束)

| 维度 | 约束 |
|------|------|
| 哲学 | **advisory-over-hardlock** (DEC-20260519-001):本约定**不**引入硬锁/不阻塞写入/不 auto-enable 协调 |
| History prepend-desc (L5) | `latest.md` History 段的 **prepend-descending 写法保持不动** — 它天然 append-friendly (§3.2), 不是 thrash 源 |
| 与 Layer L 关系 | Layer L (claim YAML / orphan ref / reconcile) 协调**谁在做哪个 track** (身份层);本约定治**文本写法** (内容层)。两者**互补不重复** |
| 与 followup row | per-session 隔离**非复用** claim_lifecycle orphan-ref 机制 (那是 Layer L 身份协调, 本约定是纯文本写法) |
| 单 session 场景 | 单 session 时本约定**优雅降级**为零额外开销 (见 §5) |

---

## 3. concurrent-safe 写法约定 (Problem-1 主解药)

### 3.1 latest.md bare pointer — 单写者 + 看板权威

`latest.md` 的 bare `**Latest**:` 行 (scan.py collector `_LATEST_POINTER_RE` 读取) 是高竞争单行。

**约定**:
- **bare pointer 只保留 1 行** (最新 session),由该 session 写;历史条目降级为 `**Latest (T-<slug> display)**:` 带后缀的 display-only 行 (collector 不读, 不竞争)。
- 多终端并发时,**看板才是语义权威** (state-scanner Phase 1.16/1.17 跨分支重建),bare pointer 仅向后兼容。
- 接手 session 改 bare pointer 时:**先 `git fetch` + FF**,若 pointer 行有并发改动 → 机械对账 (保留 sister 的 display 条目, bare 指向自己最新)。

> 实证 (本 session): bare pointer 改动遇 sister 并发,fetch→FF→手动语义合并即化解, 不 rebase thrash。

### 3.2 latest.md History 段 — prepend-descending 天然安全 (L5 不动)

History 段新条目**prepend 到顶部** (newest-first)。

**为什么天然 append-friendly (无需改)**:两个 session 各 prepend 自己的新条目块 → git 三路合并视为**两段相邻插入**,
绝大多数情况自动合并成功 (两块都保留, 顺序按 merge)。冲突仅在两者 prepend **完全同一行**时出现 — 而每个 session 的条目块 header (`## ★ ... session #<slug>`) 天然不同。

**约定**:保持 prepend-descending 不变 (L5);**不要**改成 in-place 编辑历史条目 (那会制造 thrash)。

### 3.3 UPM body / 进度叙述 — append-friendly 或 per-session 隔离

UPM 文档的人类可读叙述段 (非 UPMv2-STATE 机读块) 是共享编辑区。

**约定** (二选一,按文档结构):
- **append-friendly**:新进度**追加**到段末 (或专属"进度日志"子段),不 in-place 改写他人已写段落。
- **per-session 隔离**:为本 session 开独立子段 (`### <date> <slug> 进度`),只写自己的子段。

> UPMv2-STATE **机读块**由 `progress-updater` 机械写入 (结构化字段),不在本约定范围 (它是单写者机械区, 非自由叙述)。

### 3.4 followup `#NNN` 跟进表 — per-session sub-row / 轻量标记

跟进表 (如 issue followup `| #NNN | 状态 | ... |` 表格行) 是多 session 高频改同一 row 的区。

**约定**:
- **per-session sub-row**:同一 `#NNN` 需多 session 更新时,**追加子行**而非改原行 —
  `| #NNN | ... | <date> <slug>: 进展 |` (每 session 一行),而非 in-place 覆盖状态列。
- **轻量标记**:或在状态列**追加** `+ <session> done` 而非替换。
- **非复用 claim_lifecycle**:这是纯文本追加约定,**不**调用 Layer L orphan-ref claim 机制 (那是 track 身份协调, 不是表格行写法)。

---

## 4. AI 记录外部系统状态须引硬证据 (Problem-2 主解药, TASK-003)

> **作用域**: 本节约束 **AI 在 handoff/UPM 中记录外部系统状态**的自律, **不是**约束用户的 DB schema 设计。

当 AI 记录"外部系统 (prod / DB / 部署) 当前是什么状态、归属于谁"时:

**约定**:
- **必须引硬证据**:用**直接观测的事实** —— SQL `RETURNING` 子句返回值 / 命令 exit code / 显式时间戳 (观测时刻 UTC) / API 响应字段。
- **禁用软代理**:**不得**用 `updated_at` / `@updatedAt` 之类**应用层软代理**作为"谁最后改了它"的 canonical 判据 —— 这类字段可能不被某些写路径触发 (如 raw SQL 绕过 ORM hook),导致误判 (#133 Problem-2 根因)。
- **记录格式**:写"我于 `<UTC>` 观测到 `<硬证据>` → 推断 `<结论>`",而非"它看起来是 `<结论>`"。

**与 #54 的关系**:#54 (data-availability rubric) 是 audit prompt 对"引用历史/外部数据须先验证可达性"的通用约束;
本节是其在 **AI 记录外部状态**领域的具体实例。**独立 + 交叉引用**, 不合并。

---

## 5. 单 session 优雅降级

单 session (无并发) 时本约定**零额外开销**:
- bare pointer:正常单写,无对账。
- History:正常 prepend。
- UPM body / followup:正常写 (append 或 in-place 均可, 因无竞争者)。
- 硬证据自律 (§4):**始终适用** (与并发无关, 是记录质量约束)。

> 即:§3 (Problem-1 写法) 在单 session 退化为无操作;§4 (Problem-2 硬证据) 任何时候都遵守。

---

## 6. 正向 / 反向 pattern

### ✅ 正向

```markdown
# latest.md — 接手 session
1. git fetch origin <branch> && git merge --ff-only   # 先同步
2. bare pointer 指向自己最新 doc;前任 bare 改 display-only 后缀
3. History prepend 自己的 ## ★ 条目块 (header 含唯一 slug)

# followup 表 — 多 session 更新 #134
| #134 | open | 2026-05-30 dev-claude: triage done |
| #134 | open | 2026-05-31 sister: fix shipped |     ← 追加子行, 不改上一行

# 记录 prod 状态 (§4)
我于 2026-05-30T14:00:00Z 跑 `SELECT ... RETURNING deployed_by` 返回 'dev-claude'
→ 推断本 deploy 归属 dev-claude (硬证据: RETURNING 值)
```

### ❌ 反向 (禁止)

```markdown
# ❌ 多 session in-place 改同一 pointer 行 / 同一 followup row → thrash
| #134 | done |        ← session A 写
| #134 | in_progress | ← session B 覆盖同一行 → merge 冲突

# ❌ 用软代理判外部状态归属
"updated_at 是 14:00, 所以是 dev-claude 改的"  ← @updatedAt 可能未被 raw SQL 触发, 误判

# ❌ in-place 改写他人已写的 UPM 叙述段 → thrash
```

---

## 7. Exception 机制

本约定为**写法指引** (非机械 gate),exception 即"判断当前确为单 session, 可省 §3 对账":
- 单 session 确认 (无 sister track) → §3 自然降级 (见 §5),无需显式声明。
- §4 硬证据自律**无 exception** (记录质量底线)。

> 与 secret-hygiene / shell-jq-crlf-hygiene 不同:本约定无机械 enforcement hook,验收靠 dogfood (见 §7.1)。

### 7.1 机械 guard 评估结论 (#133 TASK-004) — 不实现 guard, 采用 dogfood

**裁定: 不实现静态机械 checker; 采用 dogfood + 既有 advisory 切口作为验收防线。**

不实现 guard 的 4 条理由:

1. **静态 checker 无法区分合法 vs 违规写法**: per-session sub-row (追加, §3.4 正向) 与 in-place 改同一 row (违规) 在**文本层面相同** — 区分需 git-history diff + 写入意图, 静态 lint 做不到 (会高频假阳/假阴)。
2. **违规本质是 write-time merge conflict, 非静态可检**: 这正是本 Spec audit C1 因果点 —— "检测/提示拦不住 write-time thrash"。一个静态 guard 恰是被实证证伪的那类机制 (SilkNode 已有 advisory 仍 thrash)。
3. **advisory-over-hardlock 禁止阻塞式 guard** (DEC-20260519-001): 任何 hard-fail guard 都违背既定哲学。
4. **早发现已被 advisory 切口覆盖**: 切口2 (state-scanner rule 1.54 `concurrent_churn_detected`, 消费 `collision.kind`) + 切口1 (phase-d-closer D.1 `fetch_gate`) 已在 scan / 写前提供 advisory 信号。再加 guard = 冗余。

**Dogfood 验收标准** (可复验, 非纯自觉):

| # | 验收项 | 可观察证据 |
|---|--------|-----------|
| AC-D1 | **翻转测试 (主)**: 两 session 各按 §3 新约定写共享区 (followup sub-row / per-session 段 / bare-pointer 单写) → 合并 | `git merge` / PR diff **无 conflict marker** (`<<<<<<<` / `=======` / `>>>>>>>`) |
| AC-D2 | **反向对照**: 同两 session 改旧写法 (in-place 同 row / 多 bare pointer) → 合并 | 产生 conflict marker (= 证明约定确实消除了冲突, 而非场景本身无冲突) |
| AC-D3 | **self-thrash dogfood** (TASK-008 6.3): 本 Spec ship 自身用 §3 约定写 handoff/SOT | ship 过程 commit 历史无因共享区 in-place 改写导致的 rebase thrash |
| AC-D4 | **硬证据自律 (§4)**: AI 记录外部状态的 handoff 段 | grep 无 `updated_at`-as-canonical 措辞; 有 RETURNING/exit-code/显式 timestamp 硬证据 |

> AC-D1/D2 是一对**翻转可验** (forcing-function): 仅 AC-D1 通过不够 (可能场景本就无冲突), 必须 AC-D2 反向产生冲突才证明约定**起作用**。这是 convention 类交付物的 Rule #6 structural substitute (无 Python guard, 故以 dogfood 翻转对照替代单元测试)。

---

## 8. 与其他 convention 的关系

| Convention | 关系 |
|------------|------|
| `session-handoff.md` (Rule #9) | 本约定治 handoff **并发写法**;session-handoff 治 handoff **位置/结构/frontmatter**。互补 |
| Layer L (`multi-terminal-coordination`) | Layer L 协调 **track 身份** (claim/reconcile);本约定治 **文本内容写法**。互补不重复 |
| `submodule-pointer-hygiene.md` | C.2.4.5 是 **fail-hard** gate;本约定切口1 fetch 是 **fail-soft** advisory。语义不同 |
| #54 (data-availability rubric) | §4 硬证据是 #54 在 AI-记录领域的实例。独立交叉引用 |

---

## 9. 触发场景速查

- 多终端/容器并发编辑同一 UPM / handoff / latest.md
- 接手他人 track 前改 bare pointer / followup 表
- handoff/UPM 中记录 prod/DB/部署的外部状态归属
- PR 反复 `mergeable: false` (thrash 征兆) → 检查是否撞共享区 in-place 写

---

**Source incident**: #133 (SilkNode 双 session merge thrash + 矛盾记录;Aria self dev-claude latest.md prepend + 5 SOT 冲突 + 4× index.lock)。
**完整 Spec**: `openspec/changes/concurrent-session-upm-safety/` (或 archive)。
