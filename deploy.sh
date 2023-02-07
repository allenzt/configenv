#!/bin/sh

install_utilities(){

	local distro_support=$1

	[ -z "$distro_support" ] && {
		echo "use 'install_utilities DISTRO_SUPPORT'"
		return
	}

	#Install some utilities
	echo "Install some utilities ..."
	tools_dir="$HOME/tools"
	[ -d $tools_dir ] && {
	    rm -rf $tools_dir
	}
	tar -cvf - tools | tar -xvf - -C $HOME

	[ -n ${DEF_PASSWD} ] || export DEF_PASSWD=123346

	echo ${DEF_PASSWD} | sudo apt install build-essential -y --no-install-recommends
	sudo apt install curl git tig tmux universal-ctags global expect bear global autoconf -y --no-install-recommends

	case "$DISTRO_SUPPORT" in
		Ubuntu-16.04)
			#Install tmux
			sudo add-apt-repository ppa:bundt/backports -y
			sudo apt update
			sudo apt install tmux=3.1c-ppa-xenial1

			#Install global
			sudo add-apt-repository ppa:alexmurray/global -y
			sudo apt update
			sudo apt install global=6.5.7-1~bpo16.04+1
		;;
		Ubuntu-18.04)
			#Install tmux
			sudo add-apt-repository ppa:bundt/backports -y
			sudo apt update
			sudo apt install tmux=3.1c-1ppa~bionic1
		;;
		*)
			apt install tmux global -y --no-install-recommends
		;;
	esac

	cp tmux.conf ${HOME}/.tmux.conf
}

configure_bashrc(){
	#check if it is configured
	[ -z "$(grep 'begin:user custom definition' ~/.bashrc)" ] || {
		echo "bashrc is configured, skip"
		return
	}

	#configure bashrc for bash
	echo "Add custom changes to .bashrc file ..."
	cp ~/.bashrc bashrc
	echo "#===========begin:user custom definition=========" >> bashrc
	echo "alias g='grep -nr --color=auto --exclude-dir=.ccls-cache'" >> bashrc
	echo "alias rm='rm -i'" >> bashrc
	#use 256 color
	echo "alias man=\"LESS_TERMCAP_mb=$'\e[01;31m' LESS_TERMCAP_md=$'\e[01;38;5;170m' LESS_TERMCAP_me=$'\e[0m' LESS_TERMCAP_se=$'\e[0m' LESS_TERMCAP_so=$'\e[38;5;246m' LESS_TERMCAP_ue=$'\e[0m' LESS_TERMCAP_us=$'\e[04;38;5;74m' man\"" >>bashrc
	echo "source $tools_dir/aliasfile" >> bashrc
	echo "PATH=$PATH:$tools_dir" >> bashrc
	echo "export EDITOR=vim" >> bashrc

	# cat >> bashrc <<'EOF'
	# export LESS_TERMCAP_md=$'\E[01;31m'
	# export LESS_TERMCAP_me=$'\E[0m'
	# export LESS_TERMCAP_se=$'\E[0m'
	# export LESS_TERMCAP_so=$'\E[01;44;33m'
	# export LESS_TERMCAP_ue=$'\E[0m'
	# export LESS_TERMCAP_us=$'\E[01;32m'
	# EOF
	echo "#===========end:user custom definition=========" >> bashrc
	mv bashrc ~/.bashrc
}

