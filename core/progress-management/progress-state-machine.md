# 通用进度状态机定义

> **文档版本**: 1.0.0-state-machine
> **创建日期**: 2025-12-09
> **适用范围**: 所有模块
> **核心标准**: ai-ddd-progress-management-core.md v1.0.0
> **责任人**: Tech Lead + AI Development Team

## 📋 概述

本文档定义跨模块通用的进度状态机，包括Phase（阶段）、Cycle（周期）、Stage（状态）三层结构及其转换规则。

---

## 🔄 三层状态机定义

### 1. Phase（阶段）状态机

**定义**: 项目生命周期的主要阶段

```yaml
Phase状态机:
  Phase 1 - Planning:
    描述: 项目规划阶段
    持续时间: 1-2周
    主要活动:
      - 需求分析和梳理
      - 技术方案选型
      - 架构设计规划
      - 人员和资源分配
    输出产物:
      - 需求文档
      - 技术方案文档
      - 项目计划

  Phase 2 - Design:
    描述: 详细设计阶段
    持续时间: 1-3周
    主要活动:
      - 系统架构设计
      - 模块接口设计
      - 数据模型设计
      - API契约设计
    输出产物:
      - 架构文档
      - 接口规范
      - 数据库schema
      - API文档

  Phase 3 - Development:
    描述: 功能开发阶段
    持续时间: 4-12周
    主要活动:
      - 功能实现
      - 单元测试编写
      - 代码审查
      - 技术债务管理
    输出产物:
      - 可执行代码
      - 测试用例
      - 技术文档

  Phase 4 - Testing:
    描述: 集成测试和验收阶段
    持续时间: 2-4周
    主要活动:
      - 集成测试
      - 系统测试
      - 性能测试
      - Bug修复
    输出产物:
      - 测试报告
      - Bug修复记录
      - 性能报告

  Phase 5 - Deployment:
    描述: 部署上线阶段
    持续时间: 1-2周
    主要活动:
      - 生产环境部署
      - 上线验证
      - 监控配置
      - 文档归档
    输出产物:
      - 部署文档
      - 运维手册
      - 上线报告
```

**Phase转换规则**:
```yaml
标准转换流程:
  Planning → Design → Development → Testing → Deployment

特殊转换:
  任意Phase → Planning:
    触发条件: 重大需求变更，需要重新规划
    操作要求: 创建变更决策记录（ADR）

  Testing → Development:
    触发条件: 发现重大缺陷需要返工
    操作要求: 记录回退原因，评估影响范围

转换检查点:
  - 前一阶段的输出产物是否完整
  - 质量门禁是否通过
  - 资源和环境是否就绪
```

### 2. Cycle（周期）状态机

**定义**: 阶段内的迭代周期

```yaml
Cycle特征:
  编号方式: 连续数字 (Cycle 1, Cycle 2, ...)
  持续时间: 1-2周
  作用域: 在单个Phase内有效
  重置规则: 切换到新Phase时重置为1

Cycle结构:
  每个Cycle包含完整的开发-测试-验证循环:
    1. 规划: 分解任务，分配优先级
    2. 开发: 实现功能，编写测试
    3. 验证: 代码审查，质量检查
    4. 总结: 回顾改进，更新进度
```

**Cycle转换规则**:
```yaml
正常转换:
  Cycle N → Cycle N+1:
    触发条件: 当前周期所有任务完成
    操作要求: 更新UPM文档cycleNumber字段

Phase切换时的Cycle重置:
  Phase N, Cycle M → Phase N+1, Cycle 1:
    触发条件: 进入新的Phase
    操作要求:
      - 更新stage字段
      - 重置cycleNumber为1
      - 记录Phase转换原因

示例:
  当前: Phase 3 - Development, Cycle 9
  完成Phase 3，进入Phase 4
  结果: Phase 4 - Testing, Cycle 1  # Cycle重置为1
```

### 3. Stage（状态）状态机

**定义**: 任务级别的开发状态

```yaml
Stage状态机:
  planning:
    描述: 任务规划和准备
    主要活动:
      - 分析任务需求
      - 分解子任务
      - 评估工作量
      - 准备开发环境
    退出条件:
      - 任务分解完成
      - 开发环境就绪
      - 技术方案明确

  development:
    描述: 功能开发和实现
    主要活动:
      - 编写代码
      - 编写单元测试
      - 本地验证
      - 提交代码
    退出条件:
      - 功能实现完成
      - 单元测试通过
      - 代码符合规范

  testing:
    描述: 测试验证
    主要活动:
      - 运行自动化测试
      - 集成测试
      - 性能测试（如需要）
      - Bug修复
    退出条件:
      - 所有测试通过
      - 覆盖率达标
      - 无阻塞性Bug

  review:
    描述: 代码审查和质量检查
    主要活动:
      - 代码审查
      - 架构审查
      - 文档审查
      - 安全审查
    退出条件:
      - 审查通过
      - 或识别问题需返回development

  completed:
    描述: 任务完成
    主要活动:
      - 合并代码
      - 更新文档
      - 归档记录
      - 触发后续任务
    特征: 终态，不可逆转

  blocked:
    描述: 任务阻塞
    主要活动:
      - 记录阻塞原因
      - 寻求解决方案
      - 升级问题
      - 调整计划
    退出条件:
      - 阻塞问题解决
      - 返回到阻塞前的状态
```

**Stage转换规则**:
```yaml
标准转换流程:
  planning → development → testing → review → completed

允许的回退:
  review → development:
    触发条件: 代码审查发现问题
    操作要求:
      - 记录审查意见
      - 标记需修复的问题
      - 更新任务状态

  任意状态 → blocked:
    触发条件: 遇到阻塞问题
    操作要求:
      - 记录阻塞原因
      - 标记依赖任务或资源
      - 估算解除阻塞时间

  blocked → 原状态:
    触发条件: 阻塞问题解决
    操作要求:
      - 记录解决方案
      - 恢复到阻塞前状态

禁止的转换:
  ✗ 跳跃式转换 (如 planning → testing)
  ✗ 从completed回退到任何状态
  ✗ development → review (必须经过testing)
```

---

## 📊 状态转换图

### Phase级别转换图

```
┌──────────┐     ┌────────┐     ┌─────────────┐     ┌─────────┐     ┌────────────┐
│ Planning │────▶│ Design │────▶│ Development │────▶│ Testing │────▶│ Deployment │
└──────────┘     └────────┘     └─────────────┘     └─────────┘     └────────────┘
     ▲                                  ▲                   │
     │                                  │                   │
     └──────────────────────────────────┴───────────────────┘
              (重大变更时可能回退)
```

### Cycle级别转换图

```
Phase 3 - Development
┌─────────┐     ┌─────────┐     ┌─────────┐
│ Cycle 1 │────▶│ Cycle 2 │────▶│ Cycle 3 │──── ... ───▶ Cycle N
└─────────┘     └─────────┘     └─────────┘

                                                    Phase切换
                                                        │
                                                        ▼
Phase 4 - Testing
┌─────────┐     ┌─────────┐
│ Cycle 1 │────▶│ Cycle 2 │──── ... (Cycle重置为1)
└─────────┘     └─────────┘
```

### Stage级别转换图

```
┌──────────┐
│ planning │
└─────┬────┘
      │
      ▼
┌─────────────┐
│ development │◀──────┐
└──────┬──────┘       │
       │              │
       ▼              │
┌─────────┐           │
│ testing │           │
└────┬────┘           │
     │                │
     ▼                │
┌────────┐            │
│ review │────────────┘
└───┬────┘   (审查不通过)
    │
    ▼
┌───────────┐
│ completed │ (终态)
└───────────┘

任意状态 ←──→ blocked (阻塞状态)
```

---

## 🔧 实施指南

### 状态机实现建议

