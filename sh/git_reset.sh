#!/bin/bash
# =========================
# 概要: Gitの問題を解消する
# オプション：ブランチ名(必須)
# =========================
source "$my_dir/conf.sh"

if [ "$#" -ne 1 ]; then
  echo "処理を中断します。オプション（ブランチ名）は必ず指定してください。"
  exit 1
fi
branch_name=$1

cd "${WEBAPP_PATH}"

# ローカルのaddを取り消す
git reset

# ローカルの変更を破棄す
git checkout -- .

git checkout main

git branch -D $branch_name
