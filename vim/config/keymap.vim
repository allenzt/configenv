"------------------------------------------- base key map
" set paste or nopaste
nnoremap <F4> :set invpaste paste?<CR>
set pastetoggle=<F4>
noremap qq <C-W><C-W>
"file undo
nmap <Leader>u :GundoToggle<cr>
" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" w!! to sudo & write a file
cmap w!! %!sudo tee >/dev/null %
" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
" remove tailing space
:command CC 1,$s/\s\+$//g
"ShortCuts Keys for file buffer
nnoremap <tab> :bn <cr>
nnoremap <S-tab> :bp <cr>

"------------------------------------------- ale
nmap <silent> <C-j> <Plug>(ale_previous_wrap)
nmap <silent> <C-k> <Plug>(ale_next_wrap)
" nn <silent> <M-d> :ALEGoToDefinition<cr>
" nn <silent> <M-r> :ALEFindReferences<cr>
" nn <silent> <M-a> :ALESymbolSearch<cr>
" nn <silent> <M-h> :ALEHover<cr>

"------------------------------------------- airline buffer
" airline key map
" nmap <M-h> <Plug>AirlineSelectPrevTab
" nmap <M-l> <Plug>AirlineSelectNextTab

"------------------------------------------- leaderf
" nnoremap <C-F> :LeaderfFile<CR>
nnoremap <C-f> :LeaderfFunction<CR>
" nnoremap <C-l> :LeaderfLine<CR>
" nnoremap <C-B> :LeaderfBufferTag<CR>
" nnoremap <C-r> :LeaderfMru<CR>

"函数搜索（仅当前文件里）
nnoremap <silent> <Leader>f :Leaderf function<CR>

"模糊搜索，很强大的功能，迅速秒搜
nnoremap <silent> <Leader>rg :Leaderf rg<CR>

"------------------------------------------- easymotion
nmap <M-k> <Plug>(easymotion-overwin-f)
" Move to line
nmap <M-j> <Plug>(easymotion-overwin-line)

"------------------------------------------- goyo
" nnoremap <F7> <esc>:Goyo<cr>

"------------------------------------------- ChooseWin
" nnoremap <silent> <M-w> :ChooseWin<CR>

"------------------------------------------- Autoformat
nnoremap <M-i> :Autoformat<cr>

"------------------------------------------- tagbar
nnoremap <F2> :TagbarToggle<cr>

"------------------------------------------- defx
" function Open_cur_file_dir()
"     let g:cur_dir = expand("%:p:h")
"     exec 'Defx '.g:cur_dir
" endfunction

" nnoremap <F2> <esc>:call Open_cur_file_dir()<cr>

"------------------------------------------- matchtag
" nnoremap <space>5 :MtaJumpToOtherTag<cr>

"------------------------------------------- vimtranslateme
" nmap <silent> <M-d> <Plug>TranslateW
" vmap <silent> <M-d> <Plug>TranslateWV
" nmap <silent> <Leader>r <Plug>TranslateR
" vmap <silent> <Leader>r <Plug>TranslateRV

"------------------------------------------- Startify
" noremap <leader>s <esc>:Startify<cr>
"
"------------------------------------------- cscope shortcut
nmap <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>

"git blame folat window
nmap <silent><Leader>b :call setbufvar(winbufnr(popup_atcursor(split(system("git log -n 1 -L " . line(".") . ",+1:" . expand("%:p")), "\n"), { "padding": [1,1,1,1], "pos": "botleft", "wrap": 0 })), "&filetype", "git")<CR>
