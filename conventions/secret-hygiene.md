# Secret Hygiene 规范

> **Version**: 1.0.0
> **Status**: Active
> **Source incidents**:
> - 2026-05-02 (Aria US-022 T8) — `nomad job inspect` 全量 dump runtime env 泄露 4 keys
> - 2026-05-06 (truffle-hound v0.3.2) — Python `subprocess.run(['nomad','var','put',...])` 默认继承 stdio, 泄露 4 keys
> **Forgejo Issue**: [10CG/Aria#78](https://forgejo.10cg.pub/10CG/Aria/issues/78)
> **Origin Spec**: `openspec/archive/<date>-aria-secret-hygiene-rule`

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

## 5. 与 Path (3) PreToolUse hook 的关系

本规范 (Path 1) 是**教育/mental model 路径**。Aria 计划在后续 Spec 引入 **Path (3) PreToolUse hook 强执行**:

- Hook 在 Claude Code SDK PreToolUse 阶段扫 Bash command pattern
- 匹配 §2 scope 列表的命令 + 未含 redirect token (`>/dev/null`, `capture_output=True`, `stdout=DEVNULL`) → block + 返回 helpful message
- Exception 路径: 命令前注释 `# secret-leak-ok-explicit` + 三件套 (理由 + 隔离 + sign-off) → hook skip

Path (3) hook 落地后, 本 Path (1) 文档继续作为:
- 命令清单 source-of-truth (hook regex matcher 引用本文 §2)
- 教育路径 (新加入项目时 onboarding 读本文)
- Exception annotation 规则 source-of-truth

Path (3) hook tracking: 见 [Forgejo Issue #78](https://forgejo.10cg.pub/10CG/Aria/issues/78) 后续 follow-up Spec。

---

## 6. 触发该规则的项目角色

| 角色 | 触发频率 | 主要场景 |
|------|----------|----------|
| Owner (人类) | 中 | 配置 secret rotation / 跨集群 deploy |
| AI assistant (Claude Code etc.) | **高** | 任何写入 secret 操作; subprocess inherit stdio 是默认行为陷阱 |
| CI/CD pipeline | 中 | secret 注入 build / deploy step |

**AI assistant 特别注意**: 默认假设命令 stdout"只是日志"会触发本规则; 必须主动检查命令是否在 §2 scope, 是即强制 redirect。

---

## 7. 与既有规范的关系

| 规范 | 关系 |
|------|------|
| `standards/conventions/git-commit.md` | 不冲突; secret 不应进 commit message (本 SOP 隐含) |
| `.aria/decisions/2026-05-02-secret-rotation-deferred.md` | rotation SOP, 关注密钥轮换调度; 本规则关注操作时不 leak |
| `feedback_secrets_never_in_conversation.md` (memory) | 个人 memory 教训; 本规则是项目级 SOP, memory 引用本文档作为 forward-looking reference |
| `feedback_nomad_inspect_secret_leak.md` (memory) | 同上 |

---

## 8. 历史 incidents

| 日期 | Project | 命令 | 泄露规模 | 修复 |
|------|---------|------|----------|------|
| 2026-05-02 | Aria | `nomad job inspect`, `aether status --json` | 4 keys (GLM_API_KEY + 3 FEISHU_*) | rotation deferred to T13 (`.aria/decisions/2026-05-02-secret-rotation-deferred.md`) |
| 2026-05-06 | truffle-hound | Python `subprocess.run(['nomad','var','put',...])` 默认 stdio | 4 keys (feishu_app_secret / LUXENO_API_KEY / FORGEJO_TOKEN / cf_access_client_secret) | 见 truffle-hound `reports/incident-2026-05-06-secret-leak-via-subprocess.md` |

---

## 9. 版本历史

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-05-07 | 初版 (Path 1 doc-only). 含核心条款 + 9 类受限命令 scope + 7 正向 pattern + 4 反例 + Path 3 hook 关系 + 8 历史 incidents. 来源: Forgejo Issue #78 + Aria 自身 2 次 incident memory feedback. |
