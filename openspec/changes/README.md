# OpenSpec Changes

> 活跃的变更规范目录

## 目录结构

```
changes/
├── README.md           # 本文件
└── {feature}/          # 活跃的变更
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
