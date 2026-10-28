# Secret Hygiene 规范

> **Version**: 1.2.1
> **Status**: Active
> **Source incidents**:
> - 2026-05-02 (Aria US-022 T8) — `nomad job inspect` 全量 dump runtime env 泄露 4 keys
> - 2026-05-06 (truffle-hound v0.3.2) — Python `subprocess.run(['nomad','var','put',...])` 默认继承 stdio, 泄露 4 keys
> - 2026-05-20 (Aria M5 T-deploy Phase B) — `nomad var get -out=json` 8-key Items map 全 dump → 触发 5-key rotation + Layer 2 紧急 cherry-pick
> **Forgejo Issue**: [10CG/Aria#78](https://forgejo.10cg.pub/10CG/Aria/issues/78), [#84](https://forgejo.10cg.pub/10CG/Aria/issues/84), [#107](https://forgejo.10cg.pub/10CG/Aria/issues/107)
> **Origin Spec**: `openspec/archive/2026-05-07-aria-secret-hygiene-rule`
> **Layer 2 Spec**: `openspec/archive/2026-05-23-aria-secret-guard-plugin-default` (v1.1.0 升级来源)

---

## 0. Path ↔ Layer mapping

本规范定义 3 条互补的 enforcement path,对应 2 层 defense-in-depth:

| Path | 性质 | Layer | 实施位置 | 触发时机 | 失败模式 |
|------|------|-------|----------|---------|---------|
| **Path 1** | Prose convention (本文档) | **Layer 0** (doc-only) | `standards/conventions/secret-hygiene.md` | Onboarding / PR review / human discipline | 取决于人/AI 是否读 + 是否遵守 (soft) |
| **Path 2** | Inline annotation | (无独立 layer,贯穿 Layer 0/2) | 命令前 `# secret-leak-ok-explicit` 三件套 (理由 + 隔离 + sign-off) | Per-command opt-out / 紧急豁免 | 注释缺失即视同未豁免;Layer 2 hook 同步识别 `# guard:ack:` |
| **Path 3** | PreToolUse + PostToolUse hook | **Layer 2** (mechanical enforcement) | `aria/hooks/{secret-guard,secret-scan}.sh` (aria-plugin SOT, v1.24.0+) | Claude Code tool 调用前/后, 自动触发 | 失败模式由 hook 自身 audit 覆盖 (991 self-tests [985 无 zsh] + cross-project dogfood) |

> **Path 1 vs Path 3 关系**: Path 1 (Layer 0) 是教育路径与 source-of-truth (§2 受限命令清单是 Path 3 regex matcher 的语义参照);Path 3 (Layer 2) 是机械执行 — 两者**并存且互补**,不互替代。

> **Why no "Layer 1"?**: Layer 1 在 Aria 内部其他语境用于指代 "post-incident rotation" (key 已泄露后立即轮换),与 enforcement 编排无关,故本规范的 enforcement layer 编号跳过 1。

---

## 1. 核心条款

> **Secret-writing/reading commands MUST NOT echo secret values to chat-visible streams.**

任何**读取或写入 secret 值**的 shell 命令**必须**:

- **Bash**: `cmd >/dev/null 2>&1` 或 `cmd 2>&1 | grep -v '<secret-pattern>'`
- **Python `subprocess`**: `capture_output=True` (且不 print stdout) 或 `stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL`
- **Verification**: 通过 metadata 验证 (HTTP status code / exit code / 字段长度 / `nomad var get -out=json … | jq '.Items | keys'` 仅取 key 名), 不读 secret value 字面

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
| Read Claude Code 配置 | `cat`/`jq`/`grep` 等读 `~/.claude/settings.json`, `~/.claude/settings.local.json`, `~/.claude.json` (`env` 节点存 API token, legacy 全局配置含 MCP token; Aria #179 补入 secret-guard Bash + Read/Edit 双平面清单) |
| Read 服务端配置 | `cat`/`grep`/`sed` 等打印型读取器读 Forgejo / Gitea 的 `app.ini` (含 `app.ini.bak` 一类备份; `JWT_SECRET` / `SECRET_KEY` / `INTERNAL_TOKEN` 与数据库口令都在其中; `10CG/aria-plugin#203` 补入 secret-guard Bash + Read/Edit 双平面清单; 项目自己的路径写法见 §5.6) |

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
| Process table | `ps aux` / `ps -ef` 等带完整命令行列的 `ps`、`pgrep -a`、`top -c`、`docker top`、`/proc/<pid>/cmdline` 与 `/proc/<pid>/environ` (别的进程命令行或环境里的凭据会被整行打出; 只出 pid 与进程名的 `pgrep -f <名字>`、`ps -eo pid,comm` 放行) |

> **注 (tight 族)**: Claude Code 配置 (§2.2)、`app.ini` (§2.2)、进程表里的 `ps` / `pgrep -a` / `top -c` / `docker top` 一族 (上表) 与 §5.6 的项目扩展条目按 **tight credit** 判: 锚定 `grep` / `grep -v` / `sed` / `cut` / `awk` 这类行级过滤**不算**过滤 (它们打印的仍是整行), 只认丢弃 (`>/dev/null`)、计数 (`wc`)、哈希 (`sha*sum`) 与 jq 取名字面 (`jq 'keys'`)。因此 secret-guard 共用 BLOCKED 文案里列出的 `Acceptable filters` (如 `| grep '^SAFE_PREFIX='`) **对 tight 族无效**: 照文案重试仍会被拦 (该文案对所有被拦命令共用, 不为 tight 族单独改)。出路是不让凭据进入命令输出 (§3), 或带 `# guard:ack: <理由>` 并留痕 (§5.3)。`/proc/<pid>/environ|cmdline` 行与远程 / 外壳包裹下的 `env` 转储不属 tight 族, 沿用基线 credit。

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
# ✅ 验证 secret 已写入: 取 key 名列表, 不读 value
#    注意 `-out` 合法枚举 = go-template|hcl|json|none|table (**无 keys 档**,
#    nomad v1.11.2 实机核验; 旧版本文档误写 -out=keys 会报 Invalid value)。
import json, subprocess
result = subprocess.run(
    ['nomad', 'var', 'get', '-out=json', 'nomad/jobs/myapp'],
    capture_output=True, check=True, text=True,   # 不 print result.stdout
)
keys = list(json.loads(result.stdout).get('Items', {}))  # 仅 key 名进变量
assert 'KEY' in keys  # 仅检查 key 名存在, 不读 value
```

### 3.4 Bash — 全部 redirect (推荐)

```bash
# ✅ secret 写入: 全 redirect
nomad var put -force nomad/jobs/myapp KEY="$VAL" >/dev/null 2>&1

# ✅ 验证 (仅取 key 名): -out=json 经 jq 只投影 key 列表, value 不出现
#    `jq '.Items | keys'` 是 secret-guard 认可的 REDACTING filter (放行);
#    写成 `keys[]`(带方括号) 会破坏该识别并被拦 — 保持无方括号形式。
nomad var get -out=json nomad/jobs/myapp | jq '.Items | keys'

# ✅ 或只验存在性 (连 key 名都不需要时): 看 exit code
nomad var get -out=json nomad/jobs/myapp >/dev/null 2>&1 && echo "OK"
```

> ⚠️ **不要用 `-out=keys`** — 该取值在 nomad **不存在** (`var get`/`var put` 合法枚举 =
> `go-template|hcl|json|none|table`; `var list` = `go-template|json|table|terse`), 实跑报
> `Invalid value for "-out"`。且 `nomad var get … 2>/dev/null` 这类**只挡 stderr**的写法
> 不被 secret-guard 视为有效 filter (stdout 仍会流出), 会被拦。两个坑常一起出现。
>
> ⚠️ **`>/dev/null` 单挡 stdout 不够 —— 务必 `>/dev/null 2>&1`** (§3.4 写法即是)。两个
> 常见的 stderr 泄漏面: (a) `nomad var put -verbose …` 的额外信息**按设计走 stderr**
> (`--help`: "Provides additional information via standard error"); (b) `curl -v` /
> `--trace-ascii` 把含 secret 的请求体打到 stderr。两者与纯 `>/dev/null` 组合都会漏,
> 且 secret-guard **当前放行**该组合 (已知缺口, 见 aria-plugin issue)。
>
> ⚠️ **顺序敏感 —— 写反了等于没写**: 必须 `>/dev/null 2>&1` (先挪 stdout, 再让 stderr
> 跟过去)。反过来的 `2>&1 >/dev/null` **无效** —— `2>&1` 先把 stderr 复制到**当时的**
> stdout (仍是 chat-visible 管道), 之后才把 stdout 挪走, stderr 根本没挡住; 而
> secret-guard 对该形态实测**放行** (零警告)。两个 token 记成一组时极易写反。

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

> ⛔ **共享宿主上不要 `docker logout`** (Nomad client / CI runner / build 机)。那个 login 态是
> 节点常驻凭据, 不归你的 session 所有 —— 登出会打掉 act_runner 与 build 工具链, 且要到下一次
> 冷缓存拉取才显形。需要临时凭据用 `DOCKER_CONFIG=/tmp/iso` 隔离。规则与两起真实事故见
> [`nomad-docker-registry-auth.md` §3.1](./nomad-docker-registry-auth.md); 机械护栏 aria-plugin
> `hooks/host-docker-logout-guard.sh` (v1.63.0+)。

### 3.7 Forgejo/GitHub token create

```bash
# ✅ Forgejo: 创建 token 后立即 redirect (token 仅在创建响应中可见, 之后只能 revoke)
forgejo POST /users/myuser/tokens -d '{"name":"mybot"}' | jq -r '.sha1' > /run/secrets/token
# ↑ 仅 token sha1 写入文件, response body 不到 stdout
```

### 3.8 长时进程的凭据传递

长时进程 (后台轮询 / 守护进程 / `watch` 循环等**无超时上界, 或预期存活期不少于 60 秒**的进程) 的**命令行参数**不得含凭据: 进程表 (`ps`、`/proc/<pid>/cmdline`) 在其整个存活期内对所有能列进程的人可见, 与命令的输出是否被 redirect 无关。凭据改用 env / `--config` 文件 / stdin 传递; 工具能用 `@<文件>` 或 stdin 时, 同一凭据优先用它们 (**这条偏好只对长时进程成立**)。

短命令 (预期存活期不足 60 秒) 的 argv 暴露窗口只在其执行期, 本节不改变它们: §3.1 / §3.2 / §3.4 / §3.5 / §4.4 里把值放在 `KEY=…` 的示例 (含 §3.1 示例的 `timeout=30`) 保持不变。来源: `10CG/Aria#221` (后台轮询进程的命令行参数里带令牌, 进程表列举把它整行打出)。

```bash
# ❌ 后台轮询的 argv 含令牌: 整条命令行在循环存活期内一直在进程表里
watch -n 30 "curl -sS -H 'Authorization: token $TOKEN' https://git.example.com/api/v1/version"

# ✅ 请求头放进权限收紧的文件, argv 里只剩文件路径
watch -n 30 'curl -sS -H @/run/secrets/auth_header https://git.example.com/api/v1/version'

# ✅ 单个长连接: 让 curl 从 stdin 读配置, header 行不进 argv
printf 'header = "Authorization: token %s"\n' "$TOKEN" | curl -sS -K - https://git.example.com/api/v1/version
```

| 工具 | 凭据不进 argv 的传法 | 核验 |
|------|----------------------|------|
| curl | `-K -` (配置从 stdin 读, 含 `header = "…"` 行) 或 `-H @<文件>` (请求头从文件读) | curl 7.88.1 实跑: 两种写法的请求头都到达本机监听端口; 对照组 `-K -` 读到空配置时退出码 2 (`no URL specified`) |
| Nomad CLI | 环境变量 `NOMAD_TOKEN` (由运行环境提供, 命令里不出现值), 不用 `-token <值>` 参数 | `nomad var put -h` (v1.11.2): `-token` 选项 "Overrides the NOMAD_TOKEN environment variable if set" |
| `nomad var put` | `KEY=@<文件>` 或 `KEY=-` (从 stdin 读值) | `nomad var put -h`: "Item values provided from file references or stdin are consumed as-is"; 对不可达地址 (`NOMAD_ADDR=http://127.0.0.1:9`) 实跑, `KEY=@<文件>` 被接受, 只是连接失败, 输出不含值 |

> 环境变量不是绝对安全: `/proc/<pid>/environ` 只对同属主与 root 可读 (argv 默认对所有用户可见)。本条是 Path 1 规范, 没有机械检查能判断 argv 里的变量是不是凭据: 进程表的**读取**由 §2.5 的 secret-guard 行拦截, 读出来的凭据形内容 (`--token=…` 一类参数、`Authorization: token …` 头) 由 secret-scan 事后告警 (§5.2), 两者都不能代替不把凭据放进 argv。

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

正确替代: 用 `nomad var get -out=json … | jq '.Items | keys'` 检查 key 存在, 不读 value (见 §3.3/§3.4)。

---

## 5. Layer 2 enforcement (Path 3 PreToolUse + PostToolUse hook)

aria-plugin v1.24.0+ ship **`aria/hooks/secret-guard.sh` + `aria/hooks/secret-scan.sh`** 作为 Layer 2 mechanical enforcement, 自动注册到 `aria/hooks/hooks.json` 的 PreToolUse + PostToolUse (secret-scan.sh 另注册 PostToolUseFailure, 扫描失败工具调用的错误文本),所有装 aria-plugin 的项目默认获保护。

### 5.1 Plugin SOT 路径

| 文件 | 角色 | 注册 matcher |
|------|------|-------------|
| `aria/hooks/secret-guard.sh` | PreToolUse Bash + Read/Edit blocker | `Bash` + `Read\|Edit\|Write\|MultiEdit` |
| `aria/hooks/secret-scan.sh` | PostToolUse / PostToolUseFailure output 扫描 + 告警 (detect-only, 非 redaction) | `Bash\|Read\|Edit\|Write\|MultiEdit` (两个事件同一 matcher) |
| `aria/hooks/tests/secret-guard.test.sh` | 991 regression cases, 985 无 zsh (含 `${CLAUDE_PLUGIN_ROOT}` substitution test + Nomad var 写向族 + #128 逐段判定/SC-1..22 族; SC-22 = #145 BLOCKED 回显脱敏; #153 Forgejo 凭据响应端点族; #179 claude-config 双平面清单 + credit 收紧 + 前置字符白名单; secret-net-l3-and-bypass-paths: `app.ini` 族 / 进程表族 / 变量间接 / 项目扩展入口 / 两处误拦修复) | n/a |
| `aria/hooks/tests/secret-scan.test.sh` | 129 regression cases | n/a |

> **NotebookEdit 不注册** (v1.24.0 决定): `.ipynb` cell 多用于实验代码,内联 secret 概率低 + ack 路径足够 — 后续 minor 可加。
>
> **Write / MultiEdit**: 虽在 secret-guard 的 matcher 内, hook 对这两个工具直接 `exit 0` (不拦; 只拦 Bash 命令与 Read / Edit 的 `file_path`)。
>
> **PostToolUseFailure**: 失败的工具调用 (Bash 非零退出等) 不触发 `PostToolUse`, 触发这个事件: 输入没有 `tool_response`, 错误文本在顶层 `error`; secret-scan 同样扫描它。

### 5.2 Exit semantics

- **PreToolUse `secret-guard.sh`**: `exit 2` = block;`exit 0` = allow。Block 时 stderr 显示 helpful 消息(matched pattern + acceptable filters list + ack 模板)。
- **PostToolUse `secret-scan.sh`**: **`exit 0` always** (warn-only, **detect-only 非 redaction**)。Tool 已执行完成,exit 2 不能 retroactively block;命中时 stderr 显示 **DETECTED** summary + 发 `additionalContext`(告知 Claude 按已泄露处理、勿复述)/ `systemMessage`(提醒 operator 轮换)。**不改写 tool_response** —— PostToolUse 架构上无法重写已产生的 tool 结果 (官方 hooks-guide line 891),故第二层是**检测+告警**而非兜底。**唯一可靠防线 = PreToolUse `secret-guard`**(事前 block)。补充事实: Claude Code 2.1.285 的 PostToolUse hook 输出 schema 含 `updatedToolOutput`, 端到端未验证, 本 hook 不使用。

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

> **实证边界**: 该 5-trial 实验在 **Write event PreToolUse** 上跑(用 `handoff-location-guard.sh` 作 proxy)。**Bash + PostToolUse 推论**: hook orchestrator 是 Claude Code 框架同一组件,merge 语义 by spec 适用于所有 hook event;`secret-guard.sh` 自身行为由 991 self-tests (985 无 zsh) + cross-project dogfood 覆盖。所以 Layer 2 设计可信赖 all-fire + non-short-circuit 在 Bash + PostToolUse 上同样成立,**但严格意义上只直接验证了 Write/PreToolUse**;若未来发现 Bash event merge 异常需 fall back to design,这是预先记录的 known-evidence-gap。memory: `feedback_claude_code_hook_merge_all_fire`。

### 5.5 Path 1 与 Layer 2 互补关系

Layer 2 ship 后,本 Path 1 文档继续作为:

- **命令清单 source-of-truth** — Layer 2 regex matcher 的语义参照(§2 受限命令清单)
- **教育路径** — 新加入项目 onboarding 必读
- **Exception annotation 规则 SOT** — `# secret-leak-ok-explicit` 三件套规范
- **Layer 2 known-limitation 全集** — Path 1 文档显式记录 Layer 2 已知 false-positive + false-negative(见 aria-plugin CHANGELOG [1.24.0]):
  - (a) `cat <script> && grep .env <script>` conservative regex 误拦(false-positive)
  - (b) log-file grep 不在 risky_patterns 内的 false-negative(parent DEC §2.6)
- **追踪 follow-up**: 见 [Forgejo Aria #84](https://forgejo.10cg.pub/10CG/Aria/issues/84) (closed via v1.24.0) + [#107](https://forgejo.10cg.pub/10CG/Aria/issues/107) (closed via v1.24.0)

### 5.6 项目级扩展入口 `.aria/secret-guard.paths`

采用方可以在**自己的项目里**追加 secret-guard 要拦的敏感路径, 不必改 plugin。来源: `10CG/aria-plugin#203`; 内建名字组认不到的路径写法 (如 Windows Git-Bash 下含反斜杠的 `C:\gitea\custom\conf\app.ini`: Bash 面的内建名字组不认反斜杠分隔符, 且大小写敏感) 由采用方在这里补一条子串, 例如 `gitea\custom\conf\app.ini` (已实跑核对: 加条目后被拦, 不加则放行)。

| 项 | 规则 |
|----|------|
| 位置 | `<项目根>/.aria/secret-guard.paths`。项目根 = 非空的环境变量 `CLAUDE_PROJECT_DIR`; 它缺失或为空时回落到 hook 输入里的 `cwd` |
| 格式 | 一行一个**字面子串** (不是正则, 不是 glob: `.` `*` `[` 等都按字面字符); `#` 起首为注释, 空行忽略; 首尾空白、行尾 CR 与文件首行的 UTF-8 BOM 会被剥掉 |
| 有效条目 | 4–200 **字节**, 且至少含一个 ASCII 字母数字或任一非 ASCII 字节 (中文目录名可用); 不满足的行被跳过, 不影响其它行 |
| 匹配 | **大小写不敏感** (只折叠 ASCII 字母); Bash 面对整条命令文本、Read / Edit 面对 `file_path` 做字面子串比对 |
| 语义 | **只增不减**: 内建名单先判, 全部放行之后才看扩展; 扩展不能移除或放宽任何内建规则 (写一行 `!.env` 也只是一条字面子串)。Bash 面不另写判定: 命中处被换成内建 `app.ini` 的名字后交给内建的同一套判定, 所以读取器集与引号 / 管道 / 重定向的处理同内建 `app.ini` 行; 被拦时复用同一份 BLOCKED 文案 (`Matched pattern:` 写 `(extension) .aria/secret-guard.paths`), 逃生口也相同 (§5.3) |
| 限额 | 文件不超过 32 KiB (32768 字节); 有效条目不超过 200 条; 每条命令只检查条目的**前 64 处**出现 |
| 失效 | 文件缺失 / 不是普通文件 / 不可读 / 超过 32 KiB / 含 NUL 字节 / 有效条目为零或超过 200 条 → **整体忽略**扩展 (不是截断), 内建名单照常; 扩展自身出错同样只丢扩展, hook 从不因扩展问题 `exit 2`。**失效是静默的**: 没有任何提示, 第 201 条条目会让前 200 条一起失效 |

**保护边界**: 覆盖面 = 内建 `app.ini` 行的读取器集 (29 个打印型读取器与 `python3 -c` / `node -e`) 加 Read / Edit。**不受保护**: 重定向读 (`while … done < 文件`、`tr … < 文件`)、`source` / `.`、`dd`、`xargs cat`、`find -exec`、目录递归与文件名 glob、**Grep 工具** (两个 hook 的 matcher 都不含 Grep)、Write、以及每条命令里**第 64 处之后**的出现 (用重复出现把读取点顶过第 64 处即可绕过)。威胁模型是防意外, 不是防对抗: 采用方的 AI 也能编辑这个文件。

**建议**: 条目选**最短**的特征子串 (如文件名 `myservice.conf`), 不要列完整路径。条目是字面子串, 完整路径对 `..` 回绕、`//`、`/./` 与 `cd` 之后的相对名都不命中, 只有短子串能覆盖这些写法 (代价: 同名文件在别处也会被拦)。

```
# <项目根>/.aria/secret-guard.paths — 一行一个字面子串, 大小写不敏感
myservice.conf
/srv/secret-store
```

按上面的文件, `cat /srv/x/MyService.CONF`、`cd /srv/x && cat myservice.conf` 与 Read `/srv/x/myservice.conf` 被拦, `cat /srv/x/other.conf` 放行; 若改列完整路径 `/srv/x/myservice.conf`, 则 `cat /srv/x/../x/myservice.conf` 这种写法放行 (以上均用当前 hook 实跑核对)。

---

### 5.7 部署前提: Claude Code 版本与 hook 前向兼容

两个 hook 经 `hooks/hooks.json` 注册; secret-scan 的失败路径依赖 `PostToolUseFailure` 事件, 需 Claude Code 识别该事件才生效 (验证过的加载下限 CC 2.1.285 / 2.1.292)。Claude Code 对**未知 hook 事件为 fail-safe** —— `claude plugin validate` 实测未知事件报 `unknown hook event; entry ignored at runtime` 且整份 hooks 仍 valid, 故 `secret-guard` (PreToolUse) 与成功路径 `secret-scan` (PostToolUse) 的加载**与该事件是否被识别无关、始终生效**; 低于识别 `PostToolUseFailure` 的版本仅失去「失败调用也扫描」这一腿, 核心守卫不受影响。插件清单 schema 无最低 CC 版本字段, 故此前提靠文档声明 + 部署侧断言 (容器内「secret-guard 真加载」的制品级实测见 `10CG/aria-plugin#218`)。

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
| 1.2.1 | 2026-10-28 | **计数同步** (零语义变更): §0 Path↔Layer 表 / §5.1 测试清单 / §5.4 实证边界的 secret-guard 计数 822/816 → 991/985 (aria-plugin v1.77.5, W10 放宽重判 + 新增 160 例; 条款逐字节不变) |
| 1.2.0 | 2026-10-09 | **Additive** (无 breaking; §3.1–§3.7 与 §4.1–§4.4 的示例逐字节不变): §2.2 加 `app.ini` 行; §2.5 加进程表行与 tight 族注 (共用 BLOCKED 文案的 `Acceptable filters` 对 tight 族无效); 新增 §3.8 长时进程的凭据传递 (命令行参数不得含凭据, 与短命令以 60 秒分界); §5.1 勘正 (secret-guard 是 Bash + Read/Edit blocker, secret-scan 同时挂 PostToolUseFailure) 并列出新测试族; §5.2 追加 `updatedToolOutput` 事实 (只增不改); 新增 §5.6 项目级扩展入口 `.aria/secret-guard.paths`; 新增 §5.7 部署前提 (CC 版本与 hook 前向兼容, PostToolUseFailure fail-safe, 见 `10CG/aria-plugin#218`); 计数同步 (secret-guard 自测 599 / 593 → 822 / 816 共三处, secret-scan 49 → 129)。来源: Spec secret-net-l3-and-bypass-paths (`10CG/aria-plugin#154` / `10CG/aria-plugin#203` / `10CG/Aria#221`)。 |
| 1.1.2 | 2026-08-02 | **计数同步** (零语义变更): §0 Path↔Layer 表 / §5.1 测试清单 / §5.4 实证边界段 三处陈旧的 secret-guard 自测数 (208 / 251 ×2) 同步为实况 **366**。同批 co-land aria-plugin v1.65.5 (该测试文件头部注释同一问题)。来源: Aria #170 cycle post_spec R4 code-reviewer m-9。 |
| 1.1.1 | 2026-08-02 | **订正 (事实性)**: 4 个推荐位教用的 `nomad var get -out=keys` 经 nomad v1.11.2 实机核验为**非法 flag 值** (`var get`/`var put` 合法枚举 = `go-template\|hcl\|json\|none\|table`; `var list` = `go-template\|json\|table\|terse`), 实跑报 `Invalid value for "-out"` — §1 Verification 定义行 / §3.3 python 例 / §3.4 bash 例 / §4.4「正确替代」句全部改为 `-out=json` 经 jq 投影 `.Items` 取 keys (secret-guard 认可的 REDACTING filter; 写成 `keys[]` 会破坏识别而被拦)。另新增两段警示: (a) `-out=keys` 不存在 + `… 2>/dev/null` 只挡 stderr 不构成有效 filter (原 §3.4 写法双重错误); (b) `>/dev/null` 单挡 stdout 不够 — nomad `-verbose` 与 curl `-v`/`--trace*` 的输出按设计走 stderr, **且 `2>&1` 必须写在 stdout 重定向之后** (`2>&1 >/dev/null` 是无效反例, 实测 secret-guard 仍放行)。来源: Aria #170 triage + Spec [secret-guard-nomad-var-put-echo](../../openspec/changes/secret-guard-nomad-var-put-echo/) post_spec R2-C-1。 |
| 1.1.0 | 2026-05-23 | **Additive** (Layer 2 ship): 新增 §0 Path↔Layer mapping table (Path 1↔Layer 0 / Path 2↔inline / Path 3↔Layer 2) + §5 重写为 Layer 2 enforcement (含 plugin SOT 路径 / exit semantics / Path 2 inline ack 与 §1.2 三件套互补关系 / Q1 hook orchestrator merge 实证 + 边界声明 / Path 1 与 Layer 2 互补关系含 known-limitation 全集) + 新 §6 local copy + plugin coexist 模式 (5-state aria-doctor pointer + cleanup 策略 + backwards-compat guarantee) + 2026-05-20 incident 追加 + Forgejo issue refs (#84, #107)。零 breaking change,Path 1 教育规范 + §2 scope + §3 正向 pattern + §4 反例全保留。来源: Spec [aria-secret-guard-plugin-default](../../openspec/archive/2026-05-23-aria-secret-guard-plugin-default/) + memory `feedback_claude_code_hook_merge_all_fire` (Q1 实证) + memory `feedback_deterministic_structural_skill_rule6_substitute` (atomicity guard)。 |
