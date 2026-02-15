#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXP_DIR="${SCRIPT_DIR}/experimental"
DEST="${HOME}/.claude/skills"

# 利用可能な実験的スキル一覧を取得
list_skills() {
  local found=false
  for dir in "${EXP_DIR}"/*/; do
    [ -d "$dir" ] || continue
    if [ -f "${dir}SKILL.md" ]; then
      found=true
      name="$(basename "$dir")"
      # フロントマターからdescriptionを抽出
      desc=$(sed -n '/^---$/,/^---$/{ /^description:/{ s/^description: *//; s/^["'"'"']//; s/["'"'"']$//; p; } }' "${dir}SKILL.md" 2>/dev/null || true)
      if [ -n "$desc" ]; then
        echo "  ${name} — ${desc}"
      else
        echo "  ${name}"
      fi
    fi
  done
  if [ "$found" = false ]; then
    echo "  (実験的スキルはありません)"
  fi
}

# スキルをインストール
install_skill() {
  local name="$1"
  local skill_dir="${EXP_DIR}/${name}"

  if [ ! -d "$skill_dir" ]; then
    echo "  ✗ ${name} (ディレクトリが見つかりません)" >&2
    return 1
  fi
  if [ ! -f "${skill_dir}/SKILL.md" ]; then
    echo "  ✗ ${name} (SKILL.md が見つかりません)" >&2
    return 1
  fi

  mkdir -p "$DEST"
  ln -sfn "$skill_dir" "${DEST}/${name}"
  echo "  ✓ ${name}"
}

if [ $# -eq 0 ]; then
  echo "利用可能な実験的スキル:"
  echo ""
  list_skills
  echo ""
  echo "インストール: $0 <skill-name> [<skill-name> ...]"
  exit 0
fi

echo "実験的スキルをインストール中..."
echo ""

errors=0
for skill in "$@"; do
  install_skill "$skill" || errors=$((errors + 1))
done

echo ""
if [ $errors -eq 0 ]; then
  echo "インストール先: ${DEST}"
else
  echo "一部のスキルのインストールに失敗しました (${errors} 件)"
  exit 1
fi
