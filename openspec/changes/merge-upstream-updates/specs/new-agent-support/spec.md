# New Agent Support Specification

## ADDED Requirements

### Requirement: OMP agent integration
The system SHALL support the OMP (OpenAI Model Protocol) agent for AI interactions.

#### Scenario: OMP agent detection
- **WHEN** OMP agent CLI is installed on the system
- **THEN** system SHALL automatically detect and add it to available agents list

#### Scenario: OMP session creation
- **WHEN** user creates a session with OMP agent
- **THEN** system SHALL initialize OMP agent with proper protocol handling

### Requirement: Hermes agent integration
The system SHALL support the Hermes agent for AI interactions.

#### Scenario: Hermes agent detection
- **WHEN** Hermes agent CLI is installed on the system
- **THEN** system SHALL automatically detect and add it to available agents list

#### Scenario: Hermes session creation
- **WHEN** user creates a session with Hermes agent
- **THEN** system SHALL initialize Hermes agent with proper protocol handling

### Requirement: Codex subagent discovery and display
The system SHALL automatically discover and display Codex subagents.

#### Scenario: Subagent auto-discovery
- **WHEN** Codex agent is used with subagents
- **THEN** system SHALL automatically discover available subagents

#### Scenario: Subagent display
- **WHEN** subagents are discovered
- **THEN** system SHALL display them in the UI with proper identification

#### Scenario: Subagent selection
- **WHEN** user selects a specific subagent
- **THEN** system SHALL route interactions through the selected subagent

### Requirement: Agent compatibility check
The system SHALL verify compatibility of new agents with existing session management.

#### Scenario: Compatibility validation
- **WHEN** new agent is added
- **THEN** system SHALL verify it follows supported protocol patterns

#### Scenario: Feature capability detection
- **WHEN** new agent is initialized
- **THEN** system SHALL detect and expose supported features (streaming, tools, etc.)