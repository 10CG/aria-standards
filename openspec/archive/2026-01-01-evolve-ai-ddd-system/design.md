# Design: Evolve AI-DDD System

> **Change**: evolve-ai-ddd-system
> **Created**: 2025-12-31
> **Updated**: 2025-12-31

---

## Problem Statement

1. **缺乏品牌辨识度**: "AI-DDD" 名称技术化，不便传播
2. **SDLC 覆盖不完整**: 需求阶段无状态追踪机制
3. **工具链缺口**: 无需求验证、同步、Issue 集成能力
4. **手动操作多**: PRD/Story/UPM/Issue 状态需手动同步

---

## Part 1: Aria 品牌设计

### 命名方案评估

| 方案 | 寓意 | 优点 | 缺点 |
|------|------|------|------|
| **Aria** | AI + Rhythm + Iteration + Automation | 简洁、音乐隐喻、首字母含 AI | 需解释缩写 |
| Cadence | 节奏 | 强调循环 | 已有同名公司 |
| Pulse | 脉动 | 简洁 | 辨识度一般 |

### 选定方案: Aria

**品牌结构**:
```
Aria Methodology
├── Aria Core
│   ├── Ten-Step Cycle      # 十步循环 (唯一活跃版本)
│   ├── UPM                 # 统一进度管理
│   ├── OpenSpec            # 规范驱动开发
│   └── Validation Gates    # 质量门禁
│
├── Aria Skills
│   ├── Entry Skills        # state-scanner, workflow-runner
│   ├── Requirements Skills # requirements-validator, requirements-sync, forgejo-sync
│   ├── Commit Skills       # commit-msg-generator, strategic-commit-orchestrator
│   └── Spec Skills         # spec-drafter, validate-docs
│
├── Aria Specs
│   └── OpenSpec Framework
│
└── Aria Extensions
    ├── Mobile Extension
    └── Backend Extension
```

---

## Part 2: Skill 架构设计

### 层级模型

```
┌─────────────────────────────────────────────────────────────────────┐
│  Layer 3: 入口 Skills (用户直接调用)                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  state-scanner              workflow-runner                         │
│  - 项目状态扫描              - 工作流编排                             │
│  - 智能推荐                  - 步骤执行                              │
│  - 调用 Layer 2 Skills       - 调用 Layer 2 Skills                  │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│  Layer 2: 业务 Skills (可组合，可独立调用)                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  requirements-       requirements-      forgejo-sync                │
│  validator           sync                                           │
│  ─────────────       ──────────────     ─────────────               │
│  - PRD 格式验证       - Story→UPM 同步   - Story→Issue 创建          │
│  - Story 格式验证     - UPM 统计更新     - Issue→Story 状态同步       │
│  - PRD↔Story 关联    - 偏差检测         - 批量同步                   │
│  - 覆盖率分析         - 自动/手动更新    - 状态映射                    │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│  Layer 1: 原子 Skills / 外部 API                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  validate-docs       progress-updater    Forgejo REST API           │
│  - 引用完整性检查     - UPM 状态更新      - Issue CRUD                 │
│                      - Phase/Cycle 更新  - Label/Milestone           │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Skill 职责定义

#### requirements-validator

```yaml
名称: requirements-validator
层级: Layer 2
职责: 验证需求文档格式和关联完整性

功能:
  validate-prd:
    - 检查 PRD 必需字段 (目的、定位、功能范围、成功标准)
    - 验证功能清单格式 (yaml + ✅/❌)
    - 检查 User Story 列表存在

  validate-story:
    - 检查 Story 必需字段 (As a/I want/So that)
    - 验证验收标准格式 (Given/When/Then)
    - 检查关联信息 (PRD、OpenSpec)

  check-associations:
    - PRD 列表的 Story 文件是否存在
    - Story 引用的 PRD 是否存在
    - Story 引用的 OpenSpec 是否存在

  coverage-analysis:
    - 统计 Story 状态分布
    - 检查 ready Story 是否有 OpenSpec
    - 报告未覆盖的 Story

输入:
  - docs/requirements/ 目录
  - UPM requirements 节 (可选)

输出:
  validation_result:
    prd_valid: true/false
    prd_issues: []
    stories_valid: true/false
    story_issues: []
    associations_valid: true/false
    association_issues: []
    coverage:
      total: 8
      with_openspec: 5
      without_openspec: 3
```

#### requirements-sync

```yaml
名称: requirements-sync
层级: Layer 2
职责: 同步 Story 状态到 UPM

功能:
  scan-stories:
    - 扫描 docs/requirements/user-stories/
    - 解析每个 Story 的 status 字段
    - 统计各状态数量

  update-upm:
    - 更新 UPM requirements.user_stories 计数
    - 更新 requirements.prd 信息
    - 保持其他 UPM 字段不变

  detect-drift:
    - 比较 UPM 记录 vs 实际 Story 状态
    - 报告偏差项
    - 建议修复操作

  modes:
    check: 仅检测偏差，不修改
    update: 检测并更新 UPM
    interactive: 逐项确认后更新

输入:
  - docs/requirements/user-stories/
  - UPM 文件路径

输出:
  sync_result:
    scanned_stories: 8
    status_distribution:
      draft: 1
      ready: 3
      in_progress: 2
      done: 2
    drift_detected: true/false
    drift_items: []
    upm_updated: true/false
```

#### forgejo-sync

```yaml
名称: forgejo-sync
层级: Layer 2
职责: 同步 Story 与 Forgejo Issue

功能:
  story-to-issue:
    - 从 Story 文件创建 Forgejo Issue
    - 设置 Title: [US-XXX] {标题}
    - 设置 Body: Story 内容 + 验收标准
    - 设置 Labels: user-story, priority:{level}
    - 设置 Milestone: 从 Story 读取
    - 更新 Story 文件的 forgejo_issue 字段

  issue-to-story:
    - 读取 Issue 状态 (open/closed)
    - 读取 Issue labels
    - 映射到 Story status
    - 更新 Story 文件

  bulk-sync:
    - 扫描所有 Story 文件
    - 批量创建/更新 Issues
    - 批量同步状态

  status-check:
    - 比较 Story status vs Issue status
    - 报告不一致项
    - 建议同步方向

  prd-to-wiki:
    - 发布 PRD 到 Forgejo Wiki
    - 单向同步 (Git → Wiki)
    - 自动生成页脚 (来源、时间、只读提示)
    - 生成 PRD-Index 索引页
    - 跳过 draft 状态的 PRD

配置:
  forgejo_url: "https://forgejo.example.com"
  api_token: "${FORGEJO_TOKEN}"
  repo: "owner/repo"
  default_labels: ["user-story"]
  milestone_mapping: true

状态映射:
  story_to_issue:
    draft: { state: open, labels: [draft] }
    ready: { state: open, labels: [ready] }
    in_progress: { state: open, labels: [in-progress] }
    blocked: { state: open, labels: [blocked] }
    done: { state: closed }

  issue_to_story:
    open + draft: draft
    open + ready: ready
    open + in-progress: in_progress
    open + blocked: blocked
    closed: done
```

---

## Part 3: UPM 需求节设计

### Schema 定义

```yaml
# 完整版 (大项目)
requirements:
  prd:
    id: "prd-v2.1.0-notification"
    status: draft | approved | superseded
    path: "docs/requirements/prd-v2.1.0-notification.md"
    wiki_page: "PRD-v2.1.0-notification"    # 新增: Wiki 页面名
    wiki_synced_at: "2025-12-31T10:00:00"   # 新增: 最后同步时间
  user_stories:
    total: 8
    draft: 1
    ready: 3
    in_progress: 2
    done: 2
    blocked: 0
  forgejo:
    enabled: true
    milestone: "v2.1.0"
    synced_at: "2025-12-31T10:00:00+08:00"

# 简化版 (小项目)
requirements:
  current_prd: "docs/requirements/prd-v2.1.0.md"
  pending_stories: 3
```

### User Story 模板扩展

```yaml
# user-story-template.md 新增字段
> **Story ID**: US-001
> **Status**: draft | ready | in_progress | done | blocked
> **Priority**: HIGH | MEDIUM | LOW
> **Created**: YYYY-MM-DD
> **Forgejo Issue**: #123           # 新增
> **Forgejo Milestone**: v2.1.0     # 新增
```

---

## Part 4: Forgejo Issue 集成

### 数据流设计

```
┌──────────────────────────────────────────────────────────────────┐
│  Story 文件 (Git 版本控制)          Forgejo Issue (团队视图)      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  US-001-xxx.md ─────────────────→ Issue #123                     │
│  - Story ID: US-001               - Title: [US-001] xxx         │
│  - Status: ready                  - State: open                 │
│  - Priority: HIGH                 - Labels: ready, priority:high│
│  - Forgejo Issue: #123            - Body: Story content         │
│                                                                  │
│  ←──────────────────────────────                                 │
│  (Issue 状态变更时同步回 Story)                                    │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### API 调用设计

```yaml
# 使用 Forgejo REST API
create_issue:
  method: POST
  url: /api/v1/repos/{owner}/{repo}/issues
  body:
    title: "[US-{id}] {title}"
    body: |
      ## User Story
      {story_content}

      ## Acceptance Criteria
      {acceptance_criteria}

      ---
      Story File: `{story_path}`
    labels: ["user-story", "{priority}"]
    milestone: {milestone_id}

update_issue:
  method: PATCH
  url: /api/v1/repos/{owner}/{repo}/issues/{issue_id}
  body:
    state: open | closed
    labels: [...]

get_issue:
  method: GET
  url: /api/v1/repos/{owner}/{repo}/issues/{issue_id}
```

---

## Part 4.5: PRD → Wiki 单向发布

### 设计原则

1. **Source of Truth**: PRD 文件在 Git 中，Wiki 是只读视图
2. **单向同步**: Git → Wiki，不支持从 Wiki 回写
3. **手动为主**: 默认手动触发，可选状态变更触发

### 数据流设计

```
┌──────────────────────────────────────────────────────────────────┐
│  PRD 文件 (Git 版本控制)            Forgejo Wiki (客户视图)       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  prd-v2.1.0-xxx.md ────────────────→ PRD-v2.1.0-xxx             │
│  - Status: approved                  - 只读内容                  │
│  - Content: ...                      - 自动生成页脚               │
│                                      - 最后同步时间               │
│                                                                  │
│  ❌ 不支持从 Wiki 回写到 Git                                       │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### API 调用设计

```yaml
# 使用 Forgejo REST API - Wiki 操作
create_wiki_page:
  method: PUT
  url: /api/v1/repos/{owner}/{repo}/wiki/page/{pageName}
  body:
    title: "PRD: {prd_title}"
    content: |
      {prd_content}

      ---
      > 📄 **Source**: `{prd_path}`
      > 🔄 **Last Synced**: {timestamp}
      > ⚠️ **Note**: 此页面由 Git 自动同步，请勿直接编辑

get_wiki_page:
  method: GET
  url: /api/v1/repos/{owner}/{repo}/wiki/page/{pageName}

delete_wiki_page:
  method: DELETE
  url: /api/v1/repos/{owner}/{repo}/wiki/page/{pageName}
```

### 触发机制

```yaml
triggers:
  manual:
    command: "/prd-to-wiki"
    description: 手动发布 PRD 到 Wiki

  on_status_change:
    condition: prd.status == "approved"
    description: PRD 审批通过时自动发布
    optional: true  # 可选功能

  on_update:
    condition: prd.content_changed && prd.status == "approved"
    description: 已发布 PRD 内容更新时同步
    optional: true
```

### 页面命名规范

```yaml
naming:
  pattern: "PRD-{version}-{short_name}"
  examples:
    - PRD-v2.1.0-notification-system
    - PRD-v2.2.0-user-authentication

  home_page:
    name: "PRD-Index"
    content: 自动生成的 PRD 列表页
```

---

## Part 5: 组合工作流

### 工作流定义

```yaml
# 工作流 1: 需求检查 (提交前/定期)
requirements-check:
  description: 验证需求文档完整性
  steps:
    - skill: requirements-validator
      mode: full
    - skill: forgejo-sync
      action: status-check
      optional: true
    - skill: state-scanner
      focus: requirements
  triggers:
    - pre-commit (optional)
    - manual: /requirements-check

