# Design: Upstream MindFS Updates Integration

## Context

The current `remove-relay-mode` branch diverged from the upstream original MindFS repository at commit `12c27c0` (v0.2.3), while upstream has advanced to `6bd22ae` (v0.3.1) with 92 new commits. Our branch removes relay remote mode functionality, while upstream has continued development with new features, bug fixes, and improvements. We need to integrate upstream changes while preserving our relay removal work and avoiding conflicts.

**Current State:**
- Our branch: `remove-relay-mode` at `4eb9c7e` (3 commits ahead of main)
- Upstream: `a9gent/mindfs` main branch at `6bd22ae` 
- Gap: 92 commits, 7 version releases (v0.2.4 → v0.3.1)
- Overlap: Some upstream commits contain relay-related code that conflicts with our changes

**Constraints:**
- Must preserve `remove-relay-mode` functionality
- Cannot reintroduce relay mode dependencies
- Must maintain compatibility with our modifications
- Limited testing resources - need incremental validation

## Goals / Non-Goals

**Goals:**
- Integrate all upstream bug fixes, features, and improvements systematically
- Maintain relay removal work without conflicts  
- Enable incremental testing and rollback capability
- Document merge process for future upstream updates
- Minimize disruption to ongoing development

**Non-Goals:**
- Reintroducing relay remote mode functionality
- Modifying upstream changes (except relay conflicts)
- Simultaneous merge of all 92 commits (too risky)
- Automated conflict resolution (manual review required)

## Decisions

### 1. Incremental Batch Strategy
**Decision:** Merge commits in 5 batches ordered by risk level and dependency relationships.

**Rationale:**
- Low-risk batches build confidence and process refinement
- Complex features (Android, Git, E2EE) get individual attention
- Easier to isolate and rollback problematic batches
- Allows testing between batches

**Alternatives considered:**
- **Single large merge**: Rejected due to high risk, difficult conflict resolution
- **Random cherry-picking**: Rejected due to dependency breakage risk
- **Time-based batches**: Rejected because feature cohesion matters more than dates

### 2. Skip Relay-Specific Commits
**Decision:** Identify and skip commits that primarily deal with relay functionality.

**Rationale:**
- Maintains integrity of `remove-relay-mode` work
- Avoids unnecessary conflicts with our changes
- Reduces merge complexity

**Affected commits:**
- `f13a451` - "fix: android notification bug with relay mode"
- `41055c0` - "refine: make relay binding explicit"
- Any other commits with relay-only changes

### 3. Git Cherry-Pick over Merge
**Decision:** Use `git cherry-pick` for individual commits rather than `git merge`.

**Rationale:**
- Precise control over which commits to include
- Easier to skip problematic commits
- Cleaner commit history in our branch
- Better conflict isolation

**Trade-off:** More manual work but worth it for control and safety.

### 4. Backup Tags Per Batch
**Decision:** Create git tags after each successful batch completion.

**Rationale:**
- Quick rollback capability if issues emerge
- Clear checkpoints for testing validation
- Safety net for experimental merge process

**Tag naming:** `backup-batch-N` (e.g., `backup-batch-1`, `backup-batch-2`)

### 5. Testing Strategy
**Decision:** Progressive testing focused on affected components per batch.

**Rationale:**
- Efficient resource utilization
- Early detection of integration issues
- Confidence building for subsequent batches

**Test categories:**
- Compilation tests (all batches)
- Functional tests (batch-specific features)
- Integration tests (cross-component interactions)

## Risks / Trade-offs

### Risk 1: Conflict Complexity
**Risk:** Cherry-picking may have unexpected merge conflicts, especially in modified files.

**Mitigation:**
- Manual conflict resolution with careful review
- Keep detailed notes of conflict resolutions
- Test thoroughly after each conflict resolution

### Risk 2: Dependency Breakage
**Risk:** Skipping some commits may break dependencies for later commits.

**Mitigation:**
- Analyze commit dependencies before batching
- Test each batch completely before proceeding
- Be prepared to include skipped commits if needed

### Risk 3: Testing Time Investment
**Risk:** Progressive testing of 5 batches requires significant time.

**Mitigation:**
- Focus testing on affected components only
- Use automated tests where available
- Accept that quality takes precedence over speed

### Risk 4: Divergence from Upstream
**Risk:** Our process creates further divergence from upstream main branch.

**Mitigation:**
- Document all modifications and skip decisions
- Consider rebasing strategy for future updates
- Maintain clear merge history

### Risk 5: Android Build Failures
**Risk:** Android changes in Batch 5 may have complex build dependencies.

**Mitigation:**
- Test Android compilation early in the batch
- Have Android development environment ready
- Be prepared for dependency version conflicts

## Migration Plan

### Phase 1: Preparation
1. Create backup of current `remove-relay-mode` branch
2. Set up upstream remote: `git remote add upstream https://github.com/a9gent/mindfs.git`
3. Fetch upstream commits: `git fetch upstream`
4. Review and finalize batch breakdown

### Phase 2: Batch Execution (per batch)
1. **Pre-merge**: Review commits in batch, identify potential conflicts
2. **Cherry-pick**: Apply commits using `git cherry-pick`
3. **Conflict resolution**: Manually resolve any merge conflicts
4. **Compilation**: Ensure project builds successfully
5. **Testing**: Validate batch-specific functionality
6. **Backup**: Create `backup-batch-N` tag if successful
7. **Rollback**: If testing fails, reset to previous backup tag

### Phase 3: Post-Merge
1. Final comprehensive testing across all components
2. Update documentation with merge notes
3. Create summary of changes and skip decisions
4. Plan for future upstream synchronization

### Rollback Strategy
Per-batch rollback capability via git tags:
```bash
# If batch N fails testing
git reset --hard backup-batch-{N-1}

# If complete restart needed  
git reset --hard <original-remove-relay-mode-backup>
```

## Open Questions

1. **Batch Priority**: Should Git workflow features (Batch 4) be prioritized over Android features (Batch 5)?
   - *Current plan*: Git first as it's more core to development workflow

2. **Testing Resources**: What level of manual testing resources are available for each batch?
   - *To be determined*: May affect timeline expectations

3. **Future Updates**: How should we handle upstream updates after this merge?
   - *Consider*: More frequent merges to reduce gap size

4. **Documentation**: How much merge process documentation should be preserved long-term?
   - *To discuss*: Balance between historical record and documentation bloat