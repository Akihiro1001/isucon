#!/bin/bash

# alpログ解析結果を出力
# 合計降順
sudo cat /var/log/nginx/access.log | alp ltsv -m '[正規表現リスト]' --sort sum -r > /tmp/alp-grouped-sum.txt
# 平均降順
#sudo cat /var/log/nginx/access.log | alp ltsv -m '[正規表現リスト]' --sort avg -r > /tmp/alp-grouped-avg.txt

# スロークエリ解析結果を出力
sudo pt-query-digest --filter '$event->{arg} =~ m/^select/i' --limit '100%:20' /var/log/mysql/mysql-slow.log > /tmp/pt-query-digest.txt
