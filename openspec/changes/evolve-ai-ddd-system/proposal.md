# Proposal: Evolve AI-DDD System

> **Change ID**: evolve-ai-ddd-system
> **Status**: Draft
> **Created**: 2025-12-31
> **Updated**: 2025-12-31
> **Author**: AI Assistant

---

## Summary

升级 AI-DDD 开发方法论体系，包括五个核心改进：

1. **品牌命名**: 为 AI-DDD 系统创建独立品牌名称 "Aria"
2. **需求文档集成**: 设计 PRD/User Story 与 UPM 的集成机制
3. **需求管理 Skills**: 新增 requirements-validator、requirements-sync、forgejo-sync
4. **state-scanner 扩展**: 增加需求感知能力，调用子 Skills
5. **Forgejo Issue 集成**: Story ↔ Issue 双向同步

---

## Motivation

### 问题陈述

当前 AI-DDD 系统存在以下局限：

1. **无独立品牌**: "AI-DDD" 作为方法论名称过于技术化，不利于推广和传播
2. **需求阶段缺失**: 十步循环主要覆盖"实现阶段"，PRD/User Story 无状态追踪
3. **工具链不完整**: state-scanner 不感知需求文档，无法提供需求相关建议

### 业务价值

| 改进 | 价值 |
|------|------|
| 品牌命名 | 提升方法论辨识度，便于开源推广 |
| 需求集成 | 完善 SDLC 覆盖，需求到实现可追溯 |
| 需求 Skills | 自动化验证和同步，减少手动检查 |
| Forgejo 集成 | 团队协作视图，Issue 驱动开发 |

---

## Scope

### In Scope

1. **Aria 品牌定义**
   - 命名规范和应用指南
   - 品牌结构 (Aria Core, Aria Skills, Aria Specs)

2. **UPM 需求节扩展**
   - `requirements` YAML 节定义
   - PRD/User Story 状态追踪
   - 需求到 OpenSpec 的关联

3. **需求管理 Skills (新增)**
   - `requirements-validator`: PRD/Story 格式验证、关联检查
   - `requirements-sync`: Story ↔ UPM 状态同步
   - `forgejo-sync`: Story ↔ Forgejo Issue 同步

4. **state-scanner 扩展**
   - 需求感知，调用 requirements-validator
   - 简单覆盖率分析 (Story → OpenSpec)
   - 需求相关工作流推荐

5. **Forgejo Issue 集成**
   - Story 文件为主，Issue 作为外部视图
   - 状态双向同步 (Story status ↔ Issue status)
   - Issue 自动创建/更新

6. **PRD → Wiki 单向发布**
   - PRD 文件发布到 Forgejo Wiki
   - 单向同步 (Git → Wiki)，Wiki 为只读视图
   - 支持手动触发和状态变更触发

### Out of Scope

- 现有文档全面更名为 Aria (后续任务)
- 完整覆盖率追溯 (Story → OpenSpec → Code，后续)
- Forgejo MCP Server 开发 (先用 REST API)

---

## Design Overview

### 1. Aria 品牌结构

```
Aria Methodology v3.0
├── Aria Core        # 十步循环 + UPM + OpenSpec
├── Aria Skills      # Skill 系统 (state-scanner, commit-msg-generator, etc.)
├── Aria Specs       # OpenSpec 框架
└── Aria Extensions  # mobile/backend 扩展
```

**命名含义**: AI + Rhythm + Iteration + Automation

### 2. Skill 层级架构

```
┌─────────────────────────────────────────────────────────────────────┐
│  Layer 3: 入口 Skills (用户直接调用)                                  │
├─────────────────────────────────────────────────────────────────────┤
│  state-scanner              workflow-runner                         │
│       │                          │                                  │
├───────┼──────────────────────────┼──────────────────────────────────┤
│  Layer 2: 业务 Skills (可组合)                                       │
├───────┼──────────────────────────┼──────────────────────────────────┤
│       ▼                          ▼                                  │
│  requirements-validator    requirements-sync    forgejo-sync        │
│       │                         │                    │              │
├───────┼─────────────────────────┼────────────────────┼──────────────┤
│  Layer 1: 原子 Skills                                               │
├───────┼─────────────────────────┼────────────────────┼──────────────┤
│       ▼                         ▼                    ▼              │
│  validate-docs           progress-updater      Forgejo API          │
└─────────────────────────────────────────────────────────────────────┘
```

### 3. 需求追溯链

```
PRD ─────────────────→ Forgejo Wiki (只读视图)
 │
 ↓
User Story ↔ Forgejo Issue → OpenSpec → Code
         ↕
       UPM (requirements 节)
```

### 4. 组合工作流

| 工作流 | 步骤 | 触发场景 |
|--------|------|----------|
| `requirements-check` | validator → state-scanner | 提交前检查 |
| `requirements-update` | validator → sync → forgejo-sync | Story 状态变更 |
| `iteration-planning` | validator → forgejo-sync → sync → state-scanner | 迭代规划 |

---

## Capabilities Affected

| Capability | Type | Description |
|------------|------|-------------|
| `intelligent-state-scanner` | MODIFIED | 需求感知，调用子 Skills |
| `upm-requirements` | ADDED | UPM 需求节规范 |
| `requirements-validator` | ADDED | PRD/Story 验证 Skill |
| `requirements-sync` | ADDED | Story ↔ UPM 同步 Skill |
| `forgejo-sync` | ADDED | Story ↔ Issue 同步 Skill |
| `prd-wiki-sync` | ADDED | PRD → Wiki 单向发布 (forgejo-sync 子功能) |

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| 品牌更名工作量大 | 中 | 分阶段迁移，先定义后应用 |
| UPM 扩展破坏兼容性 | 低 | requirements 节为可选 |
| 新增 Skills 增加维护成本 | 中 | Skills 职责单一，可独立演进 |
| Forgejo API 依赖 | 中 | 先用 REST API，后续可换 MCP |
| 同步冲突 | 低 | Story 文件为主，Issue 为视图 |

---

## Success Criteria

- [ ] Aria 品牌指南文档完成
- [ ] UPM requirements 节规范定义
- [ ] requirements-validator Skill 可验证 PRD/Story 格式
- [ ] requirements-sync Skill 可同步 Story ↔ UPM
- [ ] forgejo-sync Skill 可同步 Story ↔ Issue
- [ ] state-scanner 调用子 Skills 并提供需求推荐
- [ ] 组合工作流可正常执行

---

## Related Documents

- `openspec/changes/simplify-doc-format-standards/` - 文档格式规范 (前置)
- `standards/templates/prd-template.md` - PRD 模板 (已完成)
- `standards/templates/user-story-template.md` - User Story 模板 (已完成)
- `.claude/skills/state-scanner/SKILL.md` - 当前 state-scanner 规范
- `openspec/specs/intelligent-state-scanner/spec.md` - state-scanner 规范
