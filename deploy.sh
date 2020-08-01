#!/bin/sh

#######INSTALL BEGIN#######

#Install some utilities
tools_dir="$HOME/tools"
echo "Install some utilities ..."
[[ -d $tools_dir ]] && {
    rm -rf $tools_dir
}
tar -cvf - tools | tar -xvf - -C $HOME

#configure bashrc for bash
echo "Add custom changes to .bashrc file ..."
cp ~/.bashrc bashrc
echo "#===========begin:user custom definition=========" >> bashrc
echo "alias grep='grep -nr --color=auto' --exclude-dir=.ccls-cache" >> bashrc
echo "alias rm='rm -i'" >> bashrc
echo "source $tools_dir/aliasfile" >> bashrc
echo "PATH=$PATH:$tools_dir" >> bashrc

cat >> bashrc <<'EOF'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
EOF
echo "#===========end:user custom definition=========" >> bashrc
cp bashrc ~/.bashrc && rm -rf bashrc

#configure git setttings
echo "Configure git setttings..."
#read -p "user name for git" username
#read -p "user email for git" useremail
username="allen deng"
useremail="allen.zt.d@gmail.com"

git config --global user.name $username
git config --global user.email $useremail
git config --global core.editor vim
git config --global merge.tool vimdiff
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.rb rebase
git config --global push.default simple

#configure vim
echo "Configure VIM ..."
vimrc_file="$HOME/.vimrc"
vim_dir="$HOME/.vim"

[[ -f $vimrc_file ]] && {
    rm -rf $vimrc_file
}
ln -s $vim_dir/init.vim $HOME/.vimrc

[[ -f $vim_dir ]] && {
    rm -rf $vim_dir
}
tar -cvf - vim | tar -xvf - -C $HOME && mv $HOME/vim $HOME/.vim


#######INSTALL END#######
