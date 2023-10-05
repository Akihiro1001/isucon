#!/bin/bash
# =========================
# 概要: アプリケーションをデプロイする
# オプション：ブランチ名
# =========================

# =========================
# 初期処理
# =========================
my_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$my_dir/conf.sh"
source "$my_dir/utils.sh"

# =========================
# オプションの読み込み
# =========================
if [ "$#" -ne 1 ]; then
  echo "処理を中断します。オプション（ブランチ名）は必ず指定してください。"
  exit 1
fi
branch_name=$1

# =========================
# 関数
# =========================

# ブランチ切り替え、最新取り込み
pull_repo() {
  cd "${WEBAPP_PATH}"
  set +e
  git show-ref --verify --quiet refs/heads/$branch_name
  if [ $? -eq 0 ]; then
    # ブランチが存在する場合、そのブランチに切り替える
    git checkout $branch_name
  else
    # ブランチが存在しない場合、新規にブランチを作成して切り替える
    git checkout -b $branch_name
  fi

  git pull origin ${branch_name}
}

# Goのビルド
build_go() {
  cd "$(dirname ${GO_SOURCE_PATH})"
  go build $(basename ${GO_SOURCE_PATH})
}

# ログクリア
clear_log() {
  sudo truncate "${SLOW_LOG}" --size 0
  sudo truncate "${ACCESS_LOG}" --size 0
}

# =========================
# メイン処理
# =========================
exec_func pull_repo
exec_func build_go
exec_func init_config_files true false
exec_func check_nginx_mysql_conf
exec_func restart
exec_func clear_log
