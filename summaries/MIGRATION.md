# Context Loading 迁移指南

> **版本**: 1.0.0
> **创建日期**: 2025-12-23
> **适用**: 从 @ 引用模式迁移到 L0 摘要层

---

## 变更摘要

| 指标 | 迁移前 | 迁移后 | 改进 |
|------|--------|--------|------|
| 初始 Token | ~70,000 | ~3,500 | **-95%** |
| CLAUDE.md | ~14 KB | ~5 KB | -64% |
| 自动展开文件 | 18+ | 0 | -100% |

---

## 迁移后的文件结构

```
standards/
├── summaries/                    # [NEW] L0 摘要层
│   ├── README.md                 # 目录索引
│   ├── ten-step-cycle-summary.md # 十步循环摘要
│   ├── workflow-summary.md       # 工作流摘要
│   ├── conventions-summary.md    # 约定规范摘要
│   ├── extensions-summary.md     # 模块扩展摘要
│   ├── upm-summary.md           # 进度管理摘要
│   └── MIGRATION.md             # 本文档
├── core/                         # L2 详细规范
├── conventions/                  # L2 详细规范
└── extensions/                   # L2 详细规范
```

---

## 三层加载策略

### L0 - 摘要层 (Always Load)

每次会话自动加载，共 ~3,500 tokens：

```yaml
文件:
  - CLAUDE.md                         # ~5KB
  - standards/summaries/*.md          # ~7KB
```

### L1 - 模块层 (On-Demand)

特定模块开发时加载，每模块 ~1,000-2,000 tokens：

```yaml
文件:
  - {module}/CLAUDE.md
  - {module}/ARCHITECTURE.md
  - {module}/UPM文档
```

### L2 - 详细层 (Deep-Dive)

需要完整规范时加载：

```yaml
文件:
  - standards/core/*/README.md
  - standards/conventions/*.md
  - standards/extensions/*.md
```

---

## AI 工作模式

### 搜索模式 (推荐)

```yaml
触发: 需要定位功能/模块/文件
工具: arch-search Skill
策略: 三层递进搜索
优势: 平均节省 70% Token
```

### 开发模式 (默认)

```yaml
触发: 功能开发、Bug 修复
入口: CLAUDE.md → {module}/ARCHITECTURE.md → 代码
集成: arch-search 自动定位
```

### 文档维护模式

```yaml
触发: 更新/创建架构文档
入口: docs/standards/architecture-documentation-management-system.md
工具: arch-update Skill
```

---

## 迁移检查清单

### 主 CLAUDE.md

- [x] 移除所有 `@file.md` 自动展开引用
- [x] 添加 `standards/summaries/` 引用
- [x] 保留项目特定规则摘要
- [x] 添加按需加载指引

### 子模块 CLAUDE.md

- [x] backend/CLAUDE.md: 206 行 → 66 行
- [x] mobile/CLAUDE.md: 106 行 → 57 行
- [x] 移除 @ 引用，使用路径表格

### 摘要文件

- [x] ten-step-cycle-summary.md
- [x] workflow-summary.md
- [x] conventions-summary.md
- [x] extensions-summary.md
- [x] upm-summary.md

---

## 常见问题

### Q: 如何找到详细规范？

A: 使用 arch-search Skill 或直接查看 `standards/core/` 目录。

### Q: L0 摘要层足够吗？

A: L0 提供 90% 日常开发所需信息。复杂任务时按需加载 L1/L2。

### Q: @ 引用还能用吗？

A: 可以，但已从 CLAUDE.md 移除以减少 Token。按需手动引用。

---

## 相关文档

- **SSOT**: `standards/core/workflow/ai-context-loading.md`
- **摘要索引**: `standards/summaries/README.md`
- **协作架构**: `.claude/docs/CONVENTIONS_SKILLS_COLLABORATION.md`

---

**最后更新**: 2025-12-23
