# AI-DDD状态管理标准

> **文档版本**: 1.0.0-state
> **创建日期**: 2025-12-09
> **基于**: ai-ddd-progress-management-core.md v1.0.0
> **适用范围**: 所有模块（mobile/backend/frontend/shared）
> **责任人**: Tech Lead + AI Development Team

## 📋 概述

本文档定义AI-DDD进度管理的状态管理机制，包括UPMv2-STATE机读接口规范、并发更新协议、UPM体量控制策略和项目周期文档组织规范。

**相关文档**：
- **主标准** → `../progress-management/ai-ddd-progress-management-core.md`
- **工作流标准** → `../workflow/ai-ddd-workflow-standards.md`

---

## 🔍 1. UPMv2-STATE机读接口规范

### 1.1 接口目标与设计原则

```yaml
设计目标:
  AI快速读取: 200行以内，快速定位关键信息
  标准化格式: YAML格式，字段定义明确
  幂等更新: 支持并发写入的冲突检测
  版本可追溯: 通过stateToken追踪状态变更

设计原则:
  最小化原则: 只包含AI决策必需的信息
  结构化原则: 使用标准YAML格式
  可扩展原则: 支持模块特定字段扩展
  向后兼容原则: 字段增加不破坏旧版本解析
```

### 1.2 字段完整定义

```yaml
UPMv2-STATE字段规范:
  # ========== 基础状态字段 ==========
  module:
    类型: string
    必需: ✅ 是
    说明: 模块标识符
    取值: "mobile" | "backend" | "frontend" | "shared"
    示例: "mobile"
    校验: 必须是预定义的模块名

  stage:
    类型: string
    必需: ✅ 是
    说明: 当前阶段（Phase + Stage Name）
    格式: "Phase {N} - {Stage Name}"
    示例: "Phase 3 - Development"
    校验: 必须匹配格式 "Phase [1-5] - [a-zA-Z]+"

  cycleNumber:
    类型: integer
    必需: ✅ 是
    说明: 当前周期编号（阶段内递增）
    取值范围: >= 1
    示例: 7
    校验: 必须是正整数

  lastUpdateAt:
    类型: string (ISO 8601时间戳)
    必需: ✅ 是
    说明: 最后更新时间
    格式: "YYYY-MM-DDTHH:mm:ss+08:00"
    示例: "2025-12-09T15:00:00+08:00"
    校验: 必须是有效的ISO 8601格式

  lastUpdateRef:
    类型: string
    必需: ✅ 是
    说明: 最后更新引用（git commit或文档引用）
    格式: "git:{commit-hash}-{brief}" 或 "docs:{path}#L{line}"
    示例: "git:561f3dc-创建AI-DDD核心标准"
    校验: 建议包含commit hash前7位

  stateToken:
    类型: string
    必需: ✅ 是
    说明: 状态哈希值（用于幂等更新校验）
    格式: "sha256:{short-hash}"
    示例: "sha256:abc123def456"
    生成方法: SHA256(module + stage + cycleNumber + lastUpdateAt + kpiSnapshot)
    校验: 必须是sha256前缀 + 12-16位十六进制

  # ========== 计划与决策字段 ==========
  nextCycle:
    类型: object
    必需: ⚠️ 强烈建议
    说明: 下一循环候选任务集（轻量级索引）

    字段:
      intent:
        类型: string
        说明: 下一循环的目标意图
        示例: "完成P2剩余页面与性能优化"

      candidates:
        类型: array of object
        说明: 候选任务列表

        任务对象:
          id:
            类型: string
            格式: "{module}-{group}#{task-id}"
            示例: "mobile-B6-2#task-analytics-chart"
            说明: 任务唯一标识（可用作锚点跳转）

          rationale:
            类型: string
            示例: "高优先级数据可视化功能"
            说明: 候选原因简述

      constraints:
        类型: array of string
        说明: 约束条件列表
        示例:
          - "依赖B5/B6已验证"
          - "内存问题已缓解"

  # ========== KPI快照字段 ==========
  kpiSnapshot:
    类型: object
    必需: ✅ 是
    说明: 关键质量指标快照

    通用字段:
      coverage:
        类型: string
        格式: ">= {percentage}%"
        示例: ">= 87.2%"
        说明: 测试覆盖率

      build:
        类型: string
        取值: "green" | "yellow" | "red" | "n/a"
        示例: "green"
        说明: 构建状态

      lintErrors:
        类型: integer
        示例: 0
        说明: Lint错误数量

      typeErrors:
        类型: integer
        示例: 0
        说明: 类型错误数量

    模块特定字段（可选）:
      perf:
        说明: 性能指标（mobile常用）
        字段: startup, memory, fps

      api:
        说明: API指标（backend常用）
        字段: endpoints, documented, responseTime_p95

      securityIssues:
        说明: 安全问题（backend/frontend常用）
        字段: high, medium, low

  # ========== 风险管理字段 ==========
  risks:
    类型: array of object
    必需: ❌ 可选（但建议有风险时填写）
    说明: 当前风险列表

    风险对象:
      id:
        类型: string
        格式: "{MODULE}_{CATEGORY}_{LEVEL}"
        示例: "MOBILE_MEMORY_P0"
        说明: 风险唯一标识

      level:
        类型: string
        取值: "P0" | "P1" | "P2" | "P3"
        示例: "P0"
        说明: 风险等级

      mitigation:
        类型: string
        示例: "分批执行测试+优化内存使用"
        说明: 缓解措施

  # ========== 文档指针字段 ==========
  pointers:
    类型: object
    必需: ⚠️ 强烈建议
    说明: 相关文档快速定位指针

    通用指针:
      upm:
        类型: string
        示例: "mobile/project-planning/unified-progress-management.md"
        说明: UPM文档路径

      plan:
        类型: string
        示例: "mobile/project-planning/mo-production-development-plan.md"
        说明: 战略规划文档路径

      tasks:
        类型: string
        示例: "mobile/project-planning/detailed-development-tasks.md"
        说明: 任务详细文档路径

      architecture:
        类型: string
        示例: "mobile/docs/architecture/ARCHITECTURE.md"
        说明: 架构文档路径

      standards:
        core: 核心标准路径
        extension: 模块扩展标准路径

      lifecycle:
        current: 当前周期文档目录
        prev: 上一周期文档目录
```