**数据结构**:
```python
from enum import Enum

class Phase(Enum):
    PLANNING = "Phase 1 - Planning"
    DESIGN = "Phase 2 - Design"
    DEVELOPMENT = "Phase 3 - Development"
    TESTING = "Phase 4 - Testing"
    DEPLOYMENT = "Phase 5 - Deployment"

class Stage(Enum):
    PLANNING = "planning"
    DEVELOPMENT = "development"
    TESTING = "testing"
    REVIEW = "review"
    COMPLETED = "completed"
    BLOCKED = "blocked"

class ProjectState:
    phase: Phase
    cycle_number: int
    stage: Stage

    def can_transition_to(self, new_stage: Stage) -> bool:
        """检查是否可以转换到新状态"""
        valid_transitions = {
            Stage.PLANNING: [Stage.DEVELOPMENT, Stage.BLOCKED],
            Stage.DEVELOPMENT: [Stage.TESTING, Stage.BLOCKED],
            Stage.TESTING: [Stage.REVIEW, Stage.BLOCKED],
            Stage.REVIEW: [Stage.COMPLETED, Stage.DEVELOPMENT, Stage.BLOCKED],
            Stage.BLOCKED: [Stage.PLANNING, Stage.DEVELOPMENT, Stage.TESTING, Stage.REVIEW],
            Stage.COMPLETED: []  # 终态
        }

        return new_stage in valid_transitions.get(self.stage, [])
```

### 状态转换检查清单

**Phase转换检查**:
```yaml
从Phase N转换到Phase N+1之前:
  □ Phase N的所有关键任务已完成
  □ 输出产物通过质量检查
  □ 下一Phase的资源已就绪
  □ 团队已了解下一Phase的目标
  □ 更新UPM文档的stage字段
  □ 重置cycleNumber为1
```

**Cycle转换检查**:
```yaml
从Cycle N转换到Cycle N+1之前:
  □ Cycle N的所有任务已完成或推迟
  □ KPI指标已更新
  □ 技术债务已记录
  □ 下一Cycle的任务已规划
  □ 更新UPM文档的cycleNumber字段
```

**Stage转换检查**:
```yaml
状态转换前验证:
  □ 满足当前状态的退出条件
  □ 目标状态的前置条件已满足
  □ 转换路径符合状态机规则
  □ 更新任务状态记录
  □ 通知相关团队成员
```

---

## 📚 模块扩展指南

### 扩展点说明

模块可以在标准状态机基础上扩展：

**1. 定义Module-Specific Phases**:
```yaml
# 示例：Backend模块可以有更细化的Phase
Phase 3 - Development (Backend):
  Phase 3.1: API契约设计
  Phase 3.2: 核心功能开发
  Phase 3.3: API端点实现
  Phase 3.4: 文档同步
```

**2. 扩展Stage状态**:
```yaml
# 示例：Mobile模块可以添加特定状态
Stage扩展 (Mobile):
  Standard Stages: planning, development, testing, review, completed
  Mobile-Specific Stages:
    - ui-review: UI设计审查
    - performance-testing: 性能测试
    - device-testing: 设备兼容性测试
```

**约束**:
- ✅ 可以添加更细粒度的子阶段
- ✅ 可以添加模块特定的状态
- ❌ 不能修改标准Phase/Cycle/Stage的基本定义
- ❌ 不能违反标准转换规则

---

## 📝 附录

### 快速参考

**Phase转换**: Planning → Design → Development → Testing → Deployment

**Cycle规则**: 连续数字，Phase切换时重置为1

**Stage转换**: planning → development → testing → review → completed

**允许回退**: review → development, 任意状态 ↔ blocked

**禁止转换**: 跳跃式转换, completed回退

### 变更历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| 1.0.0 | 2025-12-09 | 初始状态机定义 |

---

**文档维护者**: Tech Lead + AI Development Team
**最后更新**: 2025-12-09
**适用标准**: ai-ddd-progress-management-core.md v1.0.0
