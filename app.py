from flask import Flask, request, jsonify
import boto3
import requests

app = Flask(__name__)

# S3クライアントの設定
s3_client = boto3.client('s3')

# Kendraクライアントの設定
kendra_client = boto3.client('kendra')

@app.route('/process-message', methods=['POST'])
def process_message():
    # Slackからのメッセージを取得
    message = request.json.get('text')

    # S3にメッセージを保存
    response = s3_client.put_object(
        Bucket='your-s3-bucket-name',
        Key='message.txt',
        Body=message
    )

    # Kendraにインデックスを更新するリクエストを送信
    kendra_response = kendra_client.batch_put_document(
        IndexId='your-kendra-index-id',
        Documents=[
            {
                'Id': 'document-id',
                'Title': 'Message Title',
                'Blob': bytes(message, 'utf-8')
            }
        ]
    )

    # TODO: ここでNotionに対する更新処理を実装する
    # Notion APIへのリクエストなど

    return jsonify({"message": "Message processed successfully"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
