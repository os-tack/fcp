# File Context Protocol (FCP)

MCP servers that let LLMs interact with complex file formats through a verb-based DSL.

FCP is to MCP what React is to the DOM — the LLM thinks in domain operations, FCP renders them into the target format.

## Installation

FCP is a Claude Code marketplace plugin. Add it to your `settings.json`:

```json
{
  "marketplace_plugins": {
    "fcp@os-tack/fcp": true
  }
}
```

This installs all FCP servers automatically. Prerequisites by server:

| Server | Requires |
|--------|----------|
| fcp-drawio | Node.js |
| fcp-midi | Python 3.13+ |
| fcp-terraform | Go |
| fcp-rust | rust-analyzer |
| fcp-sheets | Python 3.13+ |
| fcp-slides | Python 3.13+ |

### Manual Installation (non-Claude Code)

Each server can be installed and configured independently. Add to your MCP client config:

```json
{
  "mcpServers": {
    "fcp-drawio": {
      "command": "npx",
      "args": ["-y", "@ostk-ai/fcp-drawio"]
    },
    "fcp-terraform": {
      "command": "fcp-terraform"
    }
  }
}
```

See each server's README for full installation instructions:
[fcp-drawio](https://github.com/os-tack/fcp-drawio) · [fcp-midi](https://github.com/os-tack/fcp-midi) · [fcp-terraform](https://github.com/os-tack/fcp-terraform) · [fcp-rust](https://github.com/os-tack/fcp-rust) · [fcp-sheets](https://github.com/os-tack/fcp-sheets) · [fcp-slides](https://github.com/os-tack/fcp-slides)

## Quick Start

Here's a complete workflow — create a diagram from scratch, inspect it, and save:

```
> drawio_session("new \"Auth Flow\"")

! session "Auth Flow" created
[0s 0e 0g p:1/1]
```

```
> drawio(["add svc AuthService theme:blue", "add db UserDB theme:green", "connect AuthService -> UserDB label:\"queries\" style:dashed"])

+ svc AuthService @(0,0 140x60) blue
+ db UserDB @(200,0 120x80) green
~ AuthService -> UserDB "queries" dashed
[2s 1e 0g 320x80 p:1/1]
```

```
> drawio_query("status")

status: "Auth Flow" (unsaved, 4 ops, 0 checkpoints)
  page: Page 1 (2 shapes, 1 edge, 0 groups)
```

```
> drawio_session("save as:./auth-flow.drawio")

! saved ./auth-flow.drawio
[2s 1e 0g 320x80 p:1/1]
```

Every FCP server follows this same pattern: `session` → `mutations` → `query` → `save`.

## Servers

| Server | Format | Description |
|--------|--------|-------------|
| [fcp-drawio](https://github.com/os-tack/fcp-drawio) | draw.io diagrams | Architecture diagrams, flowcharts, ERDs |
| [fcp-midi](https://github.com/os-tack/fcp-midi) | MIDI music | Notes, chords, tracks, instruments |
| [fcp-terraform](https://github.com/os-tack/fcp-terraform) | Terraform HCL | AWS/GCP/Azure infrastructure |
| [fcp-rust](https://github.com/os-tack/fcp-rust) | Rust codebases | Navigation, inspection, refactoring via rust-analyzer |
| [fcp-sheets](https://github.com/os-tack/fcp-sheets) | Excel spreadsheets | Tables, formulas, charts, formatting |
| [fcp-slides](https://github.com/os-tack/fcp-slides) | PowerPoint presentations | Slides, shapes, tables, charts, layouts |

## What the LLM Sees

Every mutation returns a prefixed response and a digest line summarizing the current state. This gives the LLM structured feedback without reading the whole file:

| Prefix | Meaning |
|--------|---------|
| `+` | Created |
| `~` | Modified / connected |
| `*` | Style / metadata changed |
| `-` | Removed |
| `!` | Meta operation |
| `@` | Bulk / layout |

### Examples

**Diagrams** — shapes, edges, and a bounding-box digest:

```
> drawio(["add svc API theme:blue", "connect API -> DB"])

+ svc API @(0,0 140x60) blue
~ API -> DB
[2s 1e 0g 320x80 p:1/1]
```

**Music** — notes, chords, and a song-state digest:

```
> midi(["note Piano C4 at:1.1 dur:quarter vel:mf", "chord Strings Am at:2.1 dur:whole"])

+ note C4 at:1.1 dur:quarter vel:mf
+ chord Am at:2.1 dur:whole
[1t 4e tempo:120 4/4 2bars]
```

**Infrastructure** — resources, variables, and a block-count digest:

```
> terraform(["add resource aws_instance web ami:\"ami-0c55b159\" instance_type:t2.micro", "add variable region default:\"us-east-1\""])

+ resource aws_instance.web ami:"ami-0c55b159" instance_type:t2.micro
+ variable region default:"us-east-1"
2 blocks, 1 resource, 1 variable
```

**Rust** — symbol navigation, diagnostics, and refactoring:

```
> rust_session("open /path/to/my-project")

! session opened: /path/to/my-project (42 .rs files)
```

```
> rust_query("find Config @kind:struct")

Config (struct) src/config.rs:12
  fields: name, port, database_url
```

```
> rust(["rename old_handler handle_request @file:routes.rs"])

~ renamed old_handler → handle_request (3 references updated)
```

**Spreadsheets** — data blocks and a sheet-state digest:

```
> sheets(["data A1", "Name,Age,City", "Alice,30,NYC", "Bob,25,LA", "data end"])

+ Wrote 3 rows at A1
1 sheets, ~6 cells
```

**Presentations** — slides, shapes, and a deck-state digest:

```
> slides(["slide add layout:title", "placeholder set title \"Q4 Review\"", "placeholder set subtitle \"Finance Team\""])

+ slide 1 (Title Slide)
~ placeholder title = "Q4 Review"
~ placeholder subtitle = "Finance Team"
[1 slide 3 shapes]
```

## How It Works

Every FCP server exposes exactly 4 MCP tools:

| Tool | Purpose |
|------|---------|
| `{domain}(ops)` | Batch mutation operations |
| `{domain}_query(q)` | Read-only state inspection |
| `{domain}_session(action)` | Lifecycle: new, open, save, undo, redo |
| `{domain}_help()` | Self-documenting reference card |

Most servers are built on [fcp-core](https://github.com/os-tack/fcp-core) (TypeScript + Python). fcp-terraform (Go) and fcp-rust (Rust) are standalone implementations.

## Links

- [Building an FCP server](docs/writing-an-fcp-server.md)
- [Marketplace guide](docs/marketplace-guide.md)
- [FCP specification](https://github.com/os-tack/fcp-core/tree/main/spec)

## License

MIT
