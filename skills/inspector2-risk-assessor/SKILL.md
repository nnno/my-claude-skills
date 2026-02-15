---
name: inspector2-risk-assessor
description: >
  AWS Inspector2の脆弱性findingを分析し、ソースコードの実際の使用状況に基づいた実質的リスク評価レポートを生成する。
  CVE番号やInspector2のfinding情報（JSON/テキスト）が提示された時、「脆弱性を評価して」「CVEの影響を調べて」
  「Inspector2のfindingを分析して」「セキュリティリスクを評価して」「このCVEうちのコードに影響ある？」
  「パッケージの脆弱性を調査して」「セキュリティfindingのトリアージをして」と依頼された時に使用する。
  Also triggers for "assess this vulnerability", "check CVE impact", "analyze Inspector2 findings",
  "evaluate security risk". 一般的なセキュリティ相談、AWSインフラ構成のレビュー、Inspector2のセットアップには使用しない。
---

# Inspector2 Risk Assessor

AWS Inspector2のfindingからCVE詳細を調査し、プロジェクトのソースコードにおける実際の影響を評価してリスクレポートを出力する。

## ワークフロー

以下の5ステップを順に実行する。

### Step 1: Finding情報の解析

ユーザーが提示した情報から以下を抽出する:

- CVE ID（例: CVE-2024-12345）
- 対象パッケージ名とバージョン
- Inspector2の重要度（CRITICAL/HIGH/MEDIUM/LOW）
- 影響を受けるリソース（ECRイメージ、Lambda関数等）

入力形式は以下のいずれか:
- Inspector2のfinding JSON
- テキスト形式のfinding概要
- CVE番号のみ（パッケージ名をユーザーに確認する）

情報が不足する場合はユーザーに確認を求める。

入力例（Inspector2 finding JSON）:
```json
{
  "findingArn": "arn:aws:inspector2:ap-northeast-1:123456789012:finding/xxxxx",
  "type": "PACKAGE_VULNERABILITY",
  "severity": "HIGH",
  "title": "CVE-2024-12345 - lodash",
  "packageVulnerabilityDetails": {
    "vulnerablePackages": [{"name": "lodash", "version": "4.17.20"}],
    "source": "NVD",
    "cvss": [{"baseScore": 7.5, "version": "3.1"}]
  }
}
```

### Step 2: CVE詳細調査

WebSearchとWebFetchで以下の情報を収集する:

1. **NVD/MITRE**: CVSSスコア、攻撃ベクトル（AV）、攻撃複雑性（AC）、必要権限（PR）
2. **GitHub Advisory / セキュリティアドバイザリ**: 影響バージョン範囲、修正バージョン
3. **脆弱性の技術的詳細**: 脆弱な関数・メソッド、攻撃条件、PoCの有無

検索クエリ例:
- `CVE-XXXX-XXXXX NVD`
- `CVE-XXXX-XXXXX [パッケージ名] advisory`
- `CVE-XXXX-XXXXX exploit PoC`

CVEの詳細情報が見つからない場合、NVDの公開情報とCVSS基本スコアのみで評価を進め、情報の限界をレポートに明記する。

### Step 3: ソースコード分析

Grep/Glob/Readでプロジェクトコードを走査し、以下を特定する:

1. **依存関係の確認**: package.json, requirements.txt, go.mod, pom.xml等で該当パッケージのバージョンを確認
2. **使用箇所の特定**: 脆弱な関数・メソッド・モジュールのimport/呼び出し箇所をGrepで検索
3. **入力経路の追跡**: 外部入力（HTTPリクエスト、ファイルアップロード、環境変数等）が脆弱な関数に到達するかを確認
4. **推移的依存の確認**: 直接依存に見つからない場合、`npm ls [pkg]`、`pip show [pkg]`、`go mod graph | grep [pkg]`で推移的依存を確認

検索パターン例:
```
# パッケージのimport
Grep: "import.*{パッケージ名}" or "require.*{パッケージ名}" or "from {パッケージ名}"

# 脆弱な関数の呼び出し
Grep: "{脆弱な関数名}\("

# 依存定義
Glob: "**/package.json", "**/requirements*.txt", "**/go.mod", "**/pom.xml", "**/Gemfile"
```

### Step 4: 実質的リスク評価

Step 2とStep 3の結果を照合し、以下の観点で評価する:

**攻撃成立性の判定:**
- 脆弱な関数/メソッドがコード内で実際に使われているか
- 攻撃に必要な入力が外部から到達可能か
- ネットワーク経由のアクセスが必要な場合、対象サービスは外部公開されているか
- 攻撃に必要な前提条件（認証、特定設定等）がこの環境で満たされるか

**実質リスクレベルの判定基準:**

| レベル | 条件 |
|---|---|
| **Critical** | 脆弱な機能を使用 + 外部入力が到達可能 + 攻撃複雑性が低い |
| **High** | 脆弱な機能を使用 + 外部入力が到達可能だが攻撃に条件がある |
| **Medium** | 脆弱な機能を使用しているが外部入力の到達が限定的 |
| **Low** | パッケージは使用しているが脆弱な機能は未使用 |
| **Informational** | パッケージのバージョンは該当するが実質的影響なし |

### Step 5: レポート出力

`references/report-template.md` のテンプレートに従い、レポートを出力する。

## 重要な注意事項

- Inspector2の重要度と実質リスクレベルが異なる場合、その差分の理由を必ず明記する
- 「影響なし」と判断する場合でも、判断根拠を具体的に示す
- 修正方法は具体的なバージョン番号やコード変更案を含める
- 不確実な点がある場合は「要確認」として明示し、確認方法を提案する
