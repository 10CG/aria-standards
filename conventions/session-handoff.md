# Session Handoff 规范

> **Version**: 1.0.0
> **Status**: Active
> **Source incidents**:
> - 2026-05-09 (SilkNode US-095 cycle) — `/aria:state-scanner` 跳过 handoff 文档,推荐 "随便挑一个 ready story",用户反问 "你是不是没读交接文档?" 后才补读
> - 2026-05-13 (Aria self ×3) — 包括: state-scanner 推荐未读 handoff (3 起); Aria 自身 `docs/handoff/` 与 `.aria/handoff/` 双 dir 同时存在 (5 + 5 files), spec 作者本人也漂移
> **Forgejo Issue**: [10CG/Aria#92](https://forgejo.10cg.pub/10CG/Aria/issues/92) (triage [#6170](https://forgejo.10cg.pub/10CG/Aria/issues/92#issuecomment-6170))
> **Origin Spec**: `openspec/archive/2026-05-14-aria-ten-step-session-handoff-stage/` (待 ship)
> **Target release**: aria-plugin v1.21.0+

---

## 1. 核心条款

> **Session handoff documents MUST be written to `docs/handoff/` (canonical).
> `.aria/handoff/` is forbidden.**

### 1.1 Why this split

| Namespace | 语义 | 内容举例 | gitignore? |
|-----------|------|----------|-----------|
| `.aria/` | 机器状态 (machine state) | `workflow-state.json`, `audit-reports/`, `cache/`, `state-snapshot.json` | 大部分 ignore |
| `docs/` | 人类/AI 可读 prose | `requirements/`, `architecture/`, `handoff/`, decision memos | tracked |

Handoff doc 是**人写给下次 session 读的散文叙述** (8+ 段 narrative), 不是机器状态。语义上属于 `docs/handoff/`。

### 1.2 Forbidden patterns

- ❌ Write/Edit/NotebookEdit 到 `.aria/handoff/*.md` (由 L1 hook `handoff-location-guard.sh` 阻断)
- ❌ 在 `.aria/handoff/` 与 `docs/handoff/` 之间分散写入 (drift)
- ❌ 自定义其他 handoff dir (例如 `notes/`, `sessions/`, `journals/`) — 与跨项目复用 9 段模板的目标冲突
- ❌ 跳过 `docs/handoff/latest.md` pointer 更新 (导致 stale pointer)

### 1.3 Exception

**零 exception**。与 [secret-hygiene](./secret-hygiene.md) 不同 (后者有隔离环境 debug 用途), handoff 路径选择无 ambiguity 边缘场景。任何 `.aria/handoff/*.md` 写入企图都应 redirect 到 `docs/handoff/`。

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

写入后**自动**更新 `docs/handoff/latest.md` pointer。

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

`collectors/handoff.py` 返回 snapshot 顶层 `handoff` 字段 (schema 1.0 additive, 不 bump):

```yaml
handoff:
  exists: bool                    # docs/handoff/*.md has files?
  latest_path: str | null         # newest by mtime
  latest_filename: str | null
  last_modified_iso: str | null   # UTC ISO 8601
  age_hours: float | null         # time.time() - mtime (avoid timezone)
  misplaced_files: list[str]      # .aria/handoff/*.md paths
  canonical_dir: "docs/handoff/"
```

### 3.3 Layer 3 details

`RECOMMENDATION_RULES.md` 规则 `handoff_drift` (priority 1.91, 在 audit_unconverged 1.9 之后, custom_check_failed 1.95 之前):

- Condition: `snapshot.handoff.misplaced_files != []`
- Workflow: `migrate-handoff-drift`
- Steps: `git mv .aria/handoff/*.md docs/handoff/` → update `latest.md` pointer → `rmdir .aria/handoff/` → commit
- Confidence: 95%
- Auto-execute: No — file move 涉及 git history,需用户 confirm

### 3.4 Layer 5 details

`phase-d-closer` D.3 step (新增 2026-05-14 by H0 spec, SKILL 1.0.0 → 1.1.0):
- Template path: `aria/templates/session-handoff.md`
- 触发条件: 见 §2.1
- 输出路径硬编码: `docs/handoff/{YYYY-MM-DD}-{slug}.md` — 不接受 dir 参数
- Latest pointer 自动更新

---

## 4. Migration notes (downstream projects)

升级 aria-plugin 到 v1.21.0+ 后:

### 4.1 已有 `docs/handoff/` 项目 (e.g. SilkNode)

- ✅ 无需迁移 — 已是 canonical
- L2 collector 会自动 surface 给 AI
- 下次 phase-d-closer 运行时 D.3 step 可用

### 4.2 已有 `.aria/handoff/` 或其他 ad-hoc dir 项目

如 Aria 自身 (本 spec 实施前):

1. 运行 `/state-scanner` — `snapshot.handoff.misplaced_files` 会列出漂移文件
2. 接受推荐 [1] `migrate-handoff-drift` workflow
3. 执行: `git mv .aria/handoff/*.md docs/handoff/`
4. 手动检查 `docs/handoff/latest.md` pointer 是否指向真正最新 (按 mtime)
5. `rmdir .aria/handoff/` (空 dir 由 git 删除)
6. Commit: `chore(handoff): migrate misplaced files to canonical docs/handoff/`

### 4.3 模板 customization

`aria/templates/session-handoff.md` 是**起点**, 不是硬约束。下游项目可:
- ✅ 删除不适用的 §5 维度 (e.g. 无 UPM 时删除该行)
- ✅ 在 §5 加项目特有维度 (e.g. Aether 加 `aether-handoff.yaml` 维度)
- ❌ 不要删除 §0 §6 §8 (是跨 session 信号传递的核心)
- ❌ 不要换 dir (违反 §1 核心条款)

---

## 5. 与既有规范的关系

| 规范 | 关系 |
|------|------|
| [secret-hygiene](./secret-hygiene.md) (Rule #7) | **结构同构**: L1 hook + L4 convention 双层。session-handoff 是第二个采用此 pattern 的 convention |
| [git-commit](./git-commit.md) | handoff doc 的 §7 提交清单引用 commit hash, 须符合 Conventional Commits |
| [document-classification](./document-classification.md) | handoff doc 属于 "operational records" 类, 跨 session 复用 |
| [version-management](./version-management.md) | 引入 D.3 step 触发 phase-d-closer SKILL 版本 bump (1.0.0 → 1.1.0) |

---

## 6. 在 ten-step cycle 中的位置

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

## 7. References

- Trigger: Forgejo Aria [#92](https://forgejo.10cg.pub/10CG/Aria/issues/92)
- Triage SOP: [issue-triage convention](./issue-triage.md)
- Real-world handoff examples (Aria self):
  - `docs/handoff/2026-05-13-us025-m5-phase-a-b1-done.md`
  - `docs/handoff/2026-05-10-phase-c-integrator-pre-merge-gate-cycle-done.md`
  - `docs/handoff/2026-05-09-track-a-deploy-done.md`
- OpenSpec: `openspec/archive/2026-05-14-aria-ten-step-session-handoff-stage/`
- aria-plugin Skills referenced:
  - state-scanner (Phase 1.15 handoff collector)
  - phase-d-closer (D.3 step)
- CLAUDE.md Rule #9 (本规范在 Aria 项目 CLAUDE.md 中的硬约束体现)

---

**Last updated**: 2026-05-14
**Maintainer**: Aria methodology team
