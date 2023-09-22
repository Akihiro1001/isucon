#!/bin/bash
# =========================
# 概要: 各種ツールをセットアップする（全台）
# =========================

# =========================
# 初期処理
# =========================
set -e
my_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$my_dir/../conf.sh"
source "$my_dir/../utils.sh"

# =========================
# メイン処理
# =========================
# htop
sudo apt -y install htop

# alp
wget https://github.com/tkuchiki/alp/releases/download/v1.0.12/alp_linux_amd64.tar.gz
tar -zxvf alp_linux_amd64.tar.gz
sudo install alp /usr/local/bin/alp

# pt-query-digest
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
sudo apt update
sudo apt install -y percona-toolkit