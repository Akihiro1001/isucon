#!/bin/bash
# =========================
# 概要: 初期セットアップ(2台目以降)
# 注意点：GitHubのUsernameとpassword（パーソナルアクセストークン）の入力を求められる
# =========================

# =========================
# 初期処理
# =========================
set -e
my_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$my_dir/../conf.sh"
source "$my_dir/../utils.sh"

# =========================
# 関数
# =========================
clone_repo() {
  echo "webappを削除します。"
  mv -v "${WEBAPP_PATH}" "${WEBAPP_PATH}_bk"
  echo "webappを削除しました。バックアップ：${WEBAPP_PATH}_bk"

  echo "cloneします。"
  git clone "https://github.com/${GITHUB_USER_NAME}/${GITHUB_REPOSITORY}.git" "${WEBAPP_PATH}"
  echo "cloneしました。"
}

# =========================
# メイン処理
# =========================
exec_func configure_global_git
exec_func clone_repo
exec_func init_config_files "false" "false"
exec_func init_config_files "true" "false"
exec_func restart
exec_func chmod_777_files
