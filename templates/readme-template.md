# README 模板

本文档提供两种 README 风格模板：完整版（项目级）和简洁版（模块级）。

---

## 模板 A: 完整版 (项目级 README)

适用于：主项目 README、独立子项目

```markdown
# {项目名称}

> **Version**: X.Y.Z
> **Status**: Active | Maintenance | Deprecated
> **Updated**: YYYY-MM-DD

{一句话项目描述}

## 目录

1. [项目结构](#项目结构)
2. [技术栈](#技术栈)
3. [快速开始](#快速开始)
4. [开发指南](#开发指南)
5. [测试](#测试)
6. [部署](#部署)
7. [许可证](#许可证)

---

## 项目结构

\`\`\`
project/
├── src/              # 源代码
├── tests/            # 测试
├── docs/             # 文档
├── scripts/          # 脚本
└── README.md
\`\`\`

---

## 技术栈

| 层级 | 技术 | 版本 |
|------|------|------|
| 语言 | {Language} | X.X |
| 框架 | {Framework} | X.X |
| 数据库 | {Database} | X.X |
| 测试 | {Test Framework} | X.X |

---

## 快速开始

### 前置条件

- {前置条件1}
- {前置条件2}

### 安装

\`\`\`bash
# 克隆仓库
git clone {repo-url}
cd {project}

# 安装依赖
{install-command}
\`\`\`

### 运行

\`\`\`bash
# 开发模式
{dev-command}

# 生产模式
{prod-command}
\`\`\`

---

## 开发指南

### 代码规范

- {规范1}
- {规范2}

### 分支策略

| 分支 | 用途 |
|------|------|
| main | 生产分支 |
| develop | 开发分支 |
| feature/* | 功能分支 |

---

## 测试

\`\`\`bash
# 运行所有测试
{test-command}

# 覆盖率报告
{coverage-command}
\`\`\`

---

## 部署

{部署说明或链接到部署文档}

---

## 环境变量

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| {VAR1} | {说明} | {默认} |
| {VAR2} | {说明} | {默认} |

---

## 许可证

{License Type}

---

## 相关文档

- [项目文档](docs/)
- [API 文档](docs/api/)
- [贡献指南](CONTRIBUTING.md)
```

---

## 模板 B: 简洁版 (模块级 README / CLAUDE.md 风格)

适用于：子模块、AI 配置文件 (CLAUDE.md)

```markdown
# {模块名称} - {简述}

## 概述

{1-2 句描述模块用途}

## 技术栈

- {技术1} / {技术2} / {技术3}

## 常用命令

\`\`\`bash
# 测试
{test-command}

# 构建
{build-command}

# 分析
{lint-command}
\`\`\`

## 目录结构

\`\`\`
module/
├── src/       # 源代码
├── tests/     # 测试
└── docs/      # 文档
\`\`\`

## 配置参考

| 配置 | 说明 |
|------|------|
| {配置1} | {说明} |
| {配置2} | {说明} |

## 质量门禁

| 指标 | 目标 |
|------|------|
| 测试覆盖率 | >= 85% |
| 代码分析 | 0 errors |

## 相关文档

| 文档 | 路径 |
|------|------|
| 架构文档 | `docs/ARCHITECTURE.md` |
| API 契约 | `shared/contracts/` |

---

*版本: X.Y.Z | 更新: YYYY-MM-DD*
```

---

## 选择指南

| 场景 | 推荐模板 |
|------|---------|
| 主项目 README | 完整版 (A) |
| 独立子项目 (backend, mobile) | 完整版 (A) |
| 子模块 (shared, standards) | 简洁版 (B) |
| AI 配置 (CLAUDE.md) | 简洁版 (B) |
| Skill 文档 (SKILL.md) | 简洁版 (B) |

## 格式约定

- **标题**: 使用 `#` 层级，最多 3 级
- **代码块**: 指定语言 (bash, yaml, etc.)
- **表格**: 用于配置、环境变量等结构化信息
- **版本信息**: 放在文档末尾或顶部元数据
