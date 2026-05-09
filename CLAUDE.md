# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MindFS is an AI Agent Remote Access Gateway with result visualization. It provides a web interface to interact with multiple AI agent CLIs (Claude Code, OpenAI Codex, Gemini CLI, Cursor, GitHub Copilot, Cline, Augment, Kimi, Kiro, Qwen, Qoder, Pi, OpenCode, OpenClaw) through a unified browser-based UI. The application supports real-time streaming, file access, plugin system, and multi-device sync.

## Architecture

MindFS is a full-stack application with:
- **Backend**: Go server (`server/`) providing HTTP/WebSocket API, agent pool management, session storage, file system access
- **Frontend**: React TypeScript SPA (`web/`) with Vite build system, PWA support, and real-time WebSocket streaming
- **CLI Entry**: Go CLI (`cli/`) that manages projects and starts the server
- **Android App**: Capacitor-based Android app (`android/`) that embeds the web frontend

### Key Backend Components

- `server/app/server.go` - Main HTTP/WebSocket server that wires all services together
- `server/internal/agent/` - Agent pool management, protocol implementations (ACP, Claude, Codex), and session routing
- `server/internal/session/` - Session storage and search using SQLite
- `server/internal/api/` - HTTP/WebSocket handlers and use cases
- `server/internal/fs/` - File system registry and shared watchers for project directories
- `server/internal/e2ee/` - End-to-end encryption support
- `agents.json` - Agent configuration (name, command, args) for all supported agents

### Key Frontend Components

- `web/src/App.tsx` - Main application with routing and state management
- `web/src/components/SessionViewer.tsx` - Core session interaction UI
- `web/src/components/FileTree.tsx` - File browser with association tracking
- `web/src/plugins/manager.ts` - Plugin system that allows agents to generate custom file viewers
- `web/src/services/` - API client services for backend communication
- `web/src/renderer/` - Component catalog for plugin-generated UIs

## Development Commands

### Running Development Servers

```bash
# Run backend only (serves built frontend from web/dist/)
make dev-backend

# Run frontend dev server only (Vite HMR with API proxy to localhost:7331)
make dev-web

# Run full stack (Go CLI serves project directory)
make dev          # or: go run ./cli/cmd

# Run full stack with custom address
ADDR=:9000 make dev
```

### Starting MindFS Server

```bash
# Start with compiled binary
./mindfs

# Start on specific interface
./mindfs -addr 192.168.10.103:7331  # LAN only
./mindfs -addr 0.0.0.0:7331         # All interfaces (use with caution)

# Start with specific root directory
./mindfs -addr 192.168.10.103:7331 /path/to/project

# Check if mindfs is running
lsof -i :7331 | grep LISTEN
ps aux | grep mindfs | grep -v grep
```

**Security Note**: 
- Default `127.0.0.1:7331` only allows local access
- Use specific LAN IP (e.g., `192.168.10.103:7331`) for local network access only
- Avoid `0.0.0.0:7331` unless you need external access and have proper firewall rules
- Check for public IP exposure: `curl -s ifconfig.me`

### Building

```bash
# Build web assets only
make build-web    # or: cd web && npm run build

# Build CLI binary with embedded web assets
make build        # output: ./mindfs

# Build Android APK
make build-android  # output: dist/mindfs_<version>_android.apk

# Cross-compile for all platforms
make build-all    # output: dist/*.tar.gz, dist/*.zip
```

### Testing

```bash
# Run Go tests
make test         # or: go test ./...

# TypeScript type checking
cd web && npm run typecheck
```

### Installation

```bash
# Install to ~/.local/bin and ~/.local/share/mindfs
make install

# Uninstall
make uninstall
```

### Release

```bash
# Create and push git tag
make tag TAG=v1.2.3

# Build all platforms and create GitHub release
make release TAG=v1.2.3  # requires release-notes/v1.2.3.md
```

## Plugin System

Plugins allow agents to generate custom file viewers dynamically. The flow:

1. Agent receives a request to "implement a X viewer"
2. Agent generates plugin code (TypeScript) that implements `ViewPlugin` interface
3. Plugin code is stored and loaded dynamically in the browser
4. Plugin defines `match` rules (file extension, path pattern, MIME type) and a `process` function
5. When a file matches, the plugin's `process` function receives file content and returns a UI tree
6. UI tree is rendered using components from `web/src/renderer/registry.tsx`

Plugin catalog: `web/src/renderer/catalog.ts`
Plugin manager: `web/src/plugins/manager.ts`

## Agent Integration

Agents are integrated through protocol adapters in `server/internal/agent/`:
- **ACP Protocol**: Used by Cursor, Cline, GitHub Copilot, Augment, Kiro, OpenCode, OpenClaw, Qwen, Qoder, Kimi, Pi (`acp/`)
- **Claude Protocol**: Native Claude Code CLI (`claude/`)
- **Codex Protocol**: OpenAI Codex CLI (`codex/`)

The agent pool (`pool.go`) manages session creation and routing based on agent name and protocol. Each agent session wraps a subprocess (agent CLI) and communicates via stdin/stdout or WebSocket.

## Session Management

Sessions are stored in SQLite databases under `.mindfs/` in each project directory. The session manager (`server/internal/session/`) handles:
- Session CRUD operations
- Full-text search across session titles and content
- Association tracking between sessions and files
- External session import from agent CLIs

## File System

The file system registry (`server/internal/fs/registry.go`) manages multiple project directories simultaneously. Each managed directory gets a `.mindfs/` subdirectory containing:
- Session database
- File metadata
- View configuration

File associations track bidirectional links between sessions and files (which sessions created/modified which files).

## WebSocket Streaming

The backend uses WebSocket for real-time bidirectional streaming:
- Agent output tokens are streamed to the frontend as structured events
- Tool calls, thought traces, and permission prompts are rendered as collapsible cards
- Frontend sends user messages and command inputs via WebSocket

Stream hub: `server/internal/api/stream_hub.go`

## Web Frontend Architecture

The React app uses:
- **State Management**: Local component state with React hooks (no global state library)
- **Routing**: Hash-based routing via `window.location.hash`
- **Real-time Updates**: WebSocket connection with message handlers in `web/src/main.tsx`
- **Build**: Vite with React plugin, TailwindCSS v4, TypeScript
- **PWA**: Service worker for offline support (auto-generated during build)

## Key File Locations

- `cli/cmd/mindfs.go` - CLI entry point for managing projects
- `server/cmd/mindfs-server/main.go` - Standalone server entry point
- `server/app/server.go` - Server initialization and service wiring
- `server/internal/agent/pool.go` - Agent session management
- `server/internal/api/usecase/session.go` - Session API use cases
- `web/src/App.tsx` - Main React application
- `web/src/components/SessionViewer.tsx` - Session interaction UI
- `web/src/services/session.ts` - Session API client
- `agents.json` - Agent definitions (install commands and protocols)

## Environment Variables

- `MINDFS_STATIC_DIR` - Override static assets directory (default: embedded or ./web/dist)
- `MINDFS_DAEMON` - Used internally for daemon mode
- `MINDFS_INTERNAL_RESTART` - Used internally for restart detection

## Testing Strategy

- Go tests focus on agent pool management, file system operations, and API use cases
- Frontend uses TypeScript type checking instead of unit tests
- Manual testing via browser against local agent CLIs
