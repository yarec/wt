
    """"""""""""""""""""""""""""""
    " Python section
    """"""""""""""""""""""""""""""
    "Run the current buffer in python - ie. on leader+space
    au FileType python so ~/vim_local/syntax/python.vim
    autocmd FileType python map <buffer> <leader><space> :w!<cr>:!python %<cr>
    autocmd FileType python so ~/vim_local/plugin/python_fold.vim

    "Set some bindings up for 'compile' of python
    autocmd FileType python set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    autocmd FileType python set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

    "Python iMaps
    au FileType python set cindent
    au FileType python inoremap <buffer> $r return
    au FileType python inoremap <buffer> $s self
    au FileType python inoremap <buffer> $c ##<cr>#<space><cr>#<esc>kla
    au FileType python inoremap <buffer> $i import
    au FileType python inoremap <buffer> $p print
    au FileType python inoremap <buffer> $d """<cr>"""<esc>O

    "Run in the Python interpreter
    function! Python_Eval_VSplit() range
        let src = tempname()
        let dst = tempname()
        execute ": " . a:firstline . "," . a:lastline . "w " . src
        execute ":!python " . src . " > " . dst
        execute ":pedit! " . dst
    endfunction
    au FileType python vmap <F7> :call Python_Eval_VSplit()<cr>

    """""""""""""""""""""""""""""""
    " Python
    """""""""""""""""""""""""""""""
    autocmd FileType python inorea <buffer> cfun <c-r>=IMAP_PutTextWithMovement("def <++>(<++>):\n<++>\nreturn <++>")<cr>
    autocmd FileType python inorea <buffer> cclass <c-r>=IMAP_PutTextWithMovement("class <++>:\n<++>")<cr>
    autocmd FileType python inorea <buffer> cfor <c-r>=IMAP_PutTextWithMovement("for <++> in <++>:\n<++>")<cr>
    autocmd FileType python inorea <buffer> cif <c-r>=IMAP_PutTextWithMovement("if <++>:\n<++>")<cr>
    autocmd FileType python inorea <buffer> cifelse <c-r>=IMAP_PutTextWithMovement("if <++>:\n<++>\nelse:\n<++>")<cr>
