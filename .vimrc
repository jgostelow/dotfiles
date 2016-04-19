execute pathogen#infect()

set nocompatible
set backspace=2       " enable backspace to work as expected
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


" COLORS
set bg=dark
colorscheme candycode
if &diff
  colorscheme delek
endif
" do not make transparent backgrounds opaque by highlighting them
hi Normal ctermbg=none

" Do not freeze on CTRL-S
silent !stty -ixon > /dev/null 2>/dev/null

augroup filetypedetect
  au! BufRead,BufNewFile *.hamlc	setfiletype	haml " Detect .hamlc files as haml
augroup END

" json pretty - \jt
map <leader>jt  <Esc>:%!json_xs -f json -t json-pretty<CR>
" RuboCop - ctrl+q - run rubocop on current file
map <C-q> :RuboCop<CR>
" NERDTree - ctrl+e - Toggle NERDTree window
map <C-e> :NERDTreeToggle<CR>
" Command-T - ctrl-f - fast file navigator
map <C-f> :CommandT<CR>
