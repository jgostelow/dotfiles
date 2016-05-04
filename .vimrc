execute pathogen#infect()

set nocompatible
set backspace=2       " enable backspace to work as expected
set number            " display line numbers
set clipboard=unnamed " read and write from system clipboard
set incsearch         " search as your type
set hlsearch          " highlight search results
filetype plugin indent on
syntax on

" Do not overwrite buffer when pasting
vnoremap p "_dp
vnoremap P "_dP


" SPLIT WINDOWS
" move down a window when in split screen mode
map <C-J> <C-W>j<C-W>_
" move down a window when in split screen mode
map <C-K> <C-W>k<C-W>_
" maximise the current window
map <C-L> <C-W>_
set wmh=0         " minimise split windows completely instead of leaving current line


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

" RuboCop - ctrl+q - run rubocop autocorrect on current file
map <C-q> :RuboCop -a<CR>
" NERDTree - ctrl+e - Toggle NERDTree window
map <C-e> :NERDTreeToggle<CR>
" Command-T - ctrl-f - fast file navigator
map <C-f> :CommandT<CR>
" git blame - ctrl-b
map <C-b> :Gblame<CR>
" git status - ctrl-s
map <C-s> :Gstatus<CR>
" git diff - ctrl-d
map <C-d> :Gdiff<CR>
