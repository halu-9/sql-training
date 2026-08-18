# sql-training

『達人に学ぶSQL徹底指南書 第2版』学習用の最小SQL実行環境。
標準SQL(SQL:2003)への準拠度が高い **PostgreSQL 16** を使用。

## 使い方

### 1. コンテナ起動

```bash
# macでdockerを起動するときはdocker desktopを起動する（daemonの直起動は不可みたい）
open -a "Docker"
```

```bash
docker compose up -d
```

※起動できないときはゾンビプロセスが残っていることが大半なので確認

初回起動時に `init/` フォルダ内の `.sql` ファイルが自動実行されます
(テーブル定義や初期データを置いておくと便利)。

### 2. 接続情報

| 項目 | 値 |
|---|---|
| Host | localhost |
| Port | 5432 |
| User | sql_user |
| Password | sql_pass |
| Database | sql_training |

`.env` を編集すれば変更可能です(`.env.example` をコピーして使ってください)。

### 3. VSCodeから使う

拡張機能 **SQLTools** + **SQLTools PostgreSQL Driver** をインストールすると、
`.vscode/settings.json` に定義済みの接続 (`sql-training (postgres)`) がそのまま使えます。
サイドバーのSQLToolsアイコンから接続し、`.sql` ファイルを開いて実行できます。

CLIから直接触りたい場合は:

```bash
docker compose exec db psql -U sql_user -d sql_training
```

### 4. 停止・データ削除

```bash
# 停止(データは残る)
docker compose down

# 停止 + データ完全削除(初期化し直したい時)
docker compose down -v
```

## ディレクトリ構成

```
.
├── docker-compose.yml   # PostgreSQLコンテナ定義
├── .env.example          # 接続情報のテンプレート(.envにコピーして使用)
├── init/                  # 初回起動時に自動実行されるSQL
│   └── 00_init.sql
└── .vscode/
    ├── extensions.json    # SQLTools等のおすすめ拡張
    └── settings.json      # SQLTools接続設定
```
