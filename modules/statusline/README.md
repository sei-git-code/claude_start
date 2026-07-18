# ステータスライン

モデル名・Gitブランチ・コンテキスト使用率ゲージ・5時間/7日ウィンドウ消費率・累積セッションコストを1行で表示する。

## 前提
`jq` が必要（`../jq/install-jq.sh` 参照）。

## 導入手順
```bash
mkdir -p ~/.claude
cp statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

`~/.claude/settings.json` に以下をマージする（既存設定を壊さないよう `jq` でマージすること）。
```json
{
  "statusLine": { "type": "command", "command": "bash ~/.claude/statusline.sh" }
}
```

マージ例:
```bash
tmp=$(mktemp)
jq '.statusLine = {"type":"command","command":"bash ~/.claude/statusline.sh"}' ~/.claude/settings.json > "$tmp" && mv "$tmp" ~/.claude/settings.json
```
