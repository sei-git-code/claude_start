# 計画と自己改善ログ（Boris Cherny流）

出典: Boris Cherny（Claude Code作者）の運用スタイルの紹介記事群。本人のXでの発言を元にした二次資料であり、本人の実ファイルそのものではない可能性がある点に注意。

Cherny氏のCLAUDE.mdは驚くほど短い（約100行・2.5kトークン）。中身より「型」が特徴で、このモジュールはその型のうち2つをCLAUDE.mdのルールとして取り込んだもの。

## 導入手順
`claude-md-snippet.md` の内容を `~/.claude/CLAUDE.md`（グローバル）または `<project>/.claude/CLAUDE.md`（プロジェクト単位）に追記する。

## 中身
- **Plan Modeのデフォルト化**: 3ステップ以上のタスクはPlan Modeから始める
- **自己改善ログ**: ユーザーの指摘を `tasks/lessons.md` に記録し、次のタスク開始前に読み返す

## 関連（未導入）
- `/commit-push-pr` カスタムコマンド（`../commands/commit-push-pr.md`）
- 10〜15並列セッション運用、`isolation: worktree` — このリポジトリには含めていない。必要になったら公式ドキュメントの sub-agents / agent-view を参照
