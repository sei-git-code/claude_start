# claude_start — 個人用 Claude Code カスタマイズカタログ

このリポジトリは、過去のセッションで検証・導入した Claude Code のカスタマイズ項目（ステータスライン、プラグイン、セキュリティガードレール等）を、別のマシン・別のセッションでも再現できるように保管したものです。

## Claudeへ：このリポジトリを開いたときの振る舞い

**重要**: ユーザーがこのディレクトリで作業を始めたら、以下のカタログをそのまま提示し、**各項目について導入するかどうかを1つずつユーザーに確認してから適用すること**。カタログ全体をまとめて自動導入してはいけない（auto mode が有効でも、この確認は省略しない）。

確認の粒度は「モジュール単位」ではなく、モジュール内に複数の独立した要素がある場合（例: security-guardrails の4要素）は、その要素ごとに個別に確認する。過去のセッションでは `AskUserQuestion` の multiSelect を使うと好評だった。

各項目を導入する際は、記事や設定の「実体」（実在するリポジトリ名・コマンド）を鵜呑みにせず、可能な範囲で実行して動作確認してから完了報告すること（過去にインストールコマンドが記事の記載と食い違っていた例が複数あった）。

## カタログ

### 1. ステータスライン（`modules/statusline/`）
モデル名・Gitブランチ・コンテキスト使用率・5時間/7日ウィンドウ消費率・累積コストを表示する。
- 導入手順: `statusline.sh` を `~/.claude/statusline.sh` にコピーし、`~/.claude/settings.json` に以下をマージする。
  ```json
  { "statusLine": { "type": "command", "command": "bash ~/.claude/statusline.sh" } }
  ```
- 前提: `jq` が必要（`modules/jq/install-jq.sh` 参照）。

### 2. 朝の自動ping ルーティン（`modules/ping-routine/README.md`）
Claude Codeの5時間利用制限ウィンドウを毎朝7時（JST）に固定するためのクラウドルーティン。ファイルで配布できないため、`/schedule` コマンドで都度作成する。手順は README を参照。

### 3. プラグイン（`modules/plugins/README.md`）
genshijin / superpowers / dig / designer-skills / andrej-karpathy-skills の5つ。それぞれ独立したマーケットプレイス追加＋インストールコマンドを持つ。1つずつ確認する。

### 4. セキュリティガードレール（`modules/security-guardrails/`）
4つの独立した要素。まとめて聞かず、個別に確認すること。
- 最小権限 permissions（`settings.snippet.json` の `permissions.deny` 部分）
- 危険Bashコマンド遮断hook（`hooks/guard-dangerous-bash.sh`、PreToolUse）
- 不可逆操作の確認y/Nゲート（`hooks/confirm-irreversible.sh`、PreToolUse）
- 機密情報流出防止（`hooks/scan-staged-secrets.sh` PostToolUse + `claude-md-snippet.md` + `claudeignore.template`）

注意: hookのパターンマッチはコマンド文字列全体に対して行われるため、危険な文字列を含むだけの無害なコマンド（テストコマンドや`rm -r`を使った後片付けなど）にも誤反応することがある。導入時にユーザーへ一言添えること。

### 5. jq（`modules/jq/install-jq.sh`）
ステータスライン・hookスクリプトが依存する。OS別（winget/brew/apt/dnf/pacman）に自動インストールを試みる。

### 6. 計画と自己改善ログ（`modules/planning-and-lessons/`）
Boris Cherny（Claude Code作者）流の運用を2ルールに凝縮したCLAUDE.mdスニペット。3ステップ以上のタスクはPlan Modeから始める／ユーザーの指摘を`tasks/lessons.md`に記録して次回に活かす。1つの塊として提示してよいが、2ルールどちらかだけの導入を希望されたら分けて確認する。

### 7. /commit-push-pr コマンド（`modules/commands/`）
ステージング→コミット→push→PR作成を一括で行うカスタムスラッシュコマンド。`gh` CLIのインストールと`gh auth login`（対話操作、ユーザー自身が行う。素のcmd.exe/PowerShellで実行すること。Claude Codeの`!`プレフィックス経由の疑似端末では矢印キー選択やブラウザ待ちが固まることがある）が前提。

### 8. Context7 MCP（`modules/mcp-context7/`）
最新のライブラリ/フレームワークドキュメントをオンデマンドで取得するMCPサーバー。Node.js（`modules/nodejs/`）が前提。他の項目と競合しない汎用ツール。

### 9. Unity開発関連（`modules/unity/`）
2つの独立した要素。個別に確認する。
- **unity-coding-skills**（nowsprinting開発）: Unity C#のTDDワークフロー用プラグイン。9スキル+3サブエージェント。今すぐ導入可能
- **Unity MCP**（CoplayDev/unity-mcp）: Unity Editorと直接連携するMCP。Python 3.10+/uvが前提（インストール手順あり）。**ただしUnity Editor自体のインストールと、Unity内メニューでの接続設定（Configure All Detected Clients）が必須**。実際のUnityプロジェクトができてから完了させる

