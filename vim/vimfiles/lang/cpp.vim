
    """""""""""""""""""""""""""""""
    " cpp section
    """""""""""""""""""""""""""""""
    if has("autocmd")
        autocmd FileType cpp setlocal  omnifunc=omni#cpp#complete#Main
        "cppcomplete#Complete
    endif

    au FileType cpp inoremap <buffer> <C-t> System.out.println();<esc>hi

    "Java comments
    "autocmd FileType cpp source ~/vim_local/macros/jcommenter.vim
    "autocmd FileType cpp let b:jcommenter_class_author='Amir Salihefendic (amix@amix.dk)'
    "autocmd FileType cpp let b:jcommenter_file_author='Amir Salihefendic (amix@amix.dk)'
    "autocmd FileType cpp map <buffer> <F2> :call JCommentWriter()<cr>

    "Abbr'z
    autocmd FileType cpp inoremap <buffer> $pu public
    autocmd FileType cpp inoremap <buffer> $pr private
    autocmd FileType cpp inoremap <buffer> $i import
    autocmd FileType cpp inoremap <buffer> $s String
    autocmd FileType cpp inoremap <buffer> $b boolean
    autocmd FileType cpp inoremap <buffer> $v void
    autocmd FileType cpp inoremap <buffer> $r return
    autocmd FileType cpp inoremap <buffer> $nclz Class {}<esc>hi

    "Folding
    function! CppFold()
        setl foldmethod=syntax
        setl foldlevelstart=1
        syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
        syn match foldImports /\(\n\?import.\+;\n\)\+/ transparent fold

        function! FoldText()
            return substitute( getline(v:foldstart), '{.*', '{...}', '' )
        endfunction
        setl foldtext=FoldText()
    endfunction
    au FileType cpp call CppFold()
    au FileType cpp setl fen



    """""""""""""""""""""""""""""""
    " cpp
    """""""""""""""""""""""""""""""
    autocmd FileType cpp inorea <buffer> cfun   <c-r>=IMAP_PutTextWithMovement("<++> <++>::<++>(<++>) {\n<++>\nreturn <++>;\n}")<cr>
    autocmd FileType cpp inorea <buffer> cfunpr <c-r>=IMAP_PutTextWithMovement("private<++> <++>(<++>) {\n<++>\nreturn <++>;\n}")<cr>
    autocmd FileType cpp inorea <buffer> cfunpu <c-r>=IMAP_PutTextWithMovement("public<++> <++>(<++>) {\n<++>\nreturn <++>;\n}")<cr>
    autocmd FileType cpp inorea <buffer> cwhile <c-r>=IMAP_PutTextWithMovement("while(<++>) {\n<++>\n}")<cr>
    autocmd FileType cpp inorea <buffer> cfor   <c-r>=IMAP_PutTextWithMovement("for(<++>; <++>; <++>) {\n<++>\n}")<cr>
    autocmd FileType cpp inorea <buffer> cif    <c-r>=IMAP_PutTextWithMovement("if(<++>) {\n<++>\n}")<cr>
    autocmd FileType cpp inorea <buffer> cifel  <c-r>=IMAP_PutTextWithMovement("if(<++>) {\n<++>\n}\nelse {\n<++>\n}")<cr>
    autocmd FileType cpp inorea <buffer> cclz   <c-r>=IMAP_PutTextWithMovement("public class<++> {\n<++>\n}")<cr>
    autocmd FileType cpp inorea <buffer> cmain  <c-r>=IMAP_PutTextWithMovement("public static void main(String[] argv) {\n<++>\n}")<cr>
    autocmd FileType cpp inorea <buffer> cch    <c-r>=IMAP_PutTextWithMovement("}\ncatch (Exception e) {\n e.printStackTrace();\n }")<cr>

    autocmd FileType cpp inorea <buffer> cmtest <c-r>=IMAP_PutTextWithMovement(strftime(" %m-%d-20%y %H:%M")."jjjjjjjj")<cr>
    autocmd FileType cpp inorea <buffer> cmfile <c-r>=IMAP_PutTextWithMovement("\/**\nCreate by ShineTechChine\\Rentie\nDate: ".strftime("%m-%d-20%y")."\nTime: ".strftime("%H:%M")."\n/\npackage com.shinetechchina;\n")<cr><esc>
    autocmd FileType cpp inorea <buffer> cmclz  <c-r>=IMAP_PutTextWithMovement("\/**\nClassname        :<++>\nVersion info     : 1.0\nCopyright 2008 - Shinetech Software Inc. \n\/")<cr>
    autocmd FileType cpp inorea <buffer> cmbl   <c-r>=IMAP_PutTextWithMovement("\/**<++> *\/")<cr>
    autocmd FileType cpp inorea <buffer> cmblk  <c-r>=IMAP_PutTextWithMovement("\/**\n<++>\n\/")<cr>


    nmap <leader>cp :make -f Makefile.win<cr>
    nmap <leader>rcp :make -f Makefile.win clean all<cr>
    nmap <leader>gg :!backcomb.exe<cr>
