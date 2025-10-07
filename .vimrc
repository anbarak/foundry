" ─── Syntax & Mouse ─────────────────────────────────────────────
syntax enable
syntax on
set termguicolors
filetype plugin indent on
set mouse=a

" ─── Disable Arrow Keys to Learn hjkl ────────────────
nnoremap <Up>    <Nop>
nnoremap <Down>  <Nop>
nnoremap <Left>  <Nop>
nnoremap <Right> <Nop>

" ─── Essential Editor Settings ──────────────────────────────────
set tabstop=4
set shiftwidth=4
set linebreak
set nocompatible
set expandtab
set number
set relativenumber
set autoindent
set smartindent
set ignorecase
set smartcase
set hlsearch
set incsearch
set clipboard=unnamedplus                   " Enable clipboard support for system-wide copy/paste"
set backspace=indent,eol,start
set encoding=utf-8
set fileformat=unix
set showcmd
set undofile
set undodir=~/.vim/undodir
set laststatus=2
set updatetime=300
set completeopt=menuone,noinsert,noselect
set showmatch
set foldmethod=syntax
set foldlevel=99
set foldlevelstart=20

" ─── Clean Pasting Behavior ───────────────────────────────────────
" F3 toggles paste mode to avoid corrupted pastes
set pastetoggle=<F3>

" Treat .plist.template files as XML
autocmd BufRead,BufNewFile *.plist.template set filetype=xml

" Use 2-space indentation for XML/plist
autocmd FileType xml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Show hidden control characters (for cleanup if needed)
nnoremap <leader>l :set list!<CR>

" ─── UI & Visuals ───────────────────────────────────────────────
set colorcolumn=88
highlight ColorColumn ctermbg=none ctermfg=gray

" Cursor mode settings
let &t_SI.="\e[5 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"

" Add fzf to the runtime path
set rtp+=/usr/local/opt/fzf

" YAML-specific indentation
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Pretty-print YAML in-place with yq (leader + yy)
nnoremap <leader>yy :%!yq -P<CR>

" Show tabs/trailing chars (pairs well with gruvbox)
set list listchars=tab:»\ ,trail:·,extends:…,precedes:…

" Colorscheme
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark='hard'

" Vim window title
set title
set titlestring=%t\ %(\ %M%)\ %(%{&ff}\ -\ %y%)

" Load plugin files
source ~/.vim/autoload_plugins.vim
source ~/.vim/plugin_config.vim

" Force fileformat=unix only when modifiable
autocmd BufReadPost * if &modifiable | set fileformat=unix | endif

" ─── Spellchecking Setup ────────────────────────────────────────

" Enable basic spellcheck in key writing filetypes
autocmd FileType gitcommit,markdown,text setlocal spell spelllang=en_us

" Enable spellcheck in common dotfiles (like .tmux.conf)
autocmd BufRead,BufNewFile .tmux.conf,.zshrc,.bashrc,.bash_profile setlocal filetype=sh
autocmd FileType sh setlocal spell spelllang=en_us

" Optional: comment-only spellcheck (safe, limited filetypes)
augroup CommentSpell
  autocmd!
  autocmd FileType gitcommit,markdown,text syntax match CommentSpell "\v\c.*" containedin=Comment
augroup END

" Make misspelled words visually obvious
highlight clear SpellBad
highlight SpellBad cterm=underline ctermfg=Red
highlight def link CommentSpell SpellBad

" Optional: Toggle paste mode with ,p (with visual feedback)
function! TogglePaste()
  if &paste
    set nopaste
    echo "📤 Paste mode OFF"
  else
    set paste
    echo "📥 Paste mode ON"
  endif
endfunction
nnoremap <leader>p :call TogglePaste()<CR>
