# Standards Repository - Project Context

## Purpose
This repository is the **authoritative source** for development standards, processes, and quality gates for the Todo App multi-repository project.

It stores the **AI-DDD methodology** using the **OpenSpec framework**.

## Scope

### In Scope
- AI-DDD methodology definitions (seven-step cycle, UPM, validation)
- Architecture principles (Contract-First, Single Source of Truth)
- Coding standards (language-specific conventions)
- Workflow standards (Git, PR, review processes)
- Quality gates (Spec-Kit inspired gates)

### Out of Scope
- Feature-specific specifications (belong in mobile/backend/shared)
- API contracts (belong in shared)
- Implementation code

## Organization Principle

Specs are organized by **capability domain**, not by feature:
- `methodology/` - AI-DDD core concepts
- `architecture/` - Architectural principles
- `workflow/` - Process and workflow standards
- `quality/` - Quality gates and validation rules

## Standards Version
Current: v1.0.0-experimental

## Related Documentation

### Main Repository
<!-- 设计背景参考（主项目文档）:
     - docs/analysis/openspec-pilot-guide.md
     - docs/analysis/spec-system-comparison-analysis.md
-->

### Standards Workflow
- [子模块开发路线图](../workflow/submodule-development-roadmap.md)
- [OpenSpec 试点引用](../workflow/openspec-pilot-reference.md)