configure_gitconfig(){
	#configure git setttings
	echo "Configure git setttings..."

	read -p "user name for git" username
	username=${username:-dengzt}

	read -p "user email for git" useremail
	useremail=${useremail:-allen.zt.d@gmail.com}

	git config --global user.name $username
	git config --global user.email $useremail
	git config --global core.editor vim
	git config --global merge.tool vimdiff
	git config --global alias.co checkout
	git config --global alias.br branch
	git config --global alias.ci commit
	git config --global alias.st status
	git config --global alias.rb rebase
	git config --global alias.lm "log --no-merges --color --date=format:'%Y-%m-%d %H:%M' --author='$username' --pretty=format:'%Cgreen%cd %C(bold blue)%<(10)%an%Creset %Cred%h%Creset -%C(yellow)%d%Cblue %s%Creset' --abbrev-commit"
	git config --global alias.lms "log --no-merges --color --stat --date=format:'%Y-%m-%d %H:%M' --author='$username' --pretty=format:'%Cgreen%cd %C(bold blue)%<(10)%an%Creset %Cred%h%Creset -%C(yellow)%d%Cblue %s%Creset' --abbrev-commit"
	git config --global alias.ls "log --no-merges --color --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%Cgreen%cd %C(bold blue)%<(10)%an%Creset %Cred%h%Creset -%C(yellow)%d%Cblue %s%Creset' --abbrev-commit"
	git config --global alias.lss "log --no-merges --color --stat --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%Cgreen%cd %C(bold blue)%<(10)%an%Creset %Cred%h%Creset -%C(yellow)%d%Cblue %s%Creset' --abbrev-commit"
	git config --global push.default simple
}

configure_vim(){

	local distro_support=$1

	[ -z "$distro_support" ] && {
		echo "use 'configure_vim DISTRO_SUPPORT'"
		return
	}

	#configure vim
	echo "Configure VIM ..."
	#Install ccls and Nodejs for ubuntu 16.04
	case "${DISTRO_ID}-${DISTRO_RELEASE}" in
	    Ubuntu-20.04|Ubuntu-20.10|Ubuntu-21.04)
		sudo apt install ccls -y
		curl -sL install-node.now.sh/lts | sudo bash
		;;
	    Ubuntu-18.04)
		echo "Install ccls for $distro_support"
		# ./script/install-ccls-from-source-for-ubuntu-18.04.sh
		(cd $HOME/tools && ln -sf ccls-ubuntu-18.04 ccls)
		curl -sL install-node.now.sh/lts | sudo bash
		;;
	    Ubuntu-16.04)
		echo "Install ccls for Ubuntu 16.04"
		# ./script/install-ccls-from-source-for-ubuntu-16.04.sh
		(cd $HOME/tools && ln -sf ccls-ubuntu-16.04 ccls)
		curl -sL install-node.now.sh/lts | sudo bash
		;;
	    *)
		echo "Unspported DISTRO version, exit ..."
		exit
		;;
	esac

	cd ${HOME}/.config/coc/extensions/node_modules/coc-ccls && ln -sf node_modules/ws/lib
	sudo npm i -g bash-language-server

	#rmmove vim config directory first
	rm -rf $HOEM/.vim

	vimrc_file="$HOME/.vimrc"
	vim_dir="$HOME/.vim"

	[ -f $vimrc_file ] && {
	    rm -rf $vimrc_file
	}
	ln -sf $vim_dir/init.vim $HOME/.vimrc

	[ -f $vim_dir ] && {
	    rm -rf $vim_dir
	}

	tar -cvf - vim | tar -xvf - -C $HOME && mv $HOME/vim $HOME/.vim

}


##### INSTALL BEGIN####
DISTRO_ID=$(cat /etc/lsb-release  | grep DISTRIB_ID | awk -F= '{print $NF}')
DISTRO_RELEASE=$(cat /etc/lsb-release  | grep DISTRIB_RELEASE | awk -F= '{print $NF}')

case "${DISTRO_ID}-${DISTRO_RELEASE}" in
    Ubuntu-21.04|Ubuntu-20.04|Ubuntu-20.10|Ubuntu-18.04|Ubuntu-16.04)
	    DISTRO_SUPPORT="${DISTRO_ID}-${DISTRO_RELEASE}"
	;;
    *)
	    DISTRO_SUPPORT=""
	;;
esac

if [ -z "${DISTRO_SUPPORT}" ]; then
	echo "${DISTRO_ID}-${DISTRO_RELEASE} is not be supported, exit ..."
	exit
fi

install_utilities $DISTRO_SUPPORT
configure_vim $DISTRO_SUPPORT
configure_bashrc
configure_gitconfig

##### INSTALL END####

