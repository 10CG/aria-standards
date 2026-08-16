# 版本管理规范

> **Version**: 1.1.0
> **Status**: Active
> **Based on**: Semantic Versioning (semver.org)

---

## 1. 版本号格式

### 1.1 基本结构

```
major.minor.patch
  ↑     ↑     ↑
  │     │     │
  │     │     └── 补丁版本 (Bug修复、文档修正)
  │     └── 次版本 (新功能、向下兼容)
  └── 主版本 (重大变更、可能不兼容)
```

### 1.2 版本号示例

| 版本 | 说明 | 示例变更 |
|------|------|----------|
| `1.0.0` → `1.0.1` | Patch | 修复文档错别字、修正链接 |
| `1.0.0` → `1.1.0` | Minor | 新增一个 Skill、新增 Phase |
| `1.0.0` → `2.0.0` | Major | 修改十步循环结构、OpenSpec 重大变更 |

---

## 2. 何时更新版本

### 2.1 Major (主版本) - 破坏性变更

**触发条件**:
- 方法论核心结构变更
- 十步循环步骤增减或重命名
- OpenSpec 格式不兼容变更
- 移除已废弃的功能

**示例**:
```
1.x.x → 2.0.0
- 重构十步循环为十二步循环
- OpenSpec v2 → v3 (不兼容)
```

### 2.2 Minor (次版本) - 新功能

**触发条件**:
- 新增 Phase Skill
- 新增核心 Agent
- 新增规范类型
- 功能增强（向下兼容）

**示例**:
```
1.0.x → 1.1.0
- 新增 phase-x-executor Skill
- 新增 architecture-updater Agent
```

### 2.3 Patch (补丁版本) - 修复

**触发条件**:
- 文档错误修正
- 链接修复
- 小改进
- Bug 修复

**示例**:
```
1.0.0 → 1.0.1
- 修正 SKILL.md 格式错误
- 更新过期链接
- 修复 trigger-rules.json 拼写
```

---

## 3. Git Tag 规范

### 3.1 Tag 命名

```bash
# 主项目
v{major}.{minor}.{patch}

# 子模块
{name}-v{major}.{minor}.{patch}

# 预发布版本
v{version}-{rc|beta|alpha}.{number}
```

### 3.2 Tag 示例

| 类型 | 格式 | 示例 |
|------|------|------|
| 正式发布 | `v{version}` | `v1.0.0`, `v1.1.0` |
| 候选版本 | `v{version}-rc.{n}` | `v1.1.0-rc.1` |
| 测试版本 | `v{version}-beta.{n}` | `v2.0.0-beta.1` |
| 子模块 | `{name}-v{version}` | `agents-v2.0.2` |

### 3.3 何时打 Tag

```
✅ 应该打 Tag:
  - 正式发布 (Release)
  - 里程碑完成
  - 重要文档定稿

❌ 不应打 Tag:
  - 每次提交
  - 临时工作状态
  - 仅文档草稿
  - Meta-repo / 按需锚点型的常规版本 bump (无 tag 消费方; VERSION 文件即 SOT, 见 §4.3 三分判据)
```

---

## 4. VERSION 文件

### 4.1 文件位置

```
{project}/VERSION          # 主项目版本
{submodule}/VERSION        # 子模块版本 (在各子仓库)
```

### 4.2 文件格式

```markdown
# {项目名} 版本信息

> **版本**: {version}
> **最后更新**: {date}

## 版本号

```
{major}.{minor}.{patch}
```

## 子模块版本

| 子模块 | 版本 | 仓库 |
|--------|------|------|
| ... | ... | ... |

## 对应 Tag

```
v{version}
```
```

### 4.3 同步规则

tag 要求按「**有没有下游按本仓 git tag 拉取**」+「**要不要历史锚点**」分三类 (判据表见本节末):

**分发型组件 (下游确实按 tag 拉取)**:

```
VERSION 文件必须与 Git Tag 保持一致

更新顺序:
  1. 更新 VERSION 文件
  2. 提交变更
  3. 打对应的 Git Tag
```

