# Proposal: Remove Relay Remote Mode

## Summary

Remove the Relay remote mode feature from MindFS, which allows remote access through a9gent.com. The user already has their own external access solution (Tailscale, VPN, etc.) and does not need this built-in functionality.

## Motivation

### Why
- User has an existing external access solution and does not need Relay functionality
- Relay mode adds code complexity (~2000+ lines) without providing value
- Reduces dependencies on external services (a9gent.com)
- Improves security by reducing attack surface
- Decreases resource usage (WebSocket connections, polling, goroutines)

### User Impact
- ✅ Local access (`localhost:7331`) unchanged
- ✅ LAN access (`192.168.1.x:7331`) unchanged
- ✅ Android App still usable (via user's own external access)
- ❌ No longer able to use a9gent.com relay for remote access
- ✅ Overall: Positive impact for user's use case

## Scope

### In Scope
- Remove entire `server/internal/relay/` package (7 files)
- Remove relay integration from `server/app/server.go`
- Remove relay fields from `server/internal/api/appcontext.go`
- Remove relay API endpoints from `server/internal/api/http.go`
- Remove `--no-relayer` flag from CLI
- Remove relay-related frontend code
- Remove `LauncherNodeSyncPlugin` from Android app
- Update configuration files (`agents.json`)
- Update documentation (README files)
- Update tests

### Out of Scope
- Core agent pool functionality
- Session management
- File system operations
- WebSocket streaming (local)
- End-to-end encryption (E2EE)
- Update service (still uses a9gent/mindfs repo for releases)

## Alternatives Considered

### 1. Keep but Disable by Default
**Pros**: Future-proof if Relay is needed later
**Cons**: Code complexity remains, maintenance burden, confusion about feature availability

### 2. Make Relay Optional Plugin
**Pros**: Core cleaner, Relay as opt-in
**Cons**: Still requires maintenance, plugin architecture doesn't exist for backend services

### 3. Complete Removal (Chosen)
**Pros**: Cleanest codebase, reduced complexity, no maintenance burden
**Cons**: Cannot easily re-enable if needed later

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Breaking change for existing users | Low | Medium | User already has alternative access method |
| Android App loses remote access | Low | Low | User's external access solution still works |
| Documentation becomes outdated | Medium | Low | Comprehensive doc updates included |
| Hidden dependencies missed | Low | Medium | Thorough code review and testing |

## Success Criteria

- [ ] All relay-related code removed
- [ ] Project builds successfully (`make build`)
- [ ] Tests pass (`make test`)
- [ ] Android App builds successfully
- [ ] Local and LAN access work as before
- [ ] Documentation updated and accurate
- [ ] No references to relay in codebase (except git history)
