# Scoped Legal Memo — 受限范围法律备忘录模板

> **Version**: 1.0.0
> **Status**: Active
> **Audience**: Aria 方法论使用者 (需进行受限范围合规评审时)
> **Purpose**: 为 User Story / Spec 的合规前置闸门 (例如 US-020 T1) 提供标准化输出格式, 确保合规评估边界清晰、可审计、可追溯
> **Source**: Agent Team Round 3 R3-C-L1 + Round 4 R4-D6 反对意见收敛

---

## 为什么需要受限范围 Memo

标准法律意见通常需要数周或数月的深度审查, 工程节奏无法等待。受限范围 Memo 的目的是:

1. **明确边界** — 显式声明评估覆盖的**司法辖区 / 时间窗口 / 议题范围**, 以及**未覆盖区域**
2. **区分结论类型** — 把"合规结论" (基于深度审查) 与"风险提示" (基于快速扫描) 分列, 避免误用
3. **定义失效条件** — 列出何种变化会使 Memo 失效 (法规变更 / 业务扩张 / 时间衰减)
4. **可追溯签字** — 不构成正式法律意见, 但作为决策可追溯记录 (audit trail) 留档

**什么情况下禁止使用本模板**:
- 涉及真实诉讼或对外声明时 (必须走持证律师正式意见)
- 合规结论将作为对第三方的承诺时
- 业务涉及跨境商业化销售/分发时 (需正式 DPA / 律师签字)

---

## 模板结构

### Frontmatter

```yaml
---
memo_id: <项目>-<US/Spec 号>-legal-memo-<版本>  # 例: aria-2.0-us020-legal-memo-v1
version: 1.0
status: draft | under_review | approved | expired
created: YYYY-MM-DD
reviewer:
  role: legal-advisor (agent) | human-counsel | internal-team
  name: <名称>
parent_artifact: <US / Spec 的路径>
evaluation_window: YYYY-MM-DD 至 YYYY-MM-DD
expires_at: YYYY-MM-DD  # 默认创建后 6 个月
---
```

### 1. 评估范围声明 (In Scope) — 必填

必须以 **结构化列表** 明确本次评估覆盖的全部议题。每条议题含:

- **议题编号** (本 Memo 内唯一)
- **议题描述** (一句话)
- **评估深度** (`risk_notice` 风险提示 / `compliance_review` 合规审查)
- **数据来源** (官方 ToS / 法规原文 / 内部文档 / 其他)

> **评估深度定义**:
> - **`risk_notice`**: 基于公开资料的快速扫描, 输出"是否存在明显风险", **不构成合规结论**
> - **`compliance_review`**: 基于原文逐条对比, 输出"是否合规"的明确判断, 构成可引用结论

**示例**:

```yaml
in_scope:
  - id: IS-1
    title: License 兼容性 (fork upstream 依赖链传染)
    depth: compliance_review
    sources:
      - license-checker --production --json 扫描结果
      - upstream package.json + 传递依赖 LICENSE 文件
  - id: IS-2
    title: GLM 5.1 ToS 自动化条款
    depth: risk_notice
    sources:
      - 智谱清言官方 API 文档 (访问日期: YYYY-MM-DD)
  - id: IS-3
    title: luxeno 代理授权与数据处理条款
    depth: risk_notice
    sources:
      - luxeno 官方网站 ToS 页面 (访问日期: YYYY-MM-DD)
```

### 2. 评估外范围 (Out of Scope) — 必填

必须**显式列出**本次 Memo 不覆盖的议题。覆盖外议题 = 不可引用结论, 后续决策如涉及需单独立项。

```yaml
out_of_scope:
  - 跨境数据流深度合规审查 (仅做 risk_notice 层级)
  - 第三方基础设施 (非 10CG 自有) 的 DPA 深度审查
  - 商标使用的商业化场景
  - 涉及特定司法辖区 (欧盟 GDPR / 美国 CCPA / 中国 PIPL) 的专项合规
```

### 3. 评估方法论 — 必填

说明本次评估如何实施, 包括工具 / 查询路径 / 访问时间窗口。目的是让未来的读者可以**重现评估流程**。

```markdown
## 评估方法论

本次评估采用"三步快速扫描"方法:
1. 工具扫描 (针对 IS-1): 使用 `license-checker --production --json --out license-js.json` 和 `pip-licenses --format=json --with-system` 扫描, 深度 transitive
2. 官方文档定位 (针对 IS-2/IS-3): 通过 {URL} 访问官方 ToS, 定位 "自动化 / Agent / 代理" 相关条款
3. 交叉验证 (针对 IS-4): ...

评估时间窗口: YYYY-MM-DD 10:00 至 YYYY-MM-DD 14:00 (UTC+8)
评估总工时: 4.5h
```

### 4. 每项议题的评估结果 — 每议题必填

对 `in_scope` 的每条议题, 按以下结构输出:

```markdown
## 议题 IS-1: License 兼容性

**评估深度**: compliance_review
**数据快照**: `license-matrix.json` (附件)

### 发现

- direct dependency: N 个, 其中 GPL/AGPL 0 个, LGPL 1 个 (lib-X v1.2.3), Unknown 0 个
- transitive dependency: N 个, ...
- (具体发现, 含证据引用)

### 风险评估

- **高**: 无
- **中**: LGPL 依赖 lib-X 若发生静态链接 → copyleft 传染风险
- **低**: ...

### 结论类型声明

- [ ] **合规结论** (compliance conclusion): 本议题基于原文逐条审查, 可作为明确判断引用
- [x] **风险提示** (risk notice): 本议题基于快速扫描, 不构成最终合规判断

### 建议动作

1. LGPL lib-X → 人类 legal-advisor 人工研判静态链接合规性, **不自动降级**
2. ...
```

### 5. 合规结论 vs 风险提示边界声明 — 必填

以文本形式汇总本 Memo 中哪些议题得出了**合规结论**, 哪些仅是**风险提示**, 帮助消费方 (产品负责人 / 下游 Story) 正确引用。

```markdown
## 结论性质汇总

本 Memo 包含:

**合规结论** (可作为明确判断引用):
- IS-1 License 兼容性 — direct dependency 无 GPL/AGPL/Unknown

**风险提示** (不构成最终合规判断, 仅用于内部决策):
- IS-2 GLM ToS 自动化条款 — 官方文档未明确
- IS-3 luxeno 代理授权 — 官方未公开授权协议
- IS-4 跨境数据流 — 未做深度审查
- IS-5 Aether 节点归属 — 查证结论不确定

**重要**: 风险提示类议题**不得**用作对外声明 / 合同承诺 / 诉讼依据。
```

### 6. 失效条件 — 必填

列出会使本 Memo 结论失效的条件。必须包含**时间衰减**和**变化触发**两类。

```markdown
## 失效条件

本 Memo 在以下任一情况下失效, 必须重新评估:

**时间类**:
- 创建日期超过 6 个月 (默认 TTL)
- `expires_at` 字段到期

**变化类**:
- 相关法规发生重大修订 (例如中国网信办发布新的跨境数据处理办法)
- upstream 依赖链发生变更 (新增 GPL/AGPL/Unknown license)
- 业务范围扩展 (例如从 10CG Lab 内部使用扩展到商业化对外服务)
- 第三方基础设施变更 (例如 Aether 节点归属变化)
- GLM / luxeno 官方 ToS 发生实质性修订

**失效后处置**:
- 不得继续作为决策依据
- 必须起草新版本 Memo 或升级为正式法律意见
```

### 7. 免责声明 — 必填 (不可删除)

```markdown
## 免责声明

**本 Memo 不构成正式法律意见**。

- 本 Memo 是为内部决策提供的快速合规评估, 由 AI agent (若适用) 和内部审阅人员编写
- AI agent 无法律主体资格, 其产出仅供参考, 不构成法律放行依据
- 涉及真实诉讼、对外商业声明、或跨境商业化场景时, **必须**由持证律师出具正式意见
- 本 Memo 的"合规结论"仅限内部决策引用, 对外承诺必须经独立律师确认
- 10CG Lab 不因本 Memo 的任何结论承担法律责任; 使用本 Memo 作出的决策风险自担
```

### 8. 签字位 — 必填

```markdown
## 签字

**Reviewer signature** (审阅人):
- `signed_by`: {agent:legal-advisor | human:<name>}
- `date`: YYYY-MM-DD
- `role`: reviewer

**Final approver signature** (最终裁决人):
- `signed_by`: human:<name>   # 必须是人类
- `date`: YYYY-MM-DD
- `role`: decision_owner

---

**签字表述** (统一, 所有签字位 footer 必须包含):
> 本签字仅作为决策可追溯记录 (audit trail), 不构成法律豁免、责任转移或正式法律意见。
```

---

## 模板使用检查清单

起草 Memo 前确认:
- [ ] 本次评估是否真的是"受限范围" (若需正式意见, 不要用本模板)
- [ ] 评估范围是否可在 timebox 内完成 (典型: 4-8h)
- [ ] 消费方 (产品负责人 / Story) 是否理解"风险提示"不等于"合规结论"

起草 Memo 后验证:
- [ ] Frontmatter 7 字段齐全 (含 `expires_at`)
- [ ] `in_scope` 每条议题的 `depth` 明确
- [ ] `out_of_scope` 显式列出未覆盖议题
- [ ] 每项议题含: 发现 + 风险 + 结论类型声明 + 建议
- [ ] 结论性质汇总段存在且区分合规结论 / 风险提示
- [ ] 失效条件含时间类 + 变化类
- [ ] 免责声明段完整且未删减
- [ ] 签字位含 reviewer + final_approver, 后者必须为人类

---

## 与 Aria 方法论的关系

本模板是 Aria 方法论的**合规评估标准产物**, 适用场景:

- **User Story 的合规前置闸门** (如 US-020 T1 = Aria 2.0 M0 Legal Memo)
- **OpenSpec 中的合规风险段**
- **Spike 的 license 兼容性评估**
- **其他任何需要"快速且边界清晰"的内部合规决策**

**不适用场景** (必须走正式律师意见):
- 对外合同起草 / 审查
- 知识产权诉讼准备
- 跨境商业化分发前合规评估
- 涉及监管机关主动询问的回应

---

## 版本历史

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-04-14 | 初版, 基于 Aria 2.0 US-020 Agent Team Round 3-4 反对收敛 (R3-C-L1 / R4-D6) |
