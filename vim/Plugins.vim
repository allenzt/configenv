set nocompatible               " be iMproved
filetype off                   " required!

call plug#begin()

"------------------
" Code Completions
"------------------
Plug 'Valloric/YouCompleteMe'
" Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}

Plug 'jiangmiao/auto-pairs'
"Plug 'Raimondi/delimitMate'

"Plug 'Shougo/echodoc.vim'

"Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
"Plug 'sjl/gundo.vim'
"Plug 'ludovicchabant/vim-gutentags'
"Plug 'skywind3000/gutentags_plus'
Plug 'joereynolds/gtags-scope'
" Plug 'jsfaint/gen_tags.vim' 
" Plug 'aceofall/gtags.vim'

Plug 'w0rp/ale'
"Plug 'zivyangll/git-blame.vim'
"Plug 'mhinz/vim-signify'
Plug 'SirVer/ultisnips'
"Plug 'tenfyzhong/CompleteParameter.vim' "should loaded after 'SirVer/ultisnips'
"Plug 'drmingdrmer/xptemplate'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
"Plug 'mileszs/ack.vim'
"Plug 'Yggdroot/LeaderF'
"Plug 'OmniCppComplete'
Plug 'bling/vim-airline'

"------- markup language -------
Plug 'tpope/vim-markdown'
" Plug 'timcharper/textile.vim'

"------- FPs ------
Plug 'kien/rainbow_parentheses.vim'
"Plug 'sheerun/vim-polyglot'
" Plug 'wsdjeg/FlyGrep.vim'

call plug#end()

"filetype Plugin indent on     " required!

