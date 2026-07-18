# Unity開発関連

## unity-coding-skills（導入済み）
出典: [nowsprinting/unity-coding-skills](https://github.com/nowsprinting/unity-coding-skills)（日本のUnityテスト分野で著名な開発者による）

Unity C#のテスト駆動開発（TDD）ワークフロー用のClaude Codeプラグイン。9スキル + 3サブエージェント。
```bash
claude plugin marketplace add nowsprinting/unity-coding-skills
claude plugin install unity-coding-skills@nowsprinting-unity-coding-skills
```

含まれるスキル: code-writing-guide, test-designing-guide, test-writing-guide, edit-scene, run-tests, fix-bug, plan-feature, refine-tests, unity-yaml-editing-guide
含まれるサブエージェント: failing-test-writer, test-designer, test-deduplicator

**注意**: `edit-scene` と `run-tests` はJetBrains MCP（`http://localhost:64342/stream`）との連携が前提。JetBrains IDE（Rider等）でUnityプロジェクトを開いている必要がある。

## Unity MCP（前提のみ準備済み・Unity側の接続は未完了）
出典: [CoplayDev/unity-mcp](https://github.com/CoplayDev/unity-mcp)（無料・MIT）

Unity Editorと直接つながるMCPサーバー。GameObject操作・シーン編集・コンソール確認・スクリプト編集をClaude Codeから直接行える。Unity 2021.3 LTS〜6.x対応。

### 前提（インストール済み）
```bash
winget install Python.Python.3.12
winget install astral-sh.uv
```

### 残りの手順（Unity Editorでプロジェクトを開いてから）
1. Unity Package Managerで `https://github.com/CoplayDev/unity-mcp.git?path=/MCPForUnity#main` を追加
2. Unity Editorのメニュー: `Window → MCP for Unity → Configure All Detected Clients` を実行（Claude Codeを自動検出して接続設定される）

**注意**: 2026-07-18時点でこのマシンにUnity Editor/Hub自体が未インストール。Unity側のメニュー操作が必須の仕様のため、CLIだけでは完了できない。
