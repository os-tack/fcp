# Writing an FCP Server

Guide for building new FCP servers that plug into the marketplace.

## Prerequisites

- [fcp-core](https://github.com/aetherwing-io/fcp-core) (TypeScript: `@aetherwing/fcp-core`, Python: `fcp-core`)
- Familiarity with the FCP grammar: `VERB [positionals...] [key:value params...] [@selectors...]`

## The 4-Tool Contract

Every FCP server exposes exactly 4 MCP tools:

| Tool | Signature | Purpose |
|------|-----------|---------|
| `{domain}(ops)` | `ops: string[]` | Batch mutation operations |
| `{domain}_query(q)` | `q: string` | Read-only state inspection |
| `{domain}_session(action)` | `action: string` | Lifecycle: new, save, undo, redo |
| `{domain}_help()` | — | Self-documenting reference card |

## Architecture Pattern

FCP servers follow a consistent layered architecture:

1. **MCP Server (Intent Layer)** — Parses op strings via fcp-core tokenizer, resolves references, dispatches to verb handlers
2. **Semantic Model (Domain)** — In-memory domain graph with event sourcing for undo/redo
3. **Serialization** — Semantic model to/from target format (XML, HCL, binary, etc.)

## Getting Started

1. Use the `templates/fcp-starter/` scaffold
2. Register your verbs with the fcp-core verb registry
3. Implement a domain adapter (see fcp-core's `FcpAdapter` interface)
4. Wire it up with `createFcpServer()` / `create_fcp_server()`

## Full Specification

See the [FCP spec](https://github.com/aetherwing-io/fcp-core/tree/main/spec) in fcp-core for the complete grammar, tool, session, and event specifications.

## Publishing

1. Add `.claude-plugin/plugin.json` with `mcpServers` and `skills` fields
2. Publish to npm or PyPI
3. Submit a PR to add your server to the [marketplace catalog](./../.claude-plugin/marketplace.json)
