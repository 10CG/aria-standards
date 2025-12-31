# Standards Repository - Project Context

## Purpose
This repository is the **authoritative source** for development standards, processes, and quality gates for the Todo App multi-repository project.

It stores the **Aria Methodology** (AI-DDD v3.0) using the **OpenSpec framework**.

> **Aria** = AI + Rhythm + Iteration + Automation
> See [Aria Brand Guide](../standards/methodology/aria-brand-guide.md) for details.

## Scope

### In Scope
- Aria Methodology definitions (Ten-Step Cycle, UPM, OpenSpec, Validation Gates)
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
- `methodology/` - Aria Core concepts (Ten-Step Cycle, brand guide)
- `core/` - Core specifications (UPM, workflow, ten-step-cycle)
- `conventions/` - Coding and process conventions
- `extensions/` - Platform-specific extensions (mobile, backend)
- `templates/` - Document templates (PRD, User Story, etc.)
- `summaries/` - Quick reference summaries

## Standards Version
Current: Aria v3.0.0 (AI-DDD)

## Related Documentation

### Main Repository
<!-- 设计背景参考（主项目文档）:
     - docs/analysis/openspec-pilot-guide.md
     - docs/analysis/spec-system-comparison-analysis.md
-->

### Standards Workflow
- [子模块开发路线图](../workflow/submodule-development-roadmap.md)
- [OpenSpec 试点引用](../workflow/openspec-pilot-reference.md)
