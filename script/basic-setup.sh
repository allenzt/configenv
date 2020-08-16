#!/bin/sh

#change software source
sudo sed -i -e 's|cn.archive.ubuntu.com|mirrors.tuna.tsinghua.edu.cn|g' -e 's|archive.canonical.com|mirrors.tuna.tsinghua.edu.cn|g' -e 's|security.ubuntu.com|mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list

#update software database
sudo apt update && sudo apt upgrade

#install build-essential
sudo apt install build-essential

#install vim
#refer to ./install-vim-from-source.sh
