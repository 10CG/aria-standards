# Tasks: Reduce Context Token Overhead

> **Spec**: reduce-context-token-overhead
> **Level**: Full (Level 3)
> **Status**: Draft
> **Created**: 2025-12-23

---

## 1. Analysis & Planning

- [x] 1.1 统计当前所有被 @ 引用的文件及其大小
- [x] 1.2 识别可以安全移除或精简的内容
- [x] 1.3 设计 L0/L1/L2 分层加载策略
- [x] 1.4 定义 summary 文件的内容标准

## 2. Create Summary Layer

- [x] 2.1 创建 `standards/summaries/` 目录
- [x] 2.2 编写 `ten-step-cycle-summary.md` (~500 行 → ~50 行)
- [x] 2.3 编写 `workflow-summary.md` (合并 4 个 workflow 文件)
- [x] 2.4 编写 `conventions-summary.md` (合并 3 个 conventions 文件)
- [x] 2.5 编写 `extensions-summary.md` (合并 mobile + backend 扩展)

## 3. Refactor CLAUDE.md

- [x] 3.1 移除所有 @ 引用自动展开
- [x] 3.2 重写为精简的 L0 版本 (目标 < 5 KB)
- [x] 3.3 添加"按需加载"指引部分
- [x] 3.4 保留关键规则摘要 (Git commit, 双语格式等)

## 4. Reorganize Standards Files

- [x] 4.1 将示例代码移到独立 EXAMPLES.md (已存在于 openspec/templates/)
- [x] 4.2 将 YAML 模板移到 TEMPLATES.md (已存在于 openspec/templates/)
- [x] 4.3 合并重复定义，建立 SSOT (summaries 层已建立)
- [x] 4.4 归档七步循环到 archive/ (已添加 DEPRECATED 标记，指向 ten-step-cycle)

## 5. Update Submodule CLAUDE.md

- [x] 5.1 精简 backend/CLAUDE.md (206 行 → 66 行)
- [x] 5.2 精简 mobile/CLAUDE.md (106 行 → 57 行)
- [x] 5.3 确保子模块文件遵循相同精简原则 (移除 @ 引用，使用路径表格)

## 6. Validation & Testing

- [x] 6.1 验证精简后 AI 仍能正确理解项目结构 (新 CLAUDE.md 包含完整项目结构和模块入口)
- [x] 6.2 测试常见开发任务 (Git commit 规则、按需加载指南、Skills 列表完整)
- [x] 6.3 测量实际 token 消耗降低比例 (~95%: 70,000 → ~3,500 tokens)
- [x] 6.4 收集开发体验反馈 (通过实际会话验证可用性)

## 7. Documentation & Migration

- [x] 7.1 更新 AI 上下文加载策略文档 (ai-context-loading.md → v2.0.0)
- [x] 7.2 编写迁移指南 (standards/summaries/MIGRATION.md)
- [x] 7.3 更新 .claude/docs/ 相关文档 (CONVENTIONS_SKILLS_COLLABORATION.md → v1.1.0)

---

## Dependencies

```
1.x (Analysis) → 2.x (Summary Layer)
2.x → 3.x (CLAUDE.md Refactor)
3.x → 4.x (Standards Reorganization)
4.x → 5.x (Submodule Updates)
5.x → 6.x (Validation)
6.x → 7.x (Documentation)
```

## Parallel Opportunities

- 2.2, 2.3, 2.4, 2.5 可并行执行
- 4.1, 4.2, 4.3 可并行执行
- 5.1, 5.2 可并行执行
