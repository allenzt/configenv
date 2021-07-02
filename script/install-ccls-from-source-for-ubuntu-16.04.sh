#!/bin/sh

cd ${HOME}
#Install clang+llvm
wget https://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz
tar -Jxv -f clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz

#Install gcc-7/g++-7
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt install g++-7 -y

#upgrade cmake
sudo apt remove $(dpkg -l | grep cmake | awk '{print $2}' | xargs)
wget https://github.com/Kitware/CMake/releases/download/v3.18.1/cmake-3.18.1.tar.gz
tar -zxv -f cmake-3.18.1.tar.gz
./configure --prefix=/usr
make
sudo make install

#Install ccls
git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=${HOME}/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04 -DCMAKE_CXX_COMPILER=/usr/bin/g++-7
cp Release/ccls ~/tools

#Fix some issues
(cd ${HOME}/.config/coc/extensions/node_modules/coc-ccls ln -s node_modules/ws/lib lib)
npm i -g bash-language-server
