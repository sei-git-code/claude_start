# Herdr

出典: [herdr.dev](https://herdr.dev/)、紹介記事 https://note.com/kazu_t/n/nb4958baf3290

Claude Code / Codex / OpenCode などのターミナル系AIエージェントを複数並べて管理するターミナル多重化ツール（tmux的な操作感）。エージェントを自動検出し、状態（待機中/処理中/承認待ち）をサイドバーに表示する。セッション永続化、SSH経由のリモートアタッチ、Git worktree連携キーバインドを備える。無料・アカウント登録不要・テレメトリなし。

**Windows版はベータ**（安定版はLinux/macOS）。

**注意: 「Herdr」ブランドには別々の2製品がある。**
- **standalone TUI版**（本セクション以下、`herdr.exe`。インストール元 `herdr.dev/install.ps1`、ソケット`%APPDATA%\herdr\herdr.sock`、Ctrl+Bプレフィックス操作）
- **Desktop App版**（後述「Desktop App版（herdr-app）」セクション。`herdr-app.exe` + バックエンド`herdr-core`/`hc`。インストール元 `releases.herdr.dev/app/install.ps1`、ソケット`\\.\pipe\herdr-core-<user>-default.sock`）

両者は別インストール・別ソケットで**相互に連携しない**。2026-11時点で実際に動作確認できているのはDesktop App版のみ。

herdrで並べたClaude Codeセッション同士は、herdrのペイン管理とは別に、Claude Code標準の`ListAgents`/`SendMessage`（セッション間メッセージング）でも直接やり取りできる（2026-08〜のバージョンで追加）。herdrはペインの可視化・永続化、`ListAgents`/`SendMessage`はセッション間の通信、と役割が分かれる。

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

## Zed連携（Windows）

Zedのターミナルパネルを開くと自動でherdrが起動するようにする。`%APPDATA%\Zed\settings.json` に追記（JSONC、末尾カンマ可）:

```jsonc
"terminal": {
  "shell": {
    "with_arguments": {
      "program": "powershell.exe",
      "args": [
        "-NoLogo",
        "-NoExit",
        "-Command",
        "& \"$env:LOCALAPPDATA\\Programs\\Herdr\\bin\\herdr.exe\"",
      ],
    },
  },
},
```

- フルパス指定なのでPATH未反映でも動く。herdr終了後は`-NoExit`で通常のPowerShellに戻る
- Zedのターミナルは新規タブも毎回herdrで起動する。普通のシェルが要るときはherdr内で分割するか、この設定を外す
- 編集前に `settings.json` をバックアップしておくこと
- Zedのターミナルパネルでherdrが起動することは確認済み。ペイン分割・エージェント状態表示などの実操作は未確認

## Desktop App版（herdr-app）

standalone TUI版とは別インストール・別ソケット（上記の注意参照）。2026-11、Claude Codeセッションから実際に動作確認済み。

### 導入
```powershell
curl.exe -fsSL https://releases.herdr.dev/app/install.ps1 -o install.ps1
# 中身確認後
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```
- `herdr-app.exe`（GUI本体）と`herdr-core.exe`（バックエンド、CLIコマンド名は`hc`）がインストールされる
- `hc`のインストール先例: `C:\Users\<user>\AppData\Local\Programs\herdr-core\hc.exe`（ユーザーPATHに自動追加）
- Desktop AppのGUIは「ワークスペース→タブ→ペイン」の階層を持つが、これは**GUI専用のレイヤーで`hc`にはpane/tab/workspaceの概念が無い**。`hc`から見えるのはフラットな「terminal」一覧（`t1`, `t2`...）のみ

### 動作確認済み（2026-11）
- `hc run --bg <コマンド>` で新規terminalを作成し、GUI上に新規タブとして出現することを確認
- `hc ls` / `hc get <t>` / `hc read <t> [--lines N]` でterminal一覧・詳細・画面内容の取得を確認
- `hc send <t> "<テキスト>"` でterminalへの文字列送信＋Enterを確認
- `hc wait <t> [--timeout N]` でterminalの処理完了待ちを確認
- `hc attach <t>` で現在のペインの表示を別terminalの内容に乗り換えられることを確認（`Ctrl+\`でdetach）
- エージェント検出: `hc get <t>`の`status`フィールドに`{"app": "<エージェント名>", "state": "idle|working|blocked"}`が出る。検出ルールは`%LOCALAPPDATA%\herdr\agent-detection\remote\<エージェント名>.toml`で定義（例: `agy.toml`はAntigravity CLI用、エイリアス`antigravity`/`antigravity-cli`）

### GUIのタブ/ペイン操作の制約
- GUIのタブ間でterminalを跨ってドラッグ移動する操作（タブそのものをドラッグ、右クリック→Split等）は**効かない**
- バイナリの文字列から判明した制約: 「ペイン上部ホバーでグリップ（ドット）が出てドラッグ開始できる」が、**ズームされたタブと1ペインのみのタブはそもそもドラッグ不可**。既に2ペイン以上に分割済みのタブ内でのペイン入れ替えにしか使えない
- `herdr pane move` / `herdr workspace` 等のCLIサブコマンドはstandalone TUI版（別ソケット）のものであり、Desktop Appには効かない（サーバーが別、`server_not_running`エラーになる）

### 別タブのエージェントを今のペインに引き込む回避策
GUIドラッグが使えない1ペインタブのterminalを、別タブの既存ペインに持ってきたい場合:
1. 持ってきたい側のペイン（空のシェルでよい）に移動
2. そこで `hc attach <持ってきたいterminalのID>` を実行
3. そのペインの表示が対象terminalの内容に切り替わる（GUI上は元のタブ自体は残るが、実質的に目的のペインで操作可能になる）

### 他エージェントへのタスク委譲パターン
Herdr配下の別agent terminal（例: Antigravity CLIの`agy`）に対して、Claude Codeセッションからタスクを投げて結果を回収する一連の流れ:
```bash
hc send t3 "<依頼内容>"
hc wait t3 --timeout 180
hc read t3 --lines 400
```
- `hc wait`はデフォルト180秒でタイムアウトする（`--timeout`で延長可）
- `hc read`は`--lines`を指定しないと直近の画面表示分しか取れない（狭いペインだと折り返しで読みにくいので多めに指定する）

### 参考にしたが使えないもの
- [zerdr](https://github.com/ryonakae/zerdr)（Zed Terminal ThreadsとHerdrタブの自動紐付け、`zerdr connect`等）: **macOS/Linux専用**。SSH・WSL・コンテナでも実行拒否されるため、Windowsでは使えない。導入は`brew install ryonakae/tap/zerdr`または`cargo install --git`
- X記事（MegaBlackLabel）: ログイン必須（HTTP 402）で本文を取得できず、内容は未反映

## 注意
- 既存のherdrペイン内（Windows Terminalのherdr起動済みウィンドウの新規タブなど）で`herdr`を再実行すると `error: nested herdr is disabled by default.` になる。ペイン内ではキーバインド（`Ctrl+B` → `v`/`c`）を使う。許可する場合は `%APPDATA%\herdr\config.toml` に `[experimental]` / `allow_nested = true`
- 新規PowerShellで`herdr`が認識されない場合、PATH更新がExplorer側に反映されていない。サインアウト→サインインか、`& "$env:LOCALAPPDATA\Programs\Herdr\bin\herdr.exe"` で起動する
- Herdr内でClaude Codeを起動しても、ホストの `~/.claude`（hook・CLAUDE.md・statusline）はそのまま使われる（隔離はしない）
