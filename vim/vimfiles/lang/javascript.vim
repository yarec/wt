
    """"""""""""""""""""""""""""""
    " JavaScript section
    """""""""""""""""""""""""""""""
    "au FileType javascript so ~/vim_local/syntax/javascript.vim
    function! JavaScriptFold()
        setl foldmethod=syntax
        setl foldlevelstart=1
        syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

        function! FoldText()
            return substitute(getline(v:foldstart), '{.*', '{...}', '')
        endfunction
        setl foldtext=FoldText()
    endfunction
    au FileType javascript call JavaScriptFold()
    au FileType javascript setl fen

    au FileType javascript imap <c-t> console.log();<esc>hi
    au FileType javascript imap <c-a> alert();<esc>hi
    "au FileType javascript setl nocindent
    au FileType javascript inoremap <buffer> $r return

    au FileType javascript inoremap <buffer> $d //<cr>//<cr>//<esc>ka<space>
    au FileType javascript inoremap <buffer> $c /**<cr><space><cr>**/<esc>ka


    """""""""""""""""""""""""""""""
    " JavaScript
    """""""""""""""""""""""""""""""
    autocmd FileType cheetah,html,javascript inorea <buffer> cfun <c-r>=IMAP_PutTextWithMovement("function <++>(<++>) {\n<++>;\nreturn <++>;\n}")<cr>
    autocmd filetype cheetah,html,javascript inorea <buffer> cfor <c-r>=IMAP_PutTextWithMovement("for(<++>; <++>; <++>) {\n<++>;\n}")<cr>
    autocmd FileType cheetah,html,javascript inorea <buffer> cif <c-r>=IMAP_PutTextWithMovement("if(<++>) {\n<++>;\n}")<cr>
    autocmd FileType cheetah,html,javascript inorea <buffer> cifelse <c-r>=IMAP_PutTextWithMovement("if(<++>) {\n<++>;\n}\nelse {\n<++>;\n}")<cr>
