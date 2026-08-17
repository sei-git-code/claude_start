# Claude Code月次サーベイ ルーティン

Claude Code新機能・最新モデルの最適化設定変化を毎月自動調査し、`reference/claude-code-monthly-survey.md`への追記をPRとして提案するクラウドルーティン。Anthropicアカウントに紐づくクラウド側の設定なので、ファイルとしては配布できない。**新しいAnthropicアカウントで使う場合のみ**、以下の手順で作り直す。

同一アカウントであれば、どのマシン・どのセッションでもすでに有効なので何もしなくてよい。

## 現在の設定
- ルーティンID: `trig_01S1hf1N8imQWfTRvqZRzisu`
- 頻度: 毎月1日 00:00 UTC（JST 09:00頃）、cron式 `0 0 1 * *`
- 対象リポジトリ: `https://github.com/sei-git-code/claude_start`（クラウド側でclone、ローカルファイルには触れない）
- モデル: `claude-sonnet-5`
- 動作: Claude Code公式ドキュメント・Anthropic公式ブログ等を調査し、`reference/claude-code-monthly-survey.md`に新しい月次セクションを追記。**mainへの直接pushはせず、新しいブランチを切ってPull Requestを作成する**（内容確認・マージは手動）。カタログへの正式な機能追加やmodules/配下への実装は行わない。

## 作成手順（別アカウントで再現する場合）
Claude Codeで `/schedule` を実行し、以下を伝える。
```
毎月1日、Claude Codeの新機能とOpus系最新モデルの最適化設定変化を調査し、
reference/claude-code-monthly-survey.md に新しいセクションとして追記するPRを作成して
（mainへの直接pushはしない）
```
- 対象リポジトリ・調査観点・追記フォーマットの詳細は、このリポジトリの`reference/claude-code-monthly-survey.md`の既存セクション（2026-08分）を参照するようClaudeに伝えると再現しやすい。

## 確認・管理
- PRが作られたら内容を確認し、必要な部分だけ手動でmainにマージする（自動マージはしない設計）。
- 実行状況の確認・停止は https://claude.ai/code/routines から行う（このツールからは削除不可）。
