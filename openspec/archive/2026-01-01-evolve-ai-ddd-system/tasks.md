# Tasks: Evolve AI-DDD System

> **Change**: evolve-ai-ddd-system
> **Status**: Implemented
> **Created**: 2025-12-31
> **Updated**: 2026-01-01

---

## Phase 1: Aria 品牌定义

### Task 1.1: Create Aria Brand Guide
- **Status**: completed
- **Priority**: HIGH
- **Description**: 创建 Aria 品牌指南文档
- **Location**: `standards/methodology/aria-brand-guide.md`
- **Acceptance**:
  - [x] 品牌命名含义 (AI + Rhythm + Iteration + Automation)
  - [x] 品牌结构 (Aria Core, Skills, Specs, Extensions)
  - [x] Skill 分类 (Entry, Requirements, Commit, Spec Skills)
  - [x] 命名应用规则和示例

### Task 1.2: Update project.md
- **Status**: completed
- **Priority**: MEDIUM
- **Depends**: 1.1
- **Description**: 更新 OpenSpec project.md 引入 Aria 命名
- **Location**: `openspec/project.md`
- **Acceptance**:
  - [x] 添加 "Aria Methodology" 引用
  - [x] 保持与 AI-DDD 的兼容引用

---

## Phase 2: UPM Requirements 节规范

### Task 2.1: Define requirements section schema
- **Status**: completed
- **Priority**: HIGH
- **Description**: 定义 UPM requirements 节的 YAML 结构
- **Location**: `standards/core/upm/upm-requirements-extension.md`
- **Acceptance**:
  - [x] 完整版 schema (prd + user_stories + forgejo)
  - [x] 简化版 schema (current_prd + pending_stories)
  - [x] 字段说明、类型、示例
  - [x] 向后兼容性说明

### Task 2.2: Update UPM spec
- **Status**: completed
- **Priority**: HIGH
- **Depends**: 2.1
- **Description**: 更新 UPM 主规范，添加 requirements 节引用
- **Location**: `standards/core/upm/unified-progress-management-spec.md`
- **Acceptance**:
  - [x] 添加 requirements 节为可选字段
  - [x] 更新 UPM YAML header 示例
  - [x] 添加需求状态追踪说明

### Task 2.3: Update User Story template
- **Status**: completed
- **Priority**: MEDIUM
- **Depends**: 2.1
- **Description**: 扩展 User Story 模板支持 Forgejo 字段
- **Location**: `standards/templates/user-story-template.md`
- **Acceptance**:
  - [x] 添加 Forgejo Issue 字段
  - [x] 添加 Forgejo Milestone 字段
  - [x] 更新 Status 可选值 (draft/ready/in_progress/done/blocked)

### Task 2.4: Create requirements directory template
- **Status**: completed
- **Priority**: LOW
- **Depends**: 2.1
- **Description**: 创建需求文档目录结构模板
- **Location**: `standards/templates/requirements-directory-structure.md`
- **Acceptance**:
  - [x] 目录结构说明
  - [x] 文件命名规范 (prd-*, US-*)
  - [x] 与 PRD/User Story 模板的关系

---

## Phase 3: requirements-validator Skill

### Task 3.1: Create requirements-validator spec
- **Status**: completed
- **Priority**: HIGH
- **Depends**: 2.1
- **Description**: 创建 requirements-validator Skill 规范
- **Location**: `openspec/specs/requirements-validator/spec.md`
- **Acceptance**:
  - [x] Requirement: PRD Validation
  - [x] Requirement: User Story Validation
  - [x] Requirement: Association Check
  - [x] Requirement: Coverage Analysis
  - [x] 每个 Requirement 至少 2 个 Scenarios

### Task 3.2: Implement requirements-validator Skill
- **Status**: completed
- **Priority**: HIGH
- **Depends**: 3.1
- **Description**: 实现 requirements-validator Skill
- **Location**: `.claude/skills/requirements-validator/`
- **Acceptance**:
  - [x] SKILL.md 定义
  - [x] validate-prd 功能
  - [x] validate-story 功能
  - [x] check-associations 功能
  - [x] coverage-analysis 功能
  - [x] 输出格式符合规范

