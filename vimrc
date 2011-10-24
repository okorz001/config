" ~/.vimrc

" vi compatibilty must be disabled to allow fancy features.
set nocompatible

set autochdir
filetype on
filetype plugin on
filetype indent on
syntax enable

" General UI.
set bg=dark
set showcmd
set showmatch
set showmode
set laststatus=2
set statusline=%F%([%R%H%W%M]%)%=%y[%l,%v][%p%%]

" It is God's will that all tabs will be replaced with 4 spaces.
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" Auto indent, fold on indents.
set autoindent
set smartindent
set foldenable
set foldmethod=indent
" ...but don't auto indent.
set foldlevel=100
" Toggle folds with spacebar.
nmap <space> za

" Searching.
set hlsearch
set incsearch
" Center the matched line.
nmap n nzz
nmap N Nzz

" Move backups out of the current directory.
set backup
silent !mkdir -p ~/.vim/backup ~/.vim/tmp &>/dev/null
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

" Look for ctags all the way up the filesystem.
set tags=.tags;/,tags;/,TAGS;/

" Move between split windows.
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
