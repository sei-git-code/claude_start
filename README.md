# claude_start

個人用の Claude Code カスタマイズカタログです。Zennやnote、Qiitaなどで見つけたClaude Code関連記事を実際に検証し、有効だったものをここにまとめています。

## 使い方

1. このリポジトリをクローンする
   ```
   git clone https://github.com/sei-git-code/claude_start.git
   ```
2. クローンしたディレクトリで `claude` を起動する（または既存プロジェクトから `claude --add-dir` で読み込む）
3. Claude が `CLAUDE.md` のカタログを提示するので、導入したい項目を1つずつ選ぶ

自動で一括導入はされません。各項目はClaudeが個別に確認してから適用します。

## 中身

- `modules/` — 実際に導入可能な設定・スクリプト
- `reference/` — 検討したが導入は見送った項目（入手先・理由を記録）
- `CLAUDE.md` — Claude Code向けの振る舞い指示（カタログ本体）

## 経緯

2026-07-18、以下の記事を起点に整備しました。
- [Claude Codeが化けた。今使っている3つのプラグイン+標準機能の活用法](https://zenn.dev/sonicmoov/articles/8712598f532b18)
- [Claude Code セキュリティガードレール 実装テンプレ集](https://qiita.com/nogataka/items/bab35c7b58a664d3b8f1)
- [実際のデザインプロセスに従う7つの Claude Code デザインスキル](https://note.com/isaot/n/nfc1861775ec3)（実体: [julianoczkowski/designer-skills](https://github.com/julianoczkowski/designer-skills)）