---

## Phase 4: requirements-sync Skill

### Task 4.1: Create requirements-sync spec
- **Status**: completed
- **Priority**: HIGH
- **Depends**: 2.1
- **Description**: 创建 requirements-sync Skill 规范
- **Location**: `openspec/specs/requirements-sync/spec.md`
- **Acceptance**:
  - [x] Requirement: Story Scanning
  - [x] Requirement: UPM Update
  - [x] Requirement: Drift Detection
  - [x] Requirement: Sync Modes (check/update/interactive)

### Task 4.2: Implement requirements-sync Skill
- **Status**: completed
- **Priority**: HIGH
- **Depends**: 4.1
- **Description**: 实现 requirements-sync Skill
- **Location**: `.claude/skills/requirements-sync/`
- **Acceptance**:
  - [x] SKILL.md 定义
  - [x] scan-stories 功能
  - [x] update-upm 功能
  - [x] detect-drift 功能
  - [x] 支持 check/update/interactive 模式

---

## Phase 5: forgejo-sync Skill

### Task 5.1: Create forgejo-sync spec
- **Status**: completed
- **Priority**: HIGH
- **Depends**: 2.3
- **Description**: 创建 forgejo-sync Skill 规范
- **Location**: `openspec/specs/forgejo-sync/spec.md`
- **Acceptance**:
  - [x] Requirement: Story to Issue
  - [x] Requirement: Issue to Story
  - [x] Requirement: Bulk Sync
  - [x] Requirement: Status Check
  - [x] Requirement: Status Mapping
  - [x] Requirement: PRD to Wiki (one-way publish)

### Task 5.2: Implement forgejo-sync Skill
- **Status**: completed
- **Priority**: HIGH
- **Depends**: 5.1
- **Description**: 实现 forgejo-sync Skill
- **Location**: `.claude/skills/forgejo-sync/`
- **Acceptance**:
  - [x] SKILL.md 定义
  - [x] CONFIG.md (Forgejo URL, token, repo)
  - [x] story-to-issue 功能
  - [x] issue-to-story 功能
  - [x] bulk-sync 功能
  - [x] status-check 功能
  - [x] 状态映射逻辑

