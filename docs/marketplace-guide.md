# Marketplace Guide

How to list a new FCP server in the marketplace.

## Requirements

Your server must:

1. **Implement the 4-tool contract** — `{domain}`, `{domain}_query`, `{domain}_session`, `{domain}_help`
2. **Depend on fcp-core** — Use the shared tokenizer, verb registry, and session management
3. **Include `.claude-plugin/plugin.json`** — With `mcpServers` config for zero-config installation

## plugin.json Schema

```json
{
  "name": "@scope/fcp-yourserver",
  "description": "One-line description of what it does",
  "version": "0.1.0",
  "license": "MIT",
  "author": "Your Name",
  "repository": "https://github.com/org/fcp-yourserver",
  "keywords": ["relevant", "keywords", "mcp"],
  "mcpServers": {
    "fcp-yourserver": {
      "command": "node",
      "args": ["node_modules/@scope/fcp-yourserver/dist/index.js"]
    }
  },
  "skills": [
    {
      "id": "yourserver",
      "name": "Human-Readable Name",
      "description": "What this server lets you do"
    }
  ]
}
```

For Python servers, use `"command": "python"` with `"args": ["-m", "your_module.main"]`.

## Marketplace Entry

Add an entry to `.claude-plugin/marketplace.json`:

```json
{
  "name": "@scope/fcp-yourserver",
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
