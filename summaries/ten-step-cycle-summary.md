# Ten-Step Cycle Summary

> **Source**: `standards/core/ten-step-cycle/README.md`
> **Full docs**: `standards/core/ten-step-cycle/`

## Overview

The Ten-Step Cycle integrates OpenSpec + AI-DDD + Branch Management.

## Phases

| Phase | Steps | Purpose |
|-------|-------|---------|
| **A: Planning** | A.0-A.3 | State scan → Spec → Tasks → Agents |
| **B: Development** | B.1-B.3 | Branch → Implement → Sync docs |
| **C: Integration** | C.1-C.2 | Commit → PR/Merge |
| **D: Closure** | D.1-D.2 | Update UPM → Archive Spec |

## Quick Reference

```yaml
A.0: state-scanner      # Read UPM, list active Specs
A.1: spec-drafter       # Create/select Spec (Level 1/2/3)
A.2: task-planner       # Break into TASK-{NNN}
A.3: task-planner       # Assign agents
B.1: branch-manager     # Create feature branch
B.2: (development)      # Implement + verify
B.3: arch-update        # Sync ARCHITECTURE.md
C.1: commit-msg-generator  # Standard commit
C.2: branch-manager     # PR → merge → delete branch
D.1: progress-updater   # Update UPM + stateToken
D.2: openspec:archive   # Archive completed Spec
```

## Level-Based Routing

| Level | Scenario | Mode |
|-------|----------|------|
| 1 | Simple fix | Skip Spec |
| 2 | New feature | Minimal Spec |
| 3 | Architecture | Full Spec |

---
*For details: `standards/core/ten-step-cycle/README.md`*
