#!/bin/bash
# =========================
# 概要: ログを集計する
# オプション：対応内容(ISSUEのタイトル)
# =========================

# =========================
# 初期処理
# =========================
set -e
my_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$my_dir/conf.sh"
source "$my_dir/utils.sh"

# =========================
# 関数
# =========================

# alpログ解析結果を出力
summary_access_log() {
  # 合計降順
  sudo cat "${ACCESS_LOG}" | alp ltsv -m "${ACCESS_LOG_REGEX}" --sort sum -r >${ACCESS_LOG_OUTPUT}
}

# スロークエリ解析結果（SELECT文のみ）を出力
summary_slow_log() {
  sudo pt-query-digest --filter '$event->{arg} =~ m/^select/i' --limit '100%:20' "${SLOW_LOG}" >${SLOW_LOG_OUTPUT}
}
# スロークエリ解析結果を出力
# summary_slow_log() {
#   sudo pt-query-digest --limit '100%:20' "${SLOW_LOG}" >${SLOW_LOG_OUTPUT}
# }

# 集計結果をissueに上げる
upload_issue() {

  # タイトルを設定
  local title="$1 $(hostname) $(date '+%H:%M:%S')"
  local output="output.txt"

  echo "### アクセスログ" >$output
  echo '```' >>$output
  cat $ACCESS_LOG_OUTPUT >>$output
  echo '```' >>$output
  echo "### スロークエリ" >>$output
  echo '```' >>$output
  cat $SLOW_LOG_OUTPUT >>$output
  echo '```' >>$output

  gh issue create --repo "${GITHUB_USER_NAME}/${GITHUB_REPOSITORY}" --title "${title}" -F "${output}"
}

# =========================
# メイン処理
# =========================
sleep 120 # ベンチ実行完了を待つ
exec_func summary_access_log
exec_func summary_slow_log
exec_func upload_issue $1
