# Tasks: Upstream MindFS Updates Integration

## 1. Preparation and Setup

- [x] 1.1 Create backup branch of current `remove-relay-mode` state
- [x] 1.2 Add upstream remote repository: `git remote add upstream https://github.com/a9gent/mindfs.git`
- [x] 1.3 Fetch upstream commits: `git fetch upstream`
- [x] 1.4 Review and document all 92 upstream commits with detailed descriptions
- [x] 1.5 Identify and document relay-specific commits to skip (f13a451, 41055c0, etc.)
- [x] 1.6 Set up testing environment for batch validation
- [x] 1.7 Create project tracking spreadsheet for batch progress

## 2. Batch 1: Documentation and Basic Fixes (15 commits)

- [x] 2.1 Cherry-pick documentation updates (release notes, README changes) **[SKIPPED - Keep our docs]**
- [x] 2.2 Cherry-pick `fix: claude sdk version in go.mod` (435526c)
- [x] 2.3 Cherry-pick `fix: copy compatibility error` (6b59824)
- [x] 2.4 Cherry-pick `fix: static missing error hint` (8a4daaf)
- [x] 2.5 Cherry-pick `fix: filter asset missing warning` (41055c0) **[SKIPPED - Relay related]**
- [x] 2.6 Cherry-pick `fix: mobile multiline paste handling` (eda0fc2)
- [x] 2.7 Cherry-pick `fix: input box fly away under safari` (cef039c)
- [x] 2.8 Cherry-pick `fix: keep input target aligned` (15c55bb)
- [x] 2.9 Resolve any merge conflicts from Batch 1 commits **[No conflicts found]**
- [x] 2.10 Run compilation tests: `make build` and `make build-web`
- [x] 2.11 Run basic functionality tests (CLI startup, web UI loading)
- [x] 2.12 Create backup tag: `git tag backup-batch-1`
- [x] 2.13 Document any conflicts and resolutions for Batch 1

## 3. Batch 2: CLI and Windows Improvements (12 commits)

- [x] 3.1 Cherry-pick `refine: mindfs cli default behavior` (e044b75)
- [x] 3.2 Cherry-pick `refine: make relay binding explicit` (41055c0) **[SKIPPED - Relay related]**
- [x] 3.3 Cherry-pick `fix: mindfs -stop/-restart windows` (82b3f9e) **[Also completed task 3.8]**
- [x] 3.4 Cherry-pick `fix: mindfs -stop for -tls` (d8a6078)
- [x] 3.5 Cherry-pick `feat: remove initiative probe` (1a61ad8)
- [x] 3.6 Cherry-pick `refine: windows directory browse` (dbcc6ec)
- [x] 3.7 Cherry-pick `fix windows static asset paths` (96d7c3d)
- [x] 3.8 Add `cli/cmd/tasklist_parse.go` and `cli/cmd/tasklist_parse_test.go` files **[Completed in task 3.3]**
- [x] 3.9 Resolve any merge conflicts from Batch 2 commits **[Conflicts resolved during cherry-pick]**
- [x] 3.10 Test CLI startup and stop functionality on Linux/Mac **[Build successful, functionality verified]**
- [x] 3.11 Test Windows-specific fixes (if Windows environment available) **[Linux env - Windows code integrated successfully]**
- [x] 3.12 Verify probe removal doesn't affect agent functionality **[Core agent functionality intact]**
- [x] 3.13 Create backup tag: `git tag backup-batch-2`
- [x] 3.14 Document any conflicts and resolutions for Batch 2

## 4. Batch 3: Web UI and Experience Improvements (20 commits)

- [x] 4.1 Cherry-pick `feat: dark/ligth/follow appearance mode setting` (bb60ad4)
- [x] 4.2 Cherry-pick `refine: edit history user message` (a8b5146) **[SKIPPED - Complex UI conflicts]**
- [ ] 4.3 Cherry-pick `refine: show version info` (2b92daf)
- [ ] 4.4 Cherry-pick `refine: add copy for code block` (3a5d901)
- [ ] 4.5 Cherry-pick `refine: separate file tree expand` (5c784f3)
- [ ] 4.6 Cherry-pick `refine: tips for empty project list` (9061da6)
- [ ] 4.7 Cherry-pick `fix: locate to search match area` (46a97e2)
- [ ] 4.8 Cherry-pick `fix: input text error voice input` (8ac00b8)
- [ ] 4.9 Cherry-pick `fix: answer ask user with claude` (4812de0)
- [ ] 4.10 Cherry-pick `fix: chinaese decode error diff` (f4e19cc)
- [ ] 4.11 Cherry-pick `fix: ui of related session git diff` (7d1cf35)
- [ ] 4.12 Cherry-pick remaining UI improvement commits
- [ ] 4.13 Resolve any merge conflicts from Batch 3 commits
- [ ] 4.14 Build web frontend: `make build-web`
- [ ] 4.15 Test theme switching (dark/light/follow system)
- [ ] 4.16 Test history message editing functionality
- [ ] 4.17 Test code block copy functionality
- [ ] 4.18 Test search and navigation improvements
- [ ] 4.19 Create backup tag: `git tag backup-batch-3`
- [ ] 4.20 Document any conflicts and resolutions for Batch 3

## 5. Batch 4: Git Workflow and Configuration Management (18 commits)

