# Claude Code 月次調査ログ

このファイルは、Claude Code公式ドキュメント・Anthropic公式ブログ・主要技術記事サイトを月次で調査し、直近で追加・変更された新機能や、最新モデル世代（Opus/Sonnet/Haiku/Fable）に対するClaude Code側のデフォルト設定（モデル・effort・fast mode等）の変化を記録するための調査ログである。

**このファイル自体はカタログ（`modules/`）ではない。** ここに書かれた項目は「まだ導入判断をしていない調査結果」であり、ユーザーがこのリポジトリを開いた際に自動確認の対象になるものではない。将来、ある項目を導入することになった場合は、`modules/`配下にモジュールとして実装し、`CLAUDE.md`のカタログに追記したうえで、このファイルの記載は参考情報として残す。

各セクションは調査を実施した月の頭に追記し、新しいセクションほど上（この説明文の直後）に来るようにする。

---

## 2026-09 調査分

調査日: 2026-09-01。対象期間はおおむね2026年8月1日〜8月31日（Claude Code公式の週次ダイジェスト Week 32〜Week 34、および changelog v2.1.220〜v2.1.252）。

### A. 新機能候補（直近1ヶ月で追加・変更されたもの）

**セキュリティ・権限まわり（`modules/security-guardrails/`と関連が深いので特に要確認）**
- **auto modeがPro/Max/Teamの新規セッションでデフォルトの権限モードになった**（2026年8月14日〜）。分類器が安全な操作は自動実行し、リスクのある操作はバックグラウンドの安全チェックでブロックする方式。従来「確認ゲート」を個別hookで実装していたこのリポジトリの方針と重なる／競合する可能性があるため、次回カタログ提示時に個別確認が必要。[Week 32ダイジェスト](https://code.claude.com/docs/en/whats-new/2026-w32)
- **`PreModelSwitch` / `PostModelSwitch` フック**が追加された（v2.1.251, 2026-08-28）。モデル切り替えをブロック・確認・注釈付けできる。既存の`hooks/confirm-irreversible.sh`と似た「確認ゲート」パターンで応用できそう。[changelog](https://code.claude.com/docs/en/changelog)
- **`--restricted`モード**が追加された（v2.1.248, 2026-08-27）。組み込みのコマンド実行・コード実行系ツールを丸ごと外して起動できる。最小権限方針の一環として検討価値あり。
- セキュリティ修正: ファイルツールでのシンボリックリンクトラバーサル、プラグインのコマンドパス検証の脆弱性が修正された（v2.1.251）。導入済み機能ではないが、既存hookの設計時の参考になる。

**新機能（今回はカタログ化していない）**
- **`/design`**（research preview）: CLI/Desktop上でClaude Designのアートボード編集ワークフローを使える。アイデアやスクリーンショットから編集可能なUIを起こせる。[Week 34ダイジェスト](https://code.claude.com/docs/en/whats-new/2026-w34)
- **Conciseアウトプットスタイル**（組み込み）: 結果を先に出し前置きを省略する。`reference/advanced-features-2026.md`に記載のExplanatory/Learningモードとは別の、新しい組み込みスタイル。
- **`ANTHROPIC_DEFAULT_MODEL`環境変数**: 新規セッションの開始モデルを設定できる（`/model`で選び直せばそちらが優先され再起動後も維持される）。
- **fork modeがインタラクティブセッションでデフォルトON**（Week 33）: サイドタスクを会話全体を引き継いだサブエージェントに渡せる。既存の`reference/advanced-features-2026.md`記載のサブエージェント入れ子（v2.1.172時点の話）とは別物で、その後の発展。
- **GitLabマージリクエスト対応**（`--worktree`、`claude agents`ビュー、素の`gitlab.com` URLのマーケットプレイスclone）。
- **`@`でセッション間メンション**（Week 33）、**クロスセッションメッセージング**（macOS/Linuxで先行、Windowsも追随）。
- **セルフホスト環境**（Team/Enterprise、パブリックベータ）: 自社インフラでClaude Codeのクラウドセッションを実行できる。
- **スペルチェック**（v2.1.235、オプション、入力中の誤字をハイライト）。
- **`SendFeedback`ツール**: セッション中に問題が起きた際、フィードバック報告書をClaudeが下書きし`/feedback`から送信確認できる。
- **`/cost`にセッション単位のプロンプトキャッシュ行**（ヒット率・キャッシュ指標）が追加（v2.1.251）。
- **`experimental.cacheTtl`**: エージェントfrontmatterでプロンプトキャッシュTTLをエージェント単位に指定できる（v2.1.248）。

### B. 最新モデルの最適化設定・デフォルト変化（Claude Code全体としての挙動）

- **アカウント種別ごとのデフォルトモデル**: Max/Team Premium/Enterprise/Anthropic APIはOpus 5、Pro/Team StandardはSonnet 5がデフォルト（Opus 5自体は2026年7月下旬に登場し継続中）。[モデル設定ドキュメント](https://code.claude.com/docs/en/model-config)
- **effortのデフォルトは現行世代モデル（Fable 5, Opus 5, Sonnet 5, Opus 4.8）で"high"**。旧世代のOpus 4.7のみ"xhigh"がデフォルトで残っている。
- **Opus 5にはeffortの「持ち越し」がない**: Opus 4.7/4.8やFable 5は初回起動時に選んだeffortをセッションをまたいで保持する仕様だが、Opus 5はこの保持機能を持たない（都度デフォルトのhighに戻る）。
- **fast mode**: Opus 5で引き続き利用可能（research preview、$10/$50 per MTok、通常比で最大2.5倍の出力速度）。インタラクティブな往復が多い場面向けで、バッチ処理向けではないという位置付けは変わらず。
- 以上より、モデル世代交代（Opus 5, Sonnet 5, Fable 5, Haiku 4.5）そのものは今回の調査期間より前（本セッション開始時点のシステム情報と一致）だが、Claude Code側のeffort/fast mode周りの扱いに8月時点で大きな仕様変更はなく、上記の「Opus 5はeffortを持ち越さない」点が唯一の新規確認事項。

### 判断

今回はあくまで調査記録の更新であり、上記のいずれについても`modules/`への実装やカタログへの正式追加は行っていない。特にauto modeのデフォルト化、`PreModelSwitch`/`PostModelSwitch`フック、`--restricted`モードの3点は既存の`security-guardrails`モジュールと重なる領域のため、次回このリポジトリを開いた際に、他のカタログ項目と同様に1つずつユーザーへ導入可否を確認すること。

**参考情報源**
- [Claude Code Docs: What's new](https://code.claude.com/docs/en/whats-new)
- [Week 32ダイジェスト](https://code.claude.com/docs/en/whats-new/2026-w32)（2026-08-03〜08-07）
- [Week 33ダイジェスト](https://code.claude.com/docs/en/whats-new/2026-w33)（2026-08-10〜08-14）
- [Week 34ダイジェスト](https://code.claude.com/docs/en/whats-new/2026-w34)（2026-08-17〜08-21）
- [Claude Code Changelog](https://code.claude.com/docs/en/changelog)（v2.1.220〜v2.1.252）
- [Model configuration - Claude Code Docs](https://code.claude.com/docs/en/model-config)
- [What's new in Claude Opus 5 - Claude Platform Docs](https://platform.claude.com/docs/en/about-claude/models/whats-new-opus-5)
