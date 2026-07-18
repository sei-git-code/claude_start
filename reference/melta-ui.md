# melta-ui（未導入・参考情報）

出典: [デザイナーの脳内をコピーして、誰でも90点以上のUIを作れるようにする](https://note.com/toitoi1618/n/ndf35dbd2585b) の着想元。リポジトリ本体: [tsubotax/melta-ui](https://github.com/tsubotax/melta-ui)（公式サイト: melta.tsubotax.com）

「人間にも、AIにも、読めるデザインシステム」を掲げるOSS。Tailwind CSS 4 + TypeScript製MCPサーバー、Playwright+axe-coreテスト。28コンポーネント・101トークン・10ファウンデーション、MIT License。

## 接続コマンド（UIプロジェクトを始めたときに使う）
```bash
claude mcp add melta-ui -- npx -y melta-ds-mcp
```
接続すると `get_component` / `check_html`（生成HTMLの自己検証）などのツールをClaude Codeから直接呼べる。

## 構成
`design/contracts/` 配下に `tokens.json`（トークン）、`rules.json`（99の禁止パターン）、`components/*.contract.json`（機械可読仕様）。人間向けMarkdown（DESIGN.md、CLAUDE.md）と同じSSOTを参照する二層構造。

## なぜ未導入か
完成品CSSライブラリではなく「契約の雛形」。既存UI・トークンを持つ具体的なプロジェクトができてから接続するのが現実的。トークン化すべき既存デザインがない段階では接続の旨味が薄い。
