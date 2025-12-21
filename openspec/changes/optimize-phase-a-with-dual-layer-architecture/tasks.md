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

- [ ] 2.1 Update task-planner skill: add tasks.md detection and parsing logic
- [ ] 2.2 Update task-planner skill: implement detailed-tasks.yaml generation with parent and status fields
- [ ] 2.3 Update task-planner skill: integrate agent assignment functionality
- [ ] 2.4 Update spec-drafter skill: use standardized OpenSpec tasks.md template
- [ ] 2.5 Update spec-drafter skill: ensure consistent numbering format
- [ ] 2.6 Extend progress-updater skill: add backward sync logic (TASK completion → checkbox)
- [ ] 2.7 Extend progress-updater skill: add conflict detection and warning

## 3. Templates and Tools

- [ ] 3.1 Create templates/tasks.md template file
- [ ] 3.2 Create templates/detailed-tasks.yaml template file
- [ ] 3.3 Update OpenSpec templates documentation
- [ ] 3.4 Add openspec validate --sync command documentation

## 4. Verification and Testing

- [ ] 4.1 Create end-to-end test case using dual-layer architecture
- [ ] 4.2 Verify AI correctly understands and uses dual-layer architecture
- [ ] 4.3 Test synchronization mechanism correctness
- [ ] 4.4 Verify conflict detection and resolution flow
- [ ] 4.5 Test migration scenarios (existing projects)

## 5. Enhancement: Numbering Change Detection (NEW)

- [ ] 5.1 Implement numbering immutability validator in task-planner
- [ ] 5.2 Add pre-sync validation in progress-updater to detect parent reference failures
- [ ] 5.3 Create openspec validate --numbering command for manual verification
- [ ] 5.4 Add warning/error output for numbering violations
- [ ] 5.5 Document numbering constraints and violation handling in phase-a-spec-planning.md

---

## Summary

| Phase | Tasks | Estimated Hours |
|-------|-------|-----------------|
| 1. Architecture Documentation | 5 | 2-3h |
| 2. Skills Implementation | 7 | 6-8h |
| 3. Templates and Tools | 4 | 2-3h |
| 4. Verification and Testing | 5 | 2-3h |
| 5. Enhancement: Numbering Detection | 5 | 2-3h |
| **Total** | **26** | **14-20h** |

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

1. **Phase 1 first**: Architecture documentation provides the foundation for implementation
2. **Phase 2 is the core**: Skills implementation is the main effort
3. **Phase 3 and Phase 4 can overlap**: Templates can be tested as they are created
4. **Phase 5 (Enhancement)**: Can be done in parallel with Phase 4, or after Phase 2 completion
