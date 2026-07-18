# Context7 MCP

出典: [upstash/context7](https://github.com/upstash/context7)

最新のライブラリ/フレームワークのドキュメントをオンデマンドで取得するMCPサーバー。学習データのカットオフによる古いAPI知識（存在しない関数を使おうとする等）を防ぐ。コーディング全般に効く汎用ツールで、他のプラグインと競合しない。

## 前提
Node.js / npx が必要（`../nodejs/README.md` 参照）。

## 導入
```bash
claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp
```
APIキーなしでも基本機能は使えるが、context7.com/dashboard で無料キーを取得すると利用上限が上がる（キーを使う場合は `--api-key YOUR_API_KEY` を付ける）。

## 動作確認
```bash
claude mcp list
```
`context7: ... - ✔ Connected` と表示されればOK。
