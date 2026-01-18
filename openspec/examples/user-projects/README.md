# User Project Examples

> 本目录包含其他使用 Aria 方法论的项目变更示例

## 说明

这些变更**不是 Aria 的一部分**，而是来自用户项目的参考示例。

**为什么在这里?**
- 历史原因: 这些变更最初被错误地放置在 `aria-standards/openspec/changes/`
- 参考价值: 展示如何使用 Aria/OpenSpec 规范来描述实际项目变更

## 包含的示例

| 项目 | 描述 | 模块 |
|------|------|------|
| `backend-api-development` | 后端 API 实现规范 | backend |
| `complete-requirements-chain` | 需求追踪链路完善 | cross |

## 您的项目应该怎么做

**不要**在 `standards/openspec/changes/` 中创建变更。

**应该**在您的项目中创建 `specs/` 目录:

```bash
your-project/
├── standards/          → aria-standards (子模块)
├── specs/              ← 您的变更目录
│   └── your-feature/
│       ├── proposal.md
│       └── tasks.md
└── docs/
    └── requirements/
```

---

**维护**: 这些示例仅供参考，不代表 Aria 的方法论定义。
