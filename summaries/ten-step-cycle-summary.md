# Ten-Step Cycle Summary

> **Version**: 1.1.0
> **Source**: `standards/core/ten-step-cycle/README.md`
> **Full docs**: `standards/core/ten-step-cycle/`

## Overview

The Ten-Step Cycle integrates OpenSpec + AI-DDD + Branch Management.

## Phases

| Phase | Steps | Purpose |
|-------|-------|---------|
| **A: Planning** | A.0-A.3 | State scan → Spec → Tasks → Agents |
| **B: Development** | B.1-B.3 | Branch → Implement (TDD) → Sync docs |
| **C: Integration** | C.1-C.2 | Commit → PR/Merge |
| **D: Closure** | D.1-D.2 | Update UPM → Archive Spec |

## Quick Reference

```yaml
A.0: state-scanner      # Read UPM, list active Specs
A.1: spec-drafter       # Create/select Spec (Level 1/2/3)
A.2: task-planner       # Break into TASK-{NNN}
A.3: task-planner       # Assign agents
B.1: branch-manager     # Create feature branch
B.2: tdd-enforcer       # RED → GREEN → REFACTOR
      + two-phase-review # Phase 1: 规范合规, Phase 2: 代码质量
B.3: arch-update        # Sync ARCHITECTURE.md
C.1: commit-msg-generator  # Standard commit
     strategic-commit-orchestrator  # Multi-module commits
C.2: branch-manager     # PR → merge → delete branch
D.1: progress-updater   # Update UPM + stateToken
D.2: openspec:archive   # Archive completed Spec
```

## TDD Quick Reference

```yaml
RED Phase:   test() → fail → stop
GREEN Phase: code() → pass → stop
REFACTOR:    clean() → pass → continue

Triggers: "测试", "test", "tdd" → tdd-enforcer
Language Support: Python, JS/TS, Dart, Java, Go
```

## Auto-Trigger Keywords

| Input | Skill | Confidence |
|-------|-------|------------|
| "测试", "test" | tdd-enforcer | 0.8+ |
| "分支", "branch" | branch-manager | 0.7+ |
| "提交", "commit" | commit-msg-generator | 0.7+ |
| "规划", "plan" | task-planner | 0.6+ |
| "状态", "state" | state-scanner | 0.6+ |

## Level-Based Routing

| Level | Scenario | Mode |
|-------|----------|------|
| 1 | Simple fix | Skip Spec |
| 2 | New feature | Minimal Spec |
| 3 | Architecture | Full Spec |

---
*For details: `standards/core/ten-step-cycle/README.md`*
**Updated**: 2026-01-20
