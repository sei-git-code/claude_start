# Gemini 3.5 Transcribe 音声入力

出典: [Google発表記事（ケータイ Watch）](https://k-tai.watch.impress.co.jp/docs/news/2129086.html)、[公式APIドキュメント](https://ai.google.dev/gemini-api/docs/transcribe)（2026-08時点で内容確認済み）

Google が2026-08-26に発表した音声認識モデル「Gemini 3.5 Transcribe」を使い、マイク入力をテキスト化してClaude Codeのターミナルに自動タイプ入力する。smart transcriptionモードにより「えー」「あー」等のフィラーワードや言い淀みを自動除去した状態でテキストが返ってくる。

`../../reference/8bitdo-voice-input.md`（物理コントローラー＋OS標準Dictation、未導入）とは別アプローチ。ハードウェア不要、Googleの音声認識APIのみで完結する。

## 前提

- Python（このマシンでは3.12.10で動作確認済み）
- Google AI Studio（https://aistudio.google.com/）でのAPIキー発行（**本人操作必須**。ブラウザ操作が伴うため、素のブラウザ・素の端末で行う。Claude Code経由の疑似端末は使わない）
- マイク（OS側のマイクアクセス許可が必要）

## 無料枠についての注意

クレジットカード登録不要の無料ティアが利用できるが、**無料ティアで送信した内容はGoogleの製品・サービス改善に利用される可能性がある**。プライバシーを重視する場合は有料ティアに切り替えること。

## セットアップ手順

### 1. APIキー発行（本人操作）
[Google AI Studio](https://aistudio.google.com/) でAPIキーを発行する。

### 2. 依存パッケージ導入（動作確認済み）
```bash
pip install google-genai sounddevice soundfile keyboard numpy
```

### 3. APIキーを環境変数に設定
```bash
export GEMINI_API_KEY=your_api_key_here   # PowerShellなら $env:GEMINI_API_KEY="..."
```
**値をコード・コミット・チャットに直書きしない**（ユーザーのグローバルCLAUDE.mdの機密情報取り扱いルールに従う）。

### 4. 起動
claudeを動かしているターミナルとは別のターミナルで実行する。
```bash
python modules/voice-input-gemini/voice_input.py
```

### 5. 使い方
1. claudeのターミナルにフォーカスを移す
2. `F9` を押す → 録音開始
3. 話す
4. もう一度 `F9` を押す → 録音停止 → Gemini 3.5 Transcribeで文字起こし（smartモードでフィラー除去）→ アクティブウィンドウ（＝claudeのターミナル）に自動タイプ入力 → Enterで自動送信

## 動作確認状況

- `pip install` によるライブラリ導入、および `import google.genai, sounddevice, soundfile, keyboard, numpy` の正常動作は確認済み
- 実際のマイク音声を使ったend-to-end（録音→文字起こし→自動タイプ）の動作確認は、GEMINI_API_KEY発行後にユーザー環境で実施すること（Claudeは音声入力を代行できないため未検証）

## 既知の制約

- `keyboard` ライブラリはWindowsでグローバルホットキーを扱うため、環境によっては管理者権限での実行が必要になる場合がある
- 認識→タイプ入力までに数秒のレイテンシがある（録音停止後、アップロード＋文字起こしの往復時間）
- ホットキー（`F9`）はスクリプト内の定数 `HOTKEY` を書き換えれば変更できる。GUI設定等は用意していない
- 一時WAVファイルは文字起こし完了後に自動削除される
