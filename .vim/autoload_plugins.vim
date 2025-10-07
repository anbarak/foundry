" Contains the Vim-Plug installation and setup

" Ensure Vim-Plug is installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Automatically run PlugInstall if there are missing plugins
autocmd VimEnter *
  \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) |
  \   execute 'PlugInstall --sync' |
  \   source $MYVIMRC |
  \ endif

" Specify the location where plugins will be installed
call plug#begin('~/.vim/plugged')

" List of plugins
" Git and Version Control
Plug 'airblade/vim-gitgutter'               " Git diff in the gutter
Plug 'tpope/vim-fugitive'                   " Git wrapper
Plug 'Xuyuanp/nerdtree-git-plugin'          " Git status indicators in NERDTree

" Linting and Development Tools
Plug 'dense-analysis/ale'                   " Linting and fixer
Plug 'editorconfig/editorconfig-vim'        " EditorConfig support
Plug 'ekalinin/dockerfile.vim'              " Dockerfile syntax highlighting
Plug 'hashivim/vim-terraform'               " Terraform syntax and indentation
Plug 'itchyny/lightline.vim'                " Lightweight status line
Plug 'junegunn/vim-easy-align'              " Dynamic alignment

" Productivity and Navigation
Plug 'junegunn/fzf'                         " Fuzzy finder
Plug 'junegunn/fzf.vim'                     " Fzf integration with Vim
Plug 'preservim/nerdtree'                   " File system explorer
Plug 'preservim/tagbar'                     " Tagbar plugin for Vim
Plug 'Chiel92/vim-autoformat'               " Autoformat plugin
Plug 'machakann/vim-highlightedyank'        " Automatically yank highlighted text to system clipboard
Plug 'christoomey/vim-tmux-navigator'       " Improved navigation between vim and tmux
Plug 'ojroques/vim-oscyank'                 " Enhance clipboard management

" Python Development
Plug 'vim-python/python-syntax'             " Python syntax highlighting
Plug 'davidhalter/jedi-vim'                 " Python autocompletion
Plug 'tmhedberg/SimpylFold'                 " Python folding
Plug 'vim-scripts/indentpython.vim'         " Improved Python indentation

" SQL
Plug 'kezhenxu94/vim-mysql-plugin'          " MySQL syntax highlighting
Plug 'tpope/vim-dadbod'                     " Interacting with databases directly within vim

" Vim Configuration and Enhancements
Plug 'tpope/vim-commentary'                 " Commenting plugin
Plug 'tpope/vim-eunuch'                     " Unix-like commands for Vim
Plug 'tpope/vim-repeat'                      " Makes . work with plugin commands
Plug 'tpope/vim-sensible'                   " Opinionated defaults for Vim
Plug 'tpope/vim-surround'                   " Surround text objects
Plug 'morhetz/gruvbox'                      " Colorsheme for vim
Plug 'lukas-reineke/virt-column.nvim'       " Add this line to install vim-virtcolumn

" UI Enhancements
Plug 'vim-airline/vim-airline'              " Status/tabline

" Optional UI Themes (choose one)
Plug 'powerline/powerline'                  " Status line plugin
Plug 'joshdick/onedark.vim'                 " One Dark theme for Vim

" Language Support and Enhancements
Plug 'sheerun/vim-polyglot'                      " Language pack for Vim
Plug 'jiangmiao/auto-pairs'                      " Automatic insertion of pairs
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " LSP client for language aware autocompletion
Plug 'pedrohdz/vim-yaml-folds'                   " Folding configuration for YAML

" Go development plugins
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Emmet Support for HTML/CSS
Plug 'mattn/emmet-vim'                      " Emmet support for HTML/CSS

" End of plugin list
call plug#end()

