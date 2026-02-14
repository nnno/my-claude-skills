# my-claude-tools

Claude Code向けのカスタムSkillsコレクションです。

## Skills

| Skill | 説明 |
|---|---|
| [skill-nav](./skills/skill-nav/) | Claude Skillsの設計ナビゲーションと品質レビュー |

## インストール

```bash
git clone https://github.com/<your-username>/my-claude-tools.git
cd my-claude-tools
chmod +x install.sh
./install.sh
```

`~/.claude/skills/` にシンボリックリンクが作成されます。

## アップデート

```bash
cd my-claude-tools
git pull
```

シンボリックリンクのため、`git pull` だけで反映されます。

## アンインストール

```bash
# 個別
rm ~/.claude/skills/skill-nav

# 全て
cd my-claude-tools
for dir in skills/*/; do rm -f ~/.claude/skills/"$(basename "$dir")"; done
```

## Skillの追加

`skills/` 配下にディレクトリを作成し、`SKILL.md` を配置してください。

```
skills/
└── new-skill/
    └── SKILL.md
```

`install.sh` を再実行すると自動的にリンクされます。
