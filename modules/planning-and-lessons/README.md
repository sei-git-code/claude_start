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
- `/btw`（作業中に割り込みで質問。履歴を汚さず、作業を止めない。2026-03導入） — このリポジトリのルールと直接は重ならないが、Plan Mode運用と組み合わせると相性がよい。未導入（CLAUDE.mdルール化するような設定ではなく、単体のビルトインコマンドのため）
- git worktree 3〜5本を同時に開き、それぞれ別のClaude Codeセッションを走らせる運用（Cherny氏が「最大の生産性向上」と紹介） — 上記の10〜15並列運用と同系統。`superpowers:using-git-worktrees` skillが同種の機能を提供済みのため、このリポジトリへの追加モジュール化はしない
