#!/bin/bash
# =========================
# 概要: 設定ファイルをGit管理する（１台目のみ）
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
# Webapp配下に設定ファイル用のディレクトリを作成
mkdir_configs() {
    echo "${CONFIGS_PATH}を作成します。"
    check_not_exist_path "${CONFIGS_PATH}"
    mkdir -p "${CONFIGS_PATH}"
    echo "${CONFIGS_PATH}を作成しました。"
}

# GitHubに上げる
commit_and_push() {
    echo "add,commit,push します。"
    cd "${WEBAPP_PATH}"
    git add .
    git commit -m "Add config files under git control"
    git push -u origin main
    echo "add,commit,push しました。"
}

# =========================
# メイン処理
# =========================
exec_func mkdir_configs
exec_func init_config_files "false" "true"
exec_func init_config_files "true" "true"
exec_func commit_and_push
