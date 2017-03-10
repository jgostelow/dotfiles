execute pathogen#infect()

set nocompatible
set backspace=2       " enable backspace to work as expected
set number            " display line numbers
" read and write from system clipboard
" set clipboard=unnamed
set incsearch         " search as you type
set hlsearch          " highlight search results
set directory=$HOME/.vim/swapfiles/
filetype plugin indent on
syntax on
autocmd BufWritePre * %s/\s\+$//e " Remove white space on save
" Do not freeze on CTRL-S
silent !stty -ixon > /dev/null 2>/dev/null

" Do not overwrite buffer when pasting
vnoremap p "_dp
vnoremap P "_dP

" Clipboard
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>

" SPLIT WINDOWS
" close all windows with ctrl+\
map <C-\> :qa<CR>
" Move window up,download,left,right - ctrl+w ctrl+[w,a,s,d]
map <C-w><C-w> <C-w><S-K>
map <C-w><C-s> <C-w><S-J>
map <C-w><C-a> <C-w><S-H>
map <C-w><C-d> <C-w><S-L>
" move down a window when in split screen mode
map <C-J> <C-W>j<C-W>_
" move down a window when in split screen mode
map <C-K> <C-W>k<C-W>_
" maximise the current window
map <C-w>m <C-w>_<C-w>\|
" switch windows : ctrl+w-r (built-in)
set wmh=0         " minimise split windows completely instead of leaving current line
set splitbelow
set splitright

" FORMATTING
set tabstop=2     " a tab is 2 spaces
set smartindent   " nosi:  Smart indent useless when C-indent is on
set expandtab		  " use spaces instead of tabs
set shiftwidth=2  " sw:  a healthy tab stop
set textwidth=120 " tw:  wrap at 120 characters
set autoindent    " ai:  indent to match previous line
set formatoptions=crql  " fo:  word wrap, format comments
set showmatch     " show matches on parens, bracketc, etc.
set diffopt+=vertical

" COLORS
set bg=dark
colorscheme candycode
if &diff
  colorscheme delek
endif
" do not make transparent backgrounds opaque by highlighting them
hi Normal ctermbg=none
" make line numbers white
hi LineNr ctermfg=white

" Filetype handlers
augroup filetypedetect
  au! BufRead,BufNewFile *.hamlc	setfiletype	haml " Detect .hamlc files as haml
augroup END

" NERDTree - ctrl+e - Toggle NERDTree window
map <C-e> :NERDTreeToggle<CR>
let NERDTreeMapOpenVSplit = '<C-v>' " ctrl-v - open vsplit
let NERDTreeMapOpenSplit = '<C-x>' " ctrl-x - open split

" Ctrl-P - ctrl-f - fast file navigator
map <C-f> :CtrlP<CR>
set runtimepath^=~/.vim/bundle/ctrlp.vim

""""""" Git
" git blame - ctrl-a,b
map <C-a>b :Gblame<CR>
" git status - ctrl-a,s
"     - open file : enter
"     - open split : o
"     - open vsplit : S
map <C-a>s :Gstatus<CR>
" git diff - ctrl-a,d
map <C-a>d :Gdiff<CR>
" git diff --staged - ctrl-a,f
map <C-a>f :Gdiff HEAD<CR>
" json pretty - ctrl-l
map <C-l> :%!python -m json.tool<CR>
map <C-n> :set invnumber<CR>

""""""" RUBY
" RuboCop - ctrl+b - run rubocop autocorrect on current file
" map <C-b> :RuboCop<CR>

""""""" Golang
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
let g:go_auto_type_info = 1

" Show test coverage - gc
map gc :GoCoverageToggle<CR>
" Switch between code and test - ga
map ga :GoAlternate<CR>
" GoDef - Go to definition - gd (built in)
" Go back to usage - ctrl-t
" Show function declarations - gf
map gf :GoDeclsDir<CR>
" Go to next function - ]] (built-in)
" Go to previous function - ]] (built_in)
" Rename a function (refactor) - :GoRename
