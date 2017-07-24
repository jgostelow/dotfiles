execute pathogen#infect()

" Break some bad habits
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

set pastetoggle=<F2>  " toggle past mode with F2
set nocompatible
set backspace=2       " enable backspace to work as expected
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
" Move window up,download,left,right - ctrl+w ctrl+[h,j,k,l]
map <C-w><C-k> <C-w><S-K>
map <C-w><C-j> <C-w><S-J>
map <C-w><C-h> <C-w><S-H>
map <C-w><C-l> <C-w><S-L>
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

" Filetype mappers
augroup filetypedetect
  au! BufRead,BufNewFile *.hamlc	setfiletype	haml " Detect .hamlc files as haml
augroup END

" ctags
set tags=./tags;

" NERDTree - ctrl+e - Toggle NERDTree window
map <C-e> :NERDTreeToggle<CR>
let NERDTreeMapOpenVSplit = '<C-v>' " ctrl-v - open vsplit
let NERDTreeMapOpenSplit = '<C-x>' " ctrl-x - open split

" Tagbar - ctrl+e - Toggle Tagbar window
map <S-e> :TagbarToggle fj<CR>
" airline - https://github.com/vim-airline/vim-airline/blob/master/README.md
set laststatus=2

set runtimepath^=~/.vim/bundle/ctrlp.vim

map <C-n> :set invnumber<CR>
set relativenumber    " display relative line numbers
" make line numbers white
hi LineNr ctermfg=white

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
