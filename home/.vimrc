set backspace=indent,eol,start

set nocompatible              " be iMproved, required
filetype off                  " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Set the syntax highlighting
syntax on

" Set the tab width to 4 spaces
set tabstop=4

" Set the number of spaces to indent
set shiftwidth=4

" Set the line break mode
set linebreak

"Cursor mode settings:
"  1 -> blinking block
"  2 -> solid block 
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar"
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

set rtp+=/usr/local/opt/fzf

" start: ref: https://www.arthurkoziel.com/setting-up-vim-for-yaml/
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

set foldlevelstart=20

let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'
" end: ref: https://www.arthurkoziel.com/setting-up-vim-for-yaml/

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"so ~/.vim/vundle.vim
so ~/.vim/plugins.vim
