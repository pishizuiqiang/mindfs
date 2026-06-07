# Enhanced E2EE Specification

## ADDED Requirements

### Requirement: Full E2EE coverage
The system SHALL extend end-to-end encryption to cover all API endpoints and data transfers.

#### Scenario: API endpoint encryption
- **WHEN** any API endpoint is accessed
- **THEN** system SHALL ensure E2EE protection is applied if session requires encryption

#### Scenario: File transfer encryption
- **WHEN** files are transferred between client and server
- **THEN** system SHALL encrypt file contents using E2EE when enabled

### Requirement: Access proof for protected APIs
The system SHALL require access proof authentication for E2EE-protected API endpoints.

#### Scenario: Access proof validation
- **WHEN** E2EE-protected API is accessed
- **THEN** system SHALL validate access proof before processing the request

#### Scenario: Proof generation
- **WHEN** client needs to access protected resource
- **THEN** system SHALL generate and validate cryptographic access proof

### Requirement: E2EE pair code re-entry prevention
The system SHALL prevent re-entry of E2EE pair codes after restart when existing sessions are valid.

#### Scenario: Session continuity
- **WHEN** MindFS server restarts with existing E2EE sessions
- **THEN** system SHALL restore sessions without requiring pair code re-entry

#### Scenario: Concurrency handling
- **WHEN** multiple concurrent requests occur after restart
- **THEN** system SHALL handle E2EE state restoration without conflicts

### Requirement: Android E2EE reply polling protection
The system SHALL protect Android reply polling functionality with E2EE.

#### Scenario: Protected polling
- **WHEN** Android app polls for agent replies
- **THEN** system SHALL ensure polling channel is E2EE protected when enabled

#### Scenario: Polling authentication
- **WHEN** E2EE is enabled for Android polling
- **THEN** system SHALL validate encryption credentials before delivering reply content