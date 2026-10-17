#!/usr/bin/env bash
# Manual install of AI-DLC into your user-level Claude Code config (macOS/Linux/WSL).
# Usage: ./install.sh [--project]   (--project installs into ./.claude instead)
set -euo pipefail
src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest="$HOME/.claude"
[[ "${1:-}" == "--project" ]] && dest="$(pwd)/.claude"

mkdir -p "$dest/skills" "$dest/agents"
cp -R "$src/skills/aidlc" "$dest/skills/"
cp "$src"/agents/aidlc-*.md "$dest/agents/"

n=$(ls "$src"/agents/aidlc-*.md | wc -l | tr -d ' ')
echo "Installed the aidlc skill and $n agents into $dest"
echo "Restart Claude Code, then type /aidlc in any project."
