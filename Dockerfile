FROM python:3.9-slim

# 作業ディレクトリを設定
WORKDIR /app

# 必要なPythonパッケージをインストールするためのrequirements.txtをコピー
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# アプリケーションのソースコードをコピー
COPY . .

# アプリケーションがリッスンするポートを指定
EXPOSE 8080

# アプリケーションを起動するコマンド
CMD ["python", "./app.py"]
