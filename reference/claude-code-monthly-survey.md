# Claude Code月次サーベイ（未導入・調査ログ）

Claude Code新機能・Opus系モデル最適化設定を毎月調査した記録。導入判断は都度見送ってよく、ここには結果だけ残す。新しい月の調査結果は、このファイルの一番上（このすぐ下）に追記していく。

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
