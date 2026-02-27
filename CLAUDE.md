# FCP — File Context Protocol

An application framework for building MCP servers that let LLMs interact with complex file formats through a verb-based DSL. FCP is to MCP what React is to the DOM — the LLM thinks in domain operations, FCP renders them into the target format.

## Architecture

Every FCP server exposes exactly 4 MCP tools: `{domain}` (batch mutations), `{domain}_query` (read-only inspection), `{domain}_session` (lifecycle), `{domain}_help` (reference card). The core grammar is `VERB [positionals...] [key:value params...] [@selectors...]`.

See `fcp-core/spec/` for the full specification (grammar, tools, session, events, conformance).

## Projects

### fcp-core (`fcp-core/`)
Shared framework — dual implementation in TypeScript and Python.

Provides: tokenizer, parsed-op, verb registry, event log (undo/redo), session dispatcher, formatter, and `createFcpServer`/`create_fcp_server` server factory.

- **TypeScript:** `fcp-core/typescript/` — `npm test` (vitest, 107 tests)
- **Python:** `fcp-core/python/` — `uv run pytest` (112 tests)

### fcp-drawio (`fcp-drawio/`)
MCP server for creating/editing draw.io diagrams. TypeScript, depends on `@aetherwing/fcp-core`.

4-layer architecture: MCP server (intent layer) → semantic model (entity graph, event sourcing) → layout (ELK) → serialization (XML). Includes component library, themes, stencils, and snapshot rendering via draw.io CLI.

- **Build:** `npm run build`
- **Test:** `npm test` (vitest, 465 tests)
- **CLAUDE.md:** `fcp-drawio/CLAUDE.md` has detailed architecture notes

### fcp-midi (`fcp-midi/`)
MCP server for semantic MIDI composition. Python, depends on `fcp-core`.

Semantic model with tracks/notes/chords → serialization via pretty-midi → MIDI binary output. Includes instrument libraries, soundfont support, and stress tests.

- **Test:** `uv run pytest` (658 tests)

### fcp-terraform (`fcp-terraform/`)
MCP server for Terraform HCL generation. TypeScript, depends on `@aetherwing/fcp-core`.

Semantic model for Terraform resources/data/variables/outputs → HCL serialization. Includes ops parser, query engine, and integration tests.

- **Build:** `npm run build`
- **Test:** `npm test` (vitest, 164 tests)

## Dependencies

All consumer repos reference fcp-core via **published npm/PyPI versions** (e.g. `"@aetherwing/fcp-core": "^0.1.0"`). Never use `file:` references in package.json — they break CI and anyone cloning the repo. For local cross-repo development, use `make link` (see below).

## Local Development

Each repo has its own git repository and publishes independently via git tags.

```bash
# First time setup — installs deps, creates npm links, configures git hooks
make setup

# Link local fcp-core into consumer repos (uses npm link, not file: references)
make link

# After any `npm install`, re-run make link (npm install undoes links)
make link

# Remove links, restore registry versions
make unlink

# Python: editable install of fcp-core for fcp-midi
make link-py
```

**Publishing order**: fcp-core first, then consumers. Tag with `vX.Y.Z` → CI publishes automatically.

## Staging

`test/` is the staging area for cross-project experiments and scratch work.

## Commands (all projects)

| Project | Test | Build |
|---------|------|-------|
| fcp-core (TS) | `cd fcp-core/typescript && npm test` | `npm run build` |
| fcp-core (Py) | `cd fcp-core/python && uv run pytest` | — |
| fcp-drawio | `cd fcp-drawio && npm test` | `npm run build` |
| fcp-midi | `cd fcp-midi && uv run pytest` | — |
| fcp-terraform | `cd fcp-terraform && npm test` | `npm run build` |

Or use the root Makefile: `make test`, `make build`, `make test-core-ts`, etc. Run `make help` for all targets.
