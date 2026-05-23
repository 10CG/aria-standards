# Nomad Docker Registry Auth

> **Version**: 1.0.0
> **Created**: 2026-05-23
> **Status**: Active
> **Source**: Aria DEC-20260523-001 + M5 Phase C O3 cold-pull empirical evidence

---

## §0 Rationale + Observed contradiction

Nomad docker driver 从 private registry pull image 时,**task-level `config { auth { ... } }` block + template-stanza-injected env var (e.g. `${REGISTRY_TOKEN}`) 的组合不可靠**。本 convention 强制改用**节点级 `plugin "docker" { config { auth { config = "<docker-config-path>" } } }`** 作为 SOT,task HCL 禁止内联 `auth { ... }` block。

### Observed empirical contradiction (must surface)

| Date | Context | Nomad ver | Result | Evidence path |
|------|---------|-----------|--------|---------------|
| 2026-04-23 | Aether spike (controlled, 11.5MB private image, cache pre-cleared) | < v1.11.2 | **GO** — template `${VAR}` + task auth block 正常工作 | Aether `openspec/archive/2026-04-22-fix-hardcoded-docker-auth/` |
| 2026-05-23 | Aria M5 Phase C O3 (cold-pull live, large image) | **v1.11.2** + Forgejo registry 11.0.6 | **FAIL** — `${VAR}` interp 在 docker driver invocation 前未 resolve, 401 | Aria M5 handoff §3 R2 |

两次实测**同 cluster 30 天前 GO / 现在 FAIL**。本 convention **不假装能解释根因**(可能因素: Nomad 版本升级 / image 大小 / `force_pull` flag / registry 升级),但**取严格立场** — 当前 Aria 实测为 ground truth SOT,禁用 task-level `auth { ${VAR} }` 模式。

适用条件: **Nomad task 使用 `template { env = true }` stanza 注入 env + HCL `config.auth` 块组合**。其他注入模式(envsubst / deploy-time substitution, e.g. `__REGISTRY_TOKEN__`)**不在本 convention scope**(见 §3 + §8)。

---

## §1 Problem statement

### Symptom

`nomad alloc status <id>` 显示 `Recent Events: Driver failure ... docker pull failed: 401 unauthorized` 或等价 registry auth 错误。

### Conditions reproducing the failure

1. HCL task 含:
   ```hcl
   task "X" {
     driver = "docker"
     config {
       image = "<registry>/<image>:<tag>"
       auth {
         username = "<bot-username>"
         password = "${<TEMPLATE_VAR>}"
       }
     }
     template {
       data = "<TEMPLATE_VAR>={{ .Data.data.<key> }}"
       env  = true
     }
   }
   ```
2. Nomad client docker plugin 未 wire 节点级 `auth.config`, 或已 wire 但 task-level block 在 override。
3. 触发条件: cold-pull (image 不在 node cache) — registry GC / image_delay 过期 / 新节点。

### Root cause

- `${<TEMPLATE_VAR>}` 在 **template stanza runtime** 渲染 (consul-template) 写入 `/secrets/*.env` 文件 → source 到 task **process env**
- 但 **docker driver image pull 发生在 task process 启动之前** (Nomad alloc lifecycle: alloc placement → image pull → container create → process start → template render → task start)
- 因此 docker driver 处理 `config.auth { password = "${<TEMPLATE_VAR>}" }` 时, `${<TEMPLATE_VAR>}` 仍是 unresolved literal (或空字符串, Nomad 版本依赖)
- registry 收到空/literal password → 401

对比: `${NOMAD_META_*}` 是 **Nomad native interpolation**, 在 driver invocation **之前**解析,工作正常 (e.g. `image = "<registry>/<image>@sha256:${NOMAD_META_IMAGE_SHA}"` 同 task 同 config 块内 work)。

---

## §2 Mechanism — Why task-level `auth` block fails

Nomad alloc lifecycle (相关阶段):

```
1. alloc placement (scheduler picks node)
2. Nomad native interpolation (${NOMAD_*} resolved, including ${NOMAD_META_*})
3. ── docker driver image pull ──   ← config.auth { } read here
4. container create
5. template render (consul-template → /secrets/*.env)
6. task process start (env 注入 from /secrets/*.env)
```

→ `config.auth { password = "${<TEMPLATE_VAR>}" }` 在阶段 3 被读, 但 `<TEMPLATE_VAR>` 在阶段 5 才 resolve。**时序错位**。

唯一可靠路径: cred 在阶段 3 **之前**就已经 ready, 不通过 task config 携带:
- **节点级 plugin auth.config 文件** — Nomad docker driver init 时读, 阶段 3 已 available
- **`auth_helper` 命令** — driver invoke 外部 cred helper, 阶段 3 同步 available
- **Vault `vault {}` stanza** — 与 template 同时机 (阶段 5), 不解决问题

本 convention 推荐 **节点级 plugin auth.config**。

---

## §3 Forbidden pattern

### ❌ DO NOT use

```hcl
task "X" {
  driver = "docker"
  config {
    image = "<registry>/<image>:<tag>"
    auth {
      username = "<bot-username>"
      password = "${<TEMPLATE_VAR>}"   # ❌ template env not ready at pull time
    }
  }
  template {
    data = "<TEMPLATE_VAR>={{ .Data.data.<key> }}"
    env  = true
  }
}
```

### Scope boundary

本 convention 适用:
- ✅ Task-level `config.auth` block 配合 `template { env = true }` stanza 注入 `${VAR}` 模式

本 convention **不适用**:
- ❌ `envsubst` / deploy-time substitution 模式 (e.g. `__REGISTRY_TOKEN__` placeholder 由 CI/ops 在 `nomad job run` 前 substitute, Nomad 看到的是 literal cred) — 这种模式不撞时序问题但仍违反 secret-hygiene Rule #7 (cred 在 file 中明文), 由 `secret-hygiene.md` 治理
- ❌ Vault `vault {}` stanza 模式 — Aether #32 Workload Identity 范畴, 独立架构演进

---

## §4 SOT pattern — 节点级 plugin auth.config

### 4.1 Nomad client config (HCL)

每节点 Nomad client config (e.g. `/opt/nomad/config/client.hcl`) 含:

```hcl
plugin "docker" {
  config {
    auth {
      config = "<docker-config-path>"   # 推荐: /root/.docker/config.json
    }
    # other docker driver config (volumes / allow_privileged / etc.)
  }
}
```

`<docker-config-path>` 路径推荐 `/root/.docker/config.json` (与 docker daemon 默认对齐), 但任意 root-readable path 均可 (e.g. `/etc/nomad/docker-auth.json`)。Lab 内统一选 path 防 cross-project drift。

### 4.2 Auth file schema

`<docker-config-path>` 文件内容:

```json
{
  "auths": {
    "<registry-host>": {
      "auth": "<base64(<bot-username>:<bot-pat>)>"
    }
  }
}
```

**Schema 规范**:
- `email` 字段**不需要** (Nomad docker driver 读 `auth` 字段, 忽略 email)
- `auth` 值必须是标准 base64 of `username:password`, **无 URL-safe variant / 无 line breaks / 无 padding 变体**
- Nomad driver per-alloc 读此文件 (filesystem read per dispatch), **不需要重启 Nomad client**;仅当 client.hcl 中 `auth.config` **路径**变更才需 `systemctl restart nomad`

### 4.3 base64 encoding 规范

```bash
printf '%s' '<bot-username>:<bot-pat>' | base64 -w0
```

`-w0` flag **必须** — 防 76-char line-wrap, 某些平台 (e.g. macOS BSD base64) decode 会因 line break 失败。

---

## §5 PAT rotation playbook (Nomad-specific only)

> 本段只覆盖 Nomad-specific 部分 (atomic 多节点 sync + round-trip verify)。
> **`docker login` 安全 pattern + chat-leak 防护**: 见 [`secret-hygiene.md §2.4 + §3.6`](./secret-hygiene.md#26-container-registry-login) (单向 reference, 不重复)。

### 5.1 Atomic multi-node sync 顺序

切忌"半部署"状态 (some nodes have new cred, others have old) — 会导致 cold-pull 部分节点 401, 难诊断:

1. **本机准备** `<docker-config-path>.new` 文件 (含新 cred), 不在 chat 出现 cred 字面值
2. **scp atomic** 到所有节点 `/tmp/<docker-config-path-basename>.new` (并行)
3. **fingerprint verify** 每节点新文件:
   ```bash
   ssh <node-N> "python3 -c 'import json,hashlib; d=json.load(open(\"/tmp/<docker-config-path-basename>.new\")); print(hashlib.sha256(d[\"auths\"][\"<registry-host>\"][\"auth\"].encode()).hexdigest()[:12])'"
   ```
   全节点输出同 12-char SHA prefix ⇒ 同步一致
4. **atomic rename** 每节点 `mv -f /tmp/<docker-config-path-basename>.new <docker-config-path>` (并行, fail-safe)
5. **round-trip verify** 每节点新 cred 有效 (per `secret-hygiene.md §3.6` docker login --password-stdin pattern, 返回 HTTP 200 即可, cred 不出现在 process args)

### 5.2 No chat-leak invariant

- Cred 字面值 **永不**在 chat / log / ssh stdout / process args 出现
- fingerprint = SHA prefix (12 char) 是 chat-safe 唯一证据
- round-trip HTTP 200 是 cred valid 唯一证据 — 不要让 curl 把 cred 字面 echo

---

## §6 References

- **M5 Phase C O3 实证**: Aria `docs/handoff/2026-05-23-m5-phase-c-o3-done-d2-close.md` §3 R2 + §4 实战教训
- **Aether spike GO (历史)**: Aether `openspec/archive/2026-04-22-fix-hardcoded-docker-auth/proposal.md` (alloc d360435e, 2026-04-23)
- **Aria Spec (本 convention 来源)**: `openspec/archive/2026-05-23-aria-layer2-docker-auth-cold-pull-fix/` (post-archive path)
- **Aria DEC**: `.aria/decisions/2026-05-23-layer2-docker-auth-cold-pull-fix.md`
- **Aether follow-up Spec slot** (待补): `Aether openspec/changes/fix-hardcoded-docker-auth-node-login/` (per Aether Issue #45)
- **Cross-ref**: [`secret-hygiene.md`](./secret-hygiene.md) (Rule #7 SOT;§2.4 + §3.6 docker login 安全 pattern)

---

## §7 Verification checklist (for existing Nomad HCL projects)

适用 Lab 内任何使用 Nomad docker driver 的项目 self-audit:

```bash
# §7.1 找所有 task-level auth block
grep -rcE '^\s*auth\s*\{' <project-root>/nomad/jobs/ <project-root>/deploy/

# §7.2 找 template-stanza-injected env var 在 config.auth.password 引用
grep -rnE 'password\s*=\s*"\$\{' <project-root>/nomad/jobs/ <project-root>/deploy/

# §7.3 verify 节点级 plugin auth.config 已 wire (每节点)
ssh <node-N> 'grep -A 3 "plugin \"docker\"" /opt/nomad/config/client.hcl 2>/dev/null | grep -c "auth.config"'

# §7.4 verify <docker-config-path> 文件存在 + 含目标 registry
ssh <node-N> 'python3 -c "import json; d=json.load(open(\"<docker-config-path>\")); print(\"<registry-host>\" in d.get(\"auths\",{}))"'
```

**Action**: §7.1 输出 > 0 OR §7.2 输出 > 0 ⇒ 项目有 forbidden pattern, 走 §8 migration。§7.3 OR §7.4 输出 false ⇒ 节点级 plugin SOT 缺, 不能简单删 task auth block (会全 fail)。

---

## §8 Migration path

从 forbidden pattern (§3) 迁移到 SOT (§4) 的标准步骤:

### Phase 1 — Probe

1. 用 §7 checklist audit 项目 Nomad HCL + 集群节点状态
2. 决定:
   - (a) 节点级 plugin **已 wire** + cred **已存在 + 有效** → 直接走 Phase 2 删 task auth block
   - (b) 节点级 plugin **已 wire** 但 cred **缺/stale** → 先走 §5 atomic sync, 再 Phase 2
   - (c) 节点级 plugin **未 wire** → 先改集群 `client.hcl` + restart Nomad + deploy `<docker-config-path>`, 再 Phase 2

### Phase 2 — HCL edits

1. 删 HCL 中 task-level `config.auth { ... }` block
2. 加 comment 注明 "Auth: 节点级 plugin auth.config (per nomad-docker-registry-auth.md);DO NOT re-add task-level auth"
3. 若 template stanza 唯一用途是注入 registry cred, **同步删 template stanza** (减少 attack surface)

### Phase 3 — Verify

1. cold-pull live test per node:
   ```bash
   ssh <node-N> "docker rmi -f <registry>/<image>@sha256:<digest>"
   nomad job dispatch <job-name>
   nomad alloc status <alloc-id> | grep 'Node Name'   # verify 落到 target node
   nomad alloc logs <alloc-id> 2>&1 | grep -E 'Pulling from|Downloading'   # verify 真冷拉
   ```
2. 3 节点 (或 cluster 全节点子集) PASS ⇒ migration done

### Scope clarifications

- **envsubst 模式** (`__REGISTRY_TOKEN__` placeholder, CI substitute) **不需要** migrate (不撞时序问题), 但建议同步 audit cred rotation 流程 + 走 `secret-hygiene.md §2.4` SOT
- **Vault stanza 模式** 不在本 convention scope, 由 Aether #32 Workload Identity 治理

---

**Last updated**: 2026-05-23
**Source SOT**: Aria DEC-20260523-001 + M5 Phase C O3 实证
**Cross-projects**: 适用 10CG/* 使用 Nomad docker driver + private registry 的项目 (Aria / Aether / SilkNode / Kairos / Kino / psych-ai-supervision / truffle-hound)
