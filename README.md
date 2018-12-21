# Cacti の古いバージョンからの移行の実験

Cacti のめちゃくちゃ古いバージョン(0.8.8a)から最新版(1.1.38)へのマイグレーションを試みたメモ。

```sh
# 旧 cacti をコピー
mkdir -p cacti-old/
rsync -rcz --delete $REMOTE:/var/www/cacti/ cacti-old/
ssh $REMOTE mysqldump -u root cacti > cacti-old/dump.sql

# 新旧の環境を docker でビルド
docker-compose build

# 旧環境を起動
docker-compose up mysql cacti-old

# 旧環境を開く
open http://192.168.99.100:8080/cacti/
```

プラグインが有効なまま起動するのはかなり困難なので、旧環境のプラグインの無効化と、不要な設定を削除する。

```sh
# 新環境を起動
docker-compose up mysql cacti-new

# 新環境を開く
open http://192.168.99.100:8080/cacti/
```

新環境の画面でウィザードをぽちぽちしていけばアップグレード完了。

---

社内の調整が進まなかったので実施していない。
新規サーバは Prometheus でリソース監視することにして緩やかに Cacti から離脱中。
