# 2026年時点の発展的機能（未導入・参考情報）

## 出力スタイル
`/config` で切り替え。Explanatoryモードは作業中にフレームワークや設計判断を解説しながら進める。Learningモードはユーザー自身に実装させてコーチする。今は標準のまま。

## サブエージェントの入れ子（isolation: worktree）
Claude Code v2.1.172以降、サブエージェントが自分でサブエージェントを生成できる。例: レビュー系サブエージェントが指摘ごとに検証用サブエージェントを分岐させる。`isolation: worktree` をエージェントのfrontmatterに加えると、並列作業をworktreeごとに安全に分離できる。大規模な並列バッチ作業や本格的なレビューパイプラインを作りたくなったら検討する。

## キュレーションリスト（ブラウズ用、導入対象ではない）
- [awesome-claude-md](https://github.com/josix/awesome-claude-md) — 108個の実例CLAUDE.mdをカテゴリ・言語で検索できる（Sentry, Cloudflare, Microsoft, Ethereum, LangChain等）
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) — スラッシュコマンド・CLAUDE.md・CLIツール・ワークフローの総合キュレーション
- [awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) — 135エージェント・35スキル・42コマンド・176+プラグインの大規模カタログ

## Boris Cherny本人の並列セッション運用（未導入）
ターミナル5+ブラウザ5〜10+モバイルで常時10〜15並列セッション。このリポジトリのモジュールには含めていない（ワークスタイルの問題であり、ファイルとして配布できるものではない）。参考: 各セッションをgit worktreeで分離すると衝突を避けやすい。
