#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXP_DIR="${SCRIPT_DIR}/experimental"
SKILL_DEST="${HOME}/.claude/skills"
CMD_DIR="${EXP_DIR}/commands"
CMD_DEST="${HOME}/.claude/commands"

# 利用可能な実験的スキル一覧を取得
list_skills() {
  local found=false
  for dir in "${EXP_DIR}"/*/; do
    [ -d "$dir" ] || continue
    [ "$(basename "$dir")" = "commands" ] && continue
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

# 利用可能な実験的コマンド一覧を取得
list_commands() {
  local found=false
  if [ -d "$CMD_DIR" ]; then
    for file in "${CMD_DIR}"/*.md; do
      [ -f "$file" ] || continue
      found=true
      name="$(basename "$file" .md)"
      # フロントマターからdescriptionを抽出
      desc=$(sed -n '/^---$/,/^---$/{ /^description:/{ s/^description: *//; s/^["'"'"']//; s/["'"'"']$//; p; } }' "$file" 2>/dev/null || true)
      if [ -n "$desc" ]; then
        echo "  ${name} — ${desc}"
      else
        echo "  ${name}"
      fi
    done
  fi
  if [ "$found" = false ]; then
    echo "  (実験的コマンドはありません)"
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

  mkdir -p "$SKILL_DEST"
  ln -sfn "$skill_dir" "${SKILL_DEST}/${name}"
  echo "  ✓ ${name} (skill)"
}

# コマンドをインストール
install_command() {
  local name="$1"
  local cmd_file="${CMD_DIR}/${name}.md"

  if [ ! -f "$cmd_file" ]; then
    echo "  ✗ ${name} (コマンドファイルが見つかりません)" >&2
    return 1
  fi

  mkdir -p "$CMD_DEST"
  ln -sfn "$cmd_file" "${CMD_DEST}/${name}.md"
  echo "  ✓ ${name} (command)"
}

if [ $# -eq 0 ]; then
  echo "利用可能な実験的スキル:"
  echo ""
  list_skills
  echo ""
  echo "利用可能な実験的コマンド:"
  echo ""
  list_commands
  echo ""
  echo "インストール: $0 <name> [<name> ...]"
  exit 0
fi

echo "実験的スキル/コマンドをインストール中..."
echo ""

errors=0
for name in "$@"; do
  if [ -f "${CMD_DIR}/${name}.md" ]; then
    install_command "$name" || errors=$((errors + 1))
  elif [ -d "${EXP_DIR}/${name}" ] && [ -f "${EXP_DIR}/${name}/SKILL.md" ]; then
    install_skill "$name" || errors=$((errors + 1))
  else
    echo "  ✗ ${name} (スキルにもコマンドにも見つかりません)" >&2
    errors=$((errors + 1))
  fi
done

echo ""
if [ $errors -eq 0 ]; then
  echo "完了"
else
  echo "一部のインストールに失敗しました (${errors} 件)"
  exit 1
fi
