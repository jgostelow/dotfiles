" https://github.com/fatih/vim-go-tutorial
" Run GoImports & GoMetaLinter on save - can be slow on large codebases
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1

" Highlight identifiers so they stand out
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
" Highlight occurences of the identifier you are on
" let g:go_auto_sameids = 1
"
" https://github.com/fatih/vim-go/blob/master/doc/vim-go.txt#L1315
" Auto show function signature of highlighted symbol
let g:go_auto_type_info = 1

" https://github.com/golang/go/wiki/gopls#vim--neovim
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Compile current file
map gb :GoBuild<CR>
" Show test coverage - gc
map gc :GoCoverageToggle<CR>
" Open corresponding test/source in a vsplit
map ga :vsplit<CR>:GoAlternate<CR>
" GoDef - Go to definition - gd (built in)
" Go back to usage - ctrl-t
map gd :GoDef<CR>
map gvd :vsplit<CR>:GoDef<CR>
" gr - find referrers to highlighted identifier
map gr :GoReferrers<CR>
" Show function definitions in current file - gf
map gf :GoDecls<CR>
" Show methods for highlighted package/instance - gh"
map gh :GoDescribe<CR>
" Show signature for highlighted function
map gi :GoDoc<CR>
" Go to next function - ]] (built-in)
" Go to previous function - ]] (built_in)
" :GoRename - Rename a function (refactor)
" :GoImplements - shows what interfaces the type implements
" :GoImpl <interface_name> - Adds method to a type to make it implement the interface
