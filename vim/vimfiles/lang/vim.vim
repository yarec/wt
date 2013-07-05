
    """"""""""""""""""""""""""""""
    " VIM
    """"""""""""""""""""""""""""""
    autocmd FileType rvrc.vim map <buffer> <leader><space> :w!<cr>:source %<cr>

    """""""""""""""""""""""""""""""
    " Vim section
    """""""""""""""""""""""""""""""
    autocmd FileType vim set nofen


" Vim templates
let g:template['vim'] = {}
let g:template['vim']['gse'] = " \"g:rs.g:re\""
