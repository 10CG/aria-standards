# UPM Summary

> **Sources**: `standards/core/upm/`, `standards/core/state-management/`, `standards/core/progress-management/`

## UPM Document Paths

```yaml
Mobile:  mobile/docs/project-planning/unified-progress-management.md
Backend: backend/project-planning/unified-progress-management.md
```

## Requirements Section (Aria v3.0, Optional)

```yaml
requirements:
  prd:
    path: "docs/requirements/prd-v1.0.0.md"
    status: approved  # draft | review | approved | deprecated
    wiki_page: "PRD-v1.0.0"  # Optional: Forgejo Wiki page
  user_stories:
    total: 8
    by_status:
      draft: 1
      ready: 3
      in_progress: 2
      done: 2
      blocked: 0
  forgejo:
    enabled: true
    synced_at: "2025-12-25T10:00:00Z"
```

> **Note**: This section is optional for backward compatibility. See `standards/core/upm/upm-requirements-extension.md`

## UPMv2-STATE Format

```yaml
---
module: "backend"
stage: "Phase 3 - Development"
cycleNumber: 5
lastUpdateAt: "2025-12-09T15:00:00+08:00"
lastUpdateRef: "git:abc1234-description"
stateToken: "sha256:..."

nextCycle:
  intent: "Goal for next cycle"
  candidates: [...]

kpiSnapshot:
  coverage: "85%"
  build: "green"
  lintErrors: 0

risks: [...]
pointers:
  upm: "path/to/upm.md"
  architecture: "path/to/ARCHITECTURE.md"
---
```

## State Token

- **Purpose**: Optimistic locking for concurrent updates
- **Formula**: SHA256(module + stage + cycleNumber + lastUpdateAt + kpiSnapshot)
- **Update**: Must recalculate on every UPM change

## Progress Metrics

| Phase | Stages |
|-------|--------|
| Phase 1 | Planning |
| Phase 2 | Design |
| Phase 3 | Development |
| Phase 4 | Testing |
| Phase 5 | Deployment |

## Update Flow

1. Write lifecycle doc (`docs/project-lifecycle/week{N}/`)
2. Update UPMv2-STATE header
3. Recalculate stateToken
4. Verify consistency

---
*For details: `standards/core/upm/`, `standards/core/state-management/`*
