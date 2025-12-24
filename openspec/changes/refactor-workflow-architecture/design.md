# Design: Refactor Workflow Architecture

## Overview

本文档描述十步循环工作流架构的重构设计，核心是将 state-scanner 升级为智能推荐入口，并引入 Phase 级别的 Skills 抽象层。

## Architecture

### 系统架构图

```
┌─────────────────────────────────────────────────────────────────┐
│                        User Intent                               │
│                   "我要提交代码" / "开发新功能"                    │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    state-scanner v2.0                            │
│                    (智能工作流入口)                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │ 状态感知引擎 │→│ 推荐决策引擎 │→│ 交互确认模块 │           │
│  └──────────────┘  └──────────────┘  └──────────────┘           │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼ 用户确认的工作流
┌─────────────────────────────────────────────────────────────────┐
│                    workflow-runner v2.0                          │
│                      (轻量编排器)                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 预置工作流: quick-fix | feature-dev | doc-update | full  │   │
│  └──────────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 自定义组合: "Phase B + Phase C" / "B.2 → C.1"            │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                │
        ┌───────────────────────┼───────────────────────┐
        ▼                       ▼                       ▼
┌───────────────┐       ┌───────────────┐       ┌───────────────┐
│ phase-a       │       │ phase-b       │       │ phase-c       │
│ planner       │       │ developer     │       │ integrator    │
├───────────────┤       ├───────────────┤       ├───────────────┤
│ A.1 spec      │       │ B.1 branch    │       │ C.1 commit    │
│ A.2 task-plan │       │ B.2 test      │       │ C.2 pr/merge  │
│ A.3 assign    │       │ B.3 arch      │       │               │
└───────────────┘       └───────────────┘       └───────────────┘
                                                        │
                                                        ▼
                                                ┌───────────────┐
                                                │ phase-d       │
                                                │ closer        │
                                                ├───────────────┤
                                                │ D.1 progress  │
                                                │ D.2 archive   │
                                                └───────────────┘
```

## Component Design

### 1. state-scanner v2.0

#### 职责

1. **状态感知**: 收集项目当前状态
2. **智能推荐**: 基于状态生成工作流推荐
3. **交互确认**: 与用户确认执行计划

#### 状态感知模块

```yaml
state_collection:
  git:
    - current_branch
    - uncommitted_changes
    - staged_files
    - recent_commits (last 5)

  project:
    - current_phase_cycle (from UPM)
    - active_module
    - openspec_status

  changes:
    - changed_file_types
    - change_complexity
    - test_coverage_status
    - architecture_impact
```

#### 推荐决策引擎

```yaml
recommendation_engine:
  inputs:
    - state_data
    - user_intent (optional)

  rules:
    # 按优先级排序
    - rule: commit_only
      condition:
        - on_feature_branch: true
        - has_staged_changes: true
        - no_unstaged_changes: true
      recommend: [C.1]
      reason: "变更已暂存，只需提交"

    - rule: quick_fix
      condition:
        - changed_files: <= 3
        - change_type: [bugfix, typo, config]
        - complexity: Level1
      recommend: quick-fix
      reason: "简单修复，使用快速流程"

    - rule: feature_with_spec
      condition:
        - has_openspec: true
        - openspec_status: approved
      recommend: feature-dev
      skip: [A.1, A.2, A.3]
      reason: "已有 OpenSpec，跳过规划阶段"

    - rule: feature_new
      condition:
        - complexity: >= Level2
        - has_openspec: false
      recommend: full-cycle
      reason: "新功能开发，建议完整流程"

    - rule: doc_only
      condition:
        - file_types: [*.md]
        - no_code_changes: true
      recommend: doc-update
      reason: "仅文档变更"

  output:
    primary_recommendation:
      workflow: string
      steps: list
      skip_steps: list
      reason: string

    alternatives:
      - workflow: string
        reason: string
```

#### 输出格式

```
╔══════════════════════════════════════════════════════════════╗
║                    PROJECT STATE ANALYSIS                     ║
╚══════════════════════════════════════════════════════════════╝

📍 当前状态
───────────────────────────────────────────────────────────────
  分支: feature/xxx
  模块: mobile
  Phase/Cycle: Phase4-Cycle9
  变更: 3 文件 (lib/*.dart, test/*.dart)
  OpenSpec: xxx-feature (approved)

🎯 推荐工作流
───────────────────────────────────────────────────────────────
  ➤ [1] feature-dev (推荐)
      执行: B.1 → B.2 → C.1
      跳过: A.* (已有 Spec), B.3 (无架构变更)
      理由: 已有 OpenSpec，代码和测试就绪

  ○ [2] quick-fix
  ○ [3] full-cycle
  ○ [4] 自定义组合

🤔 选择 [1-4] 或输入自定义 (如 "B.2 + C.1"):
```

### 2. Phase Skills

#### 通用接口

```yaml
phase_skill_interface:
  input:
    context:
      phase_cycle: string
      module: string
      changed_files: list
      previous_phase_output: object  # 上一阶段输出

    config:
      skip_steps: list  # 跳过的步骤
      params: object    # 步骤参数覆盖

  output:
    success: boolean
    steps_executed: list
    steps_skipped: list
    results: object     # 步骤执行结果
    context_for_next: object  # 传递给下一阶段
```

#### phase-a-planner

```yaml
name: phase-a-planner
description: 十步循环 Phase A - 规划阶段

steps:
  A.1:
    skill: spec-drafter
    skip_if:
      - has_openspec: true
      - complexity: Level1
    output: [spec_id, spec_status]

  A.2:
    skill: task-planner
    action: plan
    skip_if:
      - has_detailed_tasks: true
    output: [task_list, task_count]

  A.3:
    skill: task-planner
    action: assign
    depends_on: A.2
    output: [assigned_agents]

context_output:
  - spec_id
  - task_list
  - assigned_agents
```

#### phase-b-developer

```yaml
name: phase-b-developer
description: 十步循环 Phase B - 开发阶段

steps:
  B.1:
    skill: branch-manager
    action: create
    skip_if:
      - already_on_feature_branch: true
    output: [branch_name]

  B.2:
    skill: test-verifier
    params:
      coverage_threshold: 80
    degrade_if:
      - no_test_files: true
    output: [test_passed, coverage]

  B.3:
    skill: arch-update
    skip_if:
      - no_architecture_changes: true
    output: [arch_updated, files_modified]

context_output:
  - branch_name
  - test_results
  - arch_sync_status
```

#### phase-c-integrator

```yaml
name: phase-c-integrator
description: 十步循环 Phase C - 集成阶段

steps:
  C.1:
    skill: commit-msg-generator
    params:
      enhanced_markers: true
    output: [commit_sha, commit_message]

  C.2:
    skill: branch-manager
    action: pr
    skip_if:
      - no_pr_needed: true
      - direct_push_allowed: true
    output: [pr_url, pr_number]

context_output:
  - commit_sha
  - pr_url
```

#### phase-d-closer

```yaml
name: phase-d-closer
description: 十步循环 Phase D - 收尾阶段

steps:
  D.1:
    skill: progress-updater
    skip_if:
      - no_upm: true
    output: [upm_updated]

  D.2:
    skill: openspec:archive
    skip_if:
      - no_openspec: true
    output: [spec_archived]

context_output:
  - upm_updated
  - spec_archived
```

### 3. workflow-runner v2.0

#### 职责

- 接收 state-scanner 的推荐或用户选择
- 解析工作流定义为 Phase 调用序列
- 编排 Phase Skills 执行
- 管理上下文传递

#### 工作流定义

```yaml
workflows:
  quick-fix:
    phases: [B, C]
    default_skips: [B.3]
    description: 快速修复

  feature-dev:
    phases: [A, B, C]
    conditional_skips:
      - if: has_openspec
        skip: [A.1, A.2, A.3]
      - if: no_arch_changes
        skip: [B.3]
    description: 功能开发

  doc-update:
    phases: [B, C]
    only_steps: [B.3, C.1]
    description: 文档更新

  full-cycle:
    phases: [A, B, C, D]
    description: 完整循环

custom_syntax:
  examples:
    - "Phase B + Phase C"      # 执行 B 和 C 阶段
    - "B.2 + C.1"              # 只执行特定步骤
    - "A.2 → B"                # A.2 然后整个 B 阶段
    - "B without B.3"          # B 阶段但跳过 B.3
```

#### 上下文传递

```yaml
context_flow:
  state-scanner:
    provides:
      - phase_cycle
      - module
      - changed_files
      - openspec_info

  phase-a → phase-b:
    - spec_id
    - task_list
    - assigned_agents

  phase-b → phase-c:
    - branch_name
    - test_results
    - changed_files

  phase-c → phase-d:
    - commit_sha
    - pr_url
```

## Data Flow

```
User Intent
    │
    ▼
state-scanner
    │ 收集状态
    ▼
Recommendation Engine
    │ 生成推荐
    ▼
User Confirmation ←──── User Choice
    │
    ▼
workflow-runner
    │ 解析工作流
    ▼
Phase Execution Plan
    │
    ├──▶ phase-a-planner ──▶ context
    │                           │
    ├──▶ phase-b-developer ◀───┘──▶ context
    │                                  │
    ├──▶ phase-c-integrator ◀─────────┘──▶ context
    │                                         │
    └──▶ phase-d-closer ◀────────────────────┘
              │
              ▼
        Execution Report
```

## File Structure

```
.claude/skills/
├── state-scanner/
│   ├── SKILL.md              # v2.0 升级
│   ├── RECOMMENDATION_RULES.md  # 推荐规则定义
│   └── OUTPUT_FORMAT.md      # 输出格式规范
│
├── phase-a-planner/
│   └── SKILL.md
│
├── phase-b-developer/
│   └── SKILL.md
│
├── phase-c-integrator/
│   └── SKILL.md
│
├── phase-d-closer/
│   └── SKILL.md
│
├── workflow-runner/
│   ├── SKILL.md              # v2.0 重构
│   ├── WORKFLOWS.md          # 工作流定义 (更新)
│   └── SKIP_RULES.md         # 移至各 Phase Skill
│
└── README.md                 # 更新 Skills 目录
```

## Migration Strategy

### 向后兼容

1. 保留原有工作流名称 (quick-fix, feature-dev 等)
2. 原有调用方式继续可用
3. 新旧 Skills 可共存

### 渐进迁移

1. Phase 1: 创建 Phase Skills，与 workflow-runner v1 并存
2. Phase 2: 升级 state-scanner，添加推荐功能
3. Phase 3: 重构 workflow-runner 使用 Phase Skills
4. Phase 4: 标记 v1 为 deprecated，引导使用新架构

## Trade-offs

| 决策 | 选择 | 理由 |
|------|------|------|
| Phase 粒度 vs 步骤粒度 | Phase 粒度 | 平衡灵活性和复杂度 |
| 推荐 vs 强制 | 推荐 + 用户确认 | 保持用户控制权 |
| 隐式 A.0 vs 显式入口 | 显式入口 (state-scanner) | 用户知道发生了什么 |

## Open Questions

1. ~~A.0 是否应该独立?~~ → 决定: 升级为智能入口
2. 推荐规则如何扩展? → 建议: YAML 配置 + 插件机制
3. 是否支持并行 Phase 执行? → 建议: v2.0 暂不支持，后续迭代
