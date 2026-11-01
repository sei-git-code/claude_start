# Claude Code月次サーベイ（未導入・調査ログ）

Claude Code新機能・Opus系モデル最適化設定を毎月調査した記録。導入判断は都度見送ってよく、ここには結果だけ残す。新しい月の調査結果は、このファイルの一番上（このすぐ下）に追記していく。

## 2026-11 調査分

出典: 公式 [changelog](https://code.claude.com/docs/en/changelog)（v2.1.292〜v2.1.316、2026-10-06〜10-31分を精読）、公式 [whats-new](https://code.claude.com/docs/en/whats-new)（Week 37=9/7〜11が最新掲載で、Week 38以降は目次に掲載なし＝週次ダイジェスト形式が更新されていない可能性）。非公式情報（[havoptic.com](https://www.havoptic.com/releases/claude-code/2026/10)等）は項目ごとに注記のうえ参考程度に留めた。

### A. 新機能候補（このリポジトリのカタログには未収録）

1. **`permissions.blockWritesOutsideWorkingDirectories`**（v2.1.314, 10/30） — 有効にするとWrite/Edit/NotebookEditが作業ディレクトリ外へのパスをどの権限モードでも拒否するようになる。`modules/security-guardrails`の「最小権限permissions」と同系統の設定項目として候補になりうる。
2. **`/auto-mode-setup`**（v2.1.304, 10/19） — プロジェクトと直近セッションを読んでauto modeの挙動をガイド付きで設定するコマンド。auto modeは8/14からPro/Max/Teamで既定の権限モードになっている（2026-08サーベイ既出）が、その設定支援コマンドは新規。
3. **Hookの`onFailure: "block"`**（v2.1.295, 10/8） — command/HTTP hookが起動失敗・タイムアウト・異常終了した際に、素通りさせず操作をブロックする指定。`modules/security-guardrails`のhook群（危険Bashコマンド遮断等）を導入済みなら、hook自体がクラッシュした場合のフェイルセーフとして関連する。
4. **アイドル時の自動コンパクション**（v2.1.299, 10/14） — 20万トークン超の会話が約54分アイドルすると、1時間のプロンプトキャッシュが切れる前に自動要約される（`idleCompaction`設定、`CLAUDE_CODE_IDLE_COMPACT_MIN_TOKENS`で閾値変更可）。長時間アイドルしがちな運用（本リポジトリのクラウドルーティン群）に関係する可能性があるが、キャッシュ切れ対策として自動で働くものなので対応不要。
5. **Agent toolの`effort`パラメータ**（v2.1.292, 10/6） — サブエージェントごとに実行effortレベルを指定可能になった。本サーベイ自身を実行している今回のAgent toolにも`effort`パラメータが存在し、実際に機能していることを確認した。
6. **`CLAUDE_CODE_SUBAGENT_EFFORT`環境変数**（v2.1.316, 10/31） — 個別指定がない場合のサブエージェント既定effortを設定できる（未指定時はセッションのeffortを継承）。
7. Mods（プラグインがClaude Code自体のUI・挙動を拡張する仕組み）の継続拡充 — `virtualText`、`prompt.change`フック、`$.ui.notify`等が10月中に次々追加されている。本リポジトリに自作プラグイン/modはまだ無いため即時適用先はないが、`modules/plugins`に将来modベースのプラグインを追加する際の前提知識になる。

### B. 最新モデルの最適化設定・デフォルト変化（個々のユーザー設定ではなくClaude Code全体の既定・挙動）

- **Claude Haiku 5.5**（`claude-haiku-5-5`、v2.1.293, 10/7）がAnthropic APIの既定Haikuモデルになった。1Mコンテキスト窓、$0.10/$0.50 per MTok（10万トークン超のプロンプトは$0.50/$2.50）。
- **Sonnet 5.5**が実運用で確認された（v2.1.296, 10/9でキャッシュ読み出し価格が$0.20→$0.10/MTokに変更）。2026-09時点では「予告のみ」だったが、10月中に実際にリリース・値下げが行われている。
- **Fast modeがOpus 4.8で非推奨化**（2026-10-30非推奨、2026-11-30廃止予定、v2.1.316） — 廃止後はOpus 4.8でのfast modeリクエストはエラーになり標準Opus 4.8へのフォールバックもしない。公式changelogはOpus 5.5への移行を推奨している。
- **`ultrathink`キーワードの挙動変更**（v2.1.311, 10/26） — ターミナルで`ultrathink`と打つとOpus 5.5 / Sonnet 5.5 / Haiku 5.5 / Fable 5.1（Anthropic API経由）でそのターンがxhigh effortで実行されるようになった。`CLAUDE_CODE_DISABLE_ULTRATHINK`で無効化可能（v2.1.316）。
- モデル名の`[1m]`サフィックスは、効果がない場面では表示上省略されるようになった（受理は継続、v2.1.311）。
- Claude Opus 6については、一部の非公式記事（tech-insider等）が「10月第3週に出るとの未確認の噂」を報じているのみで、Anthropic公式の発表・モデルカード・料金ページは確認できなかった（2026-11-01時点、WebSearchで `site:anthropic.com` を含めて確認）。**未確認情報として記録するのみ**。

### 判断（今回は調査記録のみで自動導入はしない）

上記はいずれも調査記録であり、本リポジトリのカタログ・`modules/`配下への実装は行っていない。`permissions.blockWritesOutsideWorkingDirectories`とhookの`onFailure: "block"`は`security-guardrails`との関連が深いため、次回ユーザーと確認する際の候補として記録した。Fast mode廃止（Opus 4.8→Opus 5.5移行）はこのリポジトリの設定ファイルには影響しないが、Opus系モデルを使う場合の既知情報として残す。

---

## 2026-09 調査分

出典: `stock/ストック.md` S-05・S-12・S-19・S-28（note/Zenn/X/公式ドキュメントを検索して収集、いずれも本文精読はしていない未検証情報）。

### A. Opus 5.5（2026-09-22リリース）とClaude Codeへの影響

- Fable 5.1相当の性能、Opus 5比で約40%低コスト・約30%高速。料金は入力$4/出力$20 per MTok（Opus 5比 $5/$25から低下）、キャッシュ読み出し$0.20/MTok
- **Claude Codeの5時間セッション上限が20%増加**。料金が下がった分だけ上限内で約25%長く使える。Pro/Max/Teamは使用量リセットあり
- Pro/Max/Teamでは既定Opusモデルになる。thinkingは常時オン、effortの既定はmedium
- 現状 `~/.claude/settings.json` は `"model": "sonnet"` 固定のため影響なし。Opusに切り替える場合の参考情報として記録するのみ、設定変更はしない
- 出典: [TechCrunch](https://techcrunch.com/2026/09/22/anthropic-releases-opus-5-5-with-lower-prices-and-fable-level-performance/)、[Anthropic公式](https://www.anthropic.com/claude-opus-5-5)、[@claudeai](https://x.com/claudeai/status/2102435511222890900)、[@_catwu](https://x.com/_catwu/status/2102437713781944397)、[@ClaudeDevs](https://x.com/ClaudeDevs/status/2102438800836489554)

### B. Claude Code Projects（ベータ、2026-09-17〜）

- 1つのプロジェクトが並列スレッド・共有メモリ・プロジェクトライブラリを調整する新しいクラウド機能。各スレッドは別のクラウドセッション（ブランチ・リポジトリコピーも別）で、テスト実行やPR作成まで独立に行う。ノートPCを閉じても継続
- 一部のPro/Maxユーザー向けベータ。このリポジトリのCLIカタログ（ローカル設定・hook・プラグイン）の対象外だが、`modules/herdr`（並列エージェント管理）と目的が近く、比較対象として覚えておく価値あり
- 出典: [MarkTechPost](https://www.marktechpost.com/2026/09/17/anthropic-launches-claude-code-projects-in-beta-parallel-cloud-sessions-that-keep-running-after-you-close-your-laptop/)、[DevOps.com](https://devops.com/anthropic-adds-a-coordinator-to-claude-projects-for-running-ai-work-in-parallel/)

### C. Skills / hooksのfrontmatter拡張（Claude Code 2.1系）

自作skillを作る際の参考知識。今のところこのリポジトリに自作skillは無いため、即座の適用先はない。
- skillは既定で `/` から見える。`user-invocable: false` で人間から隠しClaudeだけが使えるskillにできる。`disable-model-invocation: true` はその逆（人間だけが呼べる）
- agentのfrontmatterに `PreToolUse`/`PostToolUse`/`Stop` のhookを書くと、そのagentの実行中だけ有効（agent-scoped hooks）。今の`modules/security-guardrails`のhookはグローバル（`~/.claude/settings.json`）設定で全セッション共通なのとは別の仕組み
- skillのfrontmatterに `context: fork` を付けると、skill本文がsubagentへのプロンプトになりメインの会話コンテキストを消費しない
- 出典: [Daniel San](https://x.com/dani_avila7/status/2009620498573873379)、[Eric Buess](https://x.com/EricBuess/status/2009073718450889209)

### C-2. Sonnet 5.5 / Haiku 5.5（予告のみ）

Opus 5.5と同時に「数週間以内に続く」と予告されている。詳細未発表のため続報待ち。

### D. 調査に使った情報源（定点観測先）

- 公式変更履歴: [code.claude.com/docs/en/whats-new](https://code.claude.com/docs/en/whats-new)（週次まとめ、日本語版は`/docs/ja/whats-new`）、[changelog](https://code.claude.com/docs/en/changelog)（全変更）
- 非公式まとめ: [Claude Code Changelog（X: @ClaudeCodeLog）](https://x.com/ClaudeCodeLog)、[gradually.ai](https://www.gradually.ai/en/changelogs/claude-code/)、[Releasebot](https://releasebot.io/updates/anthropic/claude-code)、[Havoptic](https://www.havoptic.com/tools/claude-code)
- X検索は `WebSearch` に `allowed_domains: ["x.com", "twitter.com"]` を指定すると可能（本文は取得不可、スニペットのみ）

### 判断

今回も全項目見送り。Opus 5.5への切替、Projects活用は、実際に必要になった時点で再検討する。

---

## 2026-08 調査分

### A. 新機能候補（このリポジトリのカタログには未収録）

1. **Opus 5対応確認** — `opus`エイリアスはv2.1.219以降Opus 5に解決済み。`claude update`でバージョン確認要（それ未満だと旧モデルのまま）。
2. **Fast Mode（`/fast`）** — Opus 5/4.8限定、応答最大2.5倍高速。$10/$50 per MTok（usage credits消費）。Team/Enterpriseは管理者の事前有効化が必要。
3. **`/effort ultracode`** — 複雑タスクを動的ワークフローに分解し、xhigh推論で処理する新モード。セッション限定設定。
4. **Routines**（`/schedule`, claude.ai/code/routines） — プロンプト＋リポジトリ＋トリガー（schedule/API/GitHub）をクラウド常駐実行、PC閉じても継続。既存`modules/ping-routine`（5時間ウィンドウ固定用途専用）とは別物、汎用自動化機能。Pro 5回/日、Max 15回/日上限。
5. **Cowork**（Claude Desktopアプリ内） — ターミナル不要でフォルダ指定作業。別アプリのためこのCLIカタログの対象外、参考情報止まり。
6. **settings.jsonへの`$schema`参照追加** — エディタ補完・バリデーションが効くようになる低コストな改善。
7. **`additionalDirectories`** — 複数リポジトリ横断作業を常用するなら候補。

### B. Opus 5最適化設定（`~/.claude/settings.json`確認済み）

- `"model": "sonnet"` に固定中 → Opus 5リリース後もSonnet 5使用が継続する。プラン（Pro/Max/Team等）で既定値が異なる（Max/Team/Enterprise/APIは既定Opus、Proのみ既定Sonnet）ため要判断。
- `effortLevel`未設定 → 既定`high`（Opus 5もこれに対応）。変更不要、必要な時だけ`/effort`で都度切替が実用的。
- `alwaysThinkingEnabled`未設定 → OFF。Opus 5は常時adaptive reasoningなので基本問題なし。
- `fallbackModel`未設定 — Opus混雑時にSonnet/Haikuへ自動フォールバックさせたいなら設定余地あり。
- 1M拡張コンテキスト — Max/Team/EnterpriseならOpus自動適用、Proはusage credits要。

### 判断

今回は全項目見送り。プラン変更やOpus 5の安定運用実績が出たタイミングで再検討する。

---
