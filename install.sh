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

echo ""
echo "Installed to ${DEST}"