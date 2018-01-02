" A custom Vimrc file
" Maintainer : Antoine Albertelli <antoine.albertelli@gmail.com>

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

if has('win32') || has('win64')
    " Make windows use ~/.vim too, I don't want to use _vimfiles
    set runtimepath^=~/.vim
    set guifont=Source_Code_Pro:h10

    " By default we are in system32, switch to home
    cd ~
endif

" Vundle plugins"
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'lepture/vim-jinja'
Plugin 'SirVer/ultisnips'
Plugin 'tpope/vim-fugitive'
Plugin 'gerw/vim-latex-suite'
Plugin 'kchmck/vim-coffee-script'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'airblade/vim-gitgutter'
Plugin 'itchyny/vim-haskell-indent'
Plugin 'chr4/nginx.vim'
Plugin 'w0rp/ale'

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on


" Disable beep"
set visualbell

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Puts all backup files in ~/.vim/backup"
set backup      " keep a backup file
set backupdir=~/.vim/backup

set history=50      " keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set smartcase       " turn on smart casing
set ignorecase       " turn on smart casing

" Allows to escape insert mode without leaving home row.
inoremap jk <Esc>

" In many terminal emulators the mouse works just fine, thus enable it.
" FIXME Doesnt work very well with gnome term.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on
syntax on

set incsearch       " do incremental searching
set hlsearch        " highlight search results

" Show line numbers
set relativenumber
set number

" Don't redraw the screen when its not needed (during macros)
set lazyredraw


" Sets ctags lookup dir
set tags=tags;/

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif

augroup END

" If we are editing a Git commit message, jump to the beginning instead of
" last used time."
augroup gitCommitEditMsg
    autocmd!
    autocmd BufReadPost COMMIT_EDITMSG exe "normal gg"
augroup END

" Remap non standard file extensions. "
au BufNewFile,BufRead *.sls set filetype=yaml
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.launch set filetype=xml

"Hitting enter in command mode after a search will clear the search pattern"
noremap <CR> :noh<CR><CR>

"4 space indentation"
set tabstop=4       " number of visual spaces per tab
set shiftwidth=4    " number of spaces to use for autoindent
set softtabstop=4   " number of spaces to insert/remove on <TAB>
set expandtab       " insert spaces instead of tabs

" The terminal uses dark background."
set background=dark

" Maps NERDTree to F2 "
map <F2> :NERDTreeToggle<CR>

" Autoclose Vim if the only window left open is NERDTree "
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Toggle bitween relative and aboslute line-numbers "
nnoremap <F6> :call ToggleNumbers()<cr>

function! ToggleNumbers()
    if &relativenumber
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction

"http://stackoverflow.com/questions/849084/what-fold-should-i-use-in-vim
" Folding stuff
hi Folded guibg=red guifg=Red cterm=bold ctermbg=DarkGrey ctermfg=lightblue
hi FoldColumn guibg=grey78 gui=Bold guifg=DarkBlue
set foldcolumn=2
set foldclose=
set foldmethod=indent
set foldnestmax=10
set foldlevel=999
" Toggle fold state between closed and opened.

" If there is no fold at current line, just moves forward.
" If it is present, reverse it's state.
fu! ToggleFold()
  if foldlevel('.') == 0
    normal! l
  else
    if foldclosed('.') < 0
      . foldclose
    else
      . foldopen
    endif
  endif
  echo
endf
" Map this function to Space key.
noremap <space> :call ToggleFold()<CR>

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

" Enables modeline"
set modeline

" When 'wildmenu' is on, command-line completion operates in an enhanced
" mode.  On pressing 'wildchar' (usually <Tab>) to invoke completion,
" the possible matches are shown just above the command line, with the
" first match highlighted (overwriting the status line, if there is
" one).
set wildmenu

""" Files to ignore for auto complete."""
set wildignore=*.pyc

" Enables vim-airline even when there is only a single buffer.
set laststatus=2


" Scroll 8 lines before the end."
set scrolloff=8

"some terminals, such as GNOME and XFCE supports 256 colors, but doesn't
"advertise its support."
set t_Co=256
colorscheme kolor/colors/kolor

" Sets bash as the default shell"
set shell=bash

" Highlights the 80th column to avoid going further than it "
set colorcolumn=80

" Highlight the line on which the cursor lies
set cursorline

" Delete trailing whitespace on write. "
autocmd FileType c,cpp,python,markdown autocmd BufWritePre <buffer> :StripWhitespace

" Use the silver searcher for Ctrl-P because its faster
if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
end

" Ultisnip config. "

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
let g:UltiSnipsEditSplit="horizontal"

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Neovim specific settings "
if has('nvim')
    " Exit terminal emulation
    tnoremap jk <c-\><c-n>
    tnoremap kj <c-\><c-n>
end

" Map t to go to tag, since C-T goes back
nnoremap t <C-]>

" Disable octal numbering, because I never use it
set nrformats-=octal

" Use the system yank by default
set clipboard=unnamedplus
