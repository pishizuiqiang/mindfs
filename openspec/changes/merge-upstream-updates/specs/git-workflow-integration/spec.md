# Git Workflow Integration Specification

## ADDED Requirements

### Requirement: Git branch viewing
The system SHALL provide UI for viewing and switching between Git branches in the current project.

#### Scenario: Branch list display
- **WHEN** user accesses Git functionality in a project directory
- **THEN** system SHALL display list of all local and remote branches

#### Scenario: Branch switching
- **WHEN** user selects a different branch from the branch list
- **THEN** system SHALL switch to that branch and refresh the file tree view

### Requirement: Git history browsing
The system SHALL display commit history with author, date, and message information.

#### Scenario: History panel display
- **WHEN** user opens Git history panel
- **THEN** system SHALL show chronological list of commits with metadata

#### Scenario: Commit detail viewing
- **WHEN** user selects a commit from history
- **THEN** system SHALL display detailed commit information including changed files

### Requirement: Git worktree management
The system SHALL support creating, removing, and switching between Git worktrees.

#### Scenario: Worktree creation
- **WHEN** user creates a new worktree
- **THEN** system SHALL create linked working tree and make it available for project management

#### Scenario: Worktree switching
- **WHEN** user switches to a different worktree
- **THEN** system SHALL update project context to use the new worktree directory

#### Scenario: Worktree removal
- **WHEN** user removes a worktree
- **THEN** system SHALL delete the worktree directory and update project list

### Requirement: Git status integration
The system SHALL display current Git status including modified, staged, and untracked files.

#### Scenario: Status display
- **WHEN** user views Git status panel
- **THEN** system SHALL show current branch, modified files, and untracked files

#### Scenario: File status indicators
- **WHEN** file tree is displayed
- **THEN** system SHALL show visual indicators for files with Git changes