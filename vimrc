" ~/.vimrc
" vim:ft=vim:

" vi compatibilty must be disabled to allow most features.
set nocompatible

" Return to command mode if two j's are typed.
map! jj <ESC>

" Forgive me if I don't release the shift fast enough.
cmap W w
cmap Q q

" Detect filetypes.
filetype on

" Enable filetype sensitive plugins. Not too sure what this is actually...
filetype plugin on

" Enable filetype sensitive indenting.
filetype indent on

" Enable syntax coloring.
syntax enable

" Move into the file's directory after it's opened.
" Mac OS X 10.6 vim doesn't support this.
try
    set autochdir
catch
    " TODO: Replicate this feature with an autocmd.
endtry

" Use bright colors. (I use dark terminals.)
set bg=dark

" Show pending commands at the bottom of the terminal.
set showcmd

" Show matching braces, parentheses and brackets.
set showmatch

" Indicate if we are not in command mode.
set showmode

" Always show the status bar.
set laststatus=2

" Status bar format string.
" Show the full path, the status of the buffer, the filetype, and our
" position in the buffer.
set statusline=%F%([%R%H%W%M]%)%=%y[%l,%v][%p%%]

" Insert spaces instead of a tab character when <Tab> is pressed!
" A tab character can be inserted with <C-v><Tab>
set expandtab

" Number of spaces inserted by <Tab>.
set softtabstop=4

" Number of virtual spaces to display for each tab character.
set tabstop=4

" Number of spaces to indent/dedent when using <, >.
set shiftwidth=4

" Guess indentation based on previous line.
set autoindent

" Guess indentation based off of language syntax.
set smartindent

" Enable text folding.
set foldenable

" Use indentation changes as fold markers.
" I find this is the most general solution because not all languages use
" braces, and good code should already be indented anyway.
set foldmethod=indent

" Lines starting with any of these characters do not break a fold region.
set foldignore="#"

" Auto-fold folds that are at least this deep. 100 is effectively "never".
set foldlevel=100

" Toggle folds with spacebar.
nmap <space> za

" Search for the expression as it's being typed.
set incsearch

" Highlight matches.
set hlsearch

" Center the matched line.
nmap n nzz
nmap N Nzz

" Move swap files out of the current directory.
silent !mkdir -p ~/.vim/tmp &>/dev/null
set directory=~/.vim/tmp

" Move backups out of the current directory.
silent !mkdir -p ~/.vim/backup &>/dev/null
set backupdir=~/.vim/backup

" Honestly, I'm a little confused about these two...
set nobackup
set writebackup

" Look for a tags file all the way up the filesystem.
set tags=.tags;/,tags;/,TAGS;/

" Move between split windows.
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
