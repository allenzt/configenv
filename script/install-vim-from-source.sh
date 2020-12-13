#!/bin/sh
#NOTE: test on Ubuntu 16.04
#FEATRUE: support python3, disable GUI

distro_version=$(cat /etc/lsb-release  | grep DISTRIB_RELEASE | awk -F= '{print $NF}')
[ -z "${distro_version}" ] && echo "\033[40;31mERROR: can not detect linux distro version, exit\033[0m" && exit

#install dependency
if [ "${distro_version}" = "20.04" ]; then
    sudo apt install libncurses5-dev python3-dev ruby-dev lua5.2 liblua5.2-dev libperl-dev git -y
elif [ "${distro_version}" = "16.04" ]; then
    sudo apt install libncurses5-dev python3-dev ruby-dev lua5.1 liblua5.1-0-dev libperl-dev git -y
fi

cd ~
git clone https://github.com/vim/vim.git vim-source
[ "$?" != "0" ] && echo "clone failed, exit" && exit

cd vim-source

./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-python3interp=yes \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-cscope \
            --disable-gui \
            --without-x \
            --prefix=/usr

sudo make V=s

#remove old vim
sudo apt remove $(dpkg -l | grep vim | awk '{print $2}' | xargs)
sudo dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge

#install
sudo apt install checkinstall -y
#sudo make install
sudo checkinstall -D

cd ~
sudo rm -rf vim-source
