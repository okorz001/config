" ~/.vimrc
" vim:ft=vim:

" vi compatibilty must be disabled to allow most features.
set nocompatible

" This colorscheme looks good in a dark terminal.
colorscheme evening

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
try
    " VIM 7.3 has support for this built-in.
    set autochdir
catch
    " Older versions (like on OS X) need autocmd magic.
    autocmd BufEnter * execute 'chdir ' . escape(expand('%:p:h'), ' ')
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

" Move swap files out of the current directory, creating the swap directory
" if necessary.
let s:swapdir=$HOME . "/.vim/tmp"
if !isdirectory(s:swapdir)
    if exists("*mkdir")
        call mkdir(s:swapdir, "p")
    else
        silent execute "!mkdir -p " . s:swapdir . " &>/dev/null"
    endif
endif
let &directory=s:swapdir

" Create a backup before writing, then delete it if the write succeeds.
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
let mapleader=" "

" Macro to remove trailing whitespace from entire file.
nmap <leader>ws :%s/[ \t]\+$//<CR>

" Macro to remove trailing whitespace from visual block.
vmap <leader>ws :s/[ \t]\+$//<CR>

" Macro to toggle paste mode.
nmap <leader>pa :set paste!<CR>

" Macro to clear the search register.
nmap <leader>cs :let @/=""<CR>

" Macro for manipulating the system register (X11 clipboard).
" This is designed to be used with an operator, e.g. "<leader>xyy"
map <leader>x "+

" Macro for setting this split buffer to 80 chars wide.
map <leader>vr :vertical resize 80<CR>

" Try to detect what kind of repository this file is in.
function! ScmDetect()
    " Set a sensible default.
    let b:scm_type=""

    " Look upwards for any kind of repository directories.
    let l:dir=getcwd() . "/"
    while !empty(l:dir)
        if isdirectory(l:dir . ".git")
            let b:scm_type="git"
            return
        elseif isdirectory(l:dir . ".hg")
            let b:scm_type="hg"
            return
        elseif isdirectory(l:dir . ".svn")
            let b:scm_type="svn"
            return
        elseif isdirectory(l:dir . "CVS")
            let b:scm_type="cvs"
            return
        endif

        " Chop off the last directory.
        let l:dir=strpart(l:dir, 0, match(l:dir, '[^/]\+/$'))
    endwhile
endfunction

" Try to blame.
function! ScmBlame()
    if empty(b:scm_type)
        echohl ErrorMsg
        echo "ERROR: b:scm_type is not set."
        echohl
    elseif b:scm_type == "git"
        execute "!git blame --date=short " . expand("%")
    elseif b:scm_type == "hg"
        execute "!hg blame -ucdq " . expand("%")
    elseif b:scm_type == "svn"
        execute "!svn blame " . expand("%") . " | $PAGER"
    elseif b:scm_type == "cvs"
        execute "!cvs annotate " . expand("%") . " | $PAGER"
    else
        echohl ErrorMsg
        echo "ERROR: Can't blame for b:scm_type='" . b:scm_type . "'."
        echohl
    endif
endfunction

" Try to diff.
function! ScmDiff()
    if empty(b:scm_type)
        echohl ErrorMsg
        echo "ERROR: b:scm_type is not set."
        echohl
    elseif b:scm_type == "git"
        execute "!git diff " . expand("%")
    elseif b:scm_type == "hg"
        execute "!hg diff " . expand("%")
    elseif b:scm_type == "svn"
        execute "!svn diff -x -p " . expand("%") . " | $PAGER"
    elseif b:scm_type == "cvs"
        execute "!cvs diff -u " . expand("%") . " | $PAGER"
    else
        echohl ErrorMsg
        echo "ERROR: Can't diff for b:scm_type='" . b:scm_type . "'."
        echohl
    endif
endfunction

" Detect the repository type when we open the file.
autocmd BufEnter * :call ScmDetect()

" Map others repository functions to macros.
map <leader>blame :call ScmBlame()<CR>
map <leader>diff :call ScmDiff()<CR>
