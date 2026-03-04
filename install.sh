#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="${HOME}/.claude/skills"

mkdir -p "$DEST"

for dir in "${SCRIPT_DIR}/skills"/*/; do
  [ -d "$dir" ] || continue
  name="$(basename "$dir")"
  if [ -f "${dir}SKILL.md" ]; then
    ln -sfn "$dir" "${DEST}/${name}"
    echo "  ✓ ${name}"
  else
    echo "  ✗ ${name} (SKILL.md not found, skipped)"
  fi
done

# agents
AGENT_DEST="${HOME}/.claude/agents"
mkdir -p "$AGENT_DEST"
for file in "${SCRIPT_DIR}/agents"/*.md; do
  [ -f "$file" ] || continue
  name="$(basename "$file")"
  ln -sfn "$file" "${AGENT_DEST}/${name}"
  echo "  ✓ ${name} (agent)"
done

# commands
CMD_DEST="${HOME}/.claude/commands"
mkdir -p "$CMD_DEST"
for file in "${SCRIPT_DIR}/commands"/*.md; do
  [ -f "$file" ] || continue
  name="$(basename "$file")"
  ln -sfn "$file" "${CMD_DEST}/${name}"
  echo "  ✓ ${name} (command)"
done

echo ""
echo "Installed to ${DEST}, ${AGENT_DEST}, ${CMD_DEST}"