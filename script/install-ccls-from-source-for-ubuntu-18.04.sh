#!/bin/sh
#Install clang+llvm
sudo apt update
sudo apt-get install zlib1g zlib1g-dev
sudo apt install clang-8
sudo apt install cmake

#Install ccls
git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=clang++-8 -DCMAKE_PREFIX_PATH=/usr
cp Release/ccls ~/tools

#Fix some issues
cd ~/.config/coc/extensions/node_modules/coc-ccls && ln -s node_modules/ws/lib lib
npm i -g bash-language-server

#clean
rm -rf ccls
