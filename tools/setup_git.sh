#!/bin/bash
# =========================
# 概要:Gitの初期セットアップ
# 注意点：GitHubのUsernameとpassword(パーソナルアクセストークン)の入力を求められる
# =========================

# =========================
# 設定
# =========================
GIT_USER_EMAIL="sample@sample.com"
GIT_USER_NAME="sample"

GITHUB_USER_NAME="Akihiro1001"
GITHUB_USER_REPOSITORY="private-isu"
GIT_IGNORE_TARGET="
public/
frontend/
nodejs/
perl/
php/
python/
ruby/
rust/
"

WEBAPP_PATH="/home/isucon/private_isu/webapp"

# =========================
# メイン処理
# =========================

# グローバルなgitの設定
git config --global user.name ${GIT_USER_NAME}
git config --global user.email ${GIT_USER_EMAIL}
git config --global credential.helper store
git config --global init.defaultBranch main

# webapp配下をgit管理する
cd ${WEBAPP_PATH}
git init
git remote add origin https://github.com/${GITHUB_USER_NAME}/${GITHUB_USER_REPOSITORY}.git

# .gitignoreの追加（サイズオーバーのファイルは、デフォルトで追加する）
find . -size +100M | sed -e 's/^\.\///' >> .gitignore
# 除外対象ディレクトリ・ファイルの追加
echo -e "${GIT_IGNORE_TARGET}" >> .gitignore

# GitHubに上げる
git add .
git commit -m "first commit"
git push -u origin main
