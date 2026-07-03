# CLAUDE.md 卫生规范 (CLAUDE.md Hygiene)

> **Version**: 1.0.0
> **Status**: Active
> **Purpose**: 约束 CLAUDE.md 只承载稳定的「AI 如何理解项目」内容, 禁止时效性 changelog / session 流水在其中累积
> **决策**: Option A 彻底移交 (owner sign-off 2026-07-03)

---

## 1. 问题

CLAUDE.md 每个 session **自动进上下文**, 是固定的上下文税。它有天然的"只增不删"引力:
- footer 被当 session 日志用 → 逐 session append "前次" 流水
- 版本字段被当 changelog 用 → 逐版本内联 changelog

无规矩约束时, 二者无界增长。2026-07-03 实测: Aria CLAUDE.md 73% 是时效性状态/历史 (footer 22 条前次 + 版本字段 15K 内联 changelog), 单文件 69K 字符 / 每 session ~2-3 万 token。这同时违反:
- **CC 官方推荐** (CLAUDE.md 应极简, 放反复需要的稳定知识, 不放 changelog/history)
- **文档边界** (CLAUDE.md = 项目定位 / 上下文地图 / 不可协商规则 —— 不含 session 历史)
- **Rule #9 session-handoff** (session 记录的 canonical 家是 `docs/handoff/`)
- **SOT 纪律** (版本 changelog 的 SOT 是 `CHANGELOG.md`)

## 2. 规矩 (Option A — 彻底移交)

CLAUDE.md **只**包含稳定内容; 一切时效性/历史内容移交各自 canonical 家。

### 2.1 允许 (稳定内容)
- 项目定位 / 认知框架 / 核心概念
- 上下文地图 (信息地图 / 目录导航 / 子模块职责)
- 不可协商规则
- 运维规范 (版本发布 checklist / 版本信息一致性表 —— 可复用的流程, 非历史)
- **项目状态** (当前 phase / 活跃阻塞 / 关键指针) —— 见 §2.3

### 2.2 禁止 (移交)
| 内容 | Canonical 家 |
|------|-------------|
| 版本 changelog (逐版本变更明细) | `<plugin>/CHANGELOG.md` (SOT) |
| session 进展流水 (逐 session "干了啥") | `docs/handoff/{date}-{slug}.md` (Rule #9) |
| 任何 append-only 日志 | 上述二者 / git history |

footer **不保留** `> 前次 ...` / `**更新**: ...` 滚动条目。footer 只放**指针** (指向 handoff / CHANGELOG) + 稳定元数据 (维护/仓库 URL)。

### 2.3 项目状态 = live 覆写, 非 log
「项目状态」段是当前快照, **原地覆写** (overwrite-in-place), 绝不 append:
- 预算 ~15-20 行: 当前 phase + 活跃阻塞 + 版本号一行 + 关键指针
- 版本明细指向 CHANGELOG; session 明细指向 handoff; 细节一律**指针化**
- 查询当前状态用 `/state-scanner` (读 live 项目文件), 不靠 CLAUDE.md 历史

## 3. Enforcement

`.aria/state-checks.yaml` 的 `claude-md-changelog-free` check (state-scanner Phase 1.11 每次扫描执行):
- 检出 footer 滚动 changelog 条目 (`^> 前次` / `^**更新**:`) 数 > 0 → FAIL
- 检出 CLAUDE.md 行数超预算 (疑似 changelog 回涨) → FAIL
- severity: warning (advisory-over-hardlock; 提示而非阻断)

这是根因兜底: 防"砍完又长回来"。

## 4. 与其他规范的关系
- **Rule #9 `session-handoff.md`**: session 进展的 canonical 家; 本规范把 CLAUDE.md 的 session 流水导向它。
- **`changelog-format.md` / `version-management.md`**: 版本 changelog 的 SOT 与格式; 本规范禁止在 CLAUDE.md 内联复制。
- **`document-classification.md`**: 文档四大分类; CLAUDE.md 属"AI 上下文"类, 本规范细化其内容边界。

---

**维护**: 10CG Lab
