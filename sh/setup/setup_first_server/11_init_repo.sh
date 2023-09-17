#!/bin/bash
# =========================
# 概要: Gitの初期セットアップ(1台目)
# 注意点：GitHubのUsernameとpassword（パーソナルアクセストークン）の入力を求められる
# =========================

# =========================
# 初期処理
# =========================
set -e
my_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$my_dir/../../conf.sh"
source "$my_dir/../../utils.sh"

# =========================
# 関数
# =========================
# webapp配下をgit管理する
init_repo() {
    echo "webappのバックアップを取得します。"
    check_not_exist_path "${WEBAPP_BK_PATH}"
    cp -r "${WEBAPP_PATH}" "${WEBAPP_BK_PATH}"
    echo "webappのバックアップを取得しました。バックアップ：${WEBAPP_BK_PATH}"

    echo "webappをgit管理します。"
    check_not_exist_path "${WEBAPP_PATH}/.git"
    cd "${WEBAPP_PATH}"
    git init
    git remote add origin "https://github.com/${GITHUB_USER_NAME}/${GITHUB_REPOSITORY}.git"
    echo "webappをgit管理しました。"
}

# .gitignoreを作成する
init_gitignore() {
    echo ".gitignore を作成します。サイズオーバーのファイルはデフォルトで除外対象とします。"
    check_not_exist_path "${WEBAPP_PATH}/.gitignore"
    find . -size +100M | sed -e 's/^\.\///' >>"${WEBAPP_PATH}/.gitignore"
    echo ".gitignore を作成しました。"

    echo "指定された除外対象(GIT_IGNORE_TARGET)を.gitignoreに追加します。"
    check_exist_path "${WEBAPP_PATH}/.gitignore"
    echo -e "${GIT_IGNORE_TARGET}" >>"${WEBAPP_PATH}/.gitignore"
    echo "指定された除外対象(GIT_IGNORE_TARGET)を.gitignoreに追加しました。"
}

# GitHubに反映する関数
push_to_github() {
    echo "add,commit,push します。"
    echo "GitHubのUsernameとpassword（パーソナルアクセストークン）の入力を求められる可能性があります。"
    cd "${WEBAPP_PATH}"
    git add .
    git commit -m "first commit"
    git branch -M main
    git push -u origin main
    echo "add,commit,push しました。"
}

# =========================
# メイン処理
# =========================
exec_func configure_global_git
exec_func init_repo
exec_func init_gitignore
exec_func push_to_github
