"======================================================================
"
" init-plugins.vim - 
"
" Created by skywind on 2018/05/31
" Last Modified: 2018/06/10 23:11
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :



"----------------------------------------------------------------------
" 默认情况下的分组，可以再前面覆盖之
"----------------------------------------------------------------------
if !exists('g:bundle_group')
	let g:bundle_group = ['basic',
						\ 'enhanced', 
						\ 'filetypes',
						\ 'textobj', 
						\ 'gtags-cscope', 
						\ 'nerdtree', 
						\ 'tagbar', 
						\ 'leaderf', 
						\ 'coc', 
						\ 'lightline', 
						\ 'theme', 
						\ 'git-messenger', 
						\ ]
endif


"----------------------------------------------------------------------
" 计算当前 vim-init 的子路径
"----------------------------------------------------------------------
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

function! s:path(path)
	let path = expand(s:home . '/' . a:path )
	return substitute(path, '\\', '/', 'g')
endfunc


"----------------------------------------------------------------------
" 在 ~/.vim/bundles 下安装插件
"----------------------------------------------------------------------
call plug#begin(get(g:, 'bundle_home', '~/.vim/bundles'))


"----------------------------------------------------------------------
" 默认插件 
"----------------------------------------------------------------------

" 全文快速移动，<leader><leader>f{char} 即可触发
Plug 'easymotion/vim-easymotion'
" Usage:
" <Leader>f{char}      | Find {char} to the right. See |f|.
" <Leader>F{char}      | Find {char} to the left. See |F|.
" <Leader>t{char}      | Till before the {char} to the right. See |t|.
" <Leader>T{char}      | Till after the {char} to the left. See |T|.
" <Leader>w            | Beginning of word forward. See |w|.
" <Leader>W            | Beginning of WORD forward. See |W|.
" <Leader>b            | Beginning of word backward. See |b|.
" <Leader>B            | Beginning of WORD backward. See |B|.
" <Leader>e            | End of word forward. See |e|.
" <Leader>E            | End of WORD forward. See |E|.
" <Leader>ge           | End of word backward. See |ge|.
" <Leader>gE           | End of WORD backward. See |gE|.
" <Leader>j            | Line downward. See |j|.
" <Leader>k            | Line upward. See |k|.
" <Leader>n            | Jump to latest "/" or "?" forward. See |n|.
" <Leader>N            | Jump to latest "/" or "?" backward. See |N|.
" <Leader>s            | Find(Search) {char} forward and backward.
"                      | See |f| and |F|.

" 文件浏览器，代替 netrw
Plug 'justinmk/vim-dirvish'

" 表格对齐
" 介绍文档：https://xu3352.github.io/linux/2018/10/18/vim-table-format-in-html-or-markdown
Plug 'junegunn/vim-easy-align'
" 在visual mode中启动交互式EasyAlign(e.g. vipga)
xmap ga <Plug>(EasyAlign)
" xmap ga <Plug>(LiveEasyAlign)
" 在normal mode中启动交互式EasyAlign(e.g. vipga)
nmap ga <Plug>(EasyAlign)
let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '/': {
\     'pattern':         '//\+\|/\*\|\*/',
\     'delimiter_align': 'l',
\     'ignore_groups':   ['!Comment'] },
\ ']': {
\     'pattern':       '[[\]]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       '[()]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ 'd': {
\     'pattern':      ' \(\S\+\s*[;=]\)\@=',
\     'left_margin':  0,
\     'right_margin': 0
\   }
\ }

" Diff 增强，支持 histogram / patience 等更科学的 diff 算法
Plug 'chrisbra/vim-diff-enhanced'


"----------------------------------------------------------------------
" Dirvish 设置：自动排序并隐藏文件，同时定位到相关文件
" 这个排序函数可以将目录排在前面，文件排在后面，并且按照字母顺序排序
" 比默认的纯按照字母排序更友好点。
"----------------------------------------------------------------------
function! s:setup_dirvish()
	if &buftype != 'nofile' && &filetype != 'dirvish'
		return
	endif
	if has('nvim')
		return
	endif
	" 取得光标所在行的文本（当前选中的文件名）
	let text = getline('.')
	if ! get(g:, 'dirvish_hide_visible', 0)
		exec 'silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _'
	endif
	" 排序文件名
	exec 'sort ,^.*[\/],'
	let name = '^' . escape(text, '.*[]~\') . '[/*|@=|\\*]\=\%($\|\s\+\)'
	" 定位到之前光标处的文件
	call search(name, 'wc')
	noremap <silent><buffer> ~ :Dirvish ~<cr>
	noremap <buffer> % :e %
endfunc

augroup MyPluginSetup
	autocmd!
	autocmd FileType dirvish call s:setup_dirvish()
augroup END


"----------------------------------------------------------------------
" 基础插件
"----------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0

	" 展示开始画面，显示最近编辑过的文件
	Plug 'mhinz/vim-startify'

	" 默认显示 startify
	let g:startify_disable_at_vimenter = 0
	let g:startify_session_dir = '~/.vim/session'

	" 一次性安装一大堆 colorscheme
	" Plug 'flazz/vim-colorschemes'

	" 支持库，给其他插件用的函数库
	Plug 'xolox/vim-misc'

	" surrouding 插件
	Plug 'machakann/vim-sandwich'

	" 用于在侧边符号栏显示 marks （ma-mz 记录的位置）
	Plug 'kshenoy/vim-signature'

	" 用于在侧边符号栏显示 git/svn 的 diff
	Plug 'mhinz/vim-signify'

	" 根据 quickfix 中匹配到的错误信息，高亮对应文件的错误行
	" 使用 :RemoveErrorMarkers 命令或者 <space>ha 清除错误
	" Plug 'mh21/errormarker.vim'

	" 使用 ALT+e 会在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转
	" Plug 't9md/vim-choosewin'

	" 提供基于 TAGS 的定义预览，函数参数预览，quickfix 预览
	" Plug 'skywind3000/vim-preview'

	" Git 支持
	Plug 'tpope/vim-fugitive'

	" 使用 ALT+E 来选择窗口
	" nmap <m-e> <Plug>(choosewin)

	" 使用 <space>ha 清除 errormarker 标注的错误
	" noremap <silent><space>ha :RemoveErrorMarkers<cr>

	" signify 调优
	let g:signify_vcs_list = ['git', 'svn']
	let g:signify_sign_add               = '+'
	let g:signify_sign_delete            = '_'
	let g:signify_sign_delete_first_line = '‾'
	let g:signify_sign_change            = '~'
	let g:signify_sign_changedelete      = g:signify_sign_change

	" git 仓库使用 histogram 算法进行 diff
	let g:signify_vcs_cmds = {
			\ 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
			\}
endif


"----------------------------------------------------------------------
" 增强插件
"----------------------------------------------------------------------
if index(g:bundle_group, 'enhanced') >= 0

	" 用 v 选中一个区域后，ALT_+/- 按分隔符扩大/缩小选区
	" Plug 'terryma/vim-expand-region'

	" 快速文件搜索
	Plug 'junegunn/fzf'

	" 给不同语言提供字典补全，插入模式下 c-x c-k 触发
	" Plug 'asins/vim-dict'

	" 使用 :FlyGrep 命令进行实时 grep
	" Plug 'wsdjeg/FlyGrep.vim'

	" 使用 :CtrlSF 命令进行模仿 sublime 的 grep
	" Plug 'dyng/ctrlsf.vim'

	" 配对括号和引号自动补全
	Plug 'jiangmiao/auto-pairs'

	" 提供 gist 接口
	"Plug 'lambdalisue/vim-gista', { 'on': 'Gista' }

	" ALT_+/- 用于按分隔符扩大缩小 v 选区
	" map <m-=> <Plug>(expand_region_expand)
	" map <m--> <Plug>(expand_region_shrink)
endif


"----------------------------------------------------------------------
" 自动生成 ctags/gtags，并提供自动索引功能
" 不在 git/svn 内的项目，需要在项目根目录 touch 一个空的 .root 文件
" 详细用法见：https://zhuanlan.zhihu.com/p/36279445
"----------------------------------------------------------------------
if index(g:bundle_group, 'tags') >= 0

	" 提供 ctags/gtags 后台数据库自动更新功能
	Plug 'ludovicchabant/vim-gutentags'

	" 提供 GscopeFind 命令并自动处理好 gtags 数据库切换
	" 支持光标移动到符号名上：<leader>cg 查看定义，<leader>cs 查看引用
	Plug 'skywind3000/gutentags_plus'

	" 设定项目目录标志：除了 .git/.svn 外，还有 .root 文件
	let g:gutentags_project_root = ['.root']
	let g:gutentags_ctags_tagfile = '.tags'

	" 默认生成的数据文件集中到 ~/.cache/tags 避免污染项目目录，好清理
	let g:gutentags_cache_dir = expand('~/.cache/tags')

	" 默认禁用自动生成
	let g:gutentags_modules = [] 

	" 如果有 ctags 可执行就允许动态生成 ctags 文件
	if executable('ctags')
		let g:gutentags_modules += ['ctags']
	endif

	" 如果有 gtags 可执行就允许动态生成 gtags 数据库
	if executable('gtags') && executable('gtags-cscope')
		let g:gutentags_modules += ['gtags_cscope']
	endif

	" 设置 ctags 的参数
	let g:gutentags_ctags_extra_args = []
	let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
	let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
	let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

	" 使用 universal-ctags 的话需要下面这行，请反注释
	" let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

	" 禁止 gutentags 自动链接 gtags 数据库
	let g:gutentags_auto_add_gtags_cscope = 0
endif

"----------------------------------------------------------------------
" gtags使用cscope接口
"----------------------------------------------------------------------

if index(g:bundle_group, 'gtags-cscope') >= 0

	" 提供 gtags 接口
	Plug 'joereynolds/gtags-scope'

	" let $GTAGSLABEL = 'native-pygments'
	let $GTAGSLABEL = 'native'
	" let $GTAGSCONF = '/home/dengzt/.gtagsrc'
	let cscopeprg = '/usr/bin/gtags-cscope'
	set csto=0
	set cst
	let GtagsCscope_Auto_Load = 1
	" let CtagsCscope_Auto_Map = 1
	let GtagsCscope_Quiet = 1
	"set cscopequickfix=s-,g-,d-,c-,t-,e-,f-,i-

	" 查找此函数的定义 
	nnoremap <leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
	" 查找调用此函数的函数
	nnoremap <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
	" 查找由此函数调用的函数
	nnoremap <leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>
	" 以egrep模式匹配目标cword
	nnoremap <leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>
	" 查找包含由cword的文件
	nnoremap <leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
	" Find files #including this file
	nnoremap <leader>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
	" 查找出现的cword符号
	nnoremap <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	" Find this text string
	nnoremap <leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>

	" 跳转的结果以竖直方式创建新的tab
	nnoremap <leader>vs :vert scs find s <C-R>=expand("<cword>")<CR><CR>
	nnoremap <leader>vg :vert scs find g <C-R>=expand("<cword>")<CR><CR>
	nnoremap <leader>vc :vert scs find c <C-R>=expand("<cword>")<CR><CR>
	nnoremap <leader>vt :vert scs find t <C-R>=expand("<cword>")<CR><CR>
	nnoremap <leader>ve :vert scs find e <C-R>=expand("<cword>")<CR><CR>
	nnoremap <leader>vf :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
	nnoremap <leader>vi :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nnoremap <leader>vd :vert scs find d <C-R>=expand("<cword>")<CR><CR>

	function! GtagsUpdateAll()
		let l:result = system("global -u")
	endfunction

	function! GtagsUpdateSingleFile()
		let l:result = system("global -u --single-update=\"" . expand("%") . "\"")
	endfunction

	nnoremap <silent>cu :call GtagsUpdateAll()<CR>
	nnoremap <silent>cuf :call GtagsUpdateSingleFile()<CR>
endif

"----------------------------------------------------------------------
" 文本对象：textobj 全家桶
"----------------------------------------------------------------------
if index(g:bundle_group, 'textobj') >= 0

	" 基础插件：提供让用户方便的自定义文本对象的接口
	Plug 'kana/vim-textobj-user'

	" indent 文本对象：ii/ai 表示当前缩进，vii 选中当缩进，cii 改写缩进
	Plug 'kana/vim-textobj-indent'

	" 语法文本对象：iy/ay 基于语法的文本对象
	Plug 'kana/vim-textobj-syntax'

	" 函数文本对象：if/af 支持 c/c++/vim/java
	Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }

	" 参数文本对象：i,/a, 包括参数或者列表元素
	Plug 'sgur/vim-textobj-parameter'

	" 提供 python 相关文本对象，if/af 表示函数，ic/ac 表示类
	Plug 'bps/vim-textobj-python', {'for': 'python'}

	" 提供 uri/url 的文本对象，iu/au 表示
	Plug 'jceb/vim-textobj-uri'
endif


"----------------------------------------------------------------------
" 文件类型扩展
"----------------------------------------------------------------------
if index(g:bundle_group, 'filetypes') >= 0

	" powershell 脚本文件的语法高亮
	" Plug 'pprovost/vim-ps1', { 'for': 'ps1' }

	" lua 语法高亮增强
	Plug 'tbastos/vim-lua', { 'for': 'lua' }

	" C++ 语法高亮增强，支持 11/14/17 标准
	Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

	" 额外语法文件
	Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'bison', 'flex', 'cpp'] }

	" python 语法文件增强
	Plug 'vim-python/python-syntax', { 'for': ['python'] }

	" rust 语法增强
	Plug 'rust-lang/rust.vim', { 'for': 'rust' }

	" vim org-mode 
	" Plug 'jceb/vim-orgmode', { 'for': 'org' }
endif


"----------------------------------------------------------------------
" airline
"----------------------------------------------------------------------
if index(g:bundle_group, 'airline') >= 0
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	let g:airline_left_sep = ''
	let g:airline_left_alt_sep = ''
	let g:airline_right_sep = ''
	let g:airline_right_alt_sep = ''
	let g:airline_powerline_fonts = 0
	let g:airline_exclude_preview = 1
	let g:airline_section_b = '%n'
	let g:airline_theme='deus'
	let g:airline#extensions#branch#enabled = 0
	let g:airline#extensions#syntastic#enabled = 0
	let g:airline#extensions#fugitiveline#enabled = 0
	let g:airline#extensions#csv#enabled = 0
	let g:airline#extensions#vimagit#enabled = 0
endif


"----------------------------------------------------------------------
" NERDTree
"----------------------------------------------------------------------
if index(g:bundle_group, 'nerdtree') >= 0
	Plug 'scrooloose/nerdtree', {'on': ['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind'] }
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	let g:NERDTreeMinimalUI = 1
	let g:NERDTreeDirArrows = 1
	let g:NERDTreeHijackNetrw = 0
	noremap <space>nn :NERDTree<cr>
	noremap <space>no :NERDTreeFocus<cr>
	noremap <space>nm :NERDTreeMirror<cr>
	noremap <space>nt :NERDTreeToggle<cr>
endif

"----------------------------------------------------------------------
" Tagbar
"----------------------------------------------------------------------
if index(g:bundle_group, 'tagbar') >= 0
	Plug 'majutsushi/tagbar',  { 'for': ['asm', 'h', 'hpp', 'c', 'cpp', 'python', 'js', 'ts', 'java', 'go', 'html', 'css', 'vim', 'sh', 'tex', 'md'] }
	noremap <F2> :TagbarToggle<cr>
    let g:tagbar_ctags_bin = 'ctags'  " tagbar以来ctags插件
    " let g:tagbar_width = 30         " 设置tagbar的宽度为30列，默认40
    let g:tagbar_autofocus = 1        " 这是tagbar一打开，光标即在tagbar页面内，默认在vim打开的文件内
    let g:tagbar_sort      = 0        " 设置标签不排序，默认排序
endif

"----------------------------------------------------------------------
" LanguageTool 语法检查
"----------------------------------------------------------------------
if index(g:bundle_group, 'grammer') >= 0
	Plug 'rhysd/vim-grammarous'
	noremap <space>rg :GrammarousCheck --lang=en-US --no-move-to-first-error --no-preview<cr>
	map <space>rr <Plug>(grammarous-open-info-window)
	map <space>rv <Plug>(grammarous-move-to-info-window)
	map <space>rs <Plug>(grammarous-reset)
	map <space>rx <Plug>(grammarous-close-info-window)
	map <space>rm <Plug>(grammarous-remove-error)
	map <space>rd <Plug>(grammarous-disable-rule)
	map <space>rn <Plug>(grammarous-move-to-next-error)
	map <space>rp <Plug>(grammarous-move-to-previous-error)
endif


"----------------------------------------------------------------------
" ale：动态语法检查
"----------------------------------------------------------------------
if index(g:bundle_group, 'ale') >= 0
	Plug 'w0rp/ale'

	" 设定延迟和提示信息
	let g:ale_completion_delay = 500
	let g:ale_echo_delay = 20
	let g:ale_lint_delay = 500
	let g:ale_echo_msg_format = '[%linter%] %code: %%s'

	" 设定检测的时机：normal 模式文字改变，或者离开 insert模式
	" 禁用默认 INSERT 模式下改变文字也触发的设置，太频繁外，还会让补全窗闪烁
	let g:ale_lint_on_text_changed = 'normal'
	let g:ale_lint_on_insert_leave = 1

	" 在 linux/mac 下降低语法检查程序的进程优先级（不要卡到前台进程）
	if has('win32') == 0 && has('win64') == 0 && has('win32unix') == 0
		let g:ale_command_wrapper = 'nice -n5'
	endif

	" 允许 airline 集成
	let g:airline#extensions#ale#enabled = 1

	" 编辑不同文件类型需要的语法检查器
	let g:ale_linters = {
				\ 'c': ['gcc', 'cppcheck'], 
				\ 'cpp': ['gcc', 'cppcheck'], 
				\ 'python': ['flake8', 'pylint'], 
				\ 'lua': ['luac'], 
				\ 'go': ['go build', 'gofmt'],
				\ 'java': ['javac'],
				\ 'javascript': ['eslint'], 
				\ }


	" 获取 pylint, flake8 的配置文件，在 vim-init/tools/conf 下面
	function s:lintcfg(name)
		let conf = s:path('tools/conf/')
		let path1 = conf . a:name
		let path2 = expand('~/.vim/linter/'. a:name)
		if filereadable(path2)
			return path2
		endif
		return shellescape(filereadable(path2)? path2 : path1)
	endfunc

	" 设置 flake8/pylint 的参数
	let g:ale_python_flake8_options = '--conf='.s:lintcfg('flake8.conf')
	let g:ale_python_pylint_options = '--rcfile='.s:lintcfg('pylint.conf')
	let g:ale_python_pylint_options .= ' --disable=W'
	let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
	let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
	let g:ale_c_cppcheck_options = ''
	let g:ale_cpp_cppcheck_options = ''

	let g:ale_linters.text = ['textlint', 'write-good', 'languagetool']

	" 如果没有 gcc 只有 clang 时（FreeBSD）
	if executable('gcc') == 0 && executable('clang')
		let g:ale_linters.c += ['clang']
		let g:ale_linters.cpp += ['clang']
	endif
endif

"----------------------------------------------------------------------
" LeaderF：CtrlP / FZF 的超级代替者，文件模糊匹配，tags/函数名 选择
"----------------------------------------------------------------------
if index(g:bundle_group, 'leaderf') >= 0
	" 如果 vim 支持 python 则启用  Leaderf
	if has('python') || has('python3')
		Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

		" CTRL+p 打开文件模糊匹配
		let g:Lf_ShortcutF = '<c-p>'

		" ALT+n 打开 buffer 模糊匹配
		let g:Lf_ShortcutB = '<c-n>'

		" CTRL+n 打开最近使用的文件 MRU，进行模糊匹配
		noremap <c-n> :LeaderfMru<cr>

		" CTRL+f 打开函数列表，按 i 进入模糊匹配，ESC 退出
		noremap <c-f> :LeaderfFunction!<cr>

		" ALT+SHIFT+p 打开 tag 列表，i 进入模糊匹配，ESC退出
		noremap <c-t> :LeaderfBufTag!<cr>

		" ALT+n 打开 buffer 列表进行模糊匹配
		noremap <m-b> :LeaderfBuffer<cr>

		" ALT+m 全局 tags 模糊匹配
		noremap <m-m> :LeaderfTag<cr>

		" 最大历史文件保存 2048 个
		let g:Lf_MruMaxFiles = 2048

		" ui 定制
		let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

		" 如何识别项目目录，从当前文件目录向父目录递归知道碰到下面的文件/目录
		let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
		let g:Lf_WorkingDirectoryMode = 'Ac'
		let g:Lf_WindowHeight = 0.30
		let g:Lf_CacheDirectory = expand('~/.vim/cache')

		" 显示绝对路径
		let g:Lf_ShowRelativePath = 0

		" 隐藏帮助
		let g:Lf_HideHelp = 1

		" 模糊匹配忽略扩展名
		let g:Lf_WildIgnore = {
					\ 'dir': ['.svn','.git','.hg', '.ccls-cache'],
					\ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
					\ }

		" MRU 文件忽略扩展名
		let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
		let g:Lf_StlColorscheme = 'powerline'

		" LeaderF 窗口的位置
		let g:Lf_WindowPosition = 'popup'

		" 在弹出窗口中预览
		let g:Lf_PreviewInPopup = 1

		" 禁用 function/buftag 的预览功能，可以手动用 p 预览
		let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}

		" 使用 ESC 键可以直接退出 leaderf 的 normal 模式
		let g:Lf_NormalMap = {
				\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
				\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
				\ "Mru": [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
				\ "Tag": [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
				\ "BufTag": [["<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
				\ "Function": [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
				\ }
		" 在根目录搜索光标下的单词, 正则模式, 然后进入normal 模式
		noremap <F3> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>

		" 在当前buffer搜索光标下的单词, 正则模式, 然后进入normal 模式
		" noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer -e %s ", expand("<cword>"))<CR>

		" 在所有buffer搜索光标下的单词, 正则模式, 然后进入normal 模式
		" noremap <C-D> :<C-U><C-R>=printf("Leaderf! rg -F --all-buffers -e %s ", expand("<cword>"))<CR>

		" search visually selected text literally, don't quit LeaderF after accepting an entry
		" xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen -e %s ", leaderf#Rg#visual())<CR>

		" recall last search. If the result window is closed, reopen it.
		" noremap go :<C-U>Leaderf! rg --recall<CR>


		" search word under cursor in *.h and *.cpp files.
		" noremap <Leader>a :<C-U><C-R>=printf("Leaderf! rg -e %s -g *.h -g *.cpp", expand("<cword>"))<CR>
		" the same as above
		" noremap <Leader>a :<C-U><C-R>=printf("Leaderf! rg -e %s -g *.{h,cpp}", expand("<cword>"))<CR>

		" search word under cursor in cpp and java files.
		" noremap <Leader>b :<C-U><C-R>=printf("Leaderf! rg -e %s -t cpp -t java", expand("<cword>"))<CR>

		" search word under cursor in cpp files, exclude the *.hpp files
		" noremap <Leader>c :<C-U><C-R>=printf("Leaderf! rg -e %s -t cpp -g !*.hpp", expand("<cword>"))<CR>
		" Show icons, icons are shown by default
		let g:Lf_ShowDevIcons = 0 
		" For GUI vim, the icon font can be specify like this, for example
		" let g:Lf_DevIconsFont = "DroidSansM Nerd Font Mono"
		" If needs
		" set ambiwidth=double
	else
		" 不支持 python ，使用 CtrlP 代替
		Plug 'ctrlpvim/ctrlp.vim'

		" 显示函数列表的扩展插件
		Plug 'tacahiroy/ctrlp-funky'

		" 忽略默认键位
		let g:ctrlp_map = ''

		" 模糊匹配忽略
		let g:ctrlp_custom_ignore = {
		  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
		  \ 'file': '\v\.(exe|so|dll|mp3|wav|sdf|suo|mht)$',
		  \ 'link': 'some_bad_symbolic_links',
		  \ }

		" 项目标志
		let g:ctrlp_root_markers = ['.project', '.root', '.svn', '.git']
		let g:ctrlp_working_path = 0

		" CTRL+p 打开文件模糊匹配
		noremap <c-p> :CtrlP<cr>

		" CTRL+n 打开最近访问过的文件的匹配
		noremap <c-r> :CtrlPMRUFiles<cr>

		" ALT+p 显示当前文件的函数列表
		noremap <c-p> :CtrlPFunky<cr>

		" ALT+n 匹配 buffer
		noremap <c-n> :CtrlPBuffer<cr>
	endif
endif

if index(g:bundle_group, 'coc') >= 0
	"安装coc插件
	Plug 'neoclide/coc.nvim', {'branch': 'release'}

	let g:coc_global_extensions =
				\ [
				\ 'coc-vimlsp',
				\ 'coc-python',
				\ 'coc-tsserver',
				\ 'coc-vimtex',
				\ 'coc-html',
				\ 'coc-css',
				\ 'coc-yaml',
				\ 'coc-json',
				\ 'coc-emmet',
				\ 'coc-snippets',
				\ 'coc-highlight',
				\ 'coc-ccls',
				\ 'coc-sh',
				\ 'coc-rust-analyzer',
				\ 'coc-syntax',
				\ 'coc-word',
				\ 'coc-emoji',
				\ ]

	" use <tab> to trigger completion and navigate to the next complete item
	function! CheckBackspace() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
	inoremap <silent><expr> <Tab>
				\ coc#pum#visible() ? coc#pum#next(1) :
				\ CheckBackspace() ? "\<Tab>" :
				\ coc#refresh()

	inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
	inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

	function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" 回车完成代码块
	inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() :
											\"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	" 跳转到下一个标记处
	let g:coc_snippet_next = '<TAB>'
	let g:coc_snippet_pre = '<S-TAB>'

	" 使用ctrl space触发补全
	inoremap <silent><expr> <c-space> coc#refresh()

	" diagnostic 跳转
	nmap <silent> <space>[ <Plug>(coc-diagnostic-prev)
	nmap <silent> <space>] <Plug>(coc-diagnostic-next)

	" 定义跳转
	nmap <silent> gd <Plug>(coc-definition)
	" nmap <silent> gd :call CocAction('jumpDefinition', 'vsplit')
	" nmap <silent> gd :vsp<CR><Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" function! ShowDocumentation()
	" 	if CocAction('hasProvider', 'hover')
	" 		call CocActionAsync('doHover')
	" 	else
	" 		call feedkeys('K', 'in')
	" 	endif
	" endfunction

	" " Use K to show documentation in preview window
	" nnoremap <silent> K :call ShowDocumentation()<CR>

	" nnoremap <silent> <space>k :call CocActionAsync('showSignatureHelp')<CR>

	" Highlight symbol under cursor on CursorHold
	set updatetime=100
	au CursorHold * silent call CocActionAsync('highlight')
	au CursorHoldI * sil call CocActionAsync('showSignatureHelp')

	" Remap for rename current word
	nmap <space>rn <Plug>(coc-rename)

	augroup mygroup
	autocmd!
	" Setup formatexpr specified filetype(s).
	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end

	" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
	" xmap <leader>a  <Plug>(coc-codeaction-selected)
	" nmap <leader>a  <Plug>(coc-codeaction-selected)
	" Remap for do codeAction of current line
	" nmap <leader>ac  <Plug>(coc-codeaction)
	" Fix autofix problem of current line
	" lsp如果实现quickfix功能，那么通过space qf就可以快速进行修复
	nmap <space>qf  <Plug>(coc-fix-current)

	" Remap for format selected region
	xmap <space>f  <Plug>(coc-format-selected)
	nmap <space>f  <Plug>(coc-format-selected)
	" Use `:Format` to format current buffer
	command! -nargs=0 Format :call CocAction('format')

	" Use `:Fold` to fold current buffer
	"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Using CocList
	" Show all diagnostics
	nnoremap <silent> <space>d  :<C-u>CocList diagnostics<cr>
	" Manage extensions
	nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
	" Show commands
	nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document
	nnoremap <silent> <space>t  :<C-u>CocList outline<cr>
	" Search workspace symbols
	nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
	" Do default action for next item.
	" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item.
	" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list
	nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
	" show coclist
	nnoremap <silent> <space>l  :<C-u>CocList<CR>
endif

if index(g:bundle_group, 'ycm') >= 0
"----------------------------------------------------------------------
" YouCompleteMe 默认设置：YCM 需要你另外手动编译安装
"----------------------------------------------------------------------

" 禁用预览功能：扰乱视听
let g:ycm_add_preview_to_completeopt = 0

" 禁用诊断功能：我们用前面更好用的 ALE 代替
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
set completeopt=menu,menuone,noselect

" noremap <c-z> <NOP>

" 两个字符自动触发语义补全
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }

"----------------------------------------------------------------------
" Ycm 白名单（非名单内文件不启用 YCM），避免打开个 1MB 的 txt 分析半天
"----------------------------------------------------------------------
let g:ycm_filetype_whitelist = {
			\ "c":1,
			\ "cpp":1,
			\ "objc":1,
			\ "objcpp":1,
			\ "python":1,
			\ "java":1,
			\ "javascript":1,
			\ "coffee":1,
			\ "vim":1, 
			\ "go":1,
			\ "cs":1,
			\ "lua":1,
			\ "perl":1,
			\ "perl6":1,
			\ "php":1,
			\ "ruby":1,
			\ "rust":1,
			\ "erlang":1,
			\ "asm":1,
			\ "nasm":1,
			\ "masm":1,
			\ "tasm":1,
			\ "asm68k":1,
			\ "asmh8300":1,
			\ "asciidoc":1,
			\ "basic":1,
			\ "vb":1,
			\ "make":1,
			\ "cmake":1,
			\ "html":1,
			\ "css":1,
			\ "less":1,
			\ "json":1,
			\ "cson":1,
			\ "typedscript":1,
			\ "haskell":1,
			\ "lhaskell":1,
			\ "lisp":1,
			\ "scheme":1,
			\ "sdl":1,
			\ "sh":1,
			\ "zsh":1,
			\ "bash":1,
			\ "man":1,
			\ "markdown":1,
			\ "matlab":1,
			\ "maxima":1,
			\ "dosini":1,
			\ "conf":1,
			\ "config":1,
			\ "zimbu":1,
			\ "ps1":1,
			\ }
endif

"----------------------------------------------------------------------
" colorscheme
"----------------------------------------------------------------------
if index(g:bundle_group, 'theme') >= 0
	" Plug 'lifepillar/vim-colortemplate'
	Plug 'tomasiser/vim-code-dark'
	" Plug 'dunstontc/vim-vscode-theme'
endif

"----------------------------------------------------------------------
" lightline
"----------------------------------------------------------------------
if index(g:bundle_group, 'lightline') >= 0
	Plug 'itchyny/lightline.vim'
	Plug 'ap/vim-buftabline'
	let g:lightline = {
		  \ 'colorscheme': 'codedark',
		  \ 'active': {
		  \   'left': [ [ 'mode', 'paste' ],
		  \             [ 'readonly', 'filename', 'modified', 'helloworld' ] ]
		  \ },
		  \ 'component': {
		  \   'paste': '%{&paste?"PASTE":""}',
		  \ },
		  \ }
	let g:lightline.enable = {
		\ 'statusline': 1,
		\ 'tabline': 1
		\ }
endif

if index(g:bundle_group, 'git-messenger') >= 0
if has('nvim')
	Plug 'rhysd/git-messenger.vim'
endif
endif

"----------------------------------------------------------------------
" nvim-treesitter
"----------------------------------------------------------------------
if has('nvim')
	Plug 'nvim-treesitter/nvim-treesitter'
	let g:c_syntax_for_h = 1
endif

Plug 'github/copilot.vim'

"----------------------------------------------------------------------
" 结束插件安装
"----------------------------------------------------------------------
call plug#end()

if has('nvim')
	lua <<EOF
	require'nvim-treesitter.configs'.setup {
		ensure_installed = "c", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
		ignore_install = { "javascript" }, -- List of parsers to ignore installing
		highlight = {
			enable = true,              -- false will disable the whole extension
		},
		highlight = {
			enable = true
		},
		textobjects = {
			enable = true
		},
		indent = {
			enable = true
		},
	}
EOF
endif
