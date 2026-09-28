# Claude Code月次サーベイ（未導入・調査ログ）

Claude Code新機能・Opus系モデル最適化設定を毎月調査した記録。導入判断は都度見送ってよく、ここには結果だけ残す。新しい月の調査結果は、このファイルの一番上（このすぐ下）に追記していく。

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
