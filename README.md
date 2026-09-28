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

| 項目     | 値                                                   |
| -------- | ---------------------------------------------------- |
| Host     | localhost                                            |
| Port     | 5432                                                 |
| User     | sql_user                                             |
| Password | sql_pass                                             |
| Database | `sql_training`（書籍） / `worldcup2014`（World Cup） |

`.env` を編集すれば変更可能です(`.env.example` をコピーして使ってください)。

### 3. VSCodeから使う

拡張機能 **SQLTools** + **SQLTools PostgreSQL Driver** をインストールすると、
`.vscode/settings.json` に定義済みの `sql-training (postgres)` と `worldcup2014 (postgres)` の接続が使えます。
サイドバーのSQLToolsアイコンから接続し、`.sql` ファイルを開いて実行できます。

CLIから直接触りたい場合は:

```bash
docker compose exec db psql -U sql_user -d sql_training
```

### 4. World Cupデータで練習する

書籍用の `sql_training` とは別に、World Cup専用の `worldcup2014` データベースを使います。phpMyAdmin配布ダンプをPostgreSQL 16向けに変換した [init/01_worldcup2014.sql](init/01_worldcup2014.sql) を同梱しています。Dockerのデータボリュームが空の初回起動時には、専用DBの作成とデータ取り込みが自動で行われます。

このワークスペースの既存DBにもWorld Cup用DBを作成し、データを移行済みです。新しく空のデータボリュームで起動する場合は、initスクリプトが専用DBを作成してデータを自動投入します。別の既存環境に手動で設定する場合、initスクリプトは遡って実行されないため、既存の `sql_training` を維持したまま以下を一度だけ実行してください。

```bash
docker compose exec -T db createdb -U sql_user worldcup2014
docker compose exec -T db psql -v ON_ERROR_STOP=1 -U sql_user -d worldcup2014 < init/01_worldcup2014.sql
```

VS CodeのSQLToolsでWorld Cup問題を解くときは `worldcup2014 (postgres)` に接続してください。すでにテーブルがある状態で再実行すると失敗します。PostgreSQL用に行った変換内容や確認結果は[方針資料](docs/postgresql-learning-policy.md)を参照してください。

手動で使う場合は `docker compose exec db psql -U sql_user -d worldcup2014` で接続できます。

### 5. 停止・データ削除

```bash
# 停止(データは残る)
docker compose down

# 停止 + データ完全削除(初期化し直したい時)
docker compose down -v
```

`docker compose down -v` は両データベースのデータを含むPostgreSQLの学習データをすべて削除するので注意してください。

## ディレクトリ構成

```
.
├── docker-compose.yml   # PostgreSQLコンテナ定義
├── .env.example          # 接続情報のテンプレート(.envにコピーして使用)
├── init/                  # 初回起動時に自動実行されるSQL
│   ├── 00_create_worldcup_database.sql # World Cup専用DBを作成
│   ├── 00_init.sql
│   └── 01_worldcup2014.sql # World Cup練習データ
├── docs/                  # 学習環境の方針資料
└── .vscode/
    ├── extensions.json    # SQLTools等のおすすめ拡張
    └── settings.json      # SQLTools接続設定
```
