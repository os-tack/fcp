# Marketplace Guide

How to list a new FCP server in the marketplace.

## Requirements

Your server must:

1. **Implement the 4-tool contract** — `{domain}`, `{domain}_query`, `{domain}_session`, `{domain}_help`
2. **Depend on fcp-core** — Use the shared tokenizer, verb registry, and session management
3. **Include `.claude-plugin/plugin.json`** — Plugin metadata
4. **Include `.mcp.json`** — MCP server configuration for zero-config installation

## Plugin Structure

Every FCP server plugin has this structure:

```
fcp-yourserver/
├── .claude-plugin/
│   └── plugin.json       ← Plugin metadata only
├── .mcp.json             ← MCP server config (separate from plugin.json)
├── src/                  ← Your server code
├── dist/                 ← Built output
└── ...
```

## plugin.json

Metadata only — no component configuration. Use kebab-case names without npm scopes.

```json
{
  "name": "fcp-yourserver",
  "description": "One-line description of what it does",
  "version": "0.1.0",
  "license": "MIT",
  "author": {
    "name": "Your Name"
  },
  "repository": "https://github.com/org/fcp-yourserver",
  "keywords": ["relevant", "keywords", "mcp"]
}
```

## .mcp.json

MCP server configuration at the plugin root. Use `${CLAUDE_PLUGIN_ROOT}` for paths.

**TypeScript servers:**

```json
{
  "mcpServers": {
    "fcp-yourserver": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/dist/index.js"]
    }
  }
}
```

**Python servers:**

```json
{
  "mcpServers": {
    "fcp-yourserver": {
      "command": "uv",
      "args": ["run", "python", "-m", "your_module"],
      "cwd": "${CLAUDE_PLUGIN_ROOT}"
    }
  }
}
```

## Marketplace Entry

Add an entry to `.claude-plugin/marketplace.json`. Plugin names are kebab-case identifiers (not npm/PyPI package names).

```json
{
  "name": "fcp-yourserver",
  "source": { "source": "github", "repo": "org/fcp-yourserver" },
  "description": "One-line description",
  "version": "0.1.0",
  "license": "MIT",
  "category": "development",
  "keywords": ["relevant", "keywords"]
}
```

## Categories

| Category | For | Examples |
|----------|-----|---------|
| development | Dev tooling formats | fcp-drawio, fcp-openapi, fcp-uml |
| devops | Infrastructure formats | fcp-terraform, fcp-containers |
| creative | Media/art formats | fcp-midi, fcp-svg |
| documents | Office/document formats | fcp-sheets, fcp-slides, fcp-pdf |

## Submission

1. Fork [aetherwing-io/fcp](https://github.com/aetherwing-io/fcp)
2. Add your entry to `.claude-plugin/marketplace.json`
3. Open a PR with a link to your server's repository
