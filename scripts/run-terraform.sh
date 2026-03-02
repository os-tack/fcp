#!/bin/bash
# Wrapper for fcp-terraform — provides install instructions if binary is missing.
if command -v fcp-terraform &>/dev/null; then
  exec fcp-terraform "$@"
else
  echo "fcp-terraform not found. Install:" >&2
  echo "  curl -LsSf https://github.com/aetherwing-io/fcp-terraform/releases/latest/download/install.sh | sh" >&2
  echo "" >&2
  echo "Or run /fcp:setup in Claude Code to install all FCP dependencies." >&2
  exit 1
fi
