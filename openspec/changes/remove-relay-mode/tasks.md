# Tasks: Remove Relay Remote Mode

## Phase 1: Backend Removal (Core)

### Task 1.1: Delete relay package
- [x] Delete `server/internal/relay/service.go`
- [x] Delete `server/internal/relay/manager.go`
- [x] Delete `server/internal/relay/credentials.go`
- [x] Delete `server/internal/relay/device.go`
- [x] Delete `server/internal/relay/tips.go`
- [x] Delete `server/internal/relay/wsconn.go`
- [x] Delete `server/internal/relay/service_test.go`
- [x] Delete `server/internal/relay/` directory (if empty)

**Validation:** `ls server/internal/relay/` should fail

### Task 1.2: Modify server/app/server.go
- [x] Remove `"mindfs/server/internal/relay"` import
- [x] Remove `NoRelayer` field from `StartOptions` struct
- [x] Remove `RelayBaseURL` field from `StartOptions` struct
- [x] Remove relay base URL resolution code (lines 76-79)
- [x] Remove `relayMgr` creation and initialization (lines 126-134)
- [x] Remove `services.Relay = relayMgr`
- [x] Remove `services.RelayTips = relay.NewTipsService(relayMgr)`
- [x] Remove `relayMgr.Start(ctx)` call
- [x] Remove `services.RelayTips.Start(ctx)` call

**Validation:** `go build ./server/app` should succeed

### Task 1.3: Modify server/internal/api/appcontext.go
- [x] Remove `"mindfs/server/internal/relay"` import
- [x] Remove `Relay *relay.Manager` field from `AppContext` struct
- [x] Remove `RelayTips *relay.TipsService` field from `AppContext` struct
- [x] Remove `GetRelayManager()` method
- [x] Remove `GetRelayTipsService()` method

**Validation:** `go build ./server/internal/api` should succeed

### Task 1.4: Modify server/internal/api/http.go
- [x] Remove `r.Get("/api/relay/status", h.handleRelayStatus)` route
- [x] Remove `r.Get("/api/relay/tips", h.handleRelayTips)` route
- [x] Remove `handleRelayStatus` function
- [x] Remove `handleRelayTips` function

**Validation:** `go build ./server/internal/api` should succeed

### Task 1.5: Modify cli/cmd/mindfs.go
- [x] Remove `noRelayer := flag.Bool("no-relayer", false, "disable relay integration")`
- [x] Remove `NoRelayer: *noRelayer` from `app.StartOptions`
- [x] Update usage/docs if they mention `--no-relayer`

**Validation:** `go build ./cli/cmd` should succeed

### Task 1.6: Modify server/cmd/mindfs-server/main.go
- [x] Remove `noRelayer := flag.Bool("no-relayer", false, "disable relay integration")`
- [x] Remove `NoRelayer: *noRelayer` from `app.StartOptions`

**Validation:** `go build ./server/cmd/mindfs-server` should succeed

### Task 1.7: Backend Integration Tests
- [ ] Run `go test ./server/...` and ensure all pass
- [ ] Run `make build` and ensure success
- [ ] Run `make dev-backend` and ensure server starts
- [ ] Test that `/api/relay/status` returns 404
- [ ] Test that `/api/relay/tips` returns 404

**Validation:** All tests pass, server starts successfully

---

## Phase 2: Frontend Cleanup

### Task 2.1: Modify web/src/App.tsx
- [x] Remove `RelayStatusPayload` type definition
- [x] Remove `relayStatus` state declaration
- [x] Remove `setRelayStatus` setter usage
- [x] Remove `refreshRelayStatus` function
- [x] Remove `handleRelayAction` function
- [x] Remove `redirectToRelayLogin` function
- [x] Remove `redirectToRelayNodes` function
- [x] Remove `handleRelayNavigationFailure` function
- [x] Remove `isRelayPWAContext` function
- [x] Remove relay-related `useEffect` hooks
- [x] Remove relay-related conditional logic in main useEffect