# 工作流 2: 需求同步
requirements-update:
  description: 同步 Story 状态到 UPM 和 Forgejo
  steps:
    - skill: requirements-validator
      mode: quick
    - skill: requirements-sync
      mode: update
    - skill: forgejo-sync
      action: bulk-sync
      optional: true
  triggers:
    - manual: /requirements-update
    - after: story-status-change

# 工作流 3: 创建 Story
create-story:
  description: 创建 Story 并发布到 Forgejo
  steps:
    - action: create-story-file
      template: user-story-template.md
    - skill: requirements-validator
      target: new-story
    - skill: forgejo-sync
      action: story-to-issue
    - skill: requirements-sync
      mode: update
  triggers:
    - manual: /create-story

# 工作流 4: 迭代规划
iteration-planning:
  description: 迭代开始时的需求盘点
  steps:
    - skill: requirements-validator
      mode: full
    - skill: requirements-sync
      mode: update
    - skill: forgejo-sync
      action: bulk-sync
    - skill: state-scanner
      focus: requirements
      output: planning-report
  triggers:
    - manual: /iteration-planning
```

---

## Part 6: state-scanner 扩展

### 新增能力

```yaml
state-scanner 扩展:
  requirements_awareness:
    - 调用 requirements-validator (check mode)
    - 读取 UPM requirements 节
    - 分析 Story 覆盖率

  new_recommendations:
    - condition: pending_stories > 0 && no_openspec
      recommend: create-openspec
      reason: "有 {n} 个待实现 Story，建议创建技术方案"

    - condition: !prd_exists && complexity >= L2
      recommend: create-prd
      reason: "复杂功能，建议先创建 PRD"

    - condition: stories_ready > 0 && no_active_work
      recommend: start-implementation
      reason: "有 {n} 个就绪 Story 可开始实现"

    - condition: story_issue_drift
      recommend: sync-forgejo
      reason: "Story 与 Issue 状态不一致，建议同步"

  new_output_section:
    requirements_status:
      configured: true
      prd_exists: true
      prd_path: "docs/requirements/prd-v2.1.0.md"
      prd_status: approved
      stories:
        total: 8
        ready: 3
        in_progress: 2
        done: 2
      coverage:
        with_openspec: 5
        without_openspec: 3
      forgejo:
        synced: true
        drift: false
```

---

## Decision Record

### D1: 采用 Aria 作为品牌名称
- **决策**: 选择 Aria (AI + Rhythm + Iteration + Automation)
- **理由**: 简洁、音乐隐喻、无冲突

### D2: 新增 3 个 Layer 2 Skills
- **决策**: 创建 requirements-validator, requirements-sync, forgejo-sync
- **理由**: 职责单一、可组合、可独立测试
- **替代**: 扩展现有 Skills (会导致职责膨胀)

### D3: Story 文件为主、Issue 为视图
- **决策**: Story 文件是 source of truth，Issue 是外部视图
- **理由**: Git 版本控制、AI 友好、避免冲突
- **替代**: Issue 为主 (非 Git 原生)、双向同步 (复杂)

### D4: 先用 REST API，后续可换 MCP
- **决策**: Forgejo 集成先用 REST API
- **理由**: 快速实现、验证流程
- **后续**: 如需更好体验，可开发 MCP Server

### D5: requirements 节为可选
- **决策**: UPM requirements 节为可选字段
- **理由**: 向后兼容、渐进采用

---

## Implementation Order

```
Phase 1: 品牌 + UPM 规范 (可并行)
    ├── 1.1 Aria 品牌指南
    └── 2.1 UPM requirements 节规范
           ↓
Phase 2: 核心 Skills
    ├── 3.1 requirements-validator
    └── 3.2 requirements-sync
           ↓
Phase 3: Forgejo 集成
    └── 4.1 forgejo-sync
           ↓
Phase 4: state-scanner 扩展
    └── 5.1 需求感知 + 子 Skill 调用
           ↓
Phase 5: 工作流 + 验证
    ├── 6.1 组合工作流定义
    └── 6.2 端到端测试
```

---

## References

- `openspec/specs/intelligent-state-scanner/spec.md`
- `standards/core/upm/unified-progress-management-spec.md`
- `standards/templates/user-story-template.md`
- Forgejo API: https://forgejo.org/docs/latest/user/api-usage/
