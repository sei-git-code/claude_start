# e2bクラウドサンドボックス

出典: [e2b.dev](https://e2b.dev/) 公式ドキュメント [Claude Code連携ページ](https://docs.e2b.dev/agents/claude-code)、[CLIページ](https://docs.e2b.dev/cli)、[料金ページ](https://e2b.dev/pricing)（2026-08時点で内容確認済み）

クラウド上に使い捨ての隔離VM（サンドボックス）を作り、その中でClaude Codeを動かすサービス。ホストマシンを汚さずに試したいコード変更を隔離環境で実行できる。`modules/sandbox/`（このカタログを別環境に反映する手順書）とは別軸で、e2bは反映先候補になり得る「クラウドサンドボックス提供元の1つ」という位置づけ。

## このモジュールの対応範囲

**対話ログインモードのみ**。サンドボックス内で`claude`を起動し、通常のClaude.ai/Maxサブスクリプションでログインする。追加のAnthropic API従量課金は発生しない（発生するのはe2b自体の利用料のみ）。

e2b公式ドキュメントのサンプルは `ANTHROPIC_API_KEY` を渡す**ヘッドレス自動化**（`-p`オプションで非対話実行、`--dangerously-skip-permissions`で確認スキップ）が中心だが、これはAnthropic API従量課金が別途発生するため本モジュールでは扱わない。必要になったら別途検討。

## 前提

- Node.js（`../nodejs/README.md` 参照。`npm i -g @e2b/cli` に必要）
- e2b.devアカウント・API key（**本人操作が必須**。Claudeが代行してアカウント作成はできない）

## 料金の注意（2026-08時点、要最新確認）

- 無料枠（Hobby）: サインアップ時 $100 クレジット、クレジットカード登録不要
- サンドボックス最大セッション時間: 1時間、同時実行20個まで
- 従量課金: CPU $0.000014〜0.000112/秒（1〜8vCPU）、RAM $0.0000045/GiB秒、ストレージ10GiBまで無料
- Pro（$150/月〜）は最大24時間セッション・同時100個
- **使い終わったら`e2b sbx kill`でサンドボックスを落とす**（放置すると課金が続く）

## セットアップ手順

### 1. アカウント作成・API key発行（本人操作）
[e2b.dev](https://e2b.dev/) でサインアップし、ダッシュボードの API Keys タブでキーを発行する。ブラウザ操作が伴うため、素のブラウザ・素の端末で行う（`gh auth login`と同様、Claude Code経由の疑似端末は使わない）。

### 2. CLIインストール
```bash
npm i -g @e2b/cli
```
（macOSなら `brew install e2b` でも可）

### 3. 認証
ブラウザ経由でログインする場合:
```bash
e2b auth login
```
CI等でブラウザを使わない場合は環境変数でも認証できる:
```bash
export E2B_API_KEY=e2b_xxxxxxxx
```
**API keyの値はコミット・出力・チャットに含めない**（ユーザーのグローバルCLAUDE.mdの機密情報取り扱いルールに従う）。

### 4. サンドボックス作成＋接続
公式の`claude`テンプレート（Claude Code CLIプリインストール済み）を指定してサンドボックスを作成すると、そのままターミナル接続される。
```bash
e2b sbx create claude
```

### 5. サンドボックス内でClaude Codeにログイン
接続後のプロンプトで:
```bash
claude
```
を実行し、通常のログインフロー（`/login`相当）で認証すれば、以降は普段のClaude Code CLIと同じ操作感で使える。

### 6. 終了時: サンドボックスを落とす
作業が終わったら課金を止めるために必ず落とす。
```bash
e2b sbx list        # 実行中のサンドボックスID確認
e2b sbx kill <ID>
```

## 動作確認済みコマンド一覧（このモジュール導入時に実行確認）
- `e2b --version` → CLIバージョン表示を確認
- `e2b sbx --help` / `e2b sbx create --help` / `e2b auth --help` → サブコマンド体系を確認
  - `sandbox|sbx create|cr [template]`: サンドボックス作成＋ターミナル接続（デフォルトテンプレートは`base`）
  - `sandbox|sbx connect|cn <sandboxID>`: 既存の起動中サンドボックスに再接続
  - `sandbox|sbx kill|kl [sandboxIDs...]`: サンドボックス停止
  - `auth login` / `auth logout` / `auth info`: 認証系

アカウント作成・API key発行がユーザー本人操作のため、`e2b sbx create claude` 以降の実際のログイン成功までは未検証。API key発行後に本手順で通しの動作確認を行うこと。
