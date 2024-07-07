" Plugin configuration

" Popup menu configuration for gruvbox dark
highlight Pmenu      guibg=#3c3836 guifg=#ebdbb2
highlight PmenuSel   guibg=#fabd2f guifg=#3c3836
highlight PmenuSbar  guibg=#282828
highlight PmenuThumb guibg=#fabd2f

" vim-highlightedyank configuration
let g:highlightedyank_highlight_duration = 200

" vim-tmux-navigator configuration
let g:tmux_navigator_no_mappings = 1

" Use the following keybindings to navigate between tmux and vim panes
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

" coc.nvim configuration
" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Setup formatexpr specified filetype(s).
autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
" Update signature help on jump placeholder.
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" Applying code actions to the selected code block.
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position.
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
nmap <leader>as  <Plug>(coc-codeaction-source)

" Apply the most preferred quickfix action on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens actions on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<cr>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<cr>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<cr>

" Go development settings
" Enable goimports to automatically format and organize imports
let g:go_fmt_command = "goimports"

" Automatically run :GoInstallBinaries after plugin install
autocmd BufWritePost .vimrc source % | GoInstallBinaries

" Enable auto-completion
let g:go_auto_type_info = 1

" Enable linting
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']

" Go configuration
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Python-specific settings
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

" vim-autoformat configuration
" Bash
let g:formatdef_shfmt = "'shfmt'"
let g:formatters_sh = ['shfmt']
let g:lintdef_shellcheck = "'shellcheck'"
let g:linters_sh = ['shellcheck']

" Go
let g:formatdef_gofmt = "'gofmt'"
let g:formatters_go = ['gofmt']
let g:lintdef_golangci_lint = "'golangci-lint run --out-format=short'"
let g:linters_go = ['golangci_lint']

" Python
let g:formatdef_black = "'black --fast -'"
let g:formatters_python = ['black']
let g:lintdef_flake8 = "'flake8'"
let g:linters_python = ['flake8']

" Terraform
let g:formatdef_terraform = "'terraform fmt -'"
let g:formatters_terraform = ['terraform']
let g:lintdef_tflint = "'tflint'"
let g:linters_terraform = ['tflint']

" Docker
let g:lintdef_hadolint = "'hadolint'"
let g:linters_dockerfile = ['hadolint']

" Kubernetes
let g:lintdef_kube_score = "'kube-score score -o ci'"
let g:linters_yaml = ['kube_score']

" YAML
let g:vim_yaml_folds_custom_foldtext = 1

" HTML, CSS, JavaScript, React
let g:formatdef_prettier = "'prettier --stdin-filepath '.expand('%:p')"
let g:formatters_html = ['prettier']
let g:formatters_css = ['prettier']
let g:formatters_javascript = ['prettier']
let g:formatters_react = ['prettier']
let g:lintdef_eslint = "'eslint --stdin --stdin-filename '.expand('%:p')"
let g:linters_javascript = ['eslint']
let g:linters_react = ['eslint']
let g:lintdef_stylelint = "'stylelint --stdin --stdin-filename '.expand('%:p')"
let g:linters_css = ['stylelint']

" Enable default formatting
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0

" Define filetypes and their corresponding formatters
let g:autoformat_verbosemode = 0
let g:autoformat_autoindent = 1
let g:autoformat_retab = 1

" ALE linting settings
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'

" Keybindings for formatting
nnoremap <leader>f :Autoformat<CR>
vnoremap <leader>f :Autoformat<CR>
