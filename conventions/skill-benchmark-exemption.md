# Skill Benchmark Exemption 规范 — AB 豁免判据: 内容是否影响 AI 行为

> **Version**: 1.0.0
> **Status**: Active
> **Source incidents**: 2026-07-20 两起同日发生的边界误判 —— (1) `state-scanner-stale-refs-false-parity` Phase 4 以「未改 SKILL.md 指令面」自我豁免, 而它改了 `references/rules/basic-rules.md` 的 dispatch 表 77 行; (2) `state-scanner-gate-yaml-datasource` (#113) 改了 `references/runtime-probe-declaration.md` 这份 **authoring 向导**, 按目录判据无法归类, 按规则 #10 纪律不自行裁定而提请 owner
> **Owner 裁决**: 2026-07-20 (第三次) — 判据从「文件落在哪个目录」改为「**内容是否影响 AI 行为, 以及那个行为 AB 套件测不测得到**」
> **对应规则**: Aria CLAUDE.md 不可协商规则 **#6**
> **姊妹规范**: [configured-gate-authority.md](./configured-gate-authority.md) (规则 #10 — 豁免须是机制而非临场判断)

---

## 1. 判据

> **AB benchmark 测的是「AI 读了新指令之后, 行为有没有变好」。**
> **所以豁免与否, 取决于改动是否改变 AI 的行为, 以及那个行为 AB 套件测不测得到 —— 与文件落在哪个目录无关。**

**不要按目录判**。`skills/*/references/` 目录下同时住着两类东西:

- 纯**描述性**内容: schema、字段定义与取值域、跨平台命令语法、术语表 —— 陈述事实, 不指示行为;
- **处方性**内容: `references/rules/*` 的 dispatch 表、判定规则、「什么状态给什么建议」的措辞 —— AI 读了照做, 与 SKILL.md 正文同性质。

同一个文件里也可能两者并存。**逐 hunk 判, 不逐文件判**; 只要有任一 hunk 落在「处方性且在测量范围内」, 整个变更就照跑。

## 2. 决策表 (fail-closed)

| 内容性质 | AB 套件能观测该行为吗 | 处置 |
|----------|----------------------|------|
| **描述性** (schema / 字段 / 命令语法 / 溯源注释 / 行号勘正) | 不适用 | **deterministic substitute**: 以结构化测试 (SC 级 baseline-failing 单元/集成测试, 必须在场) 替代 AB |
| **处方性**, 且属运行时指令面 (SKILL.md 正文 / `references/rules/*` dispatch / 判定规则) | 能 | **照跑 AB, 零裁量** |
| **处方性**, 但它治的行为在**固定测试集覆盖范围之外** (典型: authoring 向导 —— 给 spec 作者读的处方, 而套件测的是 skill 运行时行为) | **不能** | 见 §3 —— **不是简单豁免**, 是「AB 测不到 ⇒ 换定向 fixture + 记套件缺口」 |
| 拿不准算不算处方性 / 算不算在范围内 | — | **照跑** (宁跑勿豁) |

**SKILL.md 有变动时的附加约束** (承前): 仅当变动是**事实性同步** (溯源注释 / 行号勘正 / 术语修正) 且 frontmatter `description` 零变动, 才可能落进第一行; 须在 spec 里**逐行点名**该变动并声明非指令语义变更。`description` 或指令流程变动 ⇒ 一律第二行。

## 3. 第三行不是逃生舱 (关键设计)

「AB 套件覆盖不到这个行为」听起来像一条更宽的豁免路。**它必须比照跑 AB 更麻烦, 否则会被当成捷径滥用。** 走这一行必须**同时**满足三条, 缺一即回落到「照跑」:

1. **点名行为**: 在 spec 里写清「本改动影响的是哪个 AI 行为」(例: 「spec 作者填写 `runtime_probe` frontmatter 时的判断」), 以及**为什么现有固定测试集结构上测不到它** (例: 该套件的 eval 全是 scanning 场景, 无 authoring 场景);
2. **建定向 fixture**: 为该行为**实际建一个可证伪的 fixture / 结构化测试** —— 不是"以现有测试代替", 是**新建针对该行为的**。可证伪性须实证 (把改动回退, 该 fixture 必须转红);
3. **记套件缺口**: 把「固定测试集缺该维度」开成 issue。**套件的盲区是债, 不是豁免理由** —— 这一条防止同一个盲区被反复用来豁免。

三条齐备, 才算 substitute 成立。

> **为什么这样设计**: AB 对一个它结构上测不到的行为跑一遍, 是**测量剧场** —— 无论结果如何都不构成证据, 还会让人误以为验过了。真正诚实的做法不是"跳过验证", 而是"换一个能验到的手段, 并把测不到这件事记下来"。

## 4. 与规则 #10 的关系

规则 #10 (见姊妹规范) 说: **豁免只能来自已写明的机制, 不能来自 AI 临场判断**。本规范就是把 Rule #6 的豁免写成机制的那份文书。

两者叠加的实操含义:
- AI **可以**照本规范的决策表自行归类, 因为判据已成文;
- AI **不可以**在决策表之外自创理由 (「这次改动小」「反正测不出来」);
- 落进「拿不准」格时, **默认照跑**, 而不是默认豁免;
- 无论走哪一行, 都要在 spec/tasks 留 `rule6_note` 引用本规范 (留痕保留, 复议豁免)。

## 5. 已裁定的样例 (worked examples)

按本判据回溯裁定, 供后续对照:

| 变更 | 内容性质 | 处置 | 理由 |
|------|----------|------|------|
| `state-scanner-stale-refs-false-parity` **v1.59.0** (F5′ 纯函数, INERT 零调用点) | 描述性 + 纯代码 | substitute | 无指令面变动 |
| 同 spec **v1.60.0** (F1′-F10″ collector 代码层) | 纯代码 | substitute | 同上 |
| 同 spec **v1.62.0 / Phase 4** (`basic-rules.md` dispatch 第七路 + `degrade_when` 77 行) | **处方性 · 运行时指令面** | **照跑 AB** | 「在什么状态下给什么建议」直接改变 AI 产出; 已于 2026-07-20 补跑 |
| `state-scanner-gate-yaml-datasource` (#113) 的 `state-snapshot-schema.md` (+5 行字段语义) | 描述性 | substitute | 纯事实文档 |
| 同 cycle 的 `runtime-probe-declaration.md` (+25/-6, 改「前置条件」段, 含处方性建议) | **处方性 · authoring 向导** | **第三行** | 它影响的是「spec 作者填 frontmatter 时怎么判断」, 而 state-scanner 的固定测试集全是 scanning 场景, 结构上测不到 authoring 行为 ⇒ 跑 AB 是测量剧场。须按 §3 三条: 点名行为 + 建 authoring 定向 fixture (可证伪) + 把「套件缺 authoring 维度」开成 issue |

## 6. 已知局限

本规范只解决「要不要跑 AB」。它**不解决** AB 本身的测量有效性问题 —— 后者另有两个已知缺陷记录在案:

- **baseline 臂在项目自己的仓库里结构上无法做干净**: 项目级指令文件 (如 `CLAUDE.md`) 会自动加载进每个 subagent, 其中往往写着被测 Skill 的设计术语与结论 ⇒ `without_skill` 臂读到的是「Skill 设计的摘要」而非「没有 Skill 的世界」。因此 **with/without 那一列不能用来回答「Skill 本身是否有价值」**; 能站住的是**新版 vs 旧版**(两臂看到同一份污染, 对称抵消)。
- **该污染还会顺着「baseline 也过就删断言」的常见判据反向磨钝测试集** —— 被污染的 baseline 会通过那些对真实采用者确实有区分度的断言。三臂全过时应**先做语义分档** (完全没提 / 提到但描述为已知缺口 / 作为已接线机制给出), 再决定是拆条还是删除。

详见 aria-plugin issue #116。
