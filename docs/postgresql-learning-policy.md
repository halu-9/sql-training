# PostgreSQL学習環境の方針

## 目的

SQL練習問題を、実際にクエリを実行しながら解く。データベース製品は **PostgreSQL 16 に統一**し、MariaDBやphpMyAdminは学習環境に含めない。

## 環境の基本方針

- Docker Composeの既存PostgreSQLサービスを使う。接続先は `localhost:5432`、DB名は `sql_training`。
- データはPostgreSQLの名前付きボリュームに保存する。通常のコンテナ停止・再作成では消さない。
- Dockerfileは追加しない。公式PostgreSQLイメージで十分。
- World Cupデータは、書籍用の `sql_training` と分けた `worldcup2014` データベースに置く。配布元のテーブル名を維持し、練習問題のSQLをそのまま確認しやすくする。
- 元のダンプはDownloadsに保管し、変換後のPostgreSQL用SQLだけをプロジェクトに置く。

## World Cupダンプの扱い

配布ファイルはphpMyAdminが出力したMySQL/MariaDB用ダンプであり、PostgreSQLへそのまま投入するものではない。PostgreSQL 16用に変換した `init/01_worldcup2014.sql` と、専用DBを作成する `init/00_create_worldcup_database.sql` を同梱する。既存環境でも `worldcup2014` DBを作成してデータを移行済みで、旧 `sql_training` からはWorld Cupの7テーブルだけを削除し、書籍用テーブルは保持した。

PostgreSQLコンテナの `init/` は、データボリュームが空の初回起動時にだけ自動実行される。すでにDBを使い始めている場合、変換SQLを追加しただけでは実行されない。その場合は、確認後に手動適用するか、学習データを初期化して初回実行させる。

既存のデータボリュームへ手動適用する場合:

```bash
docker compose exec -T db createdb -U sql_user worldcup2014
docker compose exec -T db psql -v ON_ERROR_STOP=1 -U sql_user -d worldcup2014 < init/01_worldcup2014.sql
```

初回起動時は、初期化スクリプトが専用DBを作ってからデータを投入する。既存のPostgreSQLデータボリュームではinitスクリプトは自動実行されないので、上記のようにDB作成とデータ投入を一度行う。このSQLは同じDBに二度適用できない。既存の教材データを消したくない場合は、安易に `docker compose down -v` を使わない。

## 変換版SQLで行ったこと

変換では次の方針を適用した。

1. PostgreSQL 16で実行できるSQLにする。MariaDB/MySQL固有の構文や設定を残さない。
2. 元データのテーブル名・列名・値を保つ。対象テーブルは `countries`, `goals`, `goals_tmp`, `pairings`, `pairings_tmp`, `players`, `players_tmp`。
3. `NULL` と空文字列を区別して保持する。特に `goals.player_id` のNULLを勝手に補完しない。
4. 主キーとID値を保つ。明示IDを取り込んだ後も次の採番値が既存IDと衝突しないようシーケンスを調整する。
5. `int(11)` の表示幅、`ENGINE=InnoDB`、MySQLの文字コード指定、`SET SQL_MODE`、phpMyAdminの条件付きコメントなど、PostgreSQLに不要な記述を除く。`datetime` はタイムゾーン指定がない元データとして `TIMESTAMP WITHOUT TIME ZONE` にする。
6. 元ダンプにない外部キー・一意制約・業務ルールを勝手に追加しない。追加候補があれば、元データを拒否する可能性を確認したうえで別途提案する。
7. 途中で失敗した場合に半端なデータを残さないよう、可能ならトランザクションにまとめる。
8. MySQLの自動採番列はPostgreSQLのIdentity列とし、元ダンプに記録された次回採番値（countries=33, goals=256, pairings=256, players=1024）を引き継ぐ。

## 取り込み後の確認

元ダンプの主要テーブルは、少なくとも次の件数になることを確認する。

| テーブル    | 行数 |
| ----------- | ---: |
| `countries` |   32 |
| `pairings`  |  144 |
| `players`   |  736 |
| `goals`     |  188 |

実機検証で全7テーブルの行数が一致し、`goals.player_id IS NULL` の5行が保持され、国・試合・選手・得点を結合した183件が取得できることを確認した。外部キー制約は元ダンプにもなく、入力データへの追加検証を避けるため作成していない。練習問題のSQLがMySQL固有構文を使っている場合は、PostgreSQLでの等価な書き方に直してから実行する。

## 目指す状態

PostgreSQLの構文を学習の基準にする。MySQL/MariaDBとの差は、必要になったときに「どの構文・型・NULLの扱いが違うか」を確認する材料として扱い、完全互換を目標にはしない。
