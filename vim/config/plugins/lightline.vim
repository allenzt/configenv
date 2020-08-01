let g:lightline = {
      \ 'colorscheme': 'powerline',
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
