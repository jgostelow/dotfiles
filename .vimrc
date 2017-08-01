execute pathogen#infect()

" Break some bad habits
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" standard stuff
set nocompatible
set backspace=2       " enable backspace to work as expected
set tabstop=2         " a tab is 2 spaces
set smartindent       " nosi:  Smart indent useless when C-indent is on
set expandtab         " use spaces instead of tabs
set shiftwidth=2      " sw:  a healthy tab stop
set textwidth=120     " tw:  wrap at 120 characters
set autoindent        " ai:  indent to match previous line
set formatoptions=crql  " fo:  word wrap, format comments
set showmatch         " show matches on parens, bracketc, etc.
set diffopt+=vertical " Show diffs vertically

set directory=$HOME/.vim/swapfiles/
filetype plugin indent on
syntax on
autocmd BufWritePre * %s/\s\+$//e " Remove white space on save
" Do not freeze on CTRL-S (do not move this comment after the command. It breaks!)
silent !stty -ixon > /dev/null 2>/dev/null

set incsearch         " search as you type
set hlsearch          " highlight search results

" Do not overwrite buffer when pasting
vnoremap p "_dp
vnoremap P "_dP
" Clipboard
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>
" read and write from system clipboard
" set clipboard=unnamed

" key remappings
let mapleader = "\<Space>"
nmap ; :
nnoremap <Leader>p :set invpaste<CR>

" SPLIT WINDOWS
set wmh=0         " minimise split windows completely instead of leaving current line
set splitbelow
set splitright
" close all windows with Leader,q
map <Leader>q :qa<CR>
" Move window up,download,left,right - ctrl+w ctrl+[h,j,k,l]
map <C-w><C-k> <C-w><S-K>
map <C-w><C-j> <C-w><S-J>
map <C-w><C-h> <C-w><S-H>
map <C-w><C-l> <C-w><S-L>
" move down a window when in split screen mode
map <C-J> <C-W>j<C-W>_
" move up a window when in split screen mode
map <C-K> <C-W>k<C-W>_

" COLORS
set bg=dark
colorscheme apprentice
if &diff
  colorscheme apprentice
endif
" do not make transparent backgrounds opaque by highlighting them
hi Normal ctermbg=none

" Filetype mappers
augroup filetypedetect
  au! BufRead,BufNewFile *.hamlc	setfiletype	haml " hamlc => haml
augroup END

" ctags
set tags=./tags;

" --------------- PLUGINS -------------------------------

" NERDTree - leader,e - Toggle NERDTree window
map <Leader>e :NERDTreeToggle<CR>
let NERDTreeMapOpenVSplit = '<Leader>v' " Leader,v - open vsplit
let NERDTreeMapOpenSplit = '<Leader>h' " Leader,h - open split
" Open NERDTree if no files opened
autocmd vimenter * if !argc() | NERDTree | endif

" Tagbar - Leader,t - Toggle Tagbar window
map <Leader>t :TagbarToggle<CR>
" airline - https://github.com/vim-airline/vim-airline/blob/master/README.md
set laststatus=2

" Ctrl-p
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:50'

" Leader,n - display line numbers
map <Leader>n :set invnumber<CR>
set relativenumber    " display relative line numbers
" make line numbers white
hi LineNr ctermfg=white

" json pretty - Leader,j
map <Leader>j :%!python -m json.tool<CR>

" The Silver Searcher - Ag (fast search)
set grepprg=ag\ --nogroup\ --nocolor
" K - search for the word under the cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""' " let g:ctrlp_use_caching = 0
let g:ctrlp_use_caching = 0 "disable ctrl-p cache since ag is so fast
" ------------ Git ---------------------
" git blame - ctrl-a,b
map <C-a>b :Gblame<CR>
" git status - ctrl-a,s
"     - open file : enter
"     - open split : o
"     - open vsplit : S
map <C-a>s :Gstatus<CR>
" git add - ctrl-a,a
map <C-a>a :Gwrite<CR>
" git diff - ctrl-a,d
map <C-a>d :Gdiff<CR>
" git diff --staged - ctrl-a,f
map <C-a>f :Gdiff HEAD<CR>