> 🔴 **2026-08-16 更正: aria 插件不属于本类** (owner 裁定, 选项 C)。
>
> **上一版把 aria 插件举为本类的例子, 理由写作「市场/下游按 tag 拉取」—— 该理由经实测为假**:
>
> | 实测项 | 结果 |
> |---|---|
> | `marketplace.json` 的插件 `source` | `{"source": "url", "url": ".../aria-plugin.git"}` —— **裸 git 地址, 无 tag / 无 ref / 无版本 pin** |
> | 本机 marketplace 克隆的 HEAD | 在 **`master` 分支**上; `git describe --tags --exact-match` = **不在任何 tag 上** |
> | 安装路径 | 克隆 master → 读 `plugin.json` 的版本 → 按该号存进缓存目录, **全程不读 git tag** |
> | 后果 | tag 停在 **v1.21.3** 而 VERSION 走到 1.66.0 ⇒ **44 个版本 / 248 个 commit 未打 tag** |
>
> ⇒ 按本节自己的判据 (「有没有下游按本仓 tag 拉取」), aria 插件的答案是**没有** ——
> 归入分发型是**分类错误**, 不是执行不力。**一条永远不会被遵守的要求 = 恒亮的假告警。**
>
> **处置 (选项 C, 非 A 也非 B)**: 分类改对 (见下方「按需锚点型」), **且自 v1.66.0 起恢复打 tag**,
> 但**用途改为历史锚点**而非下游拉取依据; **历史断层不补**, 就地写明 —— 不假装历史是干净的。

**Meta-repo (如 Aria 主项目 — 无 tag 消费方)**:

```
VERSION 文件即 SOT, 不要求 per-version git tag。

原因:
  - 主项目版本随插件 gitlink bump + 文档同步滚动, 非离散发布事件
    (无「这个 commit = v1.7.0」的干净发布边界)
  - 无下游按主项目 git tag 拉取
    (⚠️ 2026-08-16 更正: 上一版此处写「市场拉的是 aria 插件子模块, **它自带独立 tag**」
     —— 后半句经实测为假, 市场拉的是插件仓的 master 分支, 不读 tag。结论不受影响:
     主项目本身确实无 tag 消费方; 但那个理由不成立, 已换掉)
  - 强行要求 per-version tag 会制造永久的「VERSION≠tag」假 drift
    (实证: Aria 主仓 tag 停在 v1.5.0, 版本经 VERSION bump 走到 1.7.3+ 从未补 tag)

更新顺序:
  1. 更新 VERSION 文件 (版本 SOT)
  2. 提交 + 双远程推送
  (不打 tag; 需要历史锚点时按里程碑择要打, 见 §3.3)
```

**按需锚点型 (如 aria 插件 — 无 tag 消费方, 但需要历史锚点)**:

```
VERSION 文件即 SOT (与 meta-repo 同); tag 不是发布依据, 而是历史锚点。

为什么仍然打 tag (与 meta-repo 的唯一区别):
  - 事后追溯需要「v1.52.0 到底是哪个 commit」这种问题有答案;
    没有 tag 时只能翻 CHANGELOG 猜, 而 CHANGELOG 不带 SHA
  - `git describe` / 发布说明 / bisect 起点都依赖它
  - 代价极低 (发版时一条命令), 而缺失时的补救成本随时间线性增长

更新顺序:
  1. 更新 VERSION 文件 (版本 SOT)
  2. 提交 + 双远程推送 (含 tag: git push <remote> vX.Y.Z)
  3. 逐 remote 独立核验 tag 对象 SHA (硬约束 2 同款, 不信 push 回执)

⚠️ tag 缺失**不阻断发布** —— 它不是下游拉取依据。补打即可, 无需 revert。
```

> 🔴 **aria 插件的历史断层 (2026-08-16 就地留痕, 不补)**:
> tag 自 **v1.21.3** 起中断, 至 **v1.66.0** 恢复, 中间 **44 个版本 / 248 个 commit 无 tag**。
> **不追溯补打** —— 补齐需要为每个版本考古出对应 commit, 而该区间的价值低于成本;
> 且**假装历史干净比承认断层更坏**。需要该区间的锚点时, 按 `aria/CHANGELOG.md` 的版本条目
> 配合 `git log --grep` 定位, 并接受结果是近似的。

> **判据 (三分)**:
> | 下游按本仓 tag 拉取? | 需要历史锚点? | 类别 | tag 要求 |
> |---|---|---|---|
> | 是 | — | **分发型** | 严格 VERSION = tag, 缺 tag = 发布不完整 |
> | 否 | 是 | **按需锚点型** | 打 tag 但仅作锚点, 缺失不阻断发布 |
> | 否 | 否 | **meta-repo** | VERSION-file-only, 不打 tag |
>
> ⚠️ **归类前先实测「下游到底怎么拉」**, 不要按直觉 —— 上一版把 aria 插件归成分发型正是
> 凭「它是个插件, 插件当然按 tag 分发」这种直觉, 而实测的分发路径里根本没有 tag。

