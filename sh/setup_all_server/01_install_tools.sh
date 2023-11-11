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

sudo apt update

# htop
sudo apt -y install htop

# alp
sudo wget https://github.com/tkuchiki/alp/releases/download/v1.0.12/alp_linux_amd64.tar.gz
sudo tar -zxvf alp_linux_amd64.tar.gz
sudo install alp /usr/local/bin/alp

# pt-query-digest
sudo wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
sudo apt install -y percona-toolkit

# github cli
# 参考：https://github.com/cli/cli/blob/trunk/docs/install_linux.md
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
  sudo apt install gh -y

gh auth login