- [ ] 5.1 Cherry-pick `feat: git branch and history` (ae3b25d)
- [ ] 5.2 Cherry-pick `feat: support add/remove git worktree` (a36fbd2)
- [ ] 5.3 Cherry-pick `feat: switch worktree under new worktree` (bfccd42)
- [ ] 5.4 Cherry-pick `feat: project rename` (8a201e1)
- [ ] 5.5 Cherry-pick `feat: agent config backup and switch` (8e6c730)
- [ ] 5.6 Cherry-pick `refine: merge installed & user-modified agents.json` (92cfc44)
- [ ] 5.7 Cherry-pick `refine: replace agents config backup` (3dd2ce5)
- [ ] 5.8 Cherry-pick `feat: support symbol link directory` (5870573)
- [ ] 5.9 Cherry-pick `fix: report error when add same name` (098363a)
- [ ] 5.10 Cherry-pick `refine: locate to user home dir` (40c715e)
- [ ] 5.11 Cherry-pick remaining Git workflow commits
- [ ] 5.12 Add `server/internal/gitview/` directory and files
- [ ] 5.13 Add `web/src/components/GitHistoryPanel.tsx` and related files
- [ ] 5.14 Resolve any merge conflicts from Batch 4 commits
- [ ] 5.15 Build and test Git branch viewing functionality
- [ ] 5.16 Test Git history browsing
- [ ] 5.17 Test Git worktree management
- [ ] 5.18 Test project rename functionality
- [ ] 5.19 Test agent configuration backup and switching
- [ ] 5.20 Create backup tag: `git tag backup-batch-4`
- [ ] 5.21 Document any conflicts and resolutions for Batch 4

## 6. Batch 5: Android and New Features (27 commits)

- [ ] 6.1 Cherry-pick `feat: add OMP agent support` (9a7cd31)
- [ ] 6.2 Cherry-pick `feat: support hermes agent` (8888aad)
- [ ] 6.3 Cherry-pick `feat: support codex subagent` (52584f0)
- [ ] 6.4 Cherry-pick `feat: support /goal and /shell` (d51cdf1)
- [ ] 6.5 Cherry-pick `feat: add command run mode` (ba59b44)
- [ ] 6.6 Cherry-pick `refine: ui of command mode` (2619597)
- [ ] 6.7 Cherry-pick `refine: long shell for each session` (018bfcb)
- [ ] 6.8 Cherry-pick `refine: adapt shell cols xterm width` (89a43b4)
- [ ] 6.9 Cherry-pick `feat: android status bar & lock screen` (334c04c)
- [ ] 6.10 Cherry-pick `feat: Protect Android reply polling with E2EE` (a31f960)
- [ ] 6.11 Cherry-pick `feat: android version update` (e7a5d52)
- [ ] 6.12 Cherry-pick `refine: android icon` (e795a65)
- [ ] 6.13 Cherry-pick `feat: e2ee full coverage` (67ec28d)
- [ ] 6.14 Cherry-pick `refine: access proof required for e2ee` (3b6e7b7)
- [ ] 6.15 Cherry-pick `fix: re-input e2ee pair-code` (cbae681, 6279582)
- [ ] 6.16 Cherry-pick `feat: support turn on/off fast service` (20e50b8)
- [ ] 6.17 Cherry-pick `feat: fetch latest version from release-notes` (93a2c42)
- [ ] 6.18 Cherry-pick `refine: panic recover for agent probe` (93244ea)
- [ ] 6.19 Add `android/app/src/main/java/com/mindfs/app/ReplyPollerService.java`
- [ ] 6.20 Add `android/app/src/main/res/` notification and sound resources
- [ ] 6.21 Update `agents.json` with new agent configurations
- [ ] 6.22 Add `server/internal/commandexec/` directory for command execution
- [ ] 6.23 Update `web/src/services/` for E2EE enhancements
- [ ] 6.24 Resolve any merge conflicts from Batch 5 commits
- [ ] 6.25 Build Android app: `make build-android`
- [ ] 6.26 Test new agent support (OMP, Hermes, Codex subagent)
- [ ] 6.27 Test /goal and /shell command execution modes
- [ ] 6.28 Test Android notifications and status bar integration
- [ ] 6.29 Test E2EE full coverage functionality
- [ ] 6.30 Test fast service toggle functionality
- [ ] 6.31 Create backup tag: `git tag backup-batch-5`
- [ ] 6.32 Document any conflicts and resolutions for Batch 5

## 7. Integration Testing and Validation

- [ ] 7.1 Run complete test suite: `make test`
- [ ] 7.2 Perform comprehensive CLI functionality testing
- [ ] 7.3 Perform comprehensive web UI testing across all browsers
- [ ] 7.4 Test relay removal functionality remains intact
- [ ] 7.5 Test all new features from upstream updates
- [ ] 7.6 Test git workflow integration features
- [ ] 7.7 Test agent configuration management
- [ ] 7.8 Test command execution modes
- [ ] 7.9 Test E2EE functionality with enhanced features
- [ ] 7.10 Test Android app functionality (if Android build available)
- [ ] 7.11 Verify no regressions in existing functionality
- [ ] 7.12 Performance testing for batch processing impact

## 8. Documentation and Cleanup

- [ ] 8.1 Update CLAUDE.md with merged features and changes
- [ ] 8.2 Update README.md with new capabilities
- [ ] 8.3 Create comprehensive merge summary document
- [ ] 8.4 Document skipped commits and rationale
- [ ] 8.5 Document all merge conflicts and resolutions
- [ ] 8.6 Update version information in project files
- [ ] 8.7 Create release notes for integrated upstream updates
- [ ] 8.8 Clean up temporary branches and test artifacts
- [ ] 8.9 Update OpenSpec change status to completed

## 9. Future Planning

- [ ] 9.1 Establish process for regular upstream synchronization
- [ ] 9.2 Document lessons learned from this merge process
- [ ] 9.3 Plan timeline for next upstream update cycle
- [ ] 9.4 Consider rebasing strategy for future updates