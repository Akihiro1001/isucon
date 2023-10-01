#!/bin/bash
# =========================
# 概要: 設定を一元管理する
# =========================
WEBAPP_PATH="/home/isucon/private_isu/webapp"
CONFIGS_PATH="${WEBAPP_PATH}/configs"
WEBAPP_BK_PATH="${WEBAPP_PATH}_bk"
GO_BUILD_PATH="${WEBAPP_PATH}/golang"
GO_BUILD_FILE="app.go"

GIT_USER_EMAIL="sample@sample.com"
GIT_USER_NAME="sample"

GITHUB_USER_NAME="Akihiro1001"
GITHUB_REPOSITORY="private-isu"

GIT_IGNORE_TARGET="
etc/
node/
php/
ruby/
docker-compose.yml
"
# GIT_IGNORE_TARGET="
# public/
# frontend/
# nodejs/
# perl/
# php/
# python/
# ruby/
# rust/
# "

# /etc/nginx/sites-enabled配下はシンボリックリンクで実態は/etc/nginx/sites-availableに存在するので注意
CONF_FILES_SYMBOLIC=("/etc/nginx/nginx.conf" "/etc/nginx/sites-available/isucon.conf")
CONF_FILES_HARD=("/etc/mysql/mysql.conf.d/mysqld.cnf" "/etc/sysctl.conf")

SERVICES=("nginx" "mysql" "isu-go")

ACCESS_LOG="/var/log/nginx/access.log"
SLOW_LOG="/var/log/mysql/mysql-slow.log"

ACCESS_LOG_OUTPUT="/tmp/alp-grouped-sum.txt"
SLOW_LOG_OUTPUT="/tmp/pt-query-digest.txt"

ACCESS_LOG_REGEX="/initialize,/login,/register,/logout,/posts/.*,/posts,/image/.*,/comment,/admin/banned,/.+,/}"
