#!/bin/bash
# =========================
# 概要: 共通の関数を定義する
# =========================
my_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$my_dir/conf.sh"

# 関数を実行する。また関数実行前後に共通処理を実行する。（$1:関数, $2,3..:$1実行時のオプション）
exec_func() {
    callback=$1

    #１つ目の引数を削除し、前にずらす
    shift

    echo "[関数]${callback} ${@}を実行します。"

    # 実行
    $callback "$@"

    echo "[関数]${callback} ${@}を実行しました。"
}

# Webappのバックアップ
configure_global_git() {
    git config --global user.name "${GIT_USER_NAME}"
    git config --global user.email "${GIT_USER_EMAIL}"
    git config --global credential.helper store
    git config --global init.defaultBranch main
}

# 存在しない想定のパスがすでに存在する場合処理を中断する。（$1:パス（ファイルまたはディレクトリ））
check_not_exist_path() {
    target_path=$1
    echo "${target_path}が存在しないことを確認します。"

    if [ -e "$target_path" ]; then
        echo "${target_path} がすでに存在したため処理を中断しました。"
        exit 1
    fi

    echo "${target_path}が存在しないことを確認しました。"
}

# 存在する想定のパスが存在しなかった場合処理を中断する。（$1:パス（ファイルまたはディレクトリ））
check_exist_path() {
    target_path=$1
    echo "${target_path}が存在することを確認します。"

    if [ ! -e "$target_path" ]; then
        echo "${target_path} が存在しなかったため処理を中断しました。"
        exit 1
    fi

    echo "${target_path}が存在することを確認しました。"
}

# 設定ファイルの初期処理（$1:ハードリンクかどうか,$2:対象ファイルをwebapp配下に移動するか）
init_config_files() {

    local is_hard_link=$1
    local mv_file_to_configs=$2

    if [[ $is_hard_link == "true" ]]; then
        paths=("${CONF_FILES_HARD[@]}")
    else
        paths=("${CONF_FILES_SYMBOLIC[@]}")
    fi

    for path in "${paths[@]}"; do
        local dir
        local filename

        dir=$(dirname "${path}")
        filename=$(basename "${path}")

        # 対象の設定ファイルを移動または削除する。
        if [[ $mv_file_to_configs == "true" ]]; then
            echo "${filename}をwebapp配下に移動します。"
            check_not_exist_path "${CONFIGS_PATH}/${filename}"
            sudo mv "${path}" "${CONFIGS_PATH}"
            echo "${filename}をwebapp配下に移動しました。"
        else
            echo "${filename}を削除します。"
            check_not_exist_path "${path}.bk"
            sudo mv "${path}" "${path}.bk"
            echo "${filename}を削除しました。バックアップ：${path}.bk"
        fi

        # リンクを張る
        cd "${dir}" || exit 1
        if [[ $is_hard_link == "true" ]]; then
            echo "${dir}から${CONFIGS_PATH}/${filename}にハードリンクを張ります。"
            sudo ln "${CONFIGS_PATH}/${filename}"
            echo "${dir}から${CONFIGS_PATH}/${filename}にハードリンクを張りました。"
        else
            echo "${dir}から${CONFIGS_PATH}/${filename}にシンボリックリンクを張ります。"
            sudo ln -s "${CONFIGS_PATH}/${filename}"
            echo "${dir}から${CONFIGS_PATH}/${filename}にシンボリックリンクを張りました。"
        fi
    done
}
