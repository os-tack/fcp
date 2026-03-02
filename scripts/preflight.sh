#!/bin/bash
# FCP preflight — checks for required dependencies, prints warnings for missing ones.
# Runs on SessionStart. Silent when everything is present.

missing=()

# uv — required for Python-based FCP servers (midi, sheets, slides)
if ! command -v uv &>/dev/null; then
  missing+=("  uv — required for midi, sheets, slides")
  missing+=("    Install: curl -LsSf https://astral.sh/uv/install.sh | sh")
fi

# fcp-terraform — required for terraform server
if ! command -v fcp-terraform &>/dev/null; then
  missing+=("  fcp-terraform — required for terraform")
  missing+=("    Install: curl -LsSf https://github.com/aetherwing-io/fcp-terraform/releases/latest/download/install.sh | sh")
fi

# node — required for drawio (should always be present with Claude Code)
if ! command -v node &>/dev/null; then
  missing+=("  node — required for drawio")
  missing+=("    Install: https://nodejs.org/")
fi

if [ ${#missing[@]} -gt 0 ]; then
  echo "[fcp] Missing dependencies:"
  for line in "${missing[@]}"; do
    echo "$line"
  done
  echo ""
  echo "Run /fcp:setup to install missing dependencies."
fi
