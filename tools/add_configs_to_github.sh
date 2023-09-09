#!/bin/bash
# =========================
# 概要: 設定ファイルをGit管理する
# =========================


# =========================
# 設定
# =========================
WEBAPP_PATH="/home/isucon/private_isu/webapp"
CONF_FILES_SYMBOLIC=("/etc/nginx/nginx.conf")
CONF_FILES_HARD=("/etc/mysql/mysql.conf.d/mysqld.cnf" "/etc/sysctl.conf")

# =========================
# 関数
# =========================
# Webapp配下に設定ファイル用のディレクトリを作成
mkdir_configs() {
    mkdir -p "${WEBAPP_PATH}/configs"
}

# 設定ファイルをWebapp配下に移動してリンクを張る
mv_files() {
    local -n files=$1
    local is_hard_link=$2

    for CONF_FILE in "${files[@]}"; do
        local CONF_DIR
        local CONF_FILENAME

        CONF_DIR=$(dirname "${CONF_FILE}")
        CONF_FILENAME=$(basename "${CONF_FILE}")

        # 設定ファイルをWebapp配下に移動
        sudo mv "${CONF_FILE}" "${WEBAPP_PATH}/configs/"

        # リンクを張る
        cd "${CONF_DIR}" || exit 1
        if [[ $is_hard_link == "true" ]]; then
            sudo ln "${WEBAPP_PATH}/configs/${CONF_FILENAME}"
        else
            sudo ln -s "${WEBAPP_PATH}/configs/${CONF_FILENAME}"
        fi
    done
}

# GitHubに上げる
commit_and_push() {
    cd "${WEBAPP_PATH}" || exit 1
    git add .
    git commit -m "Add config files under git control"
    git push -u origin main
}

# =========================
# メイン処理
# =========================
mkdir_configs
mv_files CONF_FILES_SYMBOLIC "false"
mv_files CONF_FILES_HARD "true"
commit_and_push
