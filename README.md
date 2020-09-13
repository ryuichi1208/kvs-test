# memcached-test

## 基本

```
# 再起動
$ make restart

# 再ビルド
$ make rebuild

```

## データ登録

```
$ docker-compose exec client sh
$ perl /usr/local/tools/test_001_set.pl
```

## 便利

```
# memdごとのキャッシュ
$ for i in $(seq 1 4); do echo "==== mem00${i} ====" && memcached-tool mem00${i}:11211 dump 2>&1 | awk '$1 ~ "add" {print $2}' | sort -n | perl -pe 's/\n/ /;' && echo; done
```
