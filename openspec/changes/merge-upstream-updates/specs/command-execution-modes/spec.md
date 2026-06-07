# Command Execution Modes Specification

## ADDED Requirements

### Requirement: Shell command execution mode
The system SHALL provide a dedicated `/shell` command mode for executing shell commands within agent sessions.

#### Scenario: Shell mode activation
- **WHEN** user types `/shell` command
- **THEN** system SHALL enter shell execution mode with dedicated UI for command input and output

#### Scenario: Shell command execution
- **WHEN** user executes a shell command in `/shell` mode
- **THEN** system SHALL run the command and display output with proper formatting

### Requirement: Goal-oriented command mode
The system SHALL provide a `/goal` command mode for executing goal-oriented tasks with file write capabilities.

#### Scenario: Goal mode activation
- **WHEN** user types `/goal` command
- **THEN** system SHALL enter goal execution mode with enhanced file manipulation capabilities

#### Scenario: Goal task execution
- **WHEN** user executes a goal-oriented task
- **THEN** system SHALL process the goal without thread blocking issues

### Requirement: Long shell session support
The system SHALL maintain persistent shell sessions per conversation session.

#### Scenario: Session-specific shell
- **WHEN** user switches between different conversation sessions
- **THEN** system SHALL maintain separate shell contexts for each session

#### Scenario: Shell context persistence
- **WHEN** user returns to a previous session
- **THEN** system SHALL restore the shell context for that session

### Requirement: Command output rendering
The system SHALL render command output using ANSI formatting instead of xterm for better compatibility and performance.

#### Scenario: ANSI output rendering
- **WHEN** command output is received
- **THEN** system SHALL parse and render ANSI escape sequences for colors and formatting

#### Scenario: Terminal width adaptation
- **WHEN** shell commands are executed
- **THEN** system SHALL adapt terminal width based on frontend xterm display dimensions

### Requirement: Command output UI cards
The system SHALL display command execution results in structured, collapsible cards within the conversation stream.

#### Scenario: Tool call card display
- **WHEN** command execution completes
- **THEN** system SHALL display results in a dedicated card with execution metadata

#### Scenario: Output expansion control
- **WHEN** user interacts with command output cards
- **THEN** system SHALL allow expansion and collapse of output sections