---
name: security-redblue-review
description: >
  Red Team（攻撃者視点）とBlue Team（防御者視点）によるセキュリティレビューを実行する。
  Agent Teamsを使って両チームの並行分析と複数ラウンドのディベートを行い、統合レポートを生成する。
  「セキュリティレビューして」「脆弱性を分析して」「脅威モデリングして」「セキュリティ監査して」
  「リリース前のセキュリティチェック」「攻撃面を分析して」「防御策を提案して」と依頼された時に使用する。
  Also triggers for "security review", "vulnerability analysis", "threat modeling",
  "security audit", "red team", "blue team", "pentest review".
  一般的なセキュリティの質問、個別CVEの調査（inspector2-risk-assessorを使用）、
  セキュリティツールのセットアップには使用しない。
---

# Security Red/Blue Team Review

Red Team（攻撃者視点）とBlue Team（防御者視点）のAgent Teamを構成し、プロジェクトのセキュリティレビューを体系的に実施する。

## 前提条件

Agent Teams機能が必要。以下の環境変数が有効であること:

```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

## ワークフロー

### Phase 1: スコープ定義

1. レビュー対象を確認する（ユーザーがスコープを指定した場合はそれに従う、指定がなければプロジェクト全体）
2. 対象の技術スタック（言語、フレームワーク、DB等）を把握する
3. 外部公開されるエンドポイントやインターフェースを特定する
4. スコープの概要をユーザーに提示し、問題なければ次のPhaseへ進む

### Phase 2: Agent Team作成と並行分析

TeamCreateで `security-review` チームを作成する。

次に、TaskCreateで以下の2つのタスクを作成する:

**タスク1: Red Team分析**
- subject: "Red Team: 攻撃面の分析と脆弱性の発見"
- description: Phase 1で把握したスコープと技術スタック情報を含める

**タスク2: Blue Team分析**
- subject: "Blue Team: 既存の防御策の評価と改善提案"
- description: Phase 1で把握したスコープと技術スタック情報を含める

次に、Taskツールで2つのteammateを起動する:

**Red Team teammate:**
- name: `red-team`
- subagent_type: `general-purpose`
- team_name: `security-review`
- プロンプトに `references/red-team-prompt.md` の全内容を含める
- プロンプトにPhase 1で把握したスコープ・技術スタック情報を含める

**Blue Team teammate:**
- name: `blue-team`
- subagent_type: `general-purpose`
- team_name: `security-review`
- プロンプトに `references/blue-team-prompt.md` の全内容を含める
- プロンプトにPhase 1で把握したスコープ・技術スタック情報を含める

TaskUpdateで各タスクをそれぞれのteammateにownerとして割り当てる。

### Phase 3: ディベート（2ラウンド）

チームリーダー（自分）がSendMessageを使って両チーム間のディベートを調整する。

**ラウンド1:**
1. Red Teamの初期分析完了を待つ（Red Teamは発見した脆弱性にRED-001から連番のIDを振る）
2. Red Teamの発見事項をBlue TeamにSendMessageで共有する
3. Blue Teamが各RED-xxxに対する防御策を提案するのを待つ

**ラウンド2:**
1. Blue Teamの防御策をRed TeamにSendMessageで共有する
2. Red Teamが防御策の回避可能性を検討するのを待つ
3. Red Teamの回避シナリオをBlue TeamにSendMessageで共有する
4. Blue Teamが追加対策を提案するのを待つ

### Phase 4: 統合レポート

両チームの分析結果を統合し、`references/report-template.md` のテンプレートに従って `security-review-report.md` をプロジェクトルートに生成する。

レポート作成時の方針:
- Red TeamとBlue Teamの発見事項を突合する
- リスクの深刻度と対応の優先度を最終判定する
- Red/Blue間で見解が分かれている点は、根拠を比較して裁定する
- 具体的なアクションプランを策定する

### Phase 5: チーム終了

1. SendMessageの `shutdown_request` で両teammateをシャットダウンする
2. TeamDeleteでチームを削除する
3. レポートのサマリーをユーザーに提示する

## 注意事項

- 実際のエクスプロイトコードやPoCは生成しない
- 攻撃「シナリオの説明」に留め、再現可能な攻撃ペイロードは出力しない
- 発見事項には必ずOWASP/CWEの分類を付与する
- レポートは開発チームが直接アクションを取れるレベルの具体性で記述する
- Critical/Highの項目は「即座に対応が必要な項目」として明確に分類する
