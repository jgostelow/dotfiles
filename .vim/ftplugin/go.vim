" https://github.com/fatih/vim-go-tutorial
" Run GoImports on save - can be slow on large codebases
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
" Auto show function signature of highlighted symbol
" let g:go_auto_type_info = 1

" Show test coverage - gc
map gc :GoCoverageToggle<CR>
" Open corresponding test/source in a vsplit
map ga :vsplit<CR>:GoAlternate<CR>
" GoDef - Go to definition - gd (built in)
" Go back to usage - ctrl-t
" gr - find referrers to highlighted identifier
map gr :GoReferrers<CR>
" Show function definitions in current file - gf
map gf :GoDecls<CR>
" Show methods for highlighted package/instance - gh"
map gh :GoDescribe<CR>
" Show signature for highlighted function
map gi :GoInfo<CR>
" Go to next function - ]] (built-in)
" Go to previous function - ]] (built_in)
" :GoRename - Rename a function (refactor)
" K - GoDoc
" :GoImplements - shows what interfaces the type implements
" :GoImpl <interface_name> - Adds method to a type to make it implement the interface
