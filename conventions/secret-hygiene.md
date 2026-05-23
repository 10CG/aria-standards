# Secret Hygiene 规范

> **Version**: 1.1.0
> **Status**: Active
> **Source incidents**:
> - 2026-05-02 (Aria US-022 T8) — `nomad job inspect` 全量 dump runtime env 泄露 4 keys
> - 2026-05-06 (truffle-hound v0.3.2) — Python `subprocess.run(['nomad','var','put',...])` 默认继承 stdio, 泄露 4 keys
> - 2026-05-20 (Aria M5 T-deploy Phase B) — `nomad var get -out=json` 8-key Items map 全 dump → 触发 5-key rotation + Layer 2 紧急 cherry-pick
> **Forgejo Issue**: [10CG/Aria#78](https://forgejo.10cg.pub/10CG/Aria/issues/78), [#84](https://forgejo.10cg.pub/10CG/Aria/issues/84), [#107](https://forgejo.10cg.pub/10CG/Aria/issues/107)
> **Origin Spec**: `openspec/archive/<date>-aria-secret-hygiene-rule`
> **Layer 2 Spec**: `openspec/archive/<date>-aria-secret-guard-plugin-default` (v1.1.0 升级来源)

---

## 0. Path ↔ Layer mapping

本规范定义 3 条互补的 enforcement path,对应 2 层 defense-in-depth:

| Path | 性质 | Layer | 实施位置 | 触发时机 | 失败模式 |
|------|------|-------|----------|---------|---------|
| **Path 1** | Prose convention (本文档) | **Layer 0** (doc-only) | `standards/conventions/secret-hygiene.md` | Onboarding / PR review / human discipline | 取决于人/AI 是否读 + 是否遵守 (soft) |
| **Path 2** | Inline annotation | (无独立 layer,贯穿 Layer 0/2) | 命令前 `# secret-leak-ok-explicit` 三件套 (理由 + 隔离 + sign-off) | Per-command opt-out / 紧急豁免 | 注释缺失即视同未豁免;Layer 2 hook 同步识别 `# guard:ack:` |
| **Path 3** | PreToolUse + PostToolUse hook | **Layer 2** (mechanical enforcement) | `aria/hooks/{secret-guard,secret-scan}.sh` (aria-plugin SOT, v1.24.0+) | Claude Code tool 调用前/后, 自动触发 | 失败模式由 hook 自身 audit 覆盖 (251 self-tests + cross-project dogfood) |

> **Path 1 vs Path 3 关系**: Path 1 (Layer 0) 是教育路径与 source-of-truth (§2 受限命令清单是 Path 3 regex matcher 的语义参照);Path 3 (Layer 2) 是机械执行 — 两者**并存且互补**,不互替代。

> **Why no "Layer 1"?**: Layer 1 在 Aria 内部其他语境用于指代 "post-incident rotation" (key 已泄露后立即轮换),与 enforcement 编排无关,故本规范的 enforcement layer 编号跳过 1。

---

## 1. 核心条款

> **Secret-writing/reading commands MUST NOT echo secret values to chat-visible streams.**

任何**读取或写入 secret 值**的 shell 命令**必须**:

- **Bash**: `cmd >/dev/null 2>&1` 或 `cmd 2>&1 | grep -v '<secret-pattern>'`
- **Python `subprocess`**: `capture_output=True` (且不 print stdout) 或 `stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL`
- **Verification**: 通过 metadata 验证 (HTTP status code / exit code / 字段长度 / `nomad var get -out=keys` 仅取 key 名), 不读 secret value 字面

### 1.1 Forbidden patterns

- ❌ Pipe secret 命令 output 到任何 chat-visible / log-persistent stream
- ❌ Python `subprocess.run([...secret cmd...])` 不 override stdio (默认行为继承 parent)
- ❌ `cat <key-file>` / `echo $SECRET_VAR` / `env | grep <secret>` 在 AI session 内
- ❌ "round-trip 验证" 通过 echo set + read value 字面对比 (用 metadata 替代)

### 1.2 Exception annotation (rare)

若**确实必须** echo (e.g., debug in isolated env, 无 chat / 无 log 持久化), 用以下注释标识豁免:

```bash
# secret-leak-ok-explicit
# Reason: <为何必须 echo>
# Isolation evidence: <隔离环境证据 — 无 chat 通道 / 无 log persist>
# Owner sign-off: <owner-id> <date>
nomad var get nomad/jobs/X
```

```python
# secret-leak-ok-explicit
# Reason: <...>
# Isolation evidence: <...>
# Owner sign-off: <owner-id> <date>
result = subprocess.run(['nomad', 'var', 'get', ...])
print(result.stdout)
```

**该注释必须包含理由 + 隔离环境证据 + owner sign-off**。无三件套的注释视同未豁免。

---

## 2. Scope (受限命令清单, non-exhaustive 启发式)

任何符合"成功响应回显 secret value"模式的命令均受本规则约束。已知列表:

### 2.1 Secret store 写入/读取

| 工具 | 命令 |
|------|------|
| Nomad Variables | `nomad var put`, `nomad var get`, `nomad var purge` |
| Kubernetes | `kubectl create secret`, `kubectl apply -f <secret-manifest>`, `kubectl get secret -o yaml` |
| HashiCorp Vault | `vault kv put`, `vault kv get`, `vault write`, `vault read` |
| Forgejo / Gitea | `forgejo POST /tokens`, `forgejo GET /users/:user/tokens`, `forgejo POST /repos/.../keys` |
| GitHub | `gh secret set`, `gh secret list`, `gh api /repos/.../secrets`, `gh auth token` |
| AWS Secrets Manager | `aws secretsmanager create-secret/put-secret-value/update-secret/get-secret-value` |
| GCP Secret Manager | `gcloud secrets versions access`, `gcloud secrets create`, `gcloud secrets versions add` |
| Azure Key Vault | `az keyvault secret show`, `az keyvault secret set` |

### 2.2 Credential 文件操作

| 操作 | 命令 |
|------|------|
| Read priv key | `cat <key-file>.{key,pem,priv,p12}`, `head/tail <key-file>` |
| Write priv key | `ssh-keygen` (生成后 `cat` 私钥), `openssl genrsa/ecparam ... -out <key>` |
| Show env | `env`, `printenv`, `set` (含 secret env vars 时) |

### 2.3 Database password commands

| DB | 命令 |
|----|------|
| PostgreSQL | `psql -c "ALTER USER ... PASSWORD '...'"`, `\password` |
| MySQL/MariaDB | `mysql -e "SET PASSWORD ..."`, `mysqladmin password` |
| MongoDB | `db.changeUserPassword(...)` |

### 2.4 Container registry login

| 工具 | 命令 |
|------|------|
| Docker | `docker login` (无 `--password-stdin` 时) |
| Helm | `helm registry login` (无 stdin pipe 时) |

### 2.5 Inspection 命令含 secret 字段

| 工具 | 命令 |
|------|------|
| Nomad | `nomad job inspect`, `nomad alloc status -json` (含 runtime env) |
| Kubernetes | `kubectl describe pod` (envFrom secret 时), `kubectl exec ... env` |
| Cluster status | `aether status --json` (若 wrap 上述) |

> **原则**: 任何输出 contains secret value 的命令 = 受限命令; 清单仅枚举常见, 实际触发应该问 "本命令成功输出会包含 secret 字面值吗?", yes 即受限。

---

## 3. 正向 patterns (强烈推荐)

### 3.1 Python — `capture_output=True` (推荐)

```python
import subprocess

# ✅ secret 写入: 捕获 output, 用 returncode 验, 不 print
result = subprocess.run(
    ['nomad', 'var', 'put', '-force', 'nomad/jobs/myapp', f'KEY={value}'],
    capture_output=True,
    check=True,
    timeout=30,
)
# stdout 在 result.stdout 但不 print; check=True 已抛异常 if 失败
assert result.returncode == 0
```

### 3.2 Python — 显式 DEVNULL

```python
import subprocess

# ✅ secret 写入: 显式丢弃 stdio
subprocess.run(
    ['nomad', 'var', 'put', '-force', 'nomad/jobs/myapp', f'KEY={value}'],
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL,
    check=True,
    timeout=30,
)
```

### 3.3 Python — Validation via metadata only

```python
# ✅ 验证 secret 已写入: 用 nomad var get -out=keys 仅取 key 列表 (无 value)
result = subprocess.run(
    ['nomad', 'var', 'get', '-out=keys', 'nomad/jobs/myapp'],
    capture_output=True, check=True, text=True,
)
assert 'KEY' in result.stdout.split()  # 仅检查 key 名存在, 不读 value
```

### 3.4 Bash — 全部 redirect (推荐)

```bash
# ✅ secret 写入: 全 redirect
nomad var put -force nomad/jobs/myapp KEY="$VAL" >/dev/null 2>&1

# ✅ 验证 (取 key 名仅): -out=keys 不输出 value
keys=$(nomad var get -out=keys nomad/jobs/myapp 2>/dev/null)
echo "$keys" | grep -q '^KEY$' && echo "OK"
```

### 3.5 Bash — Pipe filter (备选, 较脆弱)

```bash
# ⚠️  备选 — 用 grep -v 过滤 secret pattern 行
# 警告: pattern 必须精确, 否则 stderr 中其他匹配字符串会被误删
nomad var put -force nomad/jobs/myapp KEY="$VAL" 2>&1 \
    | grep -v -E '(Items|"Value":|"KEY":|Secret)'
```

### 3.6 Docker login

```bash
# ✅ Docker login: --password-stdin 防 stdout echo password
echo "$REGISTRY_PASSWORD" | docker login -u "$REGISTRY_USER" --password-stdin registry.example.com
```

### 3.7 Forgejo/GitHub token create

```bash
# ✅ Forgejo: 创建 token 后立即 redirect (token 仅在创建响应中可见, 之后只能 revoke)
forgejo POST /users/myuser/tokens -d '{"name":"mybot"}' | jq -r '.sha1' > /run/secrets/token
# ↑ 仅 token sha1 写入文件, response body 不到 stdout
```

---

## 4. 反例 (禁止 patterns)

### 4.1 Python — 默认 inherit stdio

```python
# ❌ leaks to chat: subprocess 默认 inherit parent stdio
subprocess.run(['nomad', 'var', 'put', ...])
# Python subprocess 默认 stdout=None, stderr=None 表示 inherit
# nomad var put 成功响应包含完整 Items map → AI tool result → chat 历史
```

### 4.2 Python — capture 后又 print

```python
# ❌ leaks: capture 然后 print 等于没 capture
result = subprocess.run([...], capture_output=True)
print(result.stdout)  # ← 反正 leak 了
```

### 4.3 Bash — 默认 stdio

```bash
# ❌ leaks
nomad var put ...
```

### 4.4 Round-trip 验证

```bash
# ❌ leaks: 用 echo set + read value 字面对比"验证"
nomad var put ... KEY="$VAL"
GOT=$(nomad var get nomad/jobs/myapp | jq -r '.Items.KEY')
[ "$GOT" = "$VAL" ] && echo OK
# 上行 "$GOT" 已经持有 secret value, 任何后续 echo / log 都泄露
```

正确替代: 用 `nomad var get -out=keys` 检查 key 存在, 不读 value (见 §3.3)。

---

## 5. Layer 2 enforcement (Path 3 PreToolUse + PostToolUse hook)

aria-plugin v1.24.0+ ship **`aria/hooks/secret-guard.sh` + `aria/hooks/secret-scan.sh`** 作为 Layer 2 mechanical enforcement, 自动注册到 `aria/hooks/hooks.json` 的 PreToolUse + PostToolUse,所有装 aria-plugin 的项目默认获保护。

### 5.1 Plugin SOT 路径

| 文件 | 角色 | 注册 matcher |
|------|------|-------------|
| `aria/hooks/secret-guard.sh` | PreToolUse Bash + Read/Edit/Write/MultiEdit blocker | `Bash` + `Read\|Edit\|Write\|MultiEdit` |
| `aria/hooks/secret-scan.sh` | PostToolUse output 扫描 + REDACT | `Bash\|Read\|Edit\|Write\|MultiEdit` |
| `aria/hooks/tests/secret-guard.test.sh` | 208 regression cases (含 `${CLAUDE_PLUGIN_ROOT}` substitution test) | n/a |
| `aria/hooks/tests/secret-scan.test.sh` | 44 regression cases | n/a |

> **NotebookEdit 不注册** (v1.24.0 决定): `.ipynb` cell 多用于实验代码,内联 secret 概率低 + ack 路径足够 — 后续 minor 可加。

### 5.2 Exit semantics

- **PreToolUse `secret-guard.sh`**: `exit 2` = block;`exit 0` = allow。Block 时 stderr 显示 helpful 消息(matched pattern + acceptable filters list + ack 模板)。
- **PostToolUse `secret-scan.sh`**: **`exit 0` always** (warn-only)。Tool 已执行完成,exit 2 不能 retroactively block;stderr 显示 REDACTED summary + tool_response 已被改写(secret value 替换为占位)。

### 5.3 Path 2 exception (inline `# guard:ack:` annotation)

Path 1 §1.2 的 `# secret-leak-ok-explicit` 三件套(理由 + 隔离 + sign-off)在 Layer 0 上**人/AI review-only**。Layer 2 hook 同步识别**简化版** `# guard:ack: <reason ≥ 8 non-whitespace chars>` 作 per-command bypass:

```bash
# 命令尾加 ack 注释, Layer 2 hook 检测后 skip block + log to ~/.claude/logs/guard-bypass.log
nomad var get nomad/jobs/X  # guard:ack: M5 R5.3 validator install pre-check, isolated dev env, owner sign-off
```

> Layer 2 ack 路径**不替代** Path 2 三件套规范 —— 三件套是 Path 1 教育规范要求(commit/PR review-time);ack 注释是 Layer 2 runtime gate 的快速 escape。两者并存:严肃豁免应在 commit 中提供 Path 2 三件套,Layer 2 ack 只是当下 unblock 的便捷快门。

### 5.4 Q1 evidence boundary (hook orchestrator merge 语义)

aria-secret-guard-plugin-default Spec brainstorm 跑过 5-trial instrumented test (project-level + plugin-level hook 各注入 marker + file-toggle exit 2),实证 **Claude Code 同事件多源 hook merge 语义**:

| 维度 | 实证结果 | 设计含义 |
|------|---------|---------|
| 同事件多源 hook 触发 | **All-fire** (project + plugin 都跑) | Layer 2 + 项目本地 copy 共存可行,双重防线生效 |
| 触发顺序 | project → plugin, **~17-34ms gap (sequential)** | overhead 可忽略,不并行 |
| Exit 2 是否短路后续 hook | **不短路** | 任一 hook exit 2 即整体 block;设计 block 策略不能依赖前置 short-circuit |
| Block reporting | 仅 stderr 显示触发 block 的那个 hook 路径 | 用 `$CLAUDE_PROJECT_DIR/...` vs `${CLAUDE_PLUGIN_ROOT}/...` 区分 source |

> **实证边界**: 该 5-trial 实验在 **Write event PreToolUse** 上跑(用 `handoff-location-guard.sh` 作 proxy)。**Bash + PostToolUse 推论**: hook orchestrator 是 Claude Code 框架同一组件,merge 语义 by spec 适用于所有 hook event;`secret-guard.sh` 自身行为由 251 self-tests + cross-project dogfood 覆盖。所以 Layer 2 设计可信赖 all-fire + non-short-circuit 在 Bash + PostToolUse 上同样成立,**但严格意义上只直接验证了 Write/PreToolUse**;若未来发现 Bash event merge 异常需 fall back to design,这是预先记录的 known-evidence-gap。memory: `feedback_claude_code_hook_merge_all_fire`。

### 5.5 Path 1 与 Layer 2 互补关系

Layer 2 ship 后,本 Path 1 文档继续作为:

- **命令清单 source-of-truth** — Layer 2 regex matcher 的语义参照(§2 受限命令清单)
- **教育路径** — 新加入项目 onboarding 必读
- **Exception annotation 规则 SOT** — `# secret-leak-ok-explicit` 三件套规范
- **Layer 2 known-limitation 全集** — Path 1 文档显式记录 Layer 2 已知 false-positive + false-negative(见 aria-plugin CHANGELOG [1.24.0]):
  - (a) `cat <script> && grep .env <script>` conservative regex 误拦(false-positive)
  - (b) log-file grep 不在 risky_patterns 内的 false-negative(parent DEC §2.6)
- **追踪 follow-up**: 见 [Forgejo Aria #84](https://forgejo.10cg.pub/10CG/Aria/issues/84) (closed via v1.24.0) + [#107](https://forgejo.10cg.pub/10CG/Aria/issues/107) (closed via v1.24.0)

---

## 6. Local copy + plugin coexist 模式

部分早期项目(Aria self / SilkNode)在 Layer 2 ship 前已 manual cherry-pick secret-guard hook 到 `.claude/scripts/`。Layer 2 ship 后,本地 copy 与 plugin SOT **并存**(per §5.4 Q1 实证: all-fire merge,双重防线)。

aria-plugin `aria-doctor` skill 提供 `check_secret_guard_install()` function 输出 **5 primary states + 2 sub-flags** 协助判断当前项目是否需 cleanup:

| state | 含义 | sub flags |
|-------|------|-----------|
| `not_installed` | 既无 `${CLAUDE_PROJECT_DIR}/.claude/scripts/secret-guard.sh` 也无 plugin hook 加载 (异常,不应在 plugin default-on 环境出现) | `plugin_load_failed` |
| `single_plugin` | 仅 plugin hook 活跃,无项目本地 copy (**新项目预期态**) | (none) |
| `single_local` | 仅项目本地 copy + `.claude/settings.json` 注册,plugin hook 未加载 (异常,建议查 plugin 状态 OR plugin version < v1.24.0) | (advisory only) |
| `dual_install` | plugin + 项目本地 copy 并存 (**Layer 2 ship 后 Aria self / SilkNode 预期态**,双重防线 by design) | `stale_local_version` / `divergent_content` |
| `corrupted_settings` | `.claude/settings.json` 解析失败 / hook 注册条目 malformed | (mutex with above) |

> **Sub flag 检测**: `stale_local_version` 通过本地 `.claude/scripts/secret-guard.sh` 顶部 banner version 解析(v1.2 已有 banner)与 plugin SOT 比较;`divergent_content` 通过 SHA256 对比。

**Cleanup 策略**:

- `dual_install + 无 sub-flag`: **保留** — 双重防线,Layer 2 ship 后**默认推荐保留**至少一个 next minor 周期作 fallback
- `dual_install + stale_local_version`: owner 决定是 sync 本地到 plugin SOT,还是删本地保 plugin SOT
- `dual_install + divergent_content`: 必须 investigate 差异(可能 owner 本地有定制 — 应被 upstream 或保留 Path 2 ack);不要盲删
- `single_local + plugin version >= v1.24.0`: 大概率 plugin 未正确加载 — 跑 `aria-doctor` 详查
- `single_plugin`: 新项目预期态,无 action

**aria-doctor skill 详细 schema + advisory text**: `aria/skills/aria-doctor/SKILL.md`(v1.24.0+)。

> **Schema backwards-compat guarantee**: 后续 minor 仅可 **append** sub flags,不可重命名 primary state(per memory `feedback_deterministic_structural_skill_rule6_substitute` atomicity guard)。

---

## 7. 触发该规则的项目角色

| 角色 | 触发频率 | 主要场景 |
|------|----------|----------|
| Owner (人类) | 中 | 配置 secret rotation / 跨集群 deploy |
| AI assistant (Claude Code etc.) | **高** | 任何写入 secret 操作; subprocess inherit stdio 是默认行为陷阱 |
| CI/CD pipeline | 中 | secret 注入 build / deploy step |

**AI assistant 特别注意**: 默认假设命令 stdout"只是日志"会触发本规则; 必须主动检查命令是否在 §2 scope, 是即强制 redirect。

---

## 8. 与既有规范的关系

| 规范 | 关系 |
|------|------|
| `standards/conventions/git-commit.md` | 不冲突; secret 不应进 commit message (本 SOP 隐含) |
| `.aria/decisions/2026-05-02-secret-rotation-deferred.md` | rotation SOP, 关注密钥轮换调度; 本规则关注操作时不 leak |
| `feedback_secrets_never_in_conversation.md` (memory) | 个人 memory 教训; 本规则是项目级 SOP, memory 引用本文档作为 forward-looking reference |
| `feedback_nomad_inspect_secret_leak.md` (memory) | 同上 |

---

## 9. 历史 incidents

| 日期 | Project | 命令 | 泄露规模 | 修复 |
|------|---------|------|----------|------|
| 2026-05-02 | Aria | `nomad job inspect`, `aether status --json` | 4 keys (GLM_API_KEY + 3 FEISHU_*) | rotation deferred to T13 (`.aria/decisions/2026-05-02-secret-rotation-deferred.md`) |
| 2026-05-06 | truffle-hound | Python `subprocess.run(['nomad','var','put',...])` 默认 stdio | 4 keys (feishu_app_secret / LUXENO_API_KEY / FORGEJO_TOKEN / cf_access_client_secret) | 见 truffle-hound `reports/incident-2026-05-06-secret-leak-via-subprocess.md` |

---

## 10. 版本历史

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-05-07 | 初版 (Path 1 doc-only). 含核心条款 + 9 类受限命令 scope + 7 正向 pattern + 4 反例 + Path 3 hook 关系 + 8 历史 incidents. 来源: Forgejo Issue #78 + Aria 自身 2 次 incident memory feedback. |
| 1.1.0 | 2026-05-23 | **Additive** (Layer 2 ship): 新增 §0 Path↔Layer mapping table (Path 1↔Layer 0 / Path 2↔inline / Path 3↔Layer 2) + §5 重写为 Layer 2 enforcement (含 plugin SOT 路径 / exit semantics / Path 2 inline ack 与 §1.2 三件套互补关系 / Q1 hook orchestrator merge 实证 + 边界声明 / Path 1 与 Layer 2 互补关系含 known-limitation 全集) + 新 §6 local copy + plugin coexist 模式 (5-state aria-doctor pointer + cleanup 策略 + backwards-compat guarantee) + 2026-05-20 incident 追加 + Forgejo issue refs (#84, #107)。零 breaking change,Path 1 教育规范 + §2 scope + §3 正向 pattern + §4 反例全保留。来源: Spec [aria-secret-guard-plugin-default](../../openspec/archive/<date>-aria-secret-guard-plugin-default/) + memory `feedback_claude_code_hook_merge_all_fire` (Q1 实证) + memory `feedback_deterministic_structural_skill_rule6_substitute` (atomicity guard)。 |
