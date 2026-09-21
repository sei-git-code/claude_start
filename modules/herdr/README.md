# Herdr

出典: [herdr.dev](https://herdr.dev/)、紹介記事 https://note.com/kazu_t/n/nb4958baf3290

Claude Code / Codex / OpenCode などのターミナル系AIエージェントを複数並べて管理するターミナル多重化ツール（tmux的な操作感）。エージェントを自動検出し、状態（待機中/処理中/承認待ち）をサイドバーに表示する。セッション永続化、SSH経由のリモートアタッチ、Git worktree連携キーバインドを備える。無料・アカウント登録不要・テレメトリなし。

**Windows版はベータ**（安定版はLinux/macOS）。

## 導入（Windows）

公式の案内は `irm https://herdr.dev/install.ps1 | iex` だが、このカタログはパイプ実行を避ける方針のため、**ダウンロード→中身確認→実行**の順で行う。

```powershell
curl.exe -fsSL https://herdr.dev/install.ps1 -o install.ps1
# install.ps1 の中身を確認（ユーザー領域へのインストール、SHA256検証、ユーザーPATH更新）
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

- インストール先: `%LOCALAPPDATA%\Programs\Herdr\bin`（管理者権限不要）
- ユーザーPATHが更新される。**新しいターミナルを開くと `herdr` が通る**
- Claude Codeの自動モードは `-ExecutionPolicy Bypass` 付き実行を拒否することがある。その場合は `!` プレフィックスでユーザー自身が実行する

macOS/Linux: `curl -fsSL https://herdr.dev/install.sh | sh`（同様に、先にダウンロードして中身を確認してから実行するのが望ましい）。

## 動作確認済み
- `herdr --version` → `herdr 0.9.1`
- `herdr status` → client version 0.9.1 / channel stable を確認（サーバー未起動の状態）

`herdr` 本体を起動してのペイン分割・エージェント検出の実操作は未確認。

## 基本操作（記事より）
- プレフィックスは `Ctrl+B`: `v` 右分割 / `-` 下分割 / `c` 新規タブ / `h j k l` ペイン移動 / `Shift+n` ワークスペース作成
- `herdr agent list`（実行中エージェント一覧）、`herdr agent start <名前> --cwd <dir> --split right -- <コマンド>`、`herdr agent wait <対象> --status done`

## 注意
- Herdr内でClaude Codeを起動しても、ホストの `~/.claude`（hook・CLAUDE.md・statusline）はそのまま使われる（隔離はしない）
