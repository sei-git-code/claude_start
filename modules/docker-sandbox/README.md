# Docker Sandboxes（ローカル隔離環境でClaude Codeを動かす）

出典: [Docker Sandboxes 公式](https://docs.docker.com/ai/sandboxes/)、[Claude Code用ページ](https://docs.docker.com/ai/sandboxes/agents/claude-code/)、[インストールガイド](https://docs.docker.com/ai/sandboxes/install/)、[Claude Code Docs: Choose a sandbox environment](https://code.claude.com/docs/en/sandbox-environments)（2026-09時点で内容確認済み）

ローカルPC上に使い捨ての**microVM**（専用カーネル＋専用Dockerデーモン）を作り、その中でClaude Codeを動かす。ホストのファイル・環境を汚さずに、`--dangerously-skip-permissions` 相当の無人実行ができる。`modules/e2b-sandbox/`（クラウド側の隔離）に対する、ローカル側の隔離手段という位置づけ。

## 重要: コマンドは `docker sandbox` ではなく `sbx`

旧記事・旧ドキュメントでは `docker sandbox run claude` と書かれているが、現行は独立CLI **`sbx`**（Docker Desktop不要の単体製品）。このマシン（Docker 28.3.2）で `docker sandbox` を実行すると `unknown command` になることを確認済み。

## 前提

- **Windows 11**（64bit Intel/AMD）＋ Windows Hypervisor Platform を有効化（管理者権限のPowerShellで実行、再起動が必要な場合あり）
  ```powershell
  Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -All
  ```
- macOS: Sonoma 14以降 ＋ Apple silicon ／ Linux: Ubuntu 24.04以降 ＋ KVM
- Dockerアカウント（`sbx login` で認証。ブラウザ操作あり＝本人操作。素のPowerShellで行う）

## 料金・ライセンス

`sbx` は無料の独立製品（ライセンスはProprietary）。Claude側はサンドボックス内で `/login` すれば通常のClaude.ai/Maxサブスクで使える（追加API課金なし）。APIキー方式にしたい場合は `sbx secret set anthropic`。

## セットアップ手順

### 1. インストール
```powershell
winget install -h Docker.sbx
```
- `winget show --id Docker.sbx` でパッケージ存在を確認済み（Docker Sandboxes 0.43.0、公開元 Docker Inc.）
- 全ユーザー向けは `DockerSandboxesMachine.msi` を `msiexec.exe /i DockerSandboxesMachine.msi /quiet`
- macOS: `brew trust docker/tap` → `brew install docker/tap/sbx`
- Ubuntu: `curl -fsSL https://get.docker.com | sudo SBX=1 sh`（**curl|sh 系はグローバル設定のhookで遮断される。ユーザーが手動実行すること**）

### 2. サインイン（本人操作）
```powershell
sbx login
```

### 3. 起動
プロジェクトディレクトリを指定して起動する。ワークスペースはホストとサンドボックスで同じ絶対パスに同期される。
```powershell
sbx run claude C:\path\to\my-project
```
- 初回だけ、起動したClaude内で `/login` を実行して認証する
- **デフォルトで `claude --dangerously-skip-permissions` が自動起動する**。権限プロンプトが出ない前提のため、隔離境界が唯一の防御になる
- プロンプトを渡して起動: `sbx run --name my-sandbox claude -- "指示文"`
- 並列タスク（agentsビュー）: `sbx run --clone claude . -- agents`

### 4. 管理
```powershell
sbx ls                     # サンドボックス一覧（状態・エージェント・ポート・ワークスペース）
sbx stop <name>            # 一時停止
sbx rm <name>              # 削除
sbx prune --dry-run        # 停止中サンドボックスの一括削除を事前確認
```
`sbx` だけ実行すると対話ダッシュボードが開き、外向き通信ログの閲覧やホスト単位の許可/遮断ができる（tabでパネル切替、`?`でショートカット）。

## 注意点

- **ホストの `~/.claude`（ユーザー設定・CLAUDE.md・プラグイン・hook）は引き継がれない**。サンドボックス内で使えるのはワークスペース内のプロジェクト単位設定のみ。グローバルの機密情報ルールや遮断hookも効かないため、隔離境界に頼る運用になる
- ワークスペースは書き込み可能でマウントされるため、**プロジェクトディレクトリ内のファイルは壊され得る**（gitで戻せる状態にしておく）
- 通信を許可している限り、エージェントが読めるデータの外部送信は理論上あり得る（公式ドキュメントも同様に警告）。ネットワークパネルで許可先を絞る
- プロンプトやClaudeが読んだファイルはサンドボックスの有無に関係なくAnthropic APIに送信される
- OneDrive配下（このリポジトリのパス）を同期対象にすると、同期の遅延・ロックで不安定になる可能性がある。隔離運用するプロジェクトはOneDrive外に置くことを推奨（未検証）

## 他の隔離手段との使い分け

- **Docker Sandboxes（本モジュール）**: microVMで最も手軽。Windowsネイティブ対応。カスタムのファイアウォール設定は不要
- **公式devcontainer**（`anthropics/claude-code` の `.devcontainer/`）: VS Code等のDev Containers拡張が前提。default-denyのiptablesファイアウォール付きで、チームでリポジトリに同梱して標準化する用途向き。共有カーネルのコンテナなのでmicroVMより境界は弱い
- **e2b**（`modules/e2b-sandbox/`）: クラウド側。ローカルを一切使いたくない場合

## 動作確認状況

確認済み:
- `winget show --id Docker.sbx` でパッケージ存在を確認（0.43.0）
- `docker sandbox` は現行Docker（28.3.2）で使えないことを確認
- 公式ドキュメントとの記載一致（install/run/ls/stop/rm/prune）

**未確認**（`sbx` 未インストール、Windows Hypervisor Platformの有効化状態も未確認のため）:
- `winget install` 以降の実インストール、`sbx login`、`sbx run claude` の実際の起動
- 導入時はHypervisor Platform有効化→（再起動）→インストール→ログイン→起動の順に通しで確認すること
