# カスタムスラッシュコマンド

## /commit-push-pr
ステージング→コミット→push→PR作成を一気に行う（Boris Cherny流）。

### 前提
`gh` CLI が必要。インストール後、`gh auth login` で認証しておく（ブラウザ認証が必要なため対話操作。Claude側からは完了できない）。

```bash
winget install GitHub.cli   # Windows
# または brew install gh    # Mac
gh auth login
```

### 導入手順
```bash
mkdir -p ~/.claude/commands
cp commit-push-pr.md ~/.claude/commands/
```
以降、Claude Codeで `/commit-push-pr` と入力すると起動する。
