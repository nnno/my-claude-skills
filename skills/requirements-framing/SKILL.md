---
name: requirements-framing
description: >
  Requirements elicitation and structuring techniques.
  Use when defining what to build before planning how to build it.
  Provides templates for user stories, acceptance criteria,
  MoSCoW prioritization, and scope definition.
origin: ECC
---

# 要件定義フレーミング知識基盤

このスキルは、曖昧な要望を構造化された要件定義に変換するための知識基盤を提供します。

---

## When to Activate

以下の状況でこのスキルを参照してください:

- 新機能の要件を定義するとき
- 要望のスコープが不明確なとき
- 仕様を固めてからプランニングに進みたいとき
- ステークホルダー間で認識を合わせたいとき
- 「何を作るか」がまだ曖昧な段階

---

## Core Concepts

### 機能要件 vs 非機能要件

| 種別 | 定義 | 例 |
|------|------|-----|
| 機能要件 (FR) | システムが**何をするか** | ユーザーがメールでログインできる |
| 非機能要件 (NFR) | システムが**どう動くか** | ログイン応答時間が2秒以内 |

機能要件と非機能要件は必ず分離して管理すること。混在させると優先度判断やテスト設計が困難になる。

### MoSCoW優先度

| 優先度 | 意味 | 判断基準 |
|--------|------|----------|
| **Must** | なければリリースできない | ビジネス上の必須条件 |
| **Should** | 重要だが回避策がある | 期待される機能だが代替手段あり |
| **Could** | あれば嬉しい | 余裕があれば対応 |
| **Won't** | 今回はやらない | 明示的に除外（将来の候補） |

全要件にMoSCoW優先度を付与すること。「Won't」も明示することでスコープクリープを防ぐ。

### ユーザーストーリー形式

```
As a [ロール/ペルソナ],
I want [達成したいこと],
So that [得られる価値/理由].
```

良いユーザーストーリーはINVEST原則に従う:

- **I**ndependent — 他のストーリーに依存しない
- **N**egotiable — 詳細は交渉可能
- **V**aluable — ユーザーに価値を提供する
- **E**stimable — 見積もり可能なサイズ
- **S**mall — 1イテレーションで完了できる
- **T**estable — 完了を検証できる

### 受け入れ基準 (Acceptance Criteria)

Given/When/Then形式で記述する:

```
Given [前提条件],
When [アクション],
Then [期待される結果].
```

各機能要件に最低1つの受け入れ基準を定義すること。受け入れ基準がない要件は「完了」を判定できない。

---

## Elicitation Techniques

### 5W1H深掘り

要望を受け取ったら、以下の観点で深掘りする:

- **Who** — 誰が使うのか？（ロール、ペルソナ、利用頻度）
- **What** — 何を実現したいのか？（具体的な機能・振る舞い）
- **Why** — なぜ必要なのか？（ビジネス価値、解決する課題）
- **Where** — どの画面/コンテキストで使うのか？
- **When** — いつ使うのか？（トリガー、頻度、タイミング）
- **How** — どのように操作するのか？（ユーザーフロー概要）

### Jobs to be Done (JTBD)

ユーザーの「ジョブ」に着目してニーズを発見する:

```
When [状況],
I want to [動機/ジョブ],
So I can [期待される成果].
```

機能そのものではなく、ユーザーが達成したい「ジョブ」に焦点を当てることで、より本質的な要件を発見できる。

### ネガティブ要件（何をしないか）

明示的に「やらないこと」を定義する:

- このシステムは○○を**しない**
- このフェーズでは○○を**スコープ外とする**
- ○○のユースケースは**サポートしない**

ネガティブ要件はスコープクリープの最大の防御線。曖昧さを排除し、チーム全員の期待値を揃える。

---

## Templates

### 要件ドキュメントテンプレート

```markdown
# Requirements Document: [機能名]

## 1. Overview
### Problem Statement
[解決すべき課題の簡潔な記述]

### Goals & Success Metrics
- Goal: [目標]
- Metric: [計測可能な成功指標]

## 2. Stakeholders
| Role | Needs | Priority |
|------|-------|----------|
| [ロール] | [ニーズ] | Primary/Secondary |

## 3. Functional Requirements
| ID | User Story | MoSCoW | Acceptance Criteria |
|----|-----------|--------|-------------------|
| FR-001 | As a... I want... So that... | Must | Given... When... Then... |

## 4. Non-Functional Requirements
| ID | Category | Target | Measurement |
|----|----------|--------|-------------|
| NFR-001 | Performance | [数値目標] | [計測方法] |

## 5. Scope
### IN Scope (MVP)
- [含めるもの]

### OUT of Scope (Future)
- [除外するもの]

### Assumptions
- [前提条件]

## 6. Risks & Dependencies
| ID | Type | Description | Impact | Mitigation |
|----|------|-------------|--------|------------|
| RISK-001 | Technical | [説明] | High/Medium/Low | [対策] |

## 7. Open Questions
- [ ] [未解決の質問]
```

### ユーザーストーリーテンプレート

```markdown
### [ID]: [ストーリータイトル]
**As a** [ロール],
**I want** [機能/アクション],
**So that** [価値/理由].

**Priority:** Must/Should/Could/Won't

**Acceptance Criteria:**
1. **Given** [前提], **When** [操作], **Then** [結果]
2. **Given** [前提], **When** [操作], **Then** [結果]
```

### リスクマトリクス

```
           Impact
         Low  Med  High
  High  | M  | H  | H  |
Like Med | L  | M  | H  |
  Low   | L  | L  | M  |
```

- **H (High)**: 即座にミティゲーション計画が必要
- **M (Medium)**: モニタリングとコンティンジェンシープランを用意
- **L (Low)**: 認識しておく程度

---

## Quality Checklist

各要件が以下を満たしているか検証する:

- [ ] **検証可能**: 受け入れ基準がGiven/When/Then形式で定義されている
- [ ] **ID付与**: 一意のID（FR-001, NFR-001）が割り当てられている
- [ ] **優先度設定**: MoSCoW優先度が明示されている
- [ ] **受け入れ基準あり**: 各FRに最低1つのACが定義されている
- [ ] **矛盾なし**: 他の要件と矛盾していない
- [ ] **曖昧さなし**: 「速い」「使いやすい」など定量化されていない表現がない
- [ ] **スコープ明確**: IN/OUTが明示されている
- [ ] **ステークホルダー特定**: 誰のための要件かが明確

---

## Anti-Patterns

### 1. 定量化されていない表現

| NG | OK |
|----|----|
| 「高速に動作する」 | 「応答時間が200ms以内」 |
| 「使いやすい」 | 「3クリック以内で完了できる」 |
| 「大量のデータを処理」 | 「10万件/秒を処理できる」 |
| 「セキュアである」 | 「OWASP Top 10に準拠する」 |

### 2. 実装詳細の混入

要件定義では「What」を定義し、「How」は設計・実装フェーズに委ねる。

| NG（Howの混入） | OK（Whatに集中） |
|-----------------|-----------------|
| 「Redisでキャッシュする」 | 「2回目以降のアクセスは1秒以内に応答する」 |
| 「React Componentで実装」 | 「リアルタイムでフィルタリングできる」 |
| 「REST APIを提供」 | 「外部システムからデータを取得できる」 |

### 3. スコープクリープの兆候

以下の兆候が見られたら警告する:

- 「ついでに○○も」という追加要望
- Must要件が全体の70%を超えている
- OUT of Scopeが定義されていない
- 受け入れ基準が際限なく増えている
- 「将来的には」が頻出する（→ Won't/Futureに明示的に分類する）
