# AWS DATA SYNC HUB

## 概要
このサービスは、Slackアプリを介して情報を受け取り、AWS App Runner上で動作するPythonプログラムを使用してデータを処理し、Amazon S3にデータを保存してAmazon Kendraでインデックスを作成し、Notionでの文書化を行います。

## 特徴
- Slackからのイベントをリアルタイムで処理
- AWS App RunnerでスケーラブルなPythonアプリケーションを実行
- S3バケットへのデータ永続化
- Amazon Kendraを使用したデータの検索可能なインデックス作成
- Notionとの統合によるドキュメント管理

## 事前条件
- AWSアカウント
- Slackアプリの設定
- Notion APIアクセス
- ECRへのDockerイメージのプッシュ

## セットアップ
### Terraformを使用したインフラストラクチャのセットアップ
1. `terraform init` を実行してTerraformを初期化します。
2. `terraform plan` を実行して変更をプレビューします。
3. `terraform apply` を実行してインフラストラクチャをデプロイします。

### DockerコンテナのビルドとECRへのプッシュ
1. Dockerイメージをビルドするには `docker build -t your-app-name .` を実行してください。
2. ECRへのログイン方法として `$(aws ecr get-login --no-include-email --region your-region)` を使用してください。
3. タグ付けした後、 `docker push your-account-id.dkr.ecr.your-region.amazonaws.com/your-app-name:latest` を実行してECRにプッシュしてください。
