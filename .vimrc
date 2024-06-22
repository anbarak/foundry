" Enable syntax highlighting
syntax enable

" Essential settings
set tabstop=4       " Number of spaces that a <Tab> in the file counts for
set shiftwidth=4    " Number of spaces to use for each step of (auto)indent
set expandtab       " Use spaces instead of tabs
set number          " Show line numbers
set autoindent      " Copy indent from current line when starting a new line
set smartindent     " Do smart autoindenting when starting a new line
set ignorecase      " Ignore case when searching
set smartcase       " Override 'ignorecase' if search pattern contains uppercase characters
set hlsearch        " Highlight search results
set incsearch       " Do incremental searching
set mouse=a         " Enable mouse support in all modes
set backspace=indent,eol,start  " Allow backspacing over auto-indent, line breaks, and start of insert
set encoding=utf-8   " Set default encoding to UTF-8
set fileformat=unix  " Set default file format to Unix (LF)
set showcmd         " Show incomplete commands in the bottom right corner

" Source Vim-Plug setup and installation
if empty(glob('~/.vim/autoload/plug.vim'))
  source ~/.vim/autoload_plugins.vim
endif

" Source plugin configurations
source ~/.vim/plugin_config.vim
