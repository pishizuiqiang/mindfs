# CLI Interface Enhanced Specification

## ADDED Requirements

### Requirement: Probe removal
The CLI SHALL remove the initiative probe functionality to reduce complexity and improve performance.

#### Scenario: Simplified startup
- **WHEN** MindFS CLI starts
- **THEN** system shall NOT perform automatic agent probing

#### Scenario: On-demand agent checks
- **WHEN** user needs to verify agent availability
- **THEN** system shall provide manual agent check commands

### Requirement: Windows stop/restart functionality
The CLI SHALL properly handle stop and restart commands on Windows platforms.

#### Scenario: Windows service stop
- **WHEN** user runs `mindfs -stop` on Windows
- **THEN** system shall properly terminate the MindFS process

#### Scenario: Windows service restart
- **WHEN** user runs `mindfs -restart` on Windows
- **THEN** system shall stop and restart MindFS without errors

#### Scenario: Windows TLS mode stop
- **WHEN** MindFS is running with TLS enabled on Windows
- **THEN** `mindfs -stop` command shall successfully terminate the process

### Requirement: Improved default behavior
The CLI shall provide refined default behavior for common operations.

#### Scenario: Directory browse defaults
- **WHEN** user adds a project on Windows
- **THEN** system shall provide Windows-appropriate directory browsing interface

#### Scenario: Home directory location
- **WHEN** user adds local project without current project context
- **THEN** system shall default to user home directory for browsing

### Requirement: Static asset path handling
The CLI shall properly resolve static asset paths across different platforms.

#### Scenario: Windows asset paths
- **WHEN** app runs on Windows
- **THEN** system shall resolve static asset paths using Windows path conventions

#### Scenario: Asset missing warnings
- **WHEN** static assets are not found
- **THEN** system shall display appropriate error messages without crashing