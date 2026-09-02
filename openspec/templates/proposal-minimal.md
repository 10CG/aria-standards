# {Feature Name}

> **Level**: Minimal (Level 2 Spec)
> **Status**: Draft
> **Created**: {YYYY-MM-DD}
> **Linked Issue**: `{<org>/<repo>#<n>}`

## Why

{1-3 sentences explaining the motivation}

## What

{Brief description of what will be built/changed}

### Key Deliverables
- {Deliverable 1}
- {Deliverable 2}
- {Deliverable 3}

## Impact

| Type | Description |
|------|-------------|
| **Positive** | {Main benefit} |
| **Risk** | {Main risk and mitigation} |

## Tasks

- [ ] {Task 1}
- [ ] {Task 2}
- [ ] {Task 3}

## Success Criteria

- [ ] {Criterion 1}
- [ ] {Criterion 2}

---

## Template Usage Notes

**When to use Minimal (Level 2) Spec**:
- New Skill creation
- Medium-sized feature (1-3 days work)
- Changes affecting 2-5 files
- New workflow or process

**When to upgrade to Full (Level 3) Spec**:
- Architectural changes
- Cross-module changes
- Breaking changes
- Changes affecting > 10 files

**Linked Issue header line (required for Level 2 / Level 3)**:
- Value is an inline code span of the form `<org>/<repo>#<n>` (e.g. `10CG/Aria#174`); several issues go in the same code span separated by `, `
- No related issue (verified): write exactly `none` — do not leave the value empty and do not delete the line (an empty value is indistinguishable from "forgot to fill it in"). `N/A` / `TBD` / `-` are **not** accepted sentinels
- Extraction rules (E0–E6) and the mechanical check are defined in Aria Spec `linked-issue-field-availability` §3; always write the English canonical field name and sentinel exactly as shown above

**Sections can be omitted if not applicable**:
- Impact table can be simplified
- References section optional
- Implementation phases optional for small features
