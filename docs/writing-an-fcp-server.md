# Writing an FCP Server

Guide for building new FCP servers that plug into the marketplace.

## Prerequisites

- [fcp-core](https://github.com/os-tack/fcp-core) (TypeScript: `@ostk-ai/fcp-core`, Python: `fcp-core`)
- Familiarity with the FCP grammar: `VERB [positionals...] [key:value params...] [@selectors...]`
- For Go implementations, see [fcp-terraform](https://github.com/os-tack/fcp-terraform) which ports fcp-core internally

## The 4-Tool Contract

Every FCP server exposes exactly 4 MCP tools:

| Tool | Signature | Purpose |
|------|-----------|---------|
| `{domain}(ops)` | `ops: string[]` | Batch mutation operations |
| `{domain}_query(q)` | `q: string` | Read-only state inspection |
| `{domain}_session(action)` | `action: string` | Lifecycle: new, save, undo, redo |
| `{domain}_help()` | — | Self-documenting reference card |

## Architecture Pattern

FCP servers follow a layered architecture. Most formats need 3 layers; spatial/visual formats (like diagrams or slides) may need a 4th layout layer.

**3-layer (most formats):**

1. **MCP Server (Intent Layer)** — Parses op strings via fcp-core tokenizer, resolves references, dispatches to verb handlers
2. **Semantic Model (Domain)** — In-memory domain graph with event sourcing for undo/redo
3. **Serialization** — Semantic model to/from target format (HCL, MIDI binary, YAML, etc.)

**4-layer (spatial/visual formats):**

1. **Intent Layer** — Same as above
2. **Semantic Model** — Entity graph with spatial properties
3. **Layout** — Auto-positioning, collision avoidance, spatial reasoning
4. **Serialization** — To target format (XML, SVG, etc.)

The layer count reflects the domain: fcp-terraform and fcp-midi use 3 layers because HCL is text and MIDI is a time sequence. fcp-drawio uses 4 because spatial layout is a separate concern from the semantic model.

## Getting Started

1. Use the `templates/fcp-starter/` scaffold (TypeScript/Python)
2. Register your verbs with the fcp-core verb registry
3. Implement a domain adapter (see fcp-drawio's adapter.ts for a real-world example)
4. Wire it up with `createFcpServer()` / `create_fcp_server()`

## Python: Suppressing Structured Output

Python FCP servers built with `create_fcp_server()` handle this automatically. If you register tools directly on FastMCP (bypassing fcp-core), add `structured_output=False` to every `@mcp.tool()` decorator:

```python
@mcp.tool(name=f"{domain}_help", structured_output=False)
def get_help() -> str:
    return reference_card
```

Without this, FastMCP wraps return values in a `{"result":"..."}` JSON envelope as `structuredContent`, which differs from the raw text response that TypeScript MCP servers produce. The `structured_output=False` flag suppresses this envelope for consistent behavior across all FCP servers.

## Plugin Configuration

FCP servers are distributed as Claude Code plugins. Each server needs:

- **`.claude-plugin/plugin.json`** — Metadata only (name, version, description, author)
- **`.mcp.json`** — MCP server config using `${CLAUDE_PLUGIN_ROOT}` for paths

See the [Marketplace Guide](./marketplace-guide.md) for the exact schemas.

## Full Specification

See the [FCP spec](https://github.com/os-tack/fcp-core/tree/main/spec) in fcp-core for the complete grammar, tool, session, and event specifications.

## Publishing

1. Add `.claude-plugin/plugin.json` (metadata) and `.mcp.json` (server config)
2. Publish to npm, PyPI, or GitHub Releases (Go binaries)
3. Submit a PR to add your server to the [marketplace catalog](./../.claude-plugin/marketplace.json)
