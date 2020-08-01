" tagbar config begin
" if !empty(glob(plug_home."/tagbar"))

	let g:tagbar_left=0
	let g:tagbar_width=50
	let g:tagbar_autofocus = 1
	let g:tagbar_sort = 0
	let g:tagbar_compact = 1
	"tag for coffee
	if executable('coffeetags')
		let g:tagbar_type_coffee = {
					\ 'ctagsbin' : 'coffeetags',
					\ 'ctagsargs' : '',
					\ 'kinds' : [
					\ 'f:functions',
					\ 'o:object',
					\ ],
					\ 'sro' : ".",
					\ 'kind2scope' : {
					\ 'f' : 'object',
					\ 'o' : 'object',
					\ }
					\ }

		let g:tagbar_type_markdown = {
					\ 'ctagstype' : 'markdown',
					\ 'sort' : 0,
					\ 'kinds' : [
					\ 'h:sections'
					\ ]
					\ }
	endif
	let g:tagbar_iconchars = ['+', '-']

" endif
" tagbar config begin
