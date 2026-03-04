---
description: >
  Transform vague ideas into structured requirements. Elicit needs,
  define scope, set acceptance criteria, and produce a requirements
  document. WAIT for user CONFIRM at each stage.
---

# Requirements Framer Command

曖昧な要望を構造化された要件定義書に変換します。requirements-framer エージェントのワークフローに基づき、対話的に要件を明確化します。

---

## What This Command Does

1. **Discovery** — 構造化された質問で要望を深掘り（最大3ラウンド）
2. **Structuring** — ユーザーストーリー形式で機能要件・非機能要件を整理
3. **Scoping** — IN Scope (MVP) / OUT of Scope (Future) を明示
4. **Acceptance Criteria** — Given/When/Then形式で完了条件を定義
5. **Risk Analysis** — 技術リスク・外部依存の洗い出し
6. **Output** — 構造化された要件ドキュメントを出力

---

## When to Use

- 要望が曖昧で「何を作るか」が定まっていないとき
- スコープが未定義で、どこまでやるか決まっていないとき
- 仕様を固めてから計画・実装に進みたいとき
- ステークホルダー間で認識を揃えたいとき

---

## How It Works

1. ユーザーが `/requirements-framer` + 要望の概要を入力
2. requirements-framer エージェントが Discovery 質問を開始
3. 各ステージの完了時に `**WAITING FOR CONFIRMATION**` を表示
4. ユーザーが確認・修正を指示
5. 全ステージ完了後、要件ドキュメントを出力

---

## Example Usage

```
User: /requirements-framer ユーザー認証機能を追加したい

Requirements Framer: 以下の点を確認させてください:

1. **ビジネスコンテキスト**: 認証機能が必要な理由は何ですか？
   （例: セキュリティ強化、個人データ保護、アクセス制御）
2. **ユーザー**: 認証するユーザーの種類は？
   （例: 一般ユーザー、管理者、API利用者）
3. **成功基準**: 認証が「うまく動いている」とはどんな状態ですか？
4. **制約**: 認証方式の指定はありますか？
   （例: メール/パスワード、OAuth、SSO）

---
**WAITING FOR CONFIRMATION** — Discovery Round 1 完了
上記の質問にお答えください。
---

User: Webアプリの一般ユーザー向け。メール/パスワードでログイン。
     将来的にはOAuthも入れたいけど、まずはベーシックな認証から。

Requirements Framer: ありがとうございます。要件を構造化しました:

| ID | User Story | MoSCoW |
|----|-----------|--------|
| FR-001 | As a user, I want to register with email/password... | Must |
| FR-002 | As a user, I want to log in with my credentials... | Must |
| FR-003 | As a user, I want to reset my password... | Must |
| FR-004 | As a user, I want to log in via OAuth... | Won't (Future) |

---
**WAITING FOR CONFIRMATION** — Structuring 完了
要件の構造化結果を確認してください。
---
```

---

## Important Notes

**CRITICAL:** 各ステージで `**WAITING FOR CONFIRMATION**` を表示し、ユーザーの確認を待ちます。自動的に次のステージに進むことはありません。

- 修正が必要な場合は、そのステージの内容を修正してから次に進みます
- 前のステージに戻ることも可能です（例: 「Discoveryからやり直したい」）
- 要件ドキュメントは最終確認後に出力します

---

## Integration with Other Commands

`/requirements-framer` は開発ライフサイクルの最上流に位置します:

```
/requirements-framer（要件定義）→ /plan（実装計画）→ 実装 → テスト
```

- `/requirements-framer` で「何を作るか」を固めてから、`/plan` で「どう作るか」を計画する
- `/requirements-framer` の出力（要件ドキュメント）を `/plan` の入力として使用できる

---

## Related Agents

- **requirements-framer** (`~/.claude/agents/requirements-framer.md`) — 要件定義に特化したエージェント
