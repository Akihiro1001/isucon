#!/bin/bash
# =========================
# 概要: ログを集計する
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

# スロークエリ解析結果を出力
summary_slow_log() {
  sudo pt-query-digest --filter '$event->{arg} =~ m/^select/i' --limit '100%:20' "${SLOW_LOG}" >${SLOW_LOG_OUTPUT}
}

# =========================
# メイン処理
# =========================
exec_func summary_access_log
exec_func summary_slow_log
