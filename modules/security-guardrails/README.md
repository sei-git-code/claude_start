# セキュリティガードレール

出典: [Claude Code セキュリティガードレール 実装テンプレ集](https://qiita.com/nogataka/items/bab35c7b58a664d3b8f1)

4つの独立した要素。**それぞれ個別にユーザーへ導入可否を確認すること**（まとめて一括導入しない）。すべて`~/.claude/`配下のグローバル設定が対象（プロジェクト単位にしたい場合は`.claude/`に読み替える）。

パターンマッチはコマンド文字列全体に対して行われるため、危険な文字列を含むだけの無害なコマンド（テストコマンド自体、`rm -r`を使った後片付けなど）にも反応することがある。導入時に一言添えること。

## 1. 最小権限 permissions（deny リスト）
`settings.snippet.json` の `permissions.deny` 部分だけを `~/.claude/settings.json` にマージする。
```bash
jq '.permissions.deny = ((.permissions.deny // []) + [
  "Bash(rm -rf*)","Bash(sudo rm*)","Bash(git push --force*)","Bash(git push -f*)",
  "Bash(chmod 777*)","Bash(curl * | bash)","Bash(wget * | bash)","Bash(eval*)"
] | unique)' ~/.claude/settings.json > /tmp/s.json && mv /tmp/s.json ~/.claude/settings.json
```

## 2. 危険Bashコマンド遮断hook（PreToolUse）
```bash
mkdir -p ~/.claude/hooks
cp hooks/guard-dangerous-bash.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/guard-dangerous-bash.sh
```
`~/.claude/settings.json` の `hooks.PreToolUse`（matcher: "Bash"）に `bash ~/.claude/hooks/guard-dangerous-bash.sh` を追加する。

## 3. 不可逆操作の確認 y/N ゲート（PreToolUse）
```bash
cp hooks/confirm-irreversible.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/confirm-irreversible.sh
```
同じく `hooks.PreToolUse`（matcher: "Bash"）に `bash ~/.claude/hooks/confirm-irreversible.sh` を追加する（2と同じmatcherの配列に並べてよい）。TTYが取れない環境（バックグラウンド実行等）では確認なしで通過し、ログにのみ記録する仕様。

## 4. 機密情報流出防止
```bash
cp hooks/scan-staged-secrets.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/scan-staged-secrets.sh
```
`hooks.PostToolUse`（matcher: "Bash"）に `bash ~/.claude/hooks/scan-staged-secrets.sh` を追加する。
加えて、`claude-md-snippet.md` の内容を `~/.claude/CLAUDE.md` に追記し、`claudeignore.template` をプロジェクトごとに `.claudeignore` としてコピーする（プロジェクト単位のファイルなのでグローバルには置けない）。

## settings.snippet.json について
`settings.snippet.json` は4要素すべてを導入した場合の完成形。実際にマージする際は、ユーザーが選んだ要素の `hooks.PreToolUse` / `hooks.PostToolUse` エントリだけを含めること。
