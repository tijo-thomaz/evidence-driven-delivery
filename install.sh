#!/usr/bin/env bash
# Manual install of EDD into your user-level Claude Code config (macOS/Linux/WSL).
# Usage: ./install.sh [--project]   (--project installs into ./.claude instead)
set -euo pipefail
src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest="$HOME/.claude"
[[ "${1:-}" == "--project" ]] && dest="$(pwd)/.claude"

mkdir -p "$dest/skills" "$dest/agents"
cp -R "$src/skills/edd" "$dest/skills/"
cp "$src"/agents/edd-*.md "$dest/agents/"

n=$(ls "$src"/agents/edd-*.md | wc -l | tr -d ' ')
echo "Installed the edd skill and $n agents into $dest"
echo "Restart Claude Code, then type /edd in any project."
