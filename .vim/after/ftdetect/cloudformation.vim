augroup cfn_yaml_ftdetect
  autocmd!
  " Decide YAML vs JSON for *.template on open/new
  autocmd BufRead,BufNewFile *.template call s:cfn_detect()
  " If a plugin (polyglot) sets json later, re-check and flip if needed
  autocmd FileType json if expand('%:e') ==# 'template' | call s:cfn_detect() | endif

  function! s:cfn_detect() abort
    " Find first nonblank line
    let lnum = search('\S', 'n')
    let lfirst = getline(lnum)

    " If it clearly starts as JSON, call it JSON
    if lfirst =~# '^{'
      setfiletype json
      return
    endif

    " If it starts with YAML doc marker or anything not '{', call it YAML
    if lfirst =~# '^---\s*$' || lfirst !~# '^{'
      setfiletype yaml
      return
    endif
  endfunction
augroup END
