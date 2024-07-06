" Enable mouse support
syntax enable 

" Essential settings
set tabstop=4                             " Number of spaces that a <Tab> in the file counts for
set shiftwidth=4                          " Number of spaces to use for each step of (auto)indent
set expandtab                             " Use spaces instead of tabs
set number                                " Show line numbers
set relativenumber                        " Enable relative line numbers
set autoindent                            " Copy indent from current line when starting a new line
set smartindent                           " Do smart autoindenting when starting a new line
set ignorecase                            " Ignore case when searching
set smartcase                             " Override 'ignorecase' if search pattern contains uppercase characters
set hlsearch                              " Highlight search results
set incsearch                             " Do incremental searching
set mouse=a                               " Enable mouse support in all modes
set clipboard=unnamedplus                 " Use system clipboard for copy/paste
set backspace=indent,eol,start            " Allow backspacing over auto-indent, line breaks, and start of insert
set encoding=utf-8                        " Set default encoding to UTF-8
set fileformat=unix                       " Set default file format to Unix (LF)
set showcmd                               " Show incomplete commands in the bottom right corner
set undofile                              " Enable persistent undo
set undodir=~/.vim/undodir                " Enable persistent undo
set laststatus=2                          " Enable status line
set updatetime=300                        " Set updatetime for faster completion
set completeopt=menuone,noinsert,noselect " Enable auto-completion
set showmatch                             " Show matching parantheses
set foldmethod=syntax                     " Enable folding with syntax
set foldlevel=99                          " Open all folds by default

" Set the colorscheme
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark

" Set the Vim title
set title
set titlestring=%t\ %(\ %M%)\ %(%{&ff}\ -\ %y%)

" Source autoload plugins
source ~/.vim/autoload_plugins.vim

" Source plugin configurations
source ~/.vim/plugin_config.vim