---

## 5. 子模块版本管理

### 5.1 子模块独立版本

```
aria-standards/  → 独立版本 (standards-v2.1.0)
aria-skills/     → 独立版本 (skills-v1.1.0)
aria-agents/     → 独立版本 (agents-v2.0.2)
```

### 5.2 子模块版本更新

```bash
# 更新子模块到最新
git submodule update --remote

# 锁定特定版本
cd .claude/skills
git checkout skills-v1.1.0
cd ../..
git add .claude/skills
git commit -m "chore: 锁定 aria-skills 到 v1.1.0"
```

### 5.3 主项目与子模块版本关系

```
主项目版本 ≠ 子模块版本之和

规则:
- 主项目版本反映整体方法论成熟度
- 子模块版本反映各组件演进
- 子模块 Minor 更新通常不触发主项目 Major
```

---

## 6. 发布检查清单

### 6.1 发布前

- [ ] VERSION 文件已更新
- [ ] CHANGELOG.md 已更新
- [ ] 所有文档链接有效
- [ ] 子模块版本已记录
- [ ] 测试通过 (如有)

### 6.2 发布时

> 下例含打 tag 的完整流程。按 §4.3 **三分判据**取舍步骤 3:
> **分发型** 必做 (缺 tag = 发布不完整) · **按需锚点型** (如 aria 插件) 做, 但缺失不阻断发布 ·
> **meta-repo** (如 Aria 主项目) 跳过。三类均按 §4.3 双远程推送并逐 remote 独立核验。

```bash
# 1. 更新 VERSION
# 2. 提交变更
git add VERSION CHANGELOG.md
git commit -m "chore: 发布 v1.0.0"

# 3. 创建 Tag (分发型必做 / 按需锚点型做但不阻断 / meta-repo 跳过 — 见 §4.3 三分判据)
git tag -a v1.0.0 -m "Release v1.0.0: 首个正式版本"

# 4. 推送
git push origin master
git push origin v1.0.0
```

### 6.3 发布后

- [ ] 更新 Forgejo Release
- [ ] 通知用户 (如有重大变更)
- [ ] 更新插件 marketplace

---

## 7. CHANGELOG 格式

### 7.1 标准 CHANGELOG

基于 [Keep a Changelog](https://keepachangelog.com/) 格式：

```markdown
# Changelog

## [1.1.0] - 2026-01-30

### Added
- 新增 phase-x-executor Skill
- 新增自动触发规则

### Changed
- 优化 state-scanner 性能
- 更新 README 安装说明

### Fixed
- 修复 arch-update 模块解析问题

### Deprecated
- (无)

### Removed
- (无)

## [1.0.0] - 2026-01-23

### Added
- 首个正式发布
- 十步循环工作流
- OpenSpec v2.1.0
```

---

## 8. 版本查询

### 8.1 查询当前版本

```bash
# 方式1: 查看 VERSION 文件
cat VERSION

# 方式2: 查看 Git Tag
git describe --tags --abbrev=0

# 方式3: 查看子模块版本
git submodule status
```

### 8.2 版本比较

```bash
# 检查是否有未发布的变更
git log v1.0.0..HEAD --oneline

# 查看两个版本之间的差异
git diff v1.0.0..v1.1.0
```

---

## 9. 相关文档

| 文档 | 位置 |
|------|------|
| Git 提交规范 | `standards/conventions/git-commit.md` |
| CHANGELOG 格式 | `standards/conventions/changelog-format.md` |
| Semantic Versioning | https://semver.org/lang/zh-CN/ |

---

## Version History

| 版本 | 日期 | 变更 |
|------|------|------|
| 1.0.0 | 2026-01-23 | 初始版本 |
| 1.1.0 | 2026-08-16 | §4.3 由二分改**三分** (新增「按需锚点型」)。触发: 实测发现 aria 插件被错归为「分发型」——其理由「市场按 tag 拉取」经实测为假 (marketplace.json 的 source 是裸 git 地址, 市场克隆跟的是 master 分支, `git describe --tags --exact-match` 不在任何 tag 上), 导致该要求 44 个版本 / 248 commit 从未被执行 = 恒亮假告警。owner 裁定选项 C: 分类改对 + 自 v1.66.0 起打 tag 作**历史锚点** + 历史断层就地留痕不补。同步修正 §4.3 meta-repo 段一处失实理由、§3.3 与 §6.2 的二分表述。 |

---

**维护**: 10CG Lab
**仓库**: https://github.com/10CG/Aria
