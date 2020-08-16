#!/bin/sh
#NOTE: test on Ubuntu 16.04
#FEATRUE: support python3, disable GUI

#install dependency
sudo apt install libncurses5-dev python-dev python3-dev ruby-dev lua5.1 liblua5.1-0-dev libperl-dev git

cd ~
git clone https://github.com/vim/vim.git vim-source
[ "$?" != "0" ] && echo "clone failed, exit" && exit

cd vim-source

./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-pythoninterp=yes \
            --with-python-config-dir=$(python3-config --configdir) \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-cscope \
            --disable-gui \
            --without-x \
            --prefix=/usr

sudo make V=s

#remove old vim
sudo apt remove $(dpkg -l | grep vim | awk '{print $2}' | xargs)

#install
sudo make install

cd ~
sudo rm -rf vim-source
