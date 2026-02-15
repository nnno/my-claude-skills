# my-claude-skills

Claude Code向けのカスタムSkillsコレクションです。

## Skills

| Skill | 説明 |
|---|---|
| [skill-nav](./skills/skill-nav/) | Claude Skillsの設計ナビゲーションと品質レビュー |
| [inspector2-risk-assessor](./skills/inspector2-risk-assessor/) | AWS Inspector2の脆弱性findingの実質リスク評価 |

## インストール

```bash
git clone https://github.com/nnno/my-claude-skills.git
cd my-claude-skills
chmod +x install.sh
./install.sh
```

`~/.claude/skills/` にシンボリックリンクが作成されます。

## 実験版 (Experimental)

`experimental/` には開発中・試験的なスキルが配置されています。安定版とは異なり、自動インストールされません。

### 一覧表示

```bash
./install-experimental.sh
```

### インストール

```bash
./install-experimental.sh <skill-name> [<skill-name> ...]
```

### アンインストール

安定版と同様に `rm ~/.claude/skills/<skill-name>` で削除できます。

## アップデート

```bash
cd my-claude-skills
git pull
```

シンボリックリンクのため、`git pull` だけで反映されます。

## アンインストール

```bash
# 個別
rm ~/.claude/skills/<skill-name>

# 全て
cd my-claude-skills
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
