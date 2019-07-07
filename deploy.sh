#!/bin/sh

#sudo echo "please use root privilege"

tools_dir="$HOME/tools"

#check and set up directory "tools" 
echo "check and set up tools directory in home"
[ ! -d $tools_dir ] && mkdir $tools_dir

#configure bashrc for bash
cp ~/.bashrc bashrc
echo "#===========begin:user custom definition=========" >> bashrc
echo "alias grep='grep -nr --color=auto'" >> bashrc
echo "alias rm='rm -i'" >> bashrc
echo "source $tools_dir/aliasfile" >> bashrc
echo "PATH=$tools_dir:$PATH" >> bashrc

cat >> bashrc <<'EOF'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
EOF
echo "#===========end:user custom definition=========" >> bashrc

echo "******************************************************"
diff -Nur ~/.bashrc bashrc
echo "******************************************************"
read -p "please confirm changes for .bashrc" tmp
cp bashrc ~/.bashrc

#configure .gitconfig
echo "configure .gitconfig"
read -p "user name for git" username
read -p "user email for git" useremail
git config --global user.name $username
git config --global user.email $useremail
git config --global core.editor vim
git config --global merge.tool vimdiff
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.rb rebase

#configure vim
echo "configure vim"
cp vimrc ~/.vimrc
cp -rf vim ~/.vim

#install some utility
echo "install some CLI utility"
cp -rf tools/* ~/tools
