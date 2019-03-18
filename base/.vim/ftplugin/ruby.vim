" RuboCop - ctrl+b - run rubocop autocorrect on current file
" map <C-b> :RuboCop<CR>
" autocmd BufWritePre * :normal migg=G`i " Auto indent on save

" Switch between code and test - ga
map ga :AV<CR>
" ctags - navigate to tag
map gd <C-]>

augroup filetypedetect
	au BufRead,BufNewFile *.etl setfiletype ruby
augroup END

map gvd :vsplit<CR>gd<CR>

