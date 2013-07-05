
    """"""""""""""""""""""""""""""
    " HTML related
    """"""""""""""""""""""""""""""
    " HTML entities - used by xml edit plugin
    let xml_use_xhtml = 1
    "let xml_no_auto_nesting = 1

    "To HTML
    let html_use_css = 1
    let html_number_lines = 0
    let use_xhtml = 1

    """"""""""""""""""""""""""""""
    " HTML
    """""""""""""""""""""""""""""""
    au FileType html call SourceHtml()
    au FileType html,cheetah set ft=xml
    au FileType html,cheetah set syntax=html


    """""""""""""""""""""""""""""""
    " HTML
    """""""""""""""""""""""""""""""
    autocmd FileType cheetah,html inorea <buffer> cahref <c-r>=IMAP_PutTextWithMovement('<a href="<++>"><++></a>')<cr>
    autocmd FileType cheetah,html inorea <buffer> cbold <c-r>=IMAP_PutTextWithMovement('<b><++></b>')<cr>
    autocmd FileType cheetah,html inorea <buffer> cimg <c-r>=IMAP_PutTextWithMovement('<img src="<++>" alt="<++>" />')<cr>
    autocmd FileType cheetah,html inorea <buffer> cpara <c-r>=IMAP_PutTextWithMovement('<p><++></p>')<cr>
    autocmd FileType cheetah,html inorea <buffer> ctag <c-r>=IMAP_PutTextWithMovement('<<++>><++></<++>>')<cr>
    autocmd FileType cheetah,html inorea <buffer> ctag1 <c-r>=IMAP_PutTextWithMovement("<<++>><cr><++><cr></<++>>")<cr>


    function! SourceHtml()
        if MySys() == "win32"
            execute ":so d:/wt/vim/HTML.vim"
        else
            execute ":so /home/john/wt/vim/HTML.vim"
        endif
    endfunction
