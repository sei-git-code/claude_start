# プラグイン

4つの独立したプラグイン。それぞれ個別に導入可否を確認すること。

## genshijin
日本語応答の敬語・クッション言葉を削減し、トークンを約75〜80%削減する（技術情報は保持）。PR圧縮・コミットメッセージ生成の補助機能もある。
公式マーケットプレイスには収録されていない（記事の「公式プラグイン」表記は不正確）。開発元（InterfaceX-co-jp）の自己ホスト型マーケットプレイスから入れる。
```bash
claude plugin marketplace add InterfaceX-co-jp/genshijin
claude plugin install genshijin@genshijin
```

## superpowers
要件ヒアリング→仕様確定→実装計画承認→TDD→セルフレビュー2回、という規律だった実装フローを強制する（obra開発）。
```bash
claude plugin marketplace add obra/superpowers-marketplace
claude plugin install superpowers@superpowers-marketplace
```

## dig
実装計画の暗黙的な前提をリスクの高い順に洗い出し、多層的に深掘り質問する（fumiya-kume開発）。`/dig`で起動。
マーケットプレイスは `fumiya-kume/claude-code` を追加すると `kuu-marketplace` として登録される（登録名が固定なのでこの名前でインストールする）。
```bash
claude plugin marketplace add fumiya-kume/claude-code
claude plugin install dig@kuu-marketplace
```

## designer-skills
実装計画の穴を潰すためのデザインプロセスを、Claude Codeのスキルとして再現する8つのコマンド（`/grill-me` → `/design-brief` → `/information-architecture` → `/design-tokens` → `/brief-to-tasks` → `/frontend-design` → `/design-review`、全体を通す`/design-flow`）。julianoczkowski開発。
note.com/isaot の「実際のデザインプロセスに従う7つのClaude Codeデザインスキル」という記事の実体。UIを作るプロジェクトができてから使うと効果が分かりやすい。
```bash
claude plugin marketplace add julianoczkowski/designer-skills
claude plugin install designer-skills@designer-skills
```

## 動作確認
```bash
claude plugin list
```
