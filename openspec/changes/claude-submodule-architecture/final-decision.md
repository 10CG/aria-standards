## 最终决策: 方案E - Plugin Marketplace

**采用 Anthropic 官方 `/plugin` 机制实现 Skills 共享**

```
aria-skills (GitHub Public)          # Plugin Marketplace 仓库
├── .claude-plugin/
│   └── marketplace.json             # 定义 5 个插件组
├── commit-msg-generator/
├── strategic-commit-orchestrator/
├── ... (共 20 个 Skills)

~/.claude/skills/                    # Personal Skills (Plugin 安装位置)
└── aria-skills/...                  # 安装后的 Skills

{project}/.claude/skills/            # Project Skills (优先级高于 Personal)
├── flutter-test-generator/          # 项目特定
├── test-verifier/                   # 项目特定
└── doc-integrity-validator/         # 项目特定
```

### 安装方式

```bash
/plugin marketplace add simonfishgit/aria-skills
/plugin install all-skills@10cg-aria-skills
```

### 优点

- 遵循 Anthropic 官方机制，未来兼容性有保障
- 无需子模块，减少项目复杂度
- 支持版本化和选择性安装
- GitHub 公开仓库便于社区共享

### 实施结果

| 仓库 | 位置 | 用途 |
|------|------|------|
| **aria-skills** | GitHub: simonfishgit/aria-skills | Plugin Marketplace 源 |
| **aria-skills** | Forgejo: 10CG/aria-skills | 内部备份 |
| **todo-app skills** | .claude/skills/ | 3 个项目特定 Skills |
| **nexus skills** | (via Plugin) | 按需安装 |

---

## 决策记录

| 日期 | 决策 | 原因 |
|------|------|------|
| 2025-12-29 | 创建 proposal 待讨论 | 架构决策需要深入思考 |
| 2026-01-06 | 发现 Plugin 机制 | 分析 Anthropic 官方 skills 仓库 |
| 2026-01-06 | 采用方案E | 官方机制，无需 hack |
| 2026-01-06 | 创建 aria-skills 仓库 | GitHub + Forgejo 双同步 |
| 2026-01-06 | 迁移 20 个 Skills | todo-app 保留 3 个项目特定 |
| 2026-01-06 | 验证 Plugin 安装成功 | GitHub 公开仓库可用 |

---

## 实施完成

- [x] 确定 skills 共享机制 → Plugin Marketplace
- [x] 验证 Claude Code plugin 配置能力 → 支持
- [x] 确定最终方案 → 方案E
- [x] 创建 aria-skills 仓库
- [x] 配置 marketplace.json
- [x] 迁移 20 个通用 Skills
- [x] 清理 todo-app 项目特定 Skills
- [x] 更新 todo-app skills README
- [x] 验证 Plugin 安装

---

## 相关文档

- [aria-skills](https://github.com/simonfishgit/aria-skills) - Plugin Marketplace 仓库
- [Anthropic Skills](https://github.com/anthropics/skills) - 官方 Skills 参考
- [todo-app/.claude/skills/README.md](/.claude/skills/README.md) - 项目特定 Skills 说明
