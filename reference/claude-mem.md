# claude-mem（未導入・参考情報）

出典: [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem)（6.5万スター超）

セッション中の作業を自動でAI要約し、SQLite+ChromaDBに保存、次回セッション開始時に自動で関連コンテキストを注入する永続記憶プラグイン。Codex/Gemini/Copilot等、Claude Code以外のツールにも対応。

```bash
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem@thedotmack
```
（`npm install -g claude-mem` だけではhookが登録されないため不十分。上記のplugin経由か `npx claude-mem install` を使うこと。）

## なぜ未導入か
Claude Code標準の「自動メモリ」機能、およびこのリポジトリのユーザーが日常的に使っている手動メモリシステム（`~/.claude/projects/*/memory/`）と役割が重なる。3つの記憶システムが競合・二重化するリスクを避けるため見送った。

導入したくなったら、まず標準の自動メモリ機能や手動メモリシステムとどう役割分担するかを整理してから入れること。
