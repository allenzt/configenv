#!/bin/bash

# 定义颜色代码
COLOR_RESET='\033[0m'      # 重置颜色
COLOR_RED='\033[0;31m'     # 红色
COLOR_YELLOW='\033[0;33m'  # 黄色
COLOR_GREEN='\033[0;32m'   # 绿色
COLOR_BLUE='\033[0;34m'    # 蓝色

# 日志函数（时间格式：[YYYY-MM-DD HH:MM:SS]）
log_info() {
    local timestamp=$(date +"[%Y-%m-%d %H:%M:%S]")
    echo -e "${COLOR_GREEN}[INFO ]${COLOR_RESET} ${timestamp}: $@"
}

log_warn() {
    local timestamp=$(date +"[%Y-%m-%d %H:%M:%S]")
    echo -e "${COLOR_YELLOW}[WARN ]${COLOR_RESET} ${timestamp}: $@" >&2
}

log_error() {
    local timestamp=$(date +"[%Y-%m-%d %H:%M:%S]")
    echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} ${timestamp}: $@" >&2
}

# 可选：调试日志（仅在 DEBUG=true 时显示）
log_debug() {
    if [[ "${DEBUG}" == "true" ]]; then
        local timestamp=$(date +"[%Y-%m-%d %H:%M:%S]")
        echo -e "${COLOR_BLUE}[DEBUG]${COLOR_RESET} ${timestamp}: $@"
    fi
}

sudo_wrapper(){
	echo $DEF_PASSWD | sudo -S -k $@
}

install_utilities(){

	local distro_support=$1

	[ -z "$distro_support" ] && {
		echo "use 'install_utilities DISTRO_SUPPORT'"
		return
	}

	#Install some utilities
	log_info "Install some utilities ..."
	tools_dir="$HOME/tools"
	[ -d $tools_dir ] && {
	    rm -rf $tools_dir
	}
	tar -cf - tools | tar -xf - -C $HOME

	case "$DISTRO_SUPPORT" in
		Ubuntu-16.04)
			#Install tmux
			sudo_wrapper add-apt-repository ppa:bundt/backports -y
			sudo_wrapper apt update
			sudo_wrapper apt install tmux=3.1c-ppa-xenial1

			#Install global
			sudo_wrapper add-apt-repository ppa:alexmurray/global -y
			sudo_wrapper apt update
			sudo_wrapper apt install global=6.5.7-1~bpo16.04+1
		;;
		Ubuntu-18.04)
			#Install tmux
			sudo_wrapper add-apt-repository ppa:bundt/backports -y
			sudo_wrapper apt update
			sudo_wrapper apt install tmux=3.1c-1ppa~bionic1
		;;
		Ubuntu-22.04)
			#Install tmux global
			sudo_wrapper apt install tmux global -y --no-install-recommends
		;;
		*)
			#Install tmux global and python3-pip
			sudo_wrapper apt install python3-pip tmux global -y --no-install-recommends
		;;
	esac

	sudo_wrapper apt install build-essential -y --no-install-recommends
	sudo_wrapper apt install curl git tig tmux universal-ctags global expect bear global autoconf -y --no-install-recommends

	cp tmux.conf ${HOME}/.tmux.conf
	cp tigrc ${HOME}/.tigrc
}

configure_bashrc(){
	#check if it is configured
	[ -z "$(grep 'begin:user custom definition' ~/.bashrc)" ] || {
		log_warn "bashrc is configured, skip"
		return
	}

	#configure bashrc for bash
	log_info "Add custom changes to .bashrc file ..."
	cp ~/.bashrc bashrc
	echo "#===========begin:user custom definition=========" >> bashrc
	echo "alias g='grep -nr --color=auto --exclude-dir=.ccls-cache'" >> bashrc
	echo "alias rm='rm -i'" >> bashrc

	# highlight for man
	cat >> bashrc <<'EOF'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
EOF

	#use 256 color
	echo "source $tools_dir/aliasfile" >> bashrc
	echo "PATH=\$PATH:$tools_dir" >> bashrc
	echo "export EDITOR=vim" >> bashrc

	echo "#===========end:user custom definition=========" >> bashrc
	mv bashrc ~/.bashrc
}

configure_gitconfig(){
	#configure git setttings
	if [ -z "$(grep -q -o "lss = log" $HOME/.gitconfig)" ]; then
		log_warn "Git settings had been configured..."
		return
	fi

	log_info "Configure git setttings..."

	read -p "Please input username for git(default: dengzt, timeout: 10s): " -t 10 username
	username=${username:-dengzt}

	echo ""

	read -p "Please input email for git(default: allen.zt.d@gmail.com, timeout: 10s): " -t 10 tuseremail
	useremail=${useremail:-allen.zt.d@gmail.com}

	echo ""

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
	#Install C/C++ LSP ccls
	case "${DISTRO_ID}-${DISTRO_RELEASE}" in
	    Ubuntu-18.04)
			log_info "Install ccls for $distro_support"
			# ./script/install-ccls-from-source-for-ubuntu-18.04.sh
			(cd $HOME/tools && ln -sf ccls-ubuntu-18.04 ccls)
			curl -sL install-node.now.sh/lts -o node-install.sh
			sed -i -e 's/confirm/#confirm/g' node-install.sh
			sudo_wrapper bash node-install.sh
		;;
	    Ubuntu-16.04)
			log_info "Install ccls for Ubuntu 16.04"
			# ./script/install-ccls-from-source-for-ubuntu-16.04.sh
			(cd $HOME/tools && ln -sf ccls-ubuntu-16.04 ccls)
			curl -sL install-node.now.sh/lts -o node-install.sh
			sed -i -e 's/confirm/#confirm/g' node-install.sh && chmode 755 node-install.sh
			bash node-install.sh
		;;
	    *)
			sudo_wrapper apt install ccls -y
		;;
	esac

	#Install Nodejs for Coc.nvim
	if [ -z "$(node -v 2> /dev/null)" ]; then
		log_info "================================================="
		log_info "NOTE: Please Install NodeJS manually"
		log_info "e.g. sudo_wrapper tar -Jxv -f ${HOME}/Downloads/node-v22.16.0-linux-x64.tar.xz --strip-components=ponents=1 -C /usr/local"
		log_info "================================================="
	fi

	if [ ! -d "${HOME}/.vim" ]; then
		vimrc_file="$HOME/.vimrc"
		vim_dir="$HOME/.vim"

		[ -f $vimrc_file ] && {
			rm -rf $vimrc_file
		}

		ln -sf $vim_dir/init.vim $HOME/.vimrc

		[ -f $vim_dir ] && {
			rm -rf $vim_dir
		}

		tar -cf - vim | tar -xf - -C $HOME && mv $HOME/vim $HOME/.vim

		cd ${HOME}/.config/coc/extensions/node_modules/coc-ccls && ln -sf node_modules/ws/lib
		sudo_wrapper npm i -g bash-language-server
	else
		log_warn "Vim configuration had been installed..."
	fi
}


##### INSTALL BEGIN####
DISTRO_ID=$(cat /etc/lsb-release  | grep DISTRIB_ID | awk -F= '{print $NF}')
DISTRO_RELEASE=$(cat /etc/lsb-release  | grep DISTRIB_RELEASE | awk -F= '{print $NF}')

case "${DISTRO_ID}-${DISTRO_RELEASE}" in
      Ubuntu-24.04|Ubuntu-22.04Ubuntu-21.04|Ubuntu-20.04|Ubuntu-20.10|Ubuntu-18.04|Ubuntu-16.04)
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

if [ -z "${DEF_PASSWD}" ]; then
	read -s -p "Please input password for administrator: " DEF_PASSWD
	echo ""

	if [ -z "${DEF_PASSWD}" ]; then
		echo "Password for administrator is empty..."
		exit
	fi
fi

install_utilities $DISTRO_SUPPORT
configure_vim $DISTRO_SUPPORT
configure_bashrc
configure_gitconfig

log_info "Deploy completed..."

##### INSTALL END####

