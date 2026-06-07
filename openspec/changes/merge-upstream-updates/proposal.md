# Proposal: Merge Upstream MindFS Updates

## Why

The current `remove-relay-mode` branch is based on an outdated version of MindFS (v0.2.3), while the upstream original repository has advanced to v0.3.1 with 92 new commits. This gap means we're missing critical bug fixes, important security enhancements, and valuable new features that improve stability, user experience, and functionality. Merging these upstream updates now will prevent accumulation of technical debt and ensure our relay removal work benefits from upstream improvements.

## What Changes

- **Merge 92 upstream commits** from a9gent/mindfs original repository across 5 planned batches
- **Skip relay-specific commits** to maintain compatibility with our relay removal work
- **Batch 1 (15 commits)**: Documentation updates and basic bug fixes (SDK versions, copy compatibility, Safari fixes, multiline paste handling)
- **Batch 2 (12 commits)**: CLI and Windows improvements (default behavior refinement, Windows stop/restart fixes, probe removal)
- **Batch 3 (20 commits)**: Web UI enhancements (dark/light theme system, history message editing, search improvements, code block copy)
- **Batch 4 (18 commits)**: Git workflow and configuration management (git branch viewing, worktree support, project rename, agent config backup)
- **Batch 5 (27 commits)**: Android enhancements and new features (new agent support: OMP, Hermes, Codex subagent; command execution modes /goal and /shell; E2EE full coverage, Android notifications)

## Capabilities

### New Capabilities
- `upstream-merge-process`: Systematic process for merging upstream updates with conflict resolution and testing
- `theme-system`: Dark/light/follow appearance mode settings for UI theming
- `git-workflow-integration`: Git branch viewing, history browsing, and worktree management
- `agent-config-management`: Agent configuration backup and switching capabilities
- `command-execution-modes`: `/goal` and `/shell` command execution modes with dedicated UI
- `enhanced-e2ee`: End-to-end encryption full coverage with access proof requirements
- `new-agent-support`: Support for OMP, Hermes agents and Codex subagent discovery

### Modified Capabilities
- `android-functionality`: Enhanced Android notifications, status bar integration, and E2EE-protected reply polling
- `cli-interface`: Improved CLI behavior, Windows compatibility, and probe removal
- `web-ui`: Theme system, history editing, and various UX improvements

## Impact

- **Code Integration**: 92 commits across frontend, backend, CLI, Android app, and documentation
- **Dependencies**: Updated Go modules, Android build configuration, and web dependencies
- **API Changes**: New endpoints for git operations, E2EE enhancements, and configuration management
- **Documentation**: README, CLAUDE.md, and various documentation files updated
- **Testing Required**: Each batch requires manual testing of affected components (CLI, web UI, Android, git operations)
- **Risk Management**: Skip relay-specific commits to avoid conflicts with current `remove-relay-mode` work
- **Merge Strategy**: Incremental batch merging with backup tags and rollback capability per batch