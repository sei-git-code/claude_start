## 機密情報の取り扱い

- `.env` ファイルの内容をそのままコード・コミット・出力に含めないこと
- API キー・認証トークン・パスワードは環境変数の参照（`process.env.API_KEY` 等）で扱い、値を直書きしないこと
- シークレットを含む可能性があるファイルを外部 URL に送らないこと
- コミットメッセージに機密情報を含めないこと

## 自動で止まる操作（hook による遮断）

以下の操作は hook で自動遮断されます。止まった場合は手動で実行してください。

- rm -rf 系のコマンド
- git push --force
- curl / wget のパイプ実行（curl ... | bash 等）
- chmod 777

## 確認ゲートが出る操作

以下の操作は実行前に確認ダイアログが表示されます（TTYが取得できない場合は確認なしで通過し、ログにのみ記録されます）。

- git push（通常の push を含む）
- npm publish
- docker push
- git reset --hard / git clean -f / git stash drop
