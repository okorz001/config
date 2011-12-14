" ~/.vimrc
" vim:ft=vim:

" vi compatibilty must be disabled to allow most features.
set nocompatible

" Return to command mode if two j's are typed.
imap jj <ESC>

" Learn to love the hjkl... (or use better movements instead!).
nmap <UP> <NOP>
nmap <DOWN> <NOP>
nmap <LEFT> <NOP>
nmap <RIGHT> <NOP>

" Detect filetypes.
filetype on

" Enable filetype sensitive plugins. Not too sure what this is actually...
filetype plugin on

" Enable filetype sensitive indenting.
filetype indent on

" Enable syntax coloring.
syntax enable

" Emulate readline (bash) completion.
set wildmode=longest,list

" Move into the file's directory after it's opened.
" Mac OS X 10.6 vim doesn't support this.
try
    set autochdir
catch
    " TODO: Replicate this feature with an autocmd.
endtry

" Use bright colors. (I use dark terminals.)
set background=dark

" Always keep 3 lines of context above or below the current line.
set scrolloff=3

" Show pending commands at the bottom of the terminal.
set showcmd

" Show matching braces, parentheses and brackets.
set showmatch

" Indicate if we are not in command mode.
set showmode

" Remember more commands and patterns.
set history=256

" Always show the status bar.
set laststatus=2

" Status bar format string.
" Show the full path, buffer flags, filetype and cursor position.
set statusline=%<%F%([%R%H%W%M]%)%=\ %y[%l,%v][%p%%]

" Insert spaces instead of a tab character when <TAB> is pressed!
" A tab character can be inserted with <C-V><TAB>
set expandtab

" Number of spaces inserted by <TAB>.
set softtabstop=4

" Number of virtual spaces to display for each tab character.
set tabstop=4

" Number of spaces to indent/dedent when using <, >.
set shiftwidth=4

" Guess indentation based off of language syntax.
set cindent

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

" Search for the expression as it's being typed.
set incsearch

" Highlight matches.
set hlsearch

" Case insensitive search.
set ignorecase

" ...unless a capital letter is present!
set smartcase

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

" Highlight lines that are longer than 80 characters.
highlight LineWrap ctermbg=red ctermfg=white guibg=red guifg=white
match LineWrap /\%81v.\+/

" Make Y act like C, D (i.e. til end of line).
nmap Y y$

" Set leader sequence. Leader is used for the macros below.
let mapleader = " "

" Macro to remove trailing whitespace from entire file.
nmap <leader>ws :%s/[ \t]\+$//<CR>

" Macro to remove trailing whitespace from visual block.
vmap <leader>ws :s/[ \t]\+$//<CR>

" Macro to toggle paste mode.
nmap <leader>pa :set paste!<CR>

" Macro to clear the search register.
nmap <leader>cs :let @/ = ""<CR>
