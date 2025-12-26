# Tasks: Documentation Consolidation

> **Spec**: changes/documentation-consolidation/proposal.md
> **Level**: Full (Level 3)
> **Status**: Draft
> **Created**: 2025-12-26
> **Blocker For**: backend-api-development

---

## 1. Preparation & Backup

- [ ] 1.1 Create backup of docs/maintained/ before deletion
- [ ] 1.2 Create backup of backups/ directory before cleanup
- [ ] 1.3 Document all current file locations and links

## 2. Remove Duplicate Documents

- [ ] 2.1 Verify MD5 match between mobile/docs/ and docs/maintained/
- [ ] 2.2 Search for references to docs/maintained/development/mobile/
- [ ] 2.3 Update all references to point to mobile/docs/
- [ ] 2.4 Remove docs/maintained/development/mobile/ directory
- [ ] 2.5 Decide fate of remaining docs/maintained/ content

## 3. RPD Version Consolidation

- [ ] 3.1 Create _archive/ directory under mobile/docs/project-planning/architecture/
- [ ] 3.2 Move v2.0.0, v2.1.0, v2.2.0, v3.0.0 RPDs to _archive/
- [ ] 3.3 Rename mo-v4.0.0-rpd.md to mo-unified-rpd.md (current version)
- [ ] 3.4 Add version header to mo-unified-rpd.md indicating v4.0.0
- [ ] 3.5 Handle the versionless mo-unified-rpd.md (29KB file)

## 4. Create Root UPM

- [ ] 4.1 Create docs/project-planning/ directory
- [ ] 4.2 Create unified-progress-management.md with cross-module status
- [ ] 4.3 Link to Mobile UPM and Backend UPM
- [ ] 4.4 Add project-wide milestones section

## 5. Cleanup Expired Backups

- [ ] 5.1 Review backups/time-fix-2025-06-30/ contents
- [ ] 5.2 Archive to compressed file or delete
- [ ] 5.3 Update .gitignore if needed

## 6. Update References

- [ ] 6.1 Update root CLAUDE.md document paths
- [ ] 6.2 Update mobile/CLAUDE.md if affected
- [ ] 6.3 Update backend/CLAUDE.md if affected
- [ ] 6.4 Search and update any hardcoded paths in code

## 7. Validation & Commit

- [ ] 7.1 Verify no broken links in documentation
- [ ] 7.2 Run documentation link checker (if available)
- [ ] 7.3 Create commit with all changes
- [ ] 7.4 Update analysis report with completion status

---

## Summary

| Phase | Tasks | Description |
|-------|-------|-------------|
| 1. Preparation & Backup | 3 | 备份和记录当前状态 |
| 2. Remove Duplicate Documents | 5 | 移除重复文档 |
| 3. RPD Version Consolidation | 5 | RPD 版本整合 |
| 4. Create Root UPM | 4 | 创建根 UPM |
| 5. Cleanup Expired Backups | 3 | 清理过期备份 |
| 6. Update References | 4 | 更新文档引用 |
| 7. Validation & Commit | 4 | 验证和提交 |
| **Total** | **28** | - |

---

## Dependencies

```
Phase 1 ──> Phase 2 ──> Phase 6
    │           │
    │           └──> Phase 3 ──> Phase 6
    │
    └──> Phase 4
    │
    └──> Phase 5
              │
              └──────────────> Phase 7
```

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| 删除重要文档 | Phase 1 完整备份 |
| 破坏现有链接 | Phase 6 全面搜索更新 |
| 遗漏某些引用 | Phase 7 链接检查 |

---

## Notes

1. **备份优先**: 任何删除操作前必须先备份
2. **原子提交**: 每个 Phase 可以单独提交，便于回滚
3. **链接检查**: 使用 grep 搜索所有 `docs/maintained` 和旧路径引用
4. **阻塞关系**: 本任务完成后才能执行 backend-api-development