### 10. サンドボックス反映（`modules/sandbox/`）
このカタログを別マシン・コンテナ・VM等の別環境に持ち込む際の手順書。カタログ本体の1項目ではなく、カタログ全体を別環境へ展開するための補助資料なので、提示時は他項目と並べて「導入するか」を聞く対象にはしない（ユーザーがサンドボックス反映を依頼したときに参照する）。
- `SETUP.md`: 対話操作できる環境・できない環境それぞれの反映手順
- `INITIAL_PROMPT.md`: 対話操作できないサンドボックスで`claude`セッション開始時に渡す、各カタログ項目のyes/no事前回答テンプレート

### 11. e2bクラウドサンドボックス（`modules/e2b-sandbox/`）
e2b.dev上のクラウドサンドボックスでClaude Codeを動かす。`modules/sandbox/`（このカタログの反映手順）とは別軸で、e2bは反映先候補になり得るクラウドサンドボックス提供元の1つという位置づけ。
- 対話ログインモードのみ対応（サンドボックス内`claude`起動→通常のClaude.ai/Maxサブスクでログイン）。ANTHROPIC_API_KEYによるヘッドレス自動化は追加API従量課金が発生するため未導入
- 前提: Node.js（`modules/nodejs/`）、e2b.devアカウント・API key発行（本人操作必須、Claude代行不可）
- e2b利用料自体は従量課金（無料枠$100クレジットあり）。使用後は`e2b sbx kill`を忘れずに

### 12. Gemini 3.5 Transcribe 音声入力（`modules/voice-input-gemini/`）
GoogleのGemini 3.5 Transcribe（フィラーワード自動除去のsmart transcriptionモード）でマイク音声を文字起こしし、Claude Codeのターミナルに自動タイプ入力＋Enter送信する。`reference/8bitdo-voice-input.md`（物理コントローラー＋OS標準Dictation、未導入）とは別アプローチ、ハードウェア不要。
- 前提: Python、Google AI Studio APIキー発行（本人操作必須）
- 無料ティア利用時は送信内容がGoogle製品改善に利用され得る点に注意
- ライブラリ導入・import確認は済み。実マイクでのend-to-end動作確認は未（APIキー発行後にユーザー環境で実施）

### 13. Docker Sandboxes（`modules/docker-sandbox/`）
ローカルPC上のmicroVM（専用カーネル＋専用Dockerデーモン）でClaude Codeを隔離実行する。`e2b-sandbox`（クラウド側）に対するローカル側の隔離手段。コマンドは旧`docker sandbox`ではなく独立CLI `sbx`（`sbx run claude <dir>`）。
- 前提: Windows 11 + Windows Hypervisor Platform有効化、Dockerアカウント（`sbx login`は本人操作）
- 導入: `winget install -h Docker.sbx`（パッケージ存在は確認済み）。**未インストール・起動の実機確認は未**
- 注意: サンドボックス内では`--dangerously-skip-permissions`が既定で有効、ホストの`~/.claude`（hook・CLAUDE.md）は引き継がれない。隔離境界が唯一の防御

### 14. Herdr（`modules/herdr/`）
Claude Code等のAIエージェントを複数並べて管理するターミナル多重化ツール（状態サイドバー・セッション永続化・worktree連携）。公式サイト herdr.dev。
- 導入: 公式の`irm ... | iex`ではなく、`install.ps1`をダウンロード→中身確認→実行（README参照）。ユーザー領域インストール、管理者権限不要
- Windows版はベータ。`herdr --version`/`herdr status`は確認済み、実際のペイン操作・エージェント検出は未確認
- 自動モードが`-ExecutionPolicy Bypass`実行を拒否する場合は`!`プレフィックスでユーザー自身が実行

### 参考情報のみ（未導入・ファイルなし、reference/ 配下に理由と入手先を記載）
- AWS コスト削減 Skill（`reference/aws-cost-report-skill.md`）— AWS利用者向け。IAMユーザー作成が前提のため要判断。
- melta-ui（`reference/melta-ui.md`）— AI/人間可読なデザインシステムのMCP。具体的なUIプロジェクトができてから。
- ComfyUIスプライト量産パイプライン（`reference/comfyui-sprite-pipeline.md`）— Claude Codeの設定ではなく技術ノウハウの記録。
- 8BitDo Micro 音声入力（`reference/8bitdo-voice-input.md`）— ハードウェア購入判断が必要、macOS前提。
- claude-mem（`reference/claude-mem.md`）— 永続記憶プラグイン。標準の自動メモリ・手動メモリシステムと役割が重なるため見送り。
- 出力スタイル・サブエージェント入れ子・キュレーションリスト（`reference/advanced-features-2026.md`）
- Claude Code月次サーベイ（`reference/claude-code-monthly-survey.md`）— 新機能・Opus系モデル最適化設定を毎月調査したログ。月次クラウドルーティンで自動更新（`modules/monthly-survey-routine/README.md`参照）
- AIエージェント運用テンプレート集（`reference/ai-agent-task-management-templates.md`）— CLAUDE.md規約例・task-list.mdテンプレート・複数AI役割分担の考え方。具体的な導入手順を伴わない運用方針中心のためファイルなし

## 更新履歴の残し方
このリポジトリに項目を追加・変更したときは、このCLAUDE.mdのカタログにも追記し、対応するモジュールディレクトリを作ること。カタログとファイルの実体が食い違わないようにする。
