# OpenSpec Changes

> 活跃的变更规范目录

## ⚠️ 重要: 使用边界

**本目录仅用于 Aria 自身的方法论改进变更。**

如果您正在使用 Aria 开发项目，请在**您自己的项目**中创建变更目录：

```
your-project/
├── standards/          → aria-standards 子模块 (引用)
├── specs/              ← 您的项目变更在这里
│   └── your-feature/
│       ├── proposal.md
│       └── tasks.md
└── docs/
    └── requirements/
```

**为什么?**
- aria-standards 是一个**共享子模块**，不应包含用户项目的变更
- Git 子模块的特性导致在其中创建的变更会被追踪到 aria-standards 仓库
- 这违背了 Aria 作为"通用方法论"的初衷

**参考示例**: `../examples/user-projects/` 包含其他项目的变更示例，供学习参考。

---

## 目录结构

```
changes/
├── README.md           # 本文件
└── {feature}/          # 活跃的变更 (仅限 Aria 方法论改进)
    ├── proposal.md     # 变更提案 (必需)
    ├── tasks.md        # 任务清单 (必需)
    └── design.md       # 设计文档 (可选)
```

## 变更生命周期

```
Draft → Review → Approved → Implementing → Implemented → Archived
                                                            ↓
                                          移动到 ../archive/
```

## 归档说明

**归档位置**: `openspec/archive/` (与 changes 同级)

```bash
# 正确的归档操作
mv changes/{feature} archive/$(date +%Y-%m-%d)-{feature}
```

详细归档规范请参阅: [../archive/README.md](../archive/README.md)

---

**注意**: 禁止在 changes/ 下创建 archive 子目录