**Validation:** `npm run typecheck` in web/ should succeed

### Task 2.2: Modify web/src/components/Login.tsx
- [ ] Remove `consumePendingRelayNodes` import
- [ ] Remove `getNativeLauncherNodes` import (if only used for relay)
- [ ] Remove `setNativeLauncherNodes` import (if only used for relay)
- [ ] Remove `RELAY_URL` constant
- [ ] Remove relay-specific UI elements
- [ ] Remove relay node consumption logic
- [ ] Keep manual node entry (still useful for user's external access)

**Validation:** `npm run typecheck` in web/ should succeed

### Task 2.3: Delete web/src/services/launcherNodeSync.ts
- [ ] Delete entire file

**Validation:** File should not exist, no import errors

### Task 2.4: Frontend Build Test
- [ ] Run `cd web && npm run build`
- [ ] Ensure build succeeds
- [ ] Check for any relay-related console errors
- [ ] Test in browser: localhost:7331 should work

**Validation:** Build succeeds, app loads in browser

---

## Phase 3: Configuration and Tests

### Task 3.1: Modify agents.json
- [ ] Remove `"relayBaseURL": "https://relay.a9gent.com"` line
- [ ] Validate JSON is still well-formed

**Validation:** `cat agents.json | jq .` should succeed

### Task 3.2: Modify server/internal/agent/config.go
- [ ] Remove `RelayBaseURL string` field from `Config` struct tag
- [ ] Remove `cfg.RelayBaseURL = strings.TrimSpace(cfg.RelayBaseURL)` line

**Validation:** `go test ./server/internal/agent` should pass

### Task 3.3: Modify server/internal/agent/pool_test.go
- [ ] Remove `TestLoadConfigReadsRelayBaseURL` function entirely

**Validation:** `go test ./server/internal/agent` should pass

### Task 3.4: Modify server/internal/agent/testdata/agents.json
- [ ] Remove `"relayBaseURL": "https://relay.example.com"` line

**Validation:** JSON is valid

---

## Phase 4: Android Cleanup

### Task 4.1: Modify android/app/src/main/java/com/mindfs/app/MainActivity.java
- [ ] Remove `registerPlugin(LauncherNodeSyncPlugin.class);`
- [ ] Remove `LauncherNodeSyncBridge` inner class entirely
- [ ] Remove `getBridge().getWebView().addJavascriptInterface(new LauncherNodeSyncBridge(), "MindFSLauncherNodeSync");`

**Validation:** Android project should build

### Task 4.2: Delete android/app/src/main/java/com/mindfs/app/LauncherNodeSyncPlugin.java
- [ ] Delete entire file

**Validation:** No compilation errors

### Task 4.3: Android Build Test
- [ ] Run `cd android && ./gradlew assembleDebug` (or `make build-android`)
- [ ] Ensure APK builds successfully

**Validation:** APK generated without errors

---

## Phase 5: Documentation Updates

### Task 5.1: Modify README.md
- [ ] Remove "Relay remote mode" from "Access Modes" section
- [ ] Remove a9gent.com links
- [ ] Remove `-no-relayer` from "Flags" documentation
- [ ] Remove relay setup instructions
- [ ] Review entire document for relay references

**Validation:** No relay mentions in README.md

### Task 5.2: Modify README.zh.md
- [ ] Remove "Relay 远程模式" from "访问模式" section
- [ ] Remove "通过 relayer远程访问" section
- [ ] Remove `-no-relayer` from "Flags" 文档
- [ ] Remove relay setup instructions
- [ ] Review entire document for relay references

**Validation:** No relay mentions in README.zh.md

### Task 5.3: Modify CLAUDE.md
- [ ] Update "Backend" section to remove relay service reference
- [ ] Update `server/internal/relay/` entry from key file locations
- [ ] Review for any other relay mentions

**Validation:** No relay mentions in CLAUDE.md

### Task 5.4: Check for other documentation
- [ ] Search for any `*.md` files mentioning "relay"
- [ ] Update or remove relay references
- [ ] Check if any release notes mention relay

**Validation:** `grep -r "relay" --include="*.md" .` should return minimal results (only git history)

---

## Phase 6: Final Validation

### Task 6.1: Full Build Test
- [ ] Run `make dist-clean` to clean all build artifacts
- [ ] Run `make build` to build CLI with embedded web assets
- [ ] Run `make build-android` to build Android APK
- [ ] Ensure all builds succeed

**Validation:** All build artifacts generated successfully

### Task 6.2: Full Test Suite
- [ ] Run `make test` (Go tests)
- [ ] Run `cd web && npm run typecheck` (TypeScript type check)
- [ ] Ensure all tests pass

**Validation:** All tests pass

### Task 6.3: Manual Integration Testing
- [ ] Start server: `./mindfs`
- [ ] Access web UI: http://localhost:7331
- [ ] Create an agent session
- [ ] Browse files
- [ ] Test plugin functionality
- [ ] Test LAN access from another device
- [ ] Test Android App with user's external access
- [ ] Verify no relay-related errors in logs

**Validation:** All core functionality works

### Task 6.4: Code Verification
- [ ] Search for remaining relay references: `grep -r "relay" server/ --include="*.go" | grep -v ".git"`
- [ ] Search for remaining relay references: `grep -r "Relay" server/ --include="*.go" | grep -v ".git"`
- [ ] Search for remaining relay references: `grep -r "relay" web/src --include="*.ts" --include="*.tsx"`
- [ ] Verify no relay imports remain

**Validation:** Only comments or git history should contain relay references

### Task 6.5: Clean Up
- [ ] Remove `~/.config/mindfs/relay_credentials.json` if exists (optional)
- [ ] Clear browser localStorage relay data (optional)
- [ ] Verify no relay processes running

**Validation:** System is clean

---

## Phase 7: Git Commit

### Task 7.1: Prepare Commit
- [ ] Review all changes: `git status`
- [ ] Review diff: `git diff`
- [ ] Stage all changes: `git add .`

### Task 7.2: Create Commit
- [ ] Write comprehensive commit message
- [ ] Include reference to this change: "Remove relay remote mode (see openspec/changes/remove-relay-mode/)"
- [ ] Commit: `git commit`

**Validation:** Commit created successfully

### Task 7.3: Verification
- [ ] View commit: `git log -1 --stat`
- [ ] Ensure all expected files are changed/deleted
- [ ] Verify commit message is clear

**Validation:** Commit looks good

---

## Progress Tracking

- **Total Tasks:** 61
- **Completed:** 0
- **In Progress:** 0
- **Pending:** 61

### Status by Phase
- Phase 1 (Backend Removal): 0/7 tasks
- Phase 2 (Frontend Cleanup): 0/4 tasks
- Phase 3 (Config and Tests): 0/4 tasks
- Phase 4 (Android Cleanup): 0/3 tasks
- Phase 5 (Documentation): 0/4 tasks
- Phase 6 (Final Validation): 0/5 tasks
- Phase 7 (Git Commit): 0/3 tasks

---

## Notes

### Estimated Time
- Phase 1: 30-45 minutes
- Phase 2: 15-20 minutes
- Phase 3: 10-15 minutes
- Phase 4: 5-10 minutes
- Phase 5: 15-20 minutes
- Phase 6: 20-30 minutes
- Phase 7: 5 minutes

**Total Estimated Time:** 1.5-2.5 hours

### Dependencies
- Phases can be done in parallel by different people if needed
- Phase 6 depends on all previous phases
- Phase 7 depends on Phase 6

### Risk Mitigation
- Each phase has validation steps
- Can stop and rollback after any phase
- Git provides safety net
