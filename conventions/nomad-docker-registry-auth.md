# Nomad Docker Registry Auth

> **Version**: 2.1.0
> **Created**: 2026-05-23
> **Revised**: 2026-07-19 (v2.1.0 — §3.1 共享宿主 `docker logout` 禁令, 两起 wipe 归因后加)
> **Revised**: 2026-07-12 (**v1.0.0 的禁令被实证推翻并撤销** — 见 §0)
> **Status**: Active
> **Source**: 2026-07-12 判别式实测 (Nomad v1.11.2) + [Aether #234](https://forgejo.10cg.pub/10CG/Aether/issues/234) / [Aether #46](https://forgejo.10cg.pub/10CG/Aether/issues/46)
> **Supersedes**: v1.0.0 (Aria DEC-20260523-001 — 禁用 task-level auth, 节点级 auth.config 为 SOT)

---

## §0 v1.0.0 发生了什么 (必读)

**v1.0.0 (2026-05-23) 禁止 task-level `config.auth` + `template{env=true}` 组合**, 理由是一个**时序断言**:

> docker driver image pull 发生在 template render **之前** → `${VAR}` 在 pull 时仍是 unresolved literal 或空 → registry 收到空 password → 401

并据此把**节点级 `plugin "docker" { auth { config = ... } }` 定为 SOT**。

**2026-07-12 实测: 该时序断言为假。** 在**同一集群、同一 Nomad 版本 (v1.11.2, 未升级)**、并且复刻了 Aria 自己的 job 形态之后, task-level auth + template env **工作正常**。禁令**撤销**, SOT **反转** (见 §3)。

### 为什么这不是"两次实测各说各话"

关键在于**验证方法**, 不在于跑了几次。节点级凭据当时是**健康**的 —— 所以"拉得动镜像"**不构成任何证据** (可能是 job auth 生效, 也可能是 driver 回退用了节点凭据, 两者观感完全一样)。必须做**判别式实验**: 给 job 级凭据注入**错误值**, 要求它**硬失败**。

| 实验 (均为 Nomad v1.11.2 + `force_pull = true` 强制真实冷拉) | 正确凭据 | **故意写错**的凭据 |
|---|---|---|
| 普通 batch job + 静态 tag | ✅ `Driver: Downloading image` → Exit 0 | ❌ `401 Unauthorized` |
| **parameterized (dispatch) + `image = repo@sha256:${NOMAD_META_IMAGE_SHA}`** ← **v1.0.0 失败时的形态** | ✅ `Downloading image` → Exit 0 | ❌ `401 Unauthorized` |

两行合起来是**闭合**的:

- **错误凭据 → 401** ⇒ docker driver **确实在消费 auth block**, 且其失败时**不会**回退到节点 `/root/.docker/config.json` (当时节点凭据完全健康)。
- **正确凭据 → 拉取成功** ⇒ 既然不存在回退路径, 成功**只可能**来自 auth block 里**已经正确 resolve 的模板值** ⇒ **template 注入的 env 在 image pull 时已经就位**。

即: `config.auth` **一旦存在就是权威的**; template env 在 pull 时**可用**。v1.0.0 §2 的生命周期图是错的 (修正见 §2)。

### 那 2026-05-23 的 401 到底是什么？

**不知道, 且不编。** 但有一个不需要新假设的解释: 彼时用的 `FORGEJO_BOT_PAT` 属于 `ca32267` 那一代 token —— 后 (2026-07-01) 被查明**泄露 + 过度授权**并已 revoke; 同期 AD-M1-8 记录的 PAT rotation 实测也正是 "partial 4-scope **FAIL** → full 7-scope **PASS**"。**一个 scope 不足/无效的 token 同样得到 401**, 而当年把 401 归因为"插值时序"时**没有做判别式实验** (没有验证渲染出来的值究竟是不是空)。

v1.0.0 自己诚实写过 "本 convention 不假装能解释根因" —— 这份诚实是对的, 但"取严格立场"的代价是把 job 锁死在了单点凭据上 (见 §4)。

### 附带实测发现: Forgejo registry 忽略 username

`https://forgejo.10cg.pub/v2/token` 用 **token (password) 认证, 完全忽略 username**: 用 `10cg-ci-bot` / 已改名的旧名 `aria-runner-bot` / 甚至 `WRONG-USER-XYZ` 请求, 都能签出 token 并成功 GET manifest (HTTP 200); 只有 **token 错误**才 401。

推论: `auth { username = ... }` 的值对 Forgejo 拉取**不影响成败** (仍应填对, 便于审计与其他 registry 兼容); **401 只能由 token 引起**。

---

## §1 SOT — task-level auth + Nomad Variable (推荐)

```hcl
task "server" {
  driver = "docker"

  template {
    destination = "${NOMAD_SECRETS_DIR}/docker-auth.env"
    env         = true
    change_mode = "noop"   # auth 只在 alloc 创建时的 image pull 用到
    data        = <<-EOT
      {{- with nomadVar "nomad/jobs/<jobname>" -}}
      DOCKER_AUTH_USER={{ .docker_auth_user }}
      DOCKER_AUTH_PASSWORD={{ .docker_auth_password }}
      {{- end -}}
    EOT
  }

  config {
    image = "forgejo.10cg.pub/10cg/<image>:<tag>"
    auth {
      username = "${DOCKER_AUTH_USER}"
      password = "${DOCKER_AUTH_PASSWORD}"
    }
  }
}
```

**为什么这是 SOT**:

- **凭据随 job 走, 不随节点走** —— 节点凭据文件漂移不再能打掉这个 job (§0 实证: job auth 是权威的)。
- 凭据在 Nomad Variables (ACL scope) 内, 不在 HCL 明文, 不进 git / CI log / backup。
- 与 Lab 其余项目一致: 集群内 Aether / SilkNode / Kairos / Kino / shenquant / nexus / todo-web / wecom-relay 等**一直**在用此模式且工作正常 —— v1.0.0 的禁令与 Lab 现实**从一开始就是背离的** (若真按 v1.0.0 §7/§8 全 Lab 执行, 等于把能用的 auth block 删掉、集体退回节点单点)。

**Key 名契约 (硬约束)**: var key **必须**是 snake_case `docker_auth_user` / `docker_auth_password`。Aether 的轮换工具 (`aether registry-auth rotate`) 与 drift 检查 (`aether doctor pat_inventory_drift`) 按此 key 名寻址; 用别的名字 → 该路径被轮换**跳过** → 下次轮换该 job 静默 401。

**ACL 路径约束**: Variable 路径用 `nomad/jobs/<jobname>` (或 `<jobname>/<group>/<task>`) —— 这几条由 workload identity 默认 implicit policy 授读权。(本集群当前 ACL disabled, 任意路径可读, 但别依赖这个。)

**部署顺序 (硬约束)**: **先预置 Variable → 再部署 job**。因为 job auth 是权威的, var 缺失 → 模板渲染出空凭据 → **硬 401**, 而**不会**退回原先能工作的节点凭据。

---

## §2 修正: Nomad alloc 生命周期

v1.0.0 §2 声称 template render 在 image pull **之后**。**这是错的** —— template 是 **prestart hook**, 在 driver 启动 task (即 image pull) **之前**完成:

```
1. alloc placement (scheduler picks node)
2. Nomad native interpolation (${NOMAD_*} / ${NOMAD_META_*})
3. prestart hooks — 含 template render (consul-template → /secrets/*.env, env=true 注入 task env)
4. ── driver.StartTask → docker image pull ──   ← config.auth {} 在此被读, 此时 (3) 的 env 已就位
5. container create → task process start
```

(注: `artifact` hook 更早于 template —— 需要认证的 artifact 下载拿不到 template 注入的 token, 那是另一个坑, 与本文无关。)

---

## §3 节点级 plugin auth.config — 降级为 fallback, 并明示其故障模式

`plugin "docker" { config { auth { config = "/root/.docker/config.json" } } }` **仍然有效**, 但**不再是 Nomad task 的推荐路径**:

> ⚠️ `/root/.docker/config.json` 是**无 IaC、无模板、纯手工维护的单点凭据文件**。
> **2026-07-08 它在 heavy-3 上被清空** (Aether #234 字节级取证: 空文件 = `docker logout` 对空 auths 的序列化, 16B), 导致所有依赖它的 job 拉私有镜像 401、alloc 卡 pending 反复退避。同族漂移已复发多次 (Aether #200 / #225 / #232 / #234)。
> **无 auth block 的 task = 把可用性押在这个文件上。**

**仍然需要节点级凭据的场景** (不受本 convention 反转影响):
- **宿主 docker build/push** (e.g. Aether `aether-build-container`) —— 那是 docker CLI 在宿主上直接跑, 不经 Nomad task config。
- 过渡期尚未迁移的 job (迁移路径见 §5)。

节点级凭据文件的 schema / base64 规范 / 多节点 atomic sync + fingerprint verify 轮换流程, 保留在 §6 (内容未变, 仅适用范围收窄)。

**检测**: Aether 侧有 `aether doctor node_docker_auth_parity` (per-node 探测 forgejo auth 条目存在性, 区分 empty `{}` / missing entry / unreadable) 做 interim 早警。

### §3.1 ⛔ 禁止在共享宿主上 `docker logout` (2026-07-19 加, 两起事件归因后)

> **规则**: 任何 `ssh <共享宿主>` 场景下的 docker 操作, **不得** 对宿主默认 config 执行
> `docker logout`。该 login 态是**节点常驻凭据**, 不归发起 ssh 的 session 所有。

**为什么这条要单独立规**: §3 上面记的 heavy-3 事件不是孤例。2026-07-16 heavy-1 又发生一次,
同样 16B 签名。两起归因 (Aether #234 评论 16316, 经 session transcript 取证) 是**同一个反模式**:

| | 时刻 | 来源 |
|---|---|---|
| heavy-3 | 2026-07-08 13:46:04Z | 某项目 session 的 build 清理: `ssh root@<node> "rm -rf …; docker logout …"` |
| heavy-1 | 2026-07-16 19:20:36Z | 另一项目 session 的 release retag: 脚本内 `login → tag → push → logout` |

两次都**不是恶意, 也不是脚本 bug** —— 是"用完就该登出"的礼貌直觉。这个直觉在**个人机器**上
正确, 在**共享宿主**上是破坏行为: 它删掉的是别人 (act_runner / build 工具链) 正在依赖的凭据,
而破坏要等到下一次冷缓存拉取才显形 —— heavy-1 那次隔了 3 天才被一个 1 秒失败的 release build
暴露。

**正确做法 (按优先级)**:

1. **什么都不做** —— 宿主通常已持有你要的凭据。直接 pull/push, 不 login 也不 logout。
2. **需要不同凭据 → 隔离, 永不碰默认 config**:
   ```bash
   ssh root@<node> 'DOCKER_CONFIG=/tmp/iso docker login <registry> -u <user> --password-stdin; \
                    DOCKER_CONFIG=/tmp/iso docker push <image>; rm -rf /tmp/iso'
   ```
3. **凭据真的丢了 → 修复, 不是登出**: 从健康节点复制 `config.json` + `chmod 600` + 指纹比对。

**机械护栏**: aria-plugin `hooks/host-docker-logout-guard.sh` (v1.63.0+) 在 PreToolUse 拦截
`docker logout` + ssh/scp 指向 heavy 宿主 + 未设 `DOCKER_CONFIG` 的命令。**它是 speed-bump 不是
边界** —— 跨 tool-call 拆分的写法拦不住, 宿主侧动作也管不着。本条约定才是权威, hook 只是把
最常见的形态挡在门外。有意移除凭据 (如节点下线) 用 `# guard:ack: <理由>` 显式放行。

> **适用面**: 任何被多个消费方共享的 docker login 态 —— Nomad client 节点、CI runner 宿主、
> build 机。个人 dev 机的 login 态是 session 自己的, 不在此列。

---

## §4 Forbidden pattern (v2.0.0)

### ❌ 凭据明文写进 HCL

```hcl
auth {
  username = "simonfish"
  password = "0123456789abcdef..."   # ❌ 进 git / nomad job inspect / Raft log / backup
}
```
→ 走 §1 (Nomad Variable + template)。检测: `aether doctor hardcoded_docker_auth`。

### ❌ 拉私有镜像但完全不写 auth block (依赖节点凭据)

→ 这正是 Aether #234 prong b 要消灭的形态; 走 §5 迁移。

---

## §5 Migration path — 从"依赖节点凭据"迁到 job 级 auth

> 与 v1.0.0 §8 **方向相反**: v1.0.0 教人删 auth block, v2.0.0 教人加回来。

### Phase 1 — Audit

```bash
# 找出所有"拉私有镜像但无 config.auth"的 task (集群实拉, 别信 HCL —— 运行中的 job 可能来自老 commit)
# 口径: driver=docker 且 image 含 <registry-host> 且 config 无 auth
curl -s "$NOMAD_ADDR/v1/jobs" | ...   # 逐 job GET /v1/job/<id>, 检查 TaskGroups[].Tasks[].Config.auth
```

### Phase 2 — 预置凭据 (先于部署)

```bash
aether env set --job <jobname> docker_auth_user 10cg-ci-bot
aether env set --sensitive --job <jobname> docker_auth_password --from-file <token-file>
```
`aether env set` 是 Get→merge→SetCAS 原子合并, 不会清掉该 var 里其他 key。**裸 PUT /v1/var 会整体替换 Items** —— 会清掉同 var 里的 app secret, 别用。

新 Variable 路径**必须**登记进 Aether `.aether/pat-inventory.yaml` 的对应 PAT entry, 否则 `doctor pat_inventory_drift` 报 `untracked_nomad_var` 且 Tier 1 轮换跳过该路径。

### Phase 3 — HCL edits

加 template 两行 + `config.auth` block (§1)。若 task 原本无 template (无 app secret), 新增一个**只注入 registry 凭据**的 template。

### Phase 4 — Verify (判别式, 不可省)

**镜像已缓存在节点时 pull 会被跳过, auth 路径根本不走 —— 不强制冷拉的验证是假绿。**

1. 一次性 probe job (跑完即 purge), `force_pull = true`, 复刻目标 job 的关键形态 (parameterized / meta 插值镜像等)。
2. **正反双向**:
   - 故意写错的凭据 → **必须** `401 Unauthorized` 硬失败 (证明 auth block 被消费, 且无节点回退)
   - 正确凭据 → `Driver: Downloading image` → Exit 0
3. 真实 job 部署后, 核对集群侧 job spec: `config.auth` 存在 + template 含两行 + `nomadVar` 路径真实存在且含那两个 key (三者对齐; 只 grep HCL 会漏掉"部署的是老 commit"的情况)。

---

## §6 节点级凭据文件 — schema + 轮换 (适用范围: 宿主 build / 未迁移 job)

### 6.1 Nomad client config

```hcl
plugin "docker" {
  config {
    auth {
      config = "/root/.docker/config.json"
    }
  }
}
```

### 6.2 Auth file schema

```json
{ "auths": { "<registry-host>": { "auth": "<base64(<username>:<pat>)>" } } }
```

- `email` 字段不需要
- `auth` 必须是标准 base64 of `username:password` (无 URL-safe variant / 无 line break)
- Nomad driver per-alloc 读此文件; 仅当 `auth.config` **路径**变更才需 `systemctl restart nomad`

### 6.3 base64

```bash
printf '%s' '<username>:<pat>' | base64 -w0    # -w0 必须, 防 76-char line-wrap
```

### 6.4 多节点 atomic sync (轮换)

切忌"半部署"状态 (部分节点新 cred、部分旧) —— cold-pull 部分节点 401, 难诊断:

1. 本机准备 `<path>.new` (含新 cred), cred 字面值不出现在 chat
2. scp 到所有节点 `/tmp/...new` (并行)
3. **fingerprint verify** 每节点: `sha256(auth 值)[:12]` 全节点一致
4. atomic rename `mv -f` (并行)
5. round-trip verify (docker login --password-stdin, HTTP 200; cred 不进 process args)

### 6.5 No chat-leak invariant

- cred 字面值**永不**出现在 chat / log / ssh stdout / process args
- fingerprint (SHA prefix) 是 chat-safe 的唯一证据; round-trip 200 是 cred valid 的唯一证据

---

## §7 References

- **2026-07-12 判别式实测 + 反转**: [Aether #234](https://forgejo.10cg.pub/10CG/Aether/issues/234) prong b · [Aria #161](https://forgejo.10cg.pub/10CG/Aria/issues/161)
- **task-level auth pattern (canonical)**: Aether `docs/guides/nomad-variables-docker-auth.md` ([Aether #46](https://forgejo.10cg.pub/10CG/Aether/issues/46))
- **节点凭据单点故障 (为什么反转)**: Aether #234 (heavy-3 `/root/.docker/config.json` 2026-07-08 被清空, 字节级取证)
- **两起 wipe 归因 + §3.1 禁令依据**: [Aether #234 评论 16316](https://forgejo.10cg.pub/10CG/Aether/issues/234#issuecomment-16316) (41 仓 sweep + session transcript 取证: heavy-3 07-08 / heavy-1 07-16 同为 ssh 宿主后"礼貌 logout"); 机械护栏 aria-plugin `hooks/host-docker-logout-guard.sh` (v1.63.0+)
- **v1.0.0 历史记录 (已推翻的时序归因)**: Aria `.aria/decisions/2026-05-23-layer2-docker-auth-cold-pull-fix.md` + `openspec/archive/2026-05-23-aria-layer2-docker-auth-cold-pull-fix/` (保留作历史; 其**结论**已撤销, 其**记录**不改写)
- **Cross-ref**: [`secret-hygiene.md`](./secret-hygiene.md) (Rule #7 SOT; §2.4 + §3.6 docker login 安全 pattern)

---

**Last updated**: 2026-07-19 (v2.1.0 — 加 §3.1 共享宿主 docker logout 禁令; Aether #234 两起 wipe 经 transcript 取证归因同一反模式)
**Cross-projects**: 适用 10CG/* 使用 Nomad docker driver + private registry 的项目
