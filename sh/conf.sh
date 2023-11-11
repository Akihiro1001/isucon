#!/bin/bash
# =========================
# 概要: 設定を一元管理する
# =========================
WEBAPP_PATH="/home/isucon/private_isu/webapp" # TODO:調整
WEBAPP_BK_PATH="${WEBAPP_PATH}_bk"
CONFIGS_PATH="${WEBAPP_PATH}/configs"
GO_SOURCE_PATH="${WEBAPP_PATH}/golang/app.go" # TODO:調整(ソースファイルとビルドしたファイルが同一ディレクトリになる前提)
GO_BINARY_FILE="isuconquest"                  # TODO:調整(ソースファイルとビルドしたファイルが同一ディレクトリになる前提)

# TODO:GOの実行ファイル
# TODO:go versionを実行し、すでにパスが通っている場合、空文字にする
GO_EXEC_PATH="/home/isucon/local/go/bin/go"

GIT_USER_EMAIL="sample@sample.com"
GIT_USER_NAME="sample"

GITHUB_USER_NAME="Akihiro1001"
GITHUB_REPOSITORY="private-isu" # TODO:事前に調整

GIT_IGNORE_TARGET="
etc/
node/
php/
ruby/
docker-compose.yml
"
# GIT_IGNORE_TARGET="
# frontend/
# nodejs/
# perl/
# php/
# python/
# ruby/
# rust/
# "

# シンボリックリンクではなく実態のパス（/etc/nginx/sites-enabled配下はシンボリックリンク。実態は/etc/nginx/sites-available）
CONF_FILES_SYMBOLIC=("/etc/nginx/nginx.conf" "/etc/nginx/sites-available/isucon.conf") # TODO:調整
CONF_FILES_HARD=("/etc/mysql/mysql.conf.d/mysqld.cnf" "/etc/sysctl.conf")              # TODO:調整

SERVICES=("nginx" "mysql" "isu-go") # TODO:調整

ACCESS_LOG="/var/log/nginx/access.log"   # 秘伝のタレと合わせているため調整不要
SLOW_LOG="/var/log/mysql/mysql-slow.log" # 秘伝のタレと合わせているため調整不要

ACCESS_LOG_OUTPUT="/tmp/alp-grouped-sum.txt" # 秘伝のタレと合わせているため調整不要
SLOW_LOG_OUTPUT="/tmp/pt-query-digest.txt"   # 秘伝のタレと合わせているため調整不要

# TODO:調整
# ChatGPTに変換してもらう。パスパラメーターは.*に手動で置換する
# 以下の変換処理を実施してください。
# 1. パスのみ抽出する
# 2. カンマ区切りにする
# ```
# Golangのパスマッピングのコード
# ```
ACCESS_LOG_REGEX="/initialize,/login,/register,/logout,/posts/.*,/posts,/image/.*,/comment,/admin/banned,/.+,/}"

# 権限777を付与するファイル
CHMOD_777_FILES=("/var/log/mysql/mysql-slow.log")
