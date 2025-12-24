# Tasks: Add Test Verification Skill

## Phase 1: 核心 Skill 创建

- [x] 1.1 创建 test-verifier Skill 基础结构
- [x] 1.2 实现模块自动检测逻辑 (mobile/backend/shared)
- [x] 1.3 定义各模块测试命令配置

## Phase 2: 模块集成

- [x] 2.1 Mobile 模块: 集成 flutter-test-generator 复用逻辑
- [x] 2.2 Backend 模块: 实现 pytest 测试执行流程
- [x] 2.3 Shared 模块: 实现契约验证测试

## Phase 3: 验证流程

- [x] 3.1 实现测试覆盖率检查
- [x] 3.2 实现测试报告摘要生成
- [x] 3.3 实现与 OpenSpec tasks.md 状态同步

## Phase 4: 文档更新

- [x] 4.1 更新十步循环 README 的 B.2 覆盖率
- [x] 4.2 更新 Skills README 添加新 Skill 说明
- [x] 4.3 创建 MODULES.md 配置文档

## Dependencies

```
1.1 ──▶ 1.2 ──▶ 1.3
              │
              ▼
        ┌─────┴─────┐
        │           │
       2.1   2.2   2.3  (可并行)
        │           │
        └─────┬─────┘
              ▼
        3.1 ──▶ 3.2 ──▶ 3.3
                        │
                        ▼
                  4.1/4.2/4.3 (可并行)
```

## Completion Summary

- **完成时间**: 2025-12-24
- **产出物**:
  - `.claude/skills/test-verifier/SKILL.md` - 核心 Skill 定义
  - `.claude/skills/test-verifier/MODULES.md` - 模块配置文档
  - `standards/core/ten-step-cycle/README.md` - B.2 覆盖率更新 (30% → 80%)
  - `.claude/skills/README.md` - 新增 Skill 说明
