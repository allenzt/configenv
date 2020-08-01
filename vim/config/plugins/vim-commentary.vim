"python, sell, coffee
autocmd FileType python,shell,coffee set commentstring=#\ %s
"java, c, cpp
autocmd FileType java,c,cpp set commentstring=/*\ %s\ */
" 1. 普通模式
" gc{text-object}：注释文本对象所占据的行；
" gcap：注释整个段落；
" {count}gcc：注释，或取消注释光标所在行。count 默认为1，即对当前行生效。count 如果大于1，表示对连续的 count 行生效；
" gcgc、 gcu：取消连续多行的注释，连续多行可以包含空白行；
" 2. 可视模式
" gc：注释，或取消注释选中行；
" 3. 命令模式
" {range}Commentary：注释，或取消注释 range 指定的行；
