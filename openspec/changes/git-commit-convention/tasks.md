# Implementation Tasks

> **Final Status**: Core implementation complete via `standards/conventions/git-commit.md` and `commit-msg-generator` skill
> **Deferred**: Validation script, git hooks, CI/CD pipeline validation

## Phase 1: Definition ✓

### Task 1.1: Research Conventional Commits
- [x] Review Conventional Commits specification
- [x] Study Angular's commit guidelines
- [x] Identify best practices for multi-repo projects
- [x] Document findings in proposal.md

### Task 1.2: Define Format and Rules
- [x] Define allowed commit types (feat, fix, docs, etc.)
- [x] Define scope usage (optional vs required)
- [x] Create validation rules (subject length, case, punctuation)
- [x] Document format in proposal.md

### Task 1.3: Create Examples
- [x] Create positive examples (correct format) → In `conventions/git-commit.md` Section 9
- [x] Create negative examples (what to avoid) → In `conventions/git-commit.md` Section 8
- [x] Include examples for each commit type
- [x] Add examples to spec document

## Phase 2: Specification ✓

### Task 2.1: Write Spec
- [x] Create spec document → `standards/conventions/git-commit.md` (v2.0.0)
- [x] Define format requirements clearly
- [x] Include all validation rules
- [x] Add comprehensive examples

### Task 2.2: Quality Gate Validation
- [x] Simplicity check: ≤3 new concepts?
- [x] Clarity check: Understandable in 5 minutes?
- [x] Consistency check: Aligned with existing standards?
- [x] Enforceability check: Can be automated? → Via `commit-msg-generator` skill

## Phase 3: Tooling (Future)

### Task 3.1: Create Validation Script
- [ ] Develop `tools/commit-msg-lint.sh`
- [ ] Implement type validation
- [ ] Implement subject length check (≤72 chars)
- [ ] Implement case validation (lowercase)
- [ ] Implement punctuation check (no trailing period)
- [ ] Add helpful error messages

### Task 3.2: Test Validation Script
- [ ] Test with valid commit messages (should pass)
- [ ] Test with invalid types (should fail)
- [ ] Test with long subjects (should fail)
- [ ] Test with uppercase subjects (should fail)
- [ ] Test with trailing periods (should fail)
- [ ] Fix any bugs discovered

### Task 3.3: Create Git Hook Template
- [ ] Create `.git-hooks/commit-msg` template
- [ ] Add installation instructions
- [ ] Test hook installation process
- [ ] Document in README

## Phase 4: Documentation (Future)

### Task 4.1: Update Contributing Guides
- [ ] Update `standards/CONTRIBUTING.md`
- [ ] Update `mobile/CONTRIBUTING.md`
- [ ] Update `backend/CONTRIBUTING.md`
- [ ] Update `shared/CONTRIBUTING.md`
- [ ] Update `todo-app/CONTRIBUTING.md`

### Task 4.2: Create Quick Reference
- [ ] Create commit message template file
- [ ] Add examples to each CONTRIBUTING.md
- [ ] Create cheat sheet for common patterns

## Phase 5: Rollout (Future)

### Task 5.1: Install in Standards First
- [ ] Install validation script in standards repo
- [ ] Test with actual commits
- [ ] Gather feedback
- [ ] Refine if needed

### Task 5.2: Roll Out to Other Repos
- [ ] Install in shared repository
- [ ] Install in mobile repository
- [ ] Install in backend repository
- [ ] Install in main repository

### Task 5.3: CI/CD Integration
- [ ] Add commit message validation to CI pipeline
- [ ] Configure to run on PRs
- [ ] Test pipeline validation
- [ ] Document CI setup

## Phase 6: Training & Adoption (Future)

### Task 6.1: Team Communication
- [ ] Announce new standard to team
- [ ] Provide examples and documentation
- [ ] Offer training session if needed
- [ ] Collect feedback

### Task 6.2: Monitor Adoption
- [ ] Track compliance rate
- [ ] Identify common mistakes
- [ ] Update documentation based on feedback
- [ ] Refine validation rules if needed

## Success Metrics

- [ ] All new commits follow the convention
- [ ] Validation script catches 100% of format violations
- [ ] Team members report positive experience
- [ ] Automated changelog generation works correctly

## Notes

**Final Status**: Phase 1-2 Complete, Phase 3-6 Deferred

**Implementation Summary**:
- Core specification: `standards/conventions/git-commit.md` (v2.0.0)
- Message generation: `commit-msg-generator` skill
- Deferred: Standalone validation script, git hooks, CI pipeline integration

**Next Steps (if needed)**: Create separate OpenSpec change for CI/CD commit validation
