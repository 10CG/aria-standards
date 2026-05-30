# Shell jq CRLF Hygiene 规范

> **状态**: Active (aria-plugin v1.36.0+)
> **触发场景**: 任何 shell 脚本消费 `jq` 输出 (hooks / skill scripts / CI scripts)
> **根因 issue**: Forgejo Aria [#132](https://forgejo.10cg.pub/10CG/Aria/issues/132) (secret-guard fail-closed) + follow-up `shell-jq-crlf-hardening`
> **同源家族**: #61 (v1.21 GBK locale) / #131 (v1.30.3 None guard) / #132 — **Windows CRLF / 编码边界** bug

---

## 0. 一句话规则

Windows native jq builds 在**每行输出**追加 CRLF。bash 消费时只 strip `\n` 不 strip `\r`:`readarray -t` 让每个字段带尾 `\r`,`$(…)` 让单值带尾 `\r`。**进入 shell 条件判断 / 字符串比较的值必须剥 CR;数据正文与 jq 构造器输出不动。**

后果实证 (#132):`tool_type="string\r"` 通不过 `[[ "$tool_type" != "string" ]]` → PreToolUse hook fail-closed 阻断 Windows session 全部工具。姊妹 (secret-scan):同样 gate → 静默跳过 redaction = secret 泄漏。

---

## 1. CR 处理决策表 (核心条款)

| 消费形态 | 值的用途 | 处理 | 理由 |
|---------|---------|------|------|
| `readarray -t < <(jq …)` 多行 field-split | 门控/字段值 | jq 管道末 `\| tr -d '\r'` | 多行各带 CR,`${VAR%}` 只删最后一个不够 |
| `VAR=$(jq -r '.x')` / `VAR=$(… \| jq)` 单值 | 门控/比较值 (type / cwd / marker / 布尔) | 捕获后 `VAR="${VAR%$'\r'}"` (只剥尾) | 单值只有 1 个尾 CR;不碰内部,副作用最小 |
| `content=$(… \| jq -r '.body')` | **数据正文** (写回 LLM / 文件正文) | **不剥 CR** | content 是任意用户输出,CR 是合法字节;剥除 = 篡改 |
| `ENTRY=$(jq -n --arg …)` 构造器 | 生产 JSON 喂 `--argjson` | **不处理** | jq -n 构造非消费上游;`--argjson` 容忍 CR (RFC 8259 whitespace) |
| `jq -c '{…}' > file` 写文件 | jq 为生产者 | **不处理** (若有 shell 门控,改门控捕获处) | 无 shell 消费其 stdout;JSON parser 容忍 CR |

**关键原则**: 只对**进入 shell 条件判断/字符串比较**的值剥 CR。数据正文与 jq 构造器输出保持原样。

---

## 1.2 Exception annotation

数据正文或经验证安全的站点,在捕获行加注释豁免 (供 grep guard 识别):

```bash
content=$(printf '%s' "$input" | jq -r '.tool_response.output // ""')  # crlf-ok: data body written back to LLM — must NOT strip (would corrupt user content)
```

`# crlf-ok: <reason>` 必须陈述为何不剥 (数据正文 / 已验证 jq --argjson 容忍 / 构造器)。

---

## 2. 正向 patterns

```bash
# ✅ 多行 readarray → jq 管道末加 tr -d
readarray -t fields < <(jq -r '(.a), (.b), (.c)' <<<"$input" | tr -d '\r')

# ✅ 单值门控/比较 → 捕获后剥尾 CR
tool_type="$(jq -r '.tool_name | type' <<<"$input")"
tool_type="${tool_type%$'\r'}"
[[ "$tool_type" != "string" ]] && exit 0

# ✅ 单值在 if/else 后统一剥
cmd=$(jq -r '.statusLine.command // ""' "$SETTINGS")
cmd="${cmd%$'\r'}"

# ✅ 数据正文 → 不剥 (注释豁免)
content=$(jq -r '.tool_response.output // ""' <<<"$input")  # crlf-ok: data body

# ✅ jq 构造器 → 不处理 (argjson 容忍 CR)
entry=$(jq -n --arg k "$v" '{key:$k}')
results=$(echo "$results" | jq --argjson e "$entry" '. + [$e]')
```

### Anti-pattern

```bash
# ❌ 笼统对数据正文 tr -d '\r' → 篡改用户内容
content=$(jq -r '.body' | tr -d '\r')   # 删掉正文里合法 CR

# ❌ 多行 readarray 用 ${VAR%} → 只删最后一行的 CR, 中间行残留
readarray -t f < <(jq -r '.a,.b')       # f[0] 仍带 \r
```

---

## 3. 回归防线

- **机械 guard**: `aria/hooks/tests/jq-crlf-guard.sh` 扫描未防护的 jq 读取消费点 (test 阶段运行,非 pre-commit — 避免启发式误报阻断提交)。
- **测试框架**: `aria/hooks/tests/lib/crlf-shim.sh` — 可复用 CRLF shim (awk 每行补 `\r\n` 模拟 Windows native jq) + 双向 self-check + silent-bypass 双向断言原语。Linux/macOS CI 上忠实复现 Windows-only bug,无需真实 Windows runner。
- **非空洞要求**: silent-bypass 站点 (exit 0 pass-through) 的回归测试必须**双向**: nofix (去掉修复的 pristine 副本) 复现 bug → fix 后翻转。仅 fix 态通过 = 空洞,不接受。

---

## 4. 同源 bug 家族 (Windows CRLF / 编码边界)

排查新 shell/Python 代码时一并检查:

| Issue | 版本 | 根因 |
|-------|------|------|
| #61 | v1.21 | Python subprocess `text=True` 缺 `encoding="utf-8"` → GBK locale 乱码 |
| #131 | v1.30.3 | 同 #61 + `_common.py::_run` None guard |
| #132 | v1.34.1 | jq CRLF + `readarray -t` 不 strip `\r` → secret-guard fail-closed |
| shell-jq-crlf-hardening | v1.36.0 | 系统性铺开 #132 修复 + 本规范 + guard + 测试框架 |

---

**最后更新**: 2026-05-30 (shell-jq-crlf-hardening, Aria #132 follow-up)
**维护**: 10CG Lab
