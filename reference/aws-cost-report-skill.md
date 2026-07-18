# AWS コスト削減 Skill（未導入・参考情報）

出典: [ClaudeCodeのSkillsを利用してAWSのクラウド利用費を削減する](https://zenn.dev/solvio/articles/f30ebba876b93c)

## 配布元
記事中の元リポジトリ `solvio-dev/aws-cost-report-skill` は移転済み。現在の配布元:
```bash
git clone https://github.com/solvio-dev/solvio-public-skills.git
cp -r solvio-public-skills/skills/aws-cost-report ~/.claude/skills/
```
`/plugin install`形式ではなく手動git clone + コピー。

## 前提となる作業（AWS側で1回だけ）
1. 読み取り専用IAMユーザー `cost-report` を作成（`ViewOnlyAccess` + Cost Explorer/apprunner/secretsmanager/tag関連の補完インラインポリシー）
2. アクセスキーを `~/.aws/credentials` の `[cost-report]` プロファイルとして登録（値そのものはAIに貼らない）
3. `aws ec2 create-key-pair --profile cost-report` がAccessDeniedになることを確認して読み取り専用を検証

## なぜ未導入か
AWS利用者ではあるが、IAMユーザー作成などAWSアカウントへの実変更を伴うため、判断を保留した。導入する場合は上記手順を実行してから `/aws-cost-report` が使えるようになる。

設計思想（AIは分析・スクリプト生成まで、削除の実行は必ず人間）は他のクラウド（Azure/GCP）にも応用可能。
