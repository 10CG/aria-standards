# 版本管理规范

> **Version**: 1.0.0
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

```
VERSION 文件必须与 Git Tag 保持一致

更新顺序:
  1. 更新 VERSION 文件
  2. 提交变更
  3. 打对应的 Git Tag
```

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

```bash
# 1. 更新 VERSION
# 2. 提交变更
git add VERSION CHANGELOG.md
git commit -m "chore: 发布 v1.0.0"

# 3. 创建 Tag
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

---

**维护**: 10CG Lab
**仓库**: https://forgejo.10cg.pub/10CG/Aria
