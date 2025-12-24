# Add Test Verification Skill

> **Level**: 2 (Minimal)
> **Status**: Draft
> **Module**: standards
> **Created**: 2025-12-24

## Why

当前十步循环中 B.2 (执行验证) 步骤的 Skill 覆盖率仅为 30%：
- `flutter-test-generator` 仅覆盖 Flutter/Dart 测试生成
- `openspec:apply` 不包含测试验证流程
- 缺少 Python/Backend 测试支持
- 缺少跨模块的通用测试验证框架

这导致开发者在 B.2 步骤需要手动执行大量测试相关操作，无法实现十步循环的自动化闭环。

## What

创建 `test-verifier` Skill，作为 B.2 步骤的通用测试验证工具：

1. **多模块测试支持**
   - Mobile (Flutter): 集成 flutter-test-generator
   - Backend (Python): pytest 测试执行
   - Shared: 契约验证测试

2. **验证流程自动化**
   - 自动检测变更文件的测试覆盖
   - 运行相关测试套件
   - 生成测试报告摘要
   - 与 OpenSpec tasks.md 状态同步

3. **质量门控**
   - 测试通过率检查
   - 覆盖率阈值检查 (可配置)
   - 关键路径测试强制验证

### Key Deliverables

| 产出物 | 路径 | 说明 |
|--------|------|------|
| test-verifier Skill | `.claude/skills/test-verifier/SKILL.md` | 核心 Skill 定义 |
| 模块配置 | `.claude/skills/test-verifier/MODULES.md` | 各模块测试配置 |
| 十步循环更新 | `standards/core/ten-step-cycle/README.md` | B.2 覆盖率更新 |
| Skills README | `.claude/skills/README.md` | 新增 Skill 文档 |

## Impact

### Positive
- B.2 覆盖率从 30% 提升至 80%+
- 减少手动测试操作
- 统一多模块测试流程
- 与 OpenSpec 任务状态自动同步

### Risk
- 需要各模块测试框架配置正确
- 初期可能需要调试不同模块的测试命令差异

### Dependencies
- 依赖现有 `flutter-test-generator` (复用而非替代)
- 需要各模块有基础测试框架配置

## Success Criteria

- [ ] test-verifier Skill 可自动检测变更文件类型
- [ ] Mobile 模块测试执行成功率 >= 95%
- [ ] Backend 模块测试执行成功率 >= 95%
- [ ] 测试报告摘要可读性良好
- [ ] B.2 步骤覆盖率更新为 80%+
