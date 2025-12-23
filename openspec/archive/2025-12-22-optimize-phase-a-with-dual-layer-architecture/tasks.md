# Tasks: Optimize Phase A with Dual-Layer Architecture

> **Spec**: optimize-phase-a-with-dual-layer-architecture
> **Level**: Full (Level 3)
> **Status**: Approved
> **Created**: 2025-12-20
> **Estimated**: 14-20 hours (including enhancement)

---

## 1. Architecture Documentation Update

- [x] 1.1 Update phase-a-spec-planning.md with task transformation pipeline section
- [x] 1.2 Define clear responsibility boundaries for A.1/A.2/A.3 steps
- [x] 1.3 Add tasks.md and detailed-tasks.yaml examples
- [x] 1.4 Document synchronization mechanisms (forward/backward sync)
- [x] 1.5 Update ten-step-cycle README.md with dual-layer overview

## 2. Skills Implementation

- [x] 2.1 Update task-planner skill: add tasks.md detection and parsing logic
- [x] 2.2 Update task-planner skill: implement detailed-tasks.yaml generation with parent and status fields
- [x] 2.3 Update task-planner skill: integrate agent assignment functionality
- [x] 2.4 Update spec-drafter skill: use standardized OpenSpec tasks.md template
- [x] 2.5 Update spec-drafter skill: ensure consistent numbering format
- [x] 2.6 Extend progress-updater skill: add backward sync logic (TASK completion → checkbox)
- [x] 2.7 Extend progress-updater skill: add conflict detection and warning

## 3. Templates and Tools

- [x] 3.1 Create templates/tasks.md template file
- [x] 3.2 Create templates/detailed-tasks.yaml template file
- [x] 3.3 Update OpenSpec templates documentation
- [x] 3.4 Add openspec validate --sync command documentation

## 4. Verification and Testing

- [x] 4.1 Create end-to-end test case using dual-layer architecture
- [x] 4.2 Verify AI correctly understands and uses dual-layer architecture
- [x] 4.3 Test synchronization mechanism correctness
- [x] 4.4 Verify conflict detection and resolution flow
- [x] 4.5 Test migration scenarios (existing projects)

## 5. Enhancement: Numbering Change Detection (NEW)

- [x] 5.1 Implement numbering immutability validator in task-planner
- [x] 5.2 Add pre-sync validation in progress-updater to detect parent reference failures
- [ ] 5.3 Create openspec validate --numbering command for manual verification (deferred)
- [ ] 5.4 Add warning/error output for numbering violations (deferred)
- [x] 5.5 Document numbering constraints and violation handling in phase-a-spec-planning.md

---

## Summary

| Phase | Tasks | Completed | Status |
|-------|-------|-----------|--------|
| 1. Architecture Documentation | 5 | 5 | ✅ 100% |
| 2. Skills Implementation | 7 | 7 | ✅ 100% |
| 3. Templates and Tools | 4 | 4 | ✅ 100% |
| 4. Verification and Testing | 5 | 5 | ✅ 100% |
| 5. Enhancement: Numbering Detection | 5 | 3 | ⚠️ 60% (2 deferred) |
| **Total** | **26** | **24** | **92.3%** |

**Completion Notes**:
- Phase 1-4: Fully completed and verified
- Phase 5: Core functionality (5.1, 5.2, 5.5) implemented
  - 5.3, 5.4: CLI validation tool deferred (not critical for core functionality)

---

## Dependencies

```
Phase 1 ──┬──> Phase 2 ──┬──> Phase 4
          │              │
          └──> Phase 3 ──┘
                         │
                         └──> Phase 5 (can parallel with Phase 4)
```

## Notes

1. **Phase 1 first**: Architecture documentation provides the foundation for implementation ✅
2. **Phase 2 is the core**: Skills implementation is the main effort ✅
3. **Phase 3 and Phase 4 can overlap**: Templates can be tested as they are created ✅
4. **Phase 5 (Enhancement)**: Can be done in parallel with Phase 4, or after Phase 2 completion ⚠️ (partially complete)

## Current Status

**Overall Progress**: 92.3% (24/26 tasks completed)

**Completed Work**:
- ✅ Architecture documentation fully updated with dual-layer concepts
- ✅ All Skills (task-planner, spec-drafter, progress-updater) implement dual-layer architecture
- ✅ Templates created and documented
- ✅ End-to-end testing completed with comprehensive test case (e2e-test-case.md)
- ✅ Synchronization mechanisms implemented and verified
- ✅ Conflict detection (Type 1/2/3) implemented in progress-updater

**Deferred Items**:
- ⏸️ 5.3: Standalone `openspec validate --numbering` CLI command
  - Rationale: Core validation logic already in Skills; CLI tool not critical
- ⏸️ 5.4: Dedicated warning/error output formatting
  - Rationale: Skills already output warnings via standard logging; separate formatter not essential

**Next Steps** (if needed):
1. Implement CLI validation tool (5.3, 5.4) if standalone validation becomes necessary
2. Archive this Spec using `openspec:archive` (D.2)
