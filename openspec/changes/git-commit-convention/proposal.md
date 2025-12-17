# Git Commit Message Convention

> **Status**: Implemented (Core)
> **Implemented**: 2025-12-17
> **Note**: Core documentation and skill implemented; tooling tasks (validation script, CI) deferred

## Why

Consistent commit messages improve:
- **Automated changelog generation**: Tools can parse commit types to generate release notes
- **Code review efficiency**: Reviewers immediately understand the nature of changes
- **Git history readability**: Clear patterns make history navigation easier
- **CI/CD automation**: Enables semantic versioning and automated releases
- **Team collaboration**: Uniform format reduces cognitive load

## What

Define and enforce a **Conventional Commits** format for all repositories in the Todo App project:
- Main repo (todo-app)
- Standards submodule
- Shared submodule
- Mobile submodule
- Backend submodule

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Allowed Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring (no feature or bug fix)
- `test`: Adding or updating tests
- `chore`: Build process, tooling, or dependency updates

### Scope (Optional)
Component or module name, examples: `api`, `ui`, `database`, `auth`

## Impact

### Positive
- ✅ Clearer git history for all team members
- ✅ Automated tooling becomes possible (changelog, versioning)
- ✅ Better collaboration across submodules
- ✅ Easier to understand what changed in each commit
- ✅ Supports automated semantic versioning

### Negative
- ⚠️ Learning curve for team members unfamiliar with the format
- ⚠️ Requires pre-commit hook setup in each repository
- ⚠️ May slow down initial commits until habit forms

### Mitigation
- Provide clear documentation with examples
- Create pre-commit hook for automatic validation
- Include helpful error messages when format is wrong

## Affected Repositories

### Direct Impact
All five repositories must adopt this standard:
- `todo-app` (main repository)
- `standards` (this repository)
- `shared`
- `mobile`
- `backend`

### Required Changes
- Update each repository's `CONTRIBUTING.md`
- Install pre-commit hook in each repository
- Update CI/CD pipelines to validate commit messages
- Create git commit message template

## Implementation Strategy

### Phase 1: Standards Definition (This Change)
Define the standard in `standards/openspec/specs/workflow/git-standards.md`

### Phase 2: Tooling Development
Create validation script in `standards/tools/commit-msg-lint.sh`

### Phase 3: Rollout
- Install hooks in each repository
- Update documentation
- Announce to team

## Success Criteria

- [x] Commit message format is clearly documented → `standards/conventions/git-commit.md`
- [~] Validation tool is implemented and tested → Partial: `commit-msg-generator` skill (generation, not strict validation)
- [x] All repositories have adopted the standard
- [x] Team members can format messages correctly without reference → Skill provides guidance
- [ ] CI/CD pipeline validates commit messages → Deferred to future change

## References

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Angular Commit Message Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit)
- [Semantic Versioning](https://semver.org/)
