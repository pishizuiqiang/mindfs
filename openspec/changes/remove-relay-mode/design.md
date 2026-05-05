# Design: Remove Relay Remote Mode

## Architecture Changes

### Before Removal

```
┌─────────────────────────────────────────────────────────┐
│                    Current Architecture                  │
└─────────────────────────────────────────────────────────┘

Client
  │
  ├──> Local: http://localhost:7331
  ├──> LAN:   http://192.168.1.x:7331
  └──> Relay: https://a9gent.com/n/{node_id}/
                  │
                  ▼
         ┌─────────────────┐
         │  a9gent.com     │
         │  Relay Service  │
         └─────────────────┘
                  │
                  ▼ (WebSocket multiplexing)
         ┌─────────────────┐
         │  Local MindFS   │
         │  :7331          │
         └─────────────────┘

Backend Components:
├── relay/ package (7 files)
├── app/server.go (relay integration)
├── api/appcontext.go (Relay/RelayTips fields)
├── api/http.go (/api/relay/* endpoints)
└── CLI (--no-relayer flag)
```

### After Removal

```
┌─────────────────────────────────────────────────────────┐
│                    New Architecture                     │
└─────────────────────────────────────────────────────────┘

Client
  │
  ├──> Local: http://localhost:7331
  ├──> LAN:   http://192.168.1.x:7331
  └──> External: [User's Solution] ──> MindFS
                  (Tailscale/VPN/etc.)

Backend Components:
├── [relay package removed]
├── app/server.go (clean, no relay)
├── api/appcontext.go (no Relay fields)
├── api/http.go (no /api/relay/* endpoints)
└── CLI (no --no-relayer flag)
```

## Component Changes

### Backend Changes

#### 1. Delete `server/internal/relay/` Package
```
Files to delete:
├── service.go       (Core relay service, WebSocket multiplexing)
├── manager.go       (Status management, binding, polling)
├── credentials.go   (Credential storage)
├── device.go        (Device ID management)
├── tips.go          (Tips service from relay server)
├── wsconn.go        (WebSocket connection wrapper)
└── service_test.go  (Tests)
```

#### 2. Modify `server/app/server.go`

**Before:**
```go
import (
    "mindfs/server/internal/relay"
    // ...
)

type StartOptions struct {
    NoRelayer    bool
    RelayBaseURL string
    // ...
}

func Start(ctx context.Context, addr string, opts StartOptions) error {
    // ...
    relayMgr, err := relay.NewManager(addr, opts.NoRelayer, relayBaseURL, opts.UseTLS)
    if err != nil {
        return err
    }
    services.Relay = relayMgr
    services.RelayTips = relay.NewTipsService(relayMgr)
    if err := relayMgr.Start(ctx); err != nil {
        return err
    }
    services.RelayTips.Start(ctx)
    // ...
}
```

**After:**
```go
import (
    // "mindfs/server/internal/relay" REMOVED
    // ...
)

type StartOptions struct {
    // NoRelayer    bool REMOVED
    // RelayBaseURL string REMOVED
    // ...
}

func Start(ctx context.Context, addr string, opts StartOptions) error {
    // ...
    // relay initialization REMOVED
    // ...
}
```

#### 3. Modify `server/internal/api/appcontext.go`

**Before:**
```go
import (
    "mindfs/server/internal/relay"
    // ...
)

type AppContext struct {
    Dirs      *fs.Registry
    Agents    *agent.Pool
    Relay     *relay.Manager         // REMOVE
    RelayTips *relay.TipsService      // REMOVE
    // ...
}
```

**After:**
```go
import (
    // "mindfs/server/internal/relay" REMOVED
    // ...
)

type AppContext struct {
    Dirs      *fs.Registry
    Agents    *agent.Pool
    // Relay     *relay.Manager      REMOVED
    // RelayTips *relay.TipsService   REMOVED
    // ...
}
```

#### 4. Modify `server/internal/api/http.go`

**Routes to remove:**
```go
r.Get("/api/relay/status", h.handleRelayStatus)  // REMOVE
r.Get("/api/relay/tips", h.handleRelayTips)      // REMOVE
```

**Handlers to remove:**
```go
func (h *HTTPHandler) handleRelayStatus(w http.ResponseWriter, r *http.Request) // REMOVE
func (h *HTTPHandler) handleRelayTips(w http.ResponseWriter, r *http.Request)    // REMOVE
```

#### 5. Modify `cli/cmd/mindfs.go`

**Flag to remove:**
```go
noRelayer := flag.Bool("no-relayer", false, "disable relay integration") // REMOVE
```

**Options to remove:**
```go
app.Start(ctx, *addr, app.StartOptions{
    NoRelayer:  *noRelayer,  // REMOVE
    // ...
})
```

#### 6. Modify `server/cmd/mindfs-server/main.go`

Similar changes as `cli/cmd/mindfs.go`.

### Frontend Changes

#### 1. Modify `web/src/App.tsx`

**Remove:**
- `RelayStatusPayload` type
- `relayStatus` state
- `refreshRelayStatus` function
- `handleRelayAction` function
- `redirectToRelayLogin` function
- `redirectToRelayNodes` function
- `handleRelayNavigationFailure` function
- All relay-related `useEffect` hooks

#### 2. Modify `web/src/components/Login.tsx`

**Remove:**
- `consumePendingRelayNodes` import and usage
- `RELAY_URL` constant
- Relay-related UI elements (if any standalone)

**Note:** The Login component can remain for manual node entry (useful for user's external access)

#### 3. Delete `web/src/services/launcherNodeSync.ts`

**Reason:** This service is specifically designed for Relay node sync and is no longer needed.

### Android Changes

#### 1. Modify `android/app/src/main/java/com/mindfs/app/MainActivity.java`

**Remove:**
```java
registerPlugin(LauncherNodeSyncPlugin.class);  // REMOVE
getBridge().getWebView().addJavascriptInterface(
    new LauncherNodeSyncBridge(),
    "MindFSLauncherNodeSync"
);  // REMOVE
```

**Remove inner class:**
```java
private class LauncherNodeSyncBridge {
    @JavascriptInterface
    public void storeRelayNodes(String rawJSON) {
        LauncherNodeSyncPlugin.storeRelayNodesJSON(MainActivity.this, rawJSON);
    }
}  // REMOVE
```

#### 2. Delete `android/app/src/main/java/com/mindfs/app/LauncherNodeSyncPlugin.java`

**Reason:** No longer needed without Relay.

### Configuration Changes

#### 1. Modify `agents.json`

**Before:**
```json
{
  "relayBaseURL": "https://relay.a9gent.com",
  "agents": [...]
}
```

**After:**
```json
{
  "agents": [...]
}
```

#### 2. Modify `server/internal/agent/config.go`

**Remove field:**
```go
type Config struct {
    Agents       []Definition `json:"agents"`
    RelayBaseURL string       `json:"relayBaseURL,omitempty"`  // REMOVE
}
```

**Remove usage:**
```go
cfg.RelayBaseURL = strings.TrimSpace(cfg.RelayBaseURL)  // REMOVE
```

### Test Changes

#### 1. Modify `server/internal/agent/pool_test.go`

**Remove test:**
```go
func TestLoadConfigReadsRelayBaseURL(t *testing.T) {
    // ... entire test REMOVE
}
```

#### 2. Modify `server/internal/agent/testdata/agents.json`

**Remove field:**
```json
{
  "relayBaseURL": "https://relay.example.com",  // REMOVE
  "agents": [...]
}
```

#### 3. Delete `server/internal/relay/service_test.go`

**Reason:** Entire relay package is being removed.

### Documentation Changes

#### 1. Modify `README.md`

**Remove sections:**
- "Relay remote mode" from "Access Modes"
- "-no-relayer" from "Flags" documentation
- Any a9gent.com links or references

**Update:**
- Remove relay-related setup instructions

#### 2. Modify `README.zh.md`

**Remove sections:**
- "Relay 远程模式" from "访问模式"
- "-no-relayer" from "Flags" 文档
- "通过 relayer远程访问" section

**Update:**
- Remove relay-related setup instructions

#### 3. Modify `CLAUDE.md`

**Update:**
- Remove "relay service" from backend components description
- Update architecture overview

## Data Migration

### No Migration Needed

- Relay credentials stored in `~/.config/mindfs/relay_credentials.json` can be left as-is
- They won't be read or used after removal
- Users can manually delete if desired

### localStorage Cleanup

Frontend will no longer write:
- `pending_relay_nodes`
- Relay-related data in `launcher_nodes`

Existing data will be ignored, not an issue.

## Testing Strategy

### Unit Tests
- Remove relay-specific tests
- Ensure remaining tests pass

### Integration Tests
- Test local access: `localhost:7331`
- Test LAN access: `http://192.168.1.x:7331`
- Test Android App (with user's external access)

### Manual Testing Checklist
- [ ] Server starts without `--no-relayer` flag
- [ ] Server serves web UI
- [ ] Can create agent sessions
- [ ] Can browse files
- [ ] Can use plugins
- [ ] Android App can connect via user's external access
- [ ] No relay-related errors in logs
- [ ] No `/api/relay/*` endpoints available

## Rollback Plan

If issues arise:
1. Use `git revert` to undo commits
2. Or restore from git ref before removal

**Risk:** Low - changes are localized and well-defined.

## Performance Impact

### Expected Improvements
- **Reduced memory**: Fewer goroutines (no polling, no relay connection)
- **Reduced network**: No WebSocket to a9gent.com
- **Faster startup**: No relay manager initialization
- **Cleaner logs**: No relay connection logs

### Metrics
- Before: ~3-5 MB memory for relay service + 1 WebSocket + polling goroutines
- After: 0 MB + 0 connections + 0 goroutines

## Security Impact

### Improvements
- **Reduced attack surface**: No external relay dependency
- **No third-party trust**: Not relying on a9gent.com
- **No intermediate hops**: Direct connection only

### Considerations
- User's external access solution (Tailscale/VPN) security is now the primary consideration
- Ensure user's external access is properly secured

## Dependencies

### Removed Dependencies
No external package dependencies removed (relay used only stdlib and common packages like `gorilla/websocket` and `hashicorp/yamux` which may still be used elsewhere).

### Updated Dependencies
None

## Compatibility

### Breaking Changes
- **API**: `/api/relay/status` and `/api/relay/tips` endpoints removed
- **CLI**: `--no-relayer` flag removed (becomes default behavior)
- **Config**: `relayBaseURL` field in `agents.json` ignored
- **Android**: `LauncherNodeSyncPlugin` removed

### Migration Guide
None needed - user already has alternative access method.

## Future Considerations

### If Relay is Needed Later
- Could restore from git history
- Or re-implement as optional plugin
- Current architecture doesn't preclude future re-addition

### Alternative Approaches
- User's external access (Tailscale, VPN) is recommended path
- Self-hosted relay could be added if needed (outside scope of this change)
