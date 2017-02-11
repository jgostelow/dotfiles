execute pathogen#infect()

set nocompatible
set backspace=2       " enable backspace to work as expected
set number            " display line numbers
" set clipboard=unnamed " read and write from system clipboard
set incsearch         " search as your type
set hlsearch          " highlight search results
set directory=$HOME/.vim/swapfiles/
filetype plugin indent on
syntax on
autocmd BufWritePre * %s/\s\+$//e " Remove white space on save

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

" Do not freeze on CTRL-S
silent !stty -ixon > /dev/null 2>/dev/null

augroup filetypedetect
  au! BufRead,BufNewFile *.hamlc	setfiletype	haml " Detect .hamlc files as haml
augroup END

" RuboCop - ctrl+b - run rubocop autocorrect on current file
map <C-b> :RuboCop<CR>
" NERDTree - ctrl+e - Toggle NERDTree window
map <C-e> :NERDTreeToggle<CR>
let NERDTreeMapOpenVSplit = '<C-v>' " ctrl-v - open vsplit
let NERDTreeMapOpenSplit = '<C-x>' " ctrl-x - open split
" Command-T - ctrl-f - fast file navigator
" map <C-f> :CommandT<CR>
" Ctrl-P - ctrl-f - fast file navigator
map <C-f> :CtrlP<CR>
" git blame - ctrl-a,b
map <C-a>b :Gblame<CR>
" git status - ctrl-a,s
map <C-a>s :Gstatus<CR>
" git diff - ctrl-a,d
map <C-a>d :Gdiff<CR>
" git diff --staged - ctrl-a,f
map <C-a>f :Gdiff HEAD<CR>
" json pretty - ctrl-l
map <C-l> :%!python -m json.tool<CR>
map <C-n> :set invnumber<CR>

" ctrl-p
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Cheatsheet
" - Windows
"   - Switch windows : ctrl+w-r
" - Fugitive
"   - GStatus : ctrl+a-s
"     - open file : enter
"     - open split : o
"     - open vsplit : S
"
