# Test Dual-Layer Architecture - Test Documentation

> **Test Case**: test-dual-layer
> **Purpose**: End-to-end validation of OpenSpec dual-layer task architecture
> **Status**: In Progress
> **Created**: 2025-12-22

## Overview

This test case validates the dual-layer task architecture implementation in OpenSpec, ensuring that:

1. **Layer 1 (tasks.md)** properly maintains human-readable task lists with `{phase}.{task}` numbering
2. **Layer 2 (detailed-tasks.yaml)** correctly stores machine-readable task metadata with TASK-{NNN} IDs
3. **Synchronization mechanisms** work bidirectionally between both layers
4. **Validation commands** correctly detect format violations and inconsistencies

## Test Structure

### Phase 1: Setup Test Structure
- TASK-001: Create test documentation directory
- TASK-002: Initialize validation test framework
- TASK-003: Document test scenarios and expected outcomes

### Phase 2: Layer 1 Testing (tasks.md)
- TASK-004: Verify proper numbering format validation
- TASK-005: Test phase grouping and organization
- TASK-006: Validate checkbox status tracking

### Phase 3: Layer 2 Testing (detailed-tasks.yaml)
- TASK-007: Test TASK-{NNN} ID generation
- TASK-008: Verify parent reference linking
- TASK-009: Validate task metadata completeness

### Phase 4: Synchronization Testing
- TASK-010: Test forward sync (tasks.md → detailed-tasks.yaml)
- TASK-011: Test backward sync (completion status updates)
- TASK-012: Verify conflict detection mechanisms

## Validation Commands

This test case validates the following OpenSpec commands:

### 1. Sync Validation
```bash
openspec validate --sync test-dual-layer
```
**Purpose**: Validate synchronization between tasks.md and detailed-tasks.yaml

### 2. Numbering Validation
```bash
openspec validate --numbering test-dual-layer
```
**Purpose**: Verify numbering format and immutability constraints

### 3. Spec Overview
```bash
openspec show test-dual-layer
```
**Purpose**: Display complete spec overview with both layers

## Test Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Test case overview (this file) |
| `validation-report.md` | Template for recording validation results |
| `test-scenarios.md` | Detailed test scenarios for each validation aspect |
| `expected-outputs.md` | Expected outputs for each validation command |
| `test-framework.md` | Validation methodology and approach |
| `validation-checklist.md` | Comprehensive validation checklist |

## Success Criteria

- [ ] tasks.md follows proper numbering format (`{phase}.{task}`)
- [ ] detailed-tasks.yaml has valid parent references for all tasks
- [ ] `openspec validate --sync` passes without errors
- [ ] `openspec validate --numbering` passes without errors
- [ ] Forward sync (tasks.md → detailed-tasks.yaml) works correctly
- [ ] Backward sync (status updates) works correctly
- [ ] Conflict detection scenarios are properly handled

## Related Documentation

- [Proposal](../proposal.md) - Test case specification
- [Tasks](../tasks.md) - Layer 1 task list
- [Detailed Tasks](../detailed-tasks.yaml) - Layer 2 task metadata
- [Phase A Planning](../../../../core/ten-step-cycle/phase-a-spec-planning.md) - Dual-layer architecture documentation

---

**Last Updated**: 2025-12-22
**Maintainer**: AI-DDD Development Team
