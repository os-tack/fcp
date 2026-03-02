---
name: setup
description: Check and install FCP plugin dependencies (uv, fcp-terraform, node)
user_invocable: true
---

# FCP Setup

Check for required FCP dependencies and install any that are missing.

## Steps

1. **Check dependencies** — run each check and collect results:

   | Dependency | Check command | Needed for |
   |-----------|--------------|------------|
   | `node` | `node --version` | drawio |
   | `uv` | `uv --version` | midi, sheets, slides |
   | `fcp-terraform` | `fcp-terraform --version` | terraform |

2. **Report status** — show a table of what's installed and what's missing. If everything is present, say so and stop.

3. **Install missing dependencies** — for each missing dependency, offer to install it:

   - **uv**: `curl -LsSf https://astral.sh/uv/install.sh | sh`
   - **fcp-terraform**: `curl -LsSf https://github.com/aetherwing-io/fcp-terraform/releases/latest/download/install.sh | sh`
   - **node**: Direct user to https://nodejs.org/ (cannot auto-install)

   Ask the user which missing dependencies they want to install. Install the selected ones.

4. **Verify MCP servers** — for each newly installed dependency, verify the MCP server can start:

   - drawio: `npx -y @aetherwing/fcp-drawio --help` (or similar smoke test)
   - midi: `uvx --refresh-package fcp-midi --python 3.13 fcp-midi --help`
   - sheets: `uvx --refresh-package fcp-sheets --python 3.13 fcp-sheets --help`
   - terraform: `fcp-terraform --help`

5. **Summary** — report final status of all dependencies.
