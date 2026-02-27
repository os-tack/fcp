# File Context Protocol (FCP)

MCP servers that let LLMs interact with complex file formats through a verb-based DSL.

FCP is to MCP what React is to the DOM — the LLM thinks in domain operations, FCP renders them into the target format.

## Servers

| Server | Install | Domain | Description |
|--------|---------|--------|-------------|
| [fcp-drawio](https://github.com/aetherwing-io/fcp-drawio) | `npm i @aetherwing/fcp-drawio` | Diagrams | Create and edit draw.io diagrams through intent-level commands |
| [fcp-midi](https://github.com/aetherwing-io/fcp-midi) | `pip install fcp-midi` | Music | Compose MIDI music through semantic operations |
| [fcp-terraform](https://github.com/aetherwing-io/fcp-terraform) | `npm i @aetherwing/fcp-terraform` | Infrastructure | Generate Terraform HCL through resource declarations |

## How It Works

Every FCP server exposes exactly 4 MCP tools:

| Tool | Purpose |
|------|---------|
| `{domain}(ops)` | Batch mutation operations |
| `{domain}_query(q)` | Read-only state inspection |
| `{domain}_session(action)` | Lifecycle management (new, save, undo, redo) |
| `{domain}_help()` | Self-documenting reference card |

Operations follow a common grammar: `VERB [positionals...] [key:value params...] [@selectors...]`

```
# Diagrams
add svc AuthService theme:blue
connect AuthService -> UserDB label:queries

# Music
note Piano C4 at:1.1 dur:quarter vel:mf
chord Strings Am at:2.1 dur:whole

# Infrastructure
resource aws_instance web ami:"ami-0c55b159" instance_type:t2.micro
output instance_ip value:"aws_instance.web.public_ip"
```

## Shared Framework

All servers are built on [fcp-core](https://github.com/aetherwing-io/fcp-core), which provides the tokenizer, verb registry, event log (undo/redo), session management, and server factory. Available in both TypeScript and Python.

## Installation

Each server is installed independently. See individual repos for setup instructions.

## License

MIT
