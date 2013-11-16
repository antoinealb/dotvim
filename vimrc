" A custom Vimrc file
" Maintainer : Antoine Albertelli <antoine.albertelli@gmail.com>
" Based on original vimrc by Bram Moolenaar <bram@vimrc>
"

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif


" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
    " Puts all backup files in ~/.vim/backup"
    set backup		" keep a backup file
    set backupdir=~/.vim/backup
endif

set history=50		" keep 50 lines of command line history
set ruler   		" show the cursor position all the time
set showcmd	    	" display incomplete commands
set incsearch		" do incremental searching
set smartcase       " turn on smart casing
set ignorecase       " turn on smart casing

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
" FIXME Doesnt work very well with gnome term.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Show line numbers
set relativenumber
set number

" Sets ctags lookup dir 
set tags=tags;/

" Only do this part when compiled with support for autocommands.
if has("autocmd")

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

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Maps all the exotic files to the correct syntax. "
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl 
au BufNewFile,BufRead *.dasm,*.dpcu setf dcpu 
au BufNewFile,Bufread *.asm setf avr

"Hitting enter in command mode after a search will clear the search pattern"
noremap <CR> :noh<CR><CR>

"4 space indentation"
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab 

" The terminal uses dark background."
set background=dark 

" Adds highlighting for @todo"
highlight todoTags guifg=red guibg=green
syntax match todoTags /todo/

" Launch Pathogen run time manipulation plugin "
call pathogen#infect()

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
set foldmethod=syntax
set foldnestmax=10
set foldlevel=999
"set fillchars=vert:\|,fold:\
"set foldminlines=1
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

" Maps make to F5 and tells vim to do an out of source build in ./build"
set makeprg=make\ -C\ build/
noremap <F5> :w<CR> :make<CR> :cw<CR>

" Required for omnicpp "
set nocp
filetype plugin on

map <C-F6> <Esc>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+fq .<cr>
let OmniCpp_NamespaceSearch = 1
let g:ConqueTerm_CloseOnEnd = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

" Automatically reload vimrc on writing to it."
au! BufWritePost $MYVIMRC source $MYVIMRC

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

" ConqueTerm "

command! Bash ConqueTermVSplit bash
let g:ConqueTerm_PromptRegex = '^\w\+@[0-9A-Za-z_.-]\+:[0-9A-Za-z_./\~,:-]\+\$'
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_Color = 1

" Enables modeline"
set modeline 

" When 'wildmenu' is on, command-line completion operates in an enhanced
" mode.  On pressing 'wildchar' (usually <Tab>) to invoke completion,
" the possible matches are shown just above the command line, with the
" first match highlighted (overwriting the status line, if there is
" one). 
set wildmenu


" Scroll 8 lines before the end."
set scrolloff=8

"GNOME Terminal supports 256 colors, but doesn't advertise its support."

if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

colorscheme molokai

" Reverse the line order in the current visual selection"
command! Reverse '<'>global/^/move '<-1

" Maps :w!! to write to the file as root."
cmap w!! w !sudo tee >/dev/null %

" Sets bash as the default shell"
set shell=/bin/bash
