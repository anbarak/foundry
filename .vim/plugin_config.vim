" Contains the configuration related to Vim plugins

" Specify the location where plugins will be installed
call plug#begin('~/.vim/plugged')

" List of plugins
Plug 'airblade/vim-gitgutter'                      " Git diff in the gutter
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'ekalinin/dockerfile.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'hashivim/vim-terraform'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'preservim/nerdtree'                          " File system explorer
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'                          " Opinionated defaults
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'

" End of plugin list
call plug#end()
