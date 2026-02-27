# fcp-starter

Scaffold for building a new FCP server.

## Structure

```
fcp-starter/
├── .claude-plugin/
│   └── plugin.json          ← Marketplace metadata + MCP config
├── src/
│   ├── model/               ← Semantic domain model
│   ├── parser/              ← Op string parsing (via fcp-core tokenizer)
│   ├── serialization/       ← Domain model → target format
│   └── server/
│       ├── index.ts          ← Entry point, createFcpServer()
│       ├── adapter.ts        ← FcpAdapter implementation
│       ├── verb-registry.ts  ← Verb definitions
│       └── reference-card.ts ← Help text generator
├── tests/
├── package.json
└── tsconfig.json
```

## Quick Start

1. Copy this template
2. Rename `fcp-starter` to `fcp-yourdomain`
3. Implement your `FcpAdapter` (see fcp-core docs)
4. Register verbs for your domain operations
5. Implement serialization to your target format

See [Writing an FCP Server](../../docs/writing-an-fcp-server.md) for the full guide.
