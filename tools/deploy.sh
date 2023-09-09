#!/bin/bash

# Git PULL
cd /home/isucon/webapp
git checkout -b $1
git pull origin $1

# goビルド
cd /home/isucon/webapp/go
go build

# ハードリンク貼り直し（必要に応じてパス修正）
sudo rm -f /etc/mysql/mysql.conf.d/mysqld.cnf
cd /etc/mysql/mysql.conf.d
sudo ln /home/isucon/webapp/configs/mysqld.cnf

sudo rm -f /etc/sysctl.conf
cd /etc
sudo ln /home/isucon/webapp/configs/sysctl.conf

# サービス再起動
sudo systemctl restart nginx
sudo systemctl restart mysql
sudo systemctl restart [サービス名]

# OS設定変更反映
sudo sysctl -p

# ログクリア
sudo truncate /var/log/mysql/mysql-slow.log --size 0
sudo truncate /var/log/nginx/access.log --size 0