### 1.3 标准YAML模板

```yaml
---
# UPMv2-STATE: 机读进度状态（保持 <200行）
module: "mobile"
stage: "Phase 3 - Development"
cycleNumber: 7
lastUpdateAt: "2025-12-09T15:00:00+08:00"
lastUpdateRef: "git:561f3dc-创建AI-DDD核心标准"
stateToken: "sha256:mobile-p3c7-abc123"

nextCycle:
  intent: "完成P2剩余页面与AI性能回归"
  candidates:
    - id: "mobile-B6-2#task-analytics-chart"
      rationale: "高优先级数据可视化功能，价值大"
    - id: "mobile-B7#ai-offline-online-switch"
      rationale: "关键AI功能切换，用户需求强烈"
  constraints:
    - "依赖B5/B6已验证"
    - "内存溢出问题已缓解"
    - "测试覆盖率需保持≥85%"

kpiSnapshot:
  coverage: ">= 87.2%"
  build: "green"
  lintErrors: 0
  typeErrors: 0
  perf:
    startup: "1.8s"
    memory: "280MB"
    fps: "58.5"

risks:
  - id: "MOBILE_MEMORY_P0"
    level: "P0"
    mitigation: "分批执行测试+内存参数优化"
  - id: "MOBILE_COVERAGE_P1"
    level: "P1"
    mitigation: "增加Widget测试覆盖"

pointers:
  upm: "mobile/project-planning/unified-progress-management.md"
  plan: "mobile/project-planning/mo-production-development-plan.md"
  tasks: "mobile/project-planning/detailed-development-tasks.md"
  architecture: "mobile/docs/architecture/ARCHITECTURE.md"
  standards:
    core: "docs/standards/core/ai-ddd-progress-management-core.md"
    extension: "docs/standards/extensions/mobile-ai-ddd-extension.md"
  lifecycle:
    current: "docs/project-lifecycle/week7/"
    prev: "docs/project-lifecycle/week6/"
---
```

### 1.4 字段约束和校验规则

```yaml
必需字段校验:
  ✅ module, stage, cycleNumber, lastUpdateAt, lastUpdateRef, stateToken, kpiSnapshot
  ⚠️ nextCycle和pointers强烈建议但非强制

类型校验:
  - module必须是预定义模块名
  - cycleNumber必须是正整数
  - lastUpdateAt必须是有效ISO 8601时间戳
  - stateToken必须匹配sha256格式

格式校验:
  - stage必须匹配"Phase {N} - {Name}"格式
  - lastUpdateRef建议包含git hash或文档引用
  - nextCycle.candidates[].id建议包含模块前缀

业务规则校验:
  - cycleNumber在同一Phase内必须递增
  - lastUpdateAt不能早于上一次更新时间
  - stateToken必须在每次更新时重新计算
  - kpiSnapshot.build不能长期为"red"
```

---

## 🔒 2. 并发与幂等更新协议

### 2.1 并发写入问题分析

```yaml
问题场景:
  场景1 - 多AI并发写入:
    AI-1: 读取UPM（stateToken: abc123）
    AI-2: 读取UPM（stateToken: abc123）
    AI-1: 完成任务A，写入UPM（新stateToken: def456）
    AI-2: 完成任务B，写入UPM（基于旧token abc123）
    结果: AI-1的更新被AI-2覆盖 ❌

  场景2 - 人机协作写入:
    AI: 读取UPM（stateToken: abc123）
    Human: 手动更新UPM（新stateToken: xyz789）
    AI: 写入UPM（基于旧token abc123）
    结果: Human的手动更新被AI覆盖 ❌

  场景3 - 快速连续更新:
    AI: 完成任务A，更新UPM
    AI: 立即完成任务B，再次更新UPM
    结果: 可能读取到未刷新的缓存 ❌

核心问题:
  - 缺少并发控制机制
  - 无法检测写入冲突
  - 后写入覆盖先写入（Last-Write-Wins）
  - 数据丢失风险
```

### 2.2 stateToken幂等机制

```yaml
stateToken生成算法:
  输入字段:
    - module
    - stage
    - cycleNumber
    - lastUpdateAt
    - kpiSnapshot的序列化字符串

  生成步骤:
    1. 拼接字符串: "{module}|{stage}|{cycleNumber}|{lastUpdateAt}|{kpiJson}"
    2. 计算SHA256哈希
    3. 取前12-16位十六进制
    4. 添加前缀: "sha256:{hash}"

  示例:
    输入: "mobile|Phase 3 - Development|7|2025-12-09T15:00:00+08:00|{...kpi...}"
    输出: "sha256:abc123def456"

stateToken作用:
  乐观锁机制: 写入前校验token是否匹配
  冲突检测: token不匹配表示有其他写入
  版本追踪: 每次更新生成新token
  审计追踪: 通过token追溯历史状态
```

### 2.3 写入顺序规范

```yaml
标准写入顺序（Step 7进度更新）:
  第一步: 写入项目周期文档
    位置: docs/project-lifecycle/week{N}/
    文件:
      - plan.md（周初创建）
      - progress-report.md（周末创建）
      - quality-review.md（周末创建）
      - milestone-summary.md（里程碑时创建）

    原因:
      - 周期文档是详细叙事，先落地
      - 避免UPM过度膨胀
      - 周期文档是UPM的引用源

  第二步: 回写UPM的UPMv2-STATE
    操作:
      - 读取当前stateToken
      - 校验token是否匹配
      - 更新lastUpdateRef指向周期文档
      - 更新kpiSnapshot
      - 重新计算并更新stateToken

    原因:
      - UPM仅更新机读片段和摘要
      - 保持UPM精简（≤2500行）
      - 详细内容在周期文档中

写入顺序的重要性:
  ✅ 正确: 先写周期文档，再更新UPM
  ❌ 错误: 先更新UPM，再写周期文档

  原因: UPM的lastUpdateRef需要指向已存在的周期文档
```

### 2.4 冲突处理流程

```yaml
冲突检测:
  时机: 写入UPM前
  方法:
    1. 读取UPM当前stateToken
    2. 与AI本地保存的token对比
    3. 不匹配 → 检测到冲突

冲突处理策略:
  策略A - 重读-合并-重试（推荐）:
    步骤:
      1. 检测到冲突
      2. 重新读取最新UPM
      3. 合并AI的变更和最新状态
      4. 重新计算stateToken
      5. 再次尝试写入
      6. 如再次冲突，最多重试3次

    适用场景: 大部分冲突场景

  策略B - 创建UPMv2-MERGE临时段:
    步骤:
      1. 检测到严重冲突（重试3次失败）
      2. 在UPM中创建临时MERGE段
      3. 记录冲突上下文
      4. 提供候选合并方案
      5. 等待下一轮AI或人工合并

    UPMv2-MERGE格式:
      ```yaml
      # UPMv2-MERGE: 待合并的冲突状态
      conflictDetectedAt: "2025-12-09T16:30:00+08:00"
      conflictReason: "Multiple concurrent writes detected"

      localChanges:
        stateToken: "sha256:abc123"
        updates:
          - field: "kpiSnapshot.coverage"
            oldValue: "85.0%"
            newValue: "87.2%"

      remoteChanges:
        stateToken: "sha256:def456"
        updates:
          - field: "cycleNumber"
            oldValue: 7
            newValue: 8

      suggestedMerge:
        strategy: "accept-both"
        mergedState:
          cycleNumber: 8
          kpiSnapshot.coverage: "87.2%"
      ```

    适用场景: 复杂冲突，难以自动合并

冲突预防:
  - 尽量避免并发写入（任务串行化）
  - 快速完成写入操作
  - 定期刷新本地token缓存
```

---

## 📏 3. UPM体量控制与滚动窗口

### 3.1 体量控制目标

```yaml
设计目标:
  AI可读性: 单次读取不超过2500行
  人类可读性: 主要内容在500-1000行
  性能优化: 减少大文件读写开销
  可维护性: 避免无限膨胀导致维护困难

体量问题:
  问题: UPM随项目推进不断增加内容
  后果:
    - AI读取时间过长
    - 人类阅读体验差
    - Git diff难以查看
    - 合并冲突频繁

解决方案:
  滚动窗口 + 历史外迁 + 索引保留
```

### 3.2 滚动窗口策略

```yaml
核心策略:
  UPM正文保留: 最近2~3个循环的摘要
  详细叙事迁移: 迁移至docs/project-lifecycle/week{N}/
  UPMv2-STATE: 始终保持在200行以内
  历史索引: 保留指向历史内容的索引

保留内容:
  顶部UPMv2-STATE: 200行（机读接口）

  当前项目状态: 150-300行
    - 当前Cycle摘要
    - 活跃任务列表
    - KPI仪表板
    - 风险与问题

  最近循环摘要: 300-600行
    - Cycle N（当前）详细
    - Cycle N-1（上一个）概要
    - Cycle N-2（再上一个）简要

  历史索引表: 200-400行
    - 所有历史Cycle的索引
    - 指向周期文档的链接

  总计: 850-1500行 ✅ 可控

迁移内容:
  完整叙事: 迁移至docs/project-lifecycle/week{N}/
    - progress-report.md（进度报告）
    - quality-review.md（质量验证）
    - milestone-summary.md（里程碑总结）
    - decisions.md（决策记录）
```

### 3.3 体量阈值与触发机制

```yaml
体量阈值定义:
  🟢 健康: <= 1500行
    - 正常维护
    - 无需特殊操作

  🟡 警告: 1500-2000行
    - 建议迁移历史内容
    - 精简冗余描述

  🟠 需处理: 2000-2500行
    - 必须迁移历史内容
    - 删除过期信息

  🔴 紧急: > 2500行
    - 立即触发迁移
    - 阻止新增内容

触发机制:
  自动检测:
    - 每次更新UPM时检查行数
    - 超过阈值时触发告警
    - 提示执行迁移操作

  迁移操作:
    1. 选择要迁移的Cycle（通常是N-3之前的）
    2. 将详细内容迁移至week{N}/progress-report.md
    3. 在UPM中保留索引条目
    4. 更新历史索引表

  索引保留示例:
    ```markdown
    ## 历史循环索引

    | Cycle | 时间范围 | 主要成果 | 详细内容 |
    |-------|---------|---------|---------|
    | Cycle 7 | 2025-12-02~12-08 | 完成B6/B7功能 | [详见](../project-lifecycle/week7/progress-report.md) |
    | Cycle 6 | 2025-11-25~12-01 | 完成B5功能 | [详见](../project-lifecycle/week6/progress-report.md) |
    | Cycle 5 | 2025-11-18~11-24 | 完成A7阶段 | [详见](../project-lifecycle/week5/progress-report.md) |
    ```
```

### 3.4 历史索引策略

```yaml
索引表结构:
  保留在UPM中的信息:
    - Cycle编号
    - 时间范围
    - 主要成果（1-2句话）
    - 关键指标快照
    - 详细文档链接

  索引表格式:
    markdown表格 或 YAML列表

  链接格式:
    相对路径: ../project-lifecycle/week{N}/progress-report.md
    锚点定位: progress-report.md#cycle-{N}-summary
    行区间: progress-report.md#L10-L50

搜索优化:
  关键词索引:
    为每个Cycle添加关键词标签
    便于全文搜索快速定位

  里程碑索引:
    独立维护里程碑索引
    快速查看项目重要节点

  ADR索引:
    链接到相关的架构决策记录
    追踪技术决策历史
```

---

## 📂 4. 项目周期文档组织规范

### 4.1 周期文档存放规则（强制性）

```yaml
基础路径规则:
  标准路径: docs/project-lifecycle/week{N}/
  别名路径: docs/project-lifecycle/cycle{M}/ （可选，推荐映射）

禁止路径:
  ❌ docs/reports/week*
  ❌ docs/milestones/week*
  ❌ docs/planning/week*
  ❌ docs/progress/week*
  ❌ {module}/reports/week*
  ❌ 任何其他非标准路径

路径说明:
  - week{N}中的{N}是连续递增的周数或循环编号
  - 所有模块共享同一个project-lifecycle目录
  - 模块特定内容通过文件内容区分，不建立模块子目录

强制性理由:
  - 统一管理，易于查找
  - AI可预测路径，快速定位
  - 避免文档散落各处
  - 便于索引和历史追溯
```

### 4.2 周期文档结构标准

```yaml
标准目录结构:
  docs/project-lifecycle/week{N}/
    ├── plan.md                 # 周计划（周一创建）
    ├── progress-report.md      # 进度报告（周五创建）
    ├── quality-review.md       # 质量验证（周五创建）
    ├── milestone-summary.md    # 里程碑总结（里程碑时创建）
    ├── decisions.md            # 重要决策记录（按需）
    └── attachments/            # 附件目录（可选）

文件说明:
  plan.md:
    创建时机: 每周/每循环开始时
    内容:
      - 本周期目标
      - 计划任务列表
      - 优先级排序
      - 风险预估

  progress-report.md:
    创建时机: 每周/每循环结束时
    内容:
      - 完成任务汇总
      - KPI指标更新
      - 遇到的问题
      - 下周期计划调整

  quality-review.md:
    创建时机: 每周/每循环结束时
    内容:
      - 测试覆盖率报告
      - 代码质量检查结果
      - 性能指标验证
      - 技术债务记录

  milestone-summary.md:
    创建时机: 达成里程碑时
    内容:
      - 里程碑目标回顾
      - 实际达成情况
      - 经验教训
      - 后续计划

  decisions.md:
    创建时机: 做出重要决策时
    内容:
      - 决策背景
      - 选择的方案
      - 决策理由
      - 预期影响
```

### 4.3 文档命名规范