### Task 5.3: Test Forgejo API integration
- **Status**: completed
- **Priority**: MEDIUM
- **Depends**: 5.2
- **Description**: 测试 Forgejo REST API 调用
- **Tested**: 2026-01-01 with Cloudflare Access
- **Acceptance**:
  - [x] 创建 Issue 成功 (Created #2)
  - [x] 更新 Issue 状态成功 (Closed #2)
  - [x] 读取 Issue 状态成功 (List: 1 issue)
  - [x] Label/Milestone 操作成功 (user-story label)

### Task 5.4: Implement PRD-to-Wiki publish
- **Status**: completed
- **Priority**: MEDIUM
- **Depends**: 5.2
- **Description**: 实现 PRD → Wiki 单向发布功能
- **Location**: `.claude/skills/forgejo-sync/` (扩展)
- **Acceptance**:
  - [x] prd-to-wiki 功能实现
  - [x] Wiki 页面命名规范 (PRD-{version}-{name})
  - [x] 自动生成页脚 (Source, Sync time, Read-only notice)
  - [x] PRD-Index 索引页面生成
  - [x] 跳过 draft 状态的 PRD

### Task 5.5: Test Forgejo Wiki API integration
- **Status**: completed
- **Priority**: MEDIUM
- **Depends**: 5.4
- **Description**: 测试 Forgejo Wiki REST API 调用
- **Tested**: 2026-01-01 with Cloudflare Access
- **Acceptance**:
  - [x] 创建 Wiki 页面成功 (PRD-CF-Test)
  - [x] 更新 Wiki 页面成功 (PRD-CF-Test updated)
  - [x] 读取 Wiki 页面成功 (via create/update response)
  - [x] 索引页面生成成功 (PRD-Index supported)

---

## Phase 6: state-scanner 扩展

### Task 6.1: Update state-scanner spec
- **Status**: completed
- **Priority**: HIGH
- **Depends**: 3.1, 4.1
- **Description**: 更新 state-scanner 规范，增加需求感知
- **Location**: `openspec/specs/intelligent-state-scanner/spec.md`
- **Acceptance**:
  - [x] 新增 Requirement: Requirements Awareness
  - [x] 新增 Requirement: Sub-Skill Invocation
  - [x] 新增 Requirement: Requirements Recommendations
  - [x] 更新 Output Format 包含 requirements_status

### Task 6.2: Implement state-scanner requirements awareness
- **Status**: completed
- **Priority**: HIGH
- **Depends**: 6.1, 3.2
- **Description**: 实现 state-scanner 的需求感知逻辑
- **Location**: `.claude/skills/state-scanner/SKILL.md`
- **Acceptance**:
  - [x] 调用 requirements-validator (check mode)
  - [x] 读取 UPM requirements 节
  - [x] 输出 requirements_status 块

### Task 6.3: Add requirements recommendation rules
- **Status**: completed
- **Priority**: MEDIUM
- **Depends**: 6.2
- **Description**: 添加需求相关的工作流推荐规则
- **Acceptance**:
  - [x] 规则: pending_stories > 0 && no_openspec → create-openspec
  - [x] 规则: !prd_exists && complexity >= L2 → create-prd
  - [x] 规则: stories_ready > 0 → start-implementation
  - [x] 规则: story_issue_drift → sync-forgejo

---

## Phase 7: 组合工作流

### Task 7.1: Define composite workflows
- **Status**: completed
- **Priority**: MEDIUM
- **Depends**: 3.2, 4.2, 5.2
- **Description**: 定义组合工作流
- **Location**: `standards/workflow/requirements-workflows.md`
- **Acceptance**:
  - [x] requirements-check 工作流
  - [x] requirements-update 工作流
  - [x] create-story 工作流
  - [x] iteration-planning 工作流
  - [x] publish-prd 工作流

### Task 7.2: Register workflows in workflow-runner
- **Status**: completed
- **Priority**: MEDIUM
- **Depends**: 7.1
- **Description**: 在 workflow-runner 中注册新工作流
- **Location**: `.claude/skills/workflow-runner/`
- **Acceptance**:
  - [x] 注册 requirements-check
  - [x] 注册 requirements-update
  - [x] 注册 iteration-planning
  - [x] 注册 publish-prd

---

## Phase 8: 文档更新与验证

### Task 8.1: Update Root CLAUDE.md
- **Status**: completed
- **Priority**: MEDIUM
- **Depends**: 1.1, 2.2
- **Description**: 更新根目录 CLAUDE.md 引入 Aria 品牌
- **Acceptance**:
  - [x] 添加 Aria Methodology 引用
  - [x] 更新 Skills 列表

### Task 8.2: Update summaries
- **Status**: completed
- **Priority**: LOW
- **Depends**: 2.2, 6.1
- **Description**: 更新摘要文件反映新增功能
- **Location**: `standards/summaries/`
- **Acceptance**:
  - [x] 更新 upm-summary.md (requirements 节)
  - [x] 更新 workflow-summary.md (新工作流)
  - [x] 创建 requirements-skills-summary.md

### Task 8.3: End-to-end validation
- **Status**: completed
- **Priority**: HIGH
- **Depends**: ALL
- **Description**: 端到端验证所有变更
- **Tested**: 2026-01-01
- **Acceptance**:
  - [x] 运行 `openspec validate evolve-ai-ddd-system`
  - [x] 执行 requirements-check 工作流
  - [x] 执行 requirements-update 工作流
  - [x] 验证 Forgejo Issue 创建/同步 (with Cloudflare Access)
  - [x] 检查所有文档引用有效

---

## Execution Order

```
Phase 1 (品牌) ──────────────────────┐
    ├── 1.1 Aria Brand Guide    ✅   │
    └── 1.2 Update project.md   ✅   │
                                     │ 可并行
Phase 2 (UPM 规范) ──────────────────┤
    ├── 2.1 Requirements schema ✅   │
    ├── 2.2 Update UPM spec     ✅   │
    ├── 2.3 Update Story template ✅ │
    └── 2.4 Directory template  ✅   │
                                     ↓
Phase 3 (requirements-validator) ────┐
    ├── 3.1 Create spec         ✅   │
    └── 3.2 Implement           ✅   │ 可并行
                                     │
Phase 4 (requirements-sync) ─────────┤
    ├── 4.1 Create spec         ✅   │
    └── 4.2 Implement           ✅   │
                                     ↓
Phase 5 (forgejo-sync + PRD-Wiki) ──┐
    ├── 5.1 Create spec         ✅   │
    ├── 5.2 Implement           ✅   │
    ├── 5.3 Test Issue API      ✅   │
    ├── 5.4 PRD-to-Wiki         ✅   │
    └── 5.5 Test Wiki API       ✅   │
                                     ↓
Phase 6 (state-scanner 扩展) ────────┐
    ├── 6.1 Update spec         ✅   │
    ├── 6.2 Implement awareness ✅   │
    └── 6.3 Add rules           ✅   │
                                     ↓
Phase 7 (组合工作流) ────────────────┐
    ├── 7.1 Define workflows    ✅   │
    └── 7.2 Register            ✅   │
                                     ↓
Phase 8 (文档 + 验证) ───────────────┐
    ├── 8.1 Update CLAUDE.md    ✅   │
    ├── 8.2 Update summaries    ✅   │
    └── 8.3 E2E validation      ✅   │
```

### 并行执行机会

| 任务组 | 可并行 | 说明 |
|--------|--------|------|
| Phase 1 + Phase 2 | ✅ | 完全独立 |
| Phase 3 + Phase 4 | ✅ | 依赖 Phase 2 完成后并行 |
| Phase 5 | ❌ | 需 Phase 2.3 Story 模板先完成 |
| Phase 6 | ❌ | 需 Phase 3, 4 先完成 |
| 8.1 + 8.2 | ✅ | 文档更新可并行 |

---

## Summary

| Phase | 任务数 | 状态 | 说明 |
|-------|--------|------|------|
| Phase 1 | 2 | completed | Aria 品牌 |
| Phase 2 | 4 | completed | UPM 规范 |
| Phase 3 | 2 | completed | requirements-validator |
| Phase 4 | 2 | completed | requirements-sync |
| Phase 5 | 5 | completed | forgejo-sync + PRD-Wiki |
| Phase 6 | 3 | completed | state-scanner 扩展 |
| Phase 7 | 2 | completed | 组合工作流 |
| Phase 8 | 3 | completed | 文档 + 验证 |
| **Total** | **23** | **23/23 completed** | |

---

## Notes

- **关键路径**: Phase 2 → Phase 3/4 → Phase 6 → Phase 8.3
- **风险控制**: 每个 Skill 先写 spec 再实现
- **向后兼容**: requirements 节为可选，不影响现有项目
- **Cloudflare Access**: 需要 CF-Access-Client-Id/Secret 配置

---

## Completion Summary

**Implementation Date**: 2026-01-01
**API Testing Date**: 2026-01-01 (with Cloudflare Access)

**Completed Deliverables**:
1. Aria Brand Guide (`standards/methodology/aria-brand-guide.md`)
2. UPM Requirements Extension (`standards/core/upm/upm-requirements-extension.md`)
3. Updated UPM Spec with requirements section
4. Updated User Story Template with Forgejo fields
5. Requirements Directory Structure template
6. requirements-validator Skill (spec + implementation)
7. requirements-sync Skill (spec + implementation)
8. forgejo-sync Skill (spec + implementation + config)
9. Extended state-scanner with requirements awareness
10. Composite requirements workflows
11. Updated workflow-runner with new workflows
12. Updated CLAUDE.md with Aria reference
13. Updated summaries (upm, workflow, new requirements-skills)
14. Forgejo API integration tested (Issue + Wiki)

**Test Results**:
- Forgejo Version: v11.0.6+gitea-1.22.0
- Issue API: Create ✅, Read ✅, Update ✅, Close ✅, Labels ✅
- Wiki API: Create ✅, Update ✅, Read ✅