```yaml
简洁命名原则:
  ✅ 正确: plan.md, progress-report.md, quality-review.md
  ❌ 错误: week7-plan.md, week7-advanced-features-plan.md

命名说明:
  - 周信息已在目录名（week{N}）中，文件名无需重复
  - 使用功能性命名，清晰表达文档用途
  - 保持简洁，便于快速识别
  - 使用小写字母和连字符

文件名规范:
  - 使用小写字母
  - 单词间用连字符（-）连接
  - 不包含week编号
  - 不包含日期
  - 描述文档功能，不描述内容

示例对比:
  ✅ plan.md                        # 简洁清晰
  ✅ progress-report.md             # 功能明确
  ✅ quality-review.md              # 标准命名

  ❌ week7-plan.md                  # 冗余week编号
  ❌ 2025-12-09-plan.md             # 不应包含日期
  ❌ advanced-features-plan.md      # 过于具体
  ❌ Week7ProgressReport.md         # 大小写不规范
```

### 4.4 AI文档生成检查清单

```yaml
生成周期文档前必须确认:
  □ 确定当前周数/循环编号
    方法: 从UPM的cycleNumber字段获取

  □ 检查week{N}目录是否存在
    不存在则创建: mkdir -p docs/project-lifecycle/week{N}

  □ 使用标准命名（无week前缀）
    文件名: plan.md, progress-report.md, quality-review.md

  □ 更新project-lifecycle/index.md索引
    添加新周期的条目和链接

  □ 在UPM中更新指针
    更新lifecycle.current指向新目录

禁止行为:
  ⚠️ 不得在docs根目录或其他位置创建周文档
  ⚠️ 不得使用非标准命名格式
  ⚠️ 不得跳过索引更新步骤
  ⚠️ 不得重复创建同一周期的文档
```

### 4.5 周期与循环的概念映射

```yaml
概念说明:
  "周": 传统项目管理中的自然周（7天）
  "循环": 敏捷开发中的迭代周期（1-2周）

兼容策略:
  路径: 继续使用week{N}作为存放路径（历史兼容）
  概念: 理解为"开发循环"而非严格的"自然周"

展示推荐:
  文档标题: "Week {N} (Cycle {M})" 双标方式
  UPM引用: 使用Cycle {M}
  文档路径: 使用week{N}

别名映射表:
  维护在: docs/project-lifecycle/index.md
  格式:
    ```markdown
    ## 周期映射表

    | Week | Cycle | 时间范围 | Phase |
    |------|-------|---------|-------|
    | Week 7 | Cycle 7 | 2025-12-02~12-08 | Phase 3 |
    | Week 6 | Cycle 6 | 2025-11-25~12-01 | Phase 3 |
    | Week 5 | Cycle 5 | 2025-11-18~11-24 | Phase 3 |
    ```

使用建议:
  新项目: 直接使用cycle{N}作为目录名
  旧项目: 保持week{N}以保持兼容性
```

---

## 📝 附录

### A.1 stateToken计算示例

```python
import hashlib
import json

def generate_state_token(module, stage, cycle_number, last_update_at, kpi_snapshot):
    # 1. 拼接字符串
    kpi_json = json.dumps(kpi_snapshot, sort_keys=True)
    state_str = f"{module}|{stage}|{cycle_number}|{last_update_at}|{kpi_json}"

    # 2. 计算SHA256
    hash_obj = hashlib.sha256(state_str.encode('utf-8'))
    hash_hex = hash_obj.hexdigest()

    # 3. 取前12位
    short_hash = hash_hex[:12]

    # 4. 添加前缀
    state_token = f"sha256:{short_hash}"

    return state_token

# 示例
token = generate_state_token(
    module="mobile",
    stage="Phase 3 - Development",
    cycle_number=7,
    last_update_at="2025-12-09T15:00:00+08:00",
    kpi_snapshot={"coverage": "87.2%", "build": "green"}
)
print(token)  # 输出: sha256:abc123def456
```

### A.2 变更历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| 1.0.0-state | 2025-12-09 | 初始版本，定义状态管理机制和P0关键内容 |

---

**文档维护者**: Tech Lead + AI Development Team
**最后更新**: 2025-12-09
**适用模块**: Mobile, Backend, Frontend, Shared
**相关文档**: ai-ddd-progress-management-core.md, ai-ddd-workflow-standards.md
