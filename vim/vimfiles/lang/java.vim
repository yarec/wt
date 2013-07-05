
    """""""""""""""""""""""""""""""
    " Java section
    """""""""""""""""""""""""""""""
"    so $RV_VIMRUNTIME/lang/javacomplete/java_parser.vim
"    so $RV_VIMRUNTIME/lang/javacomplete/javacomplete.vim
"    autocmd Filetype java setlocal omnifunc=javacomplete#Complete
"	  autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo

    au FileType java inoremap <buffer> <C-t> System.out.println();<esc>hi

    "Java comments
    "autocmd FileType java source ~/vim_local/macros/jcommenter.vim
    "autocmd FileType java let b:jcommenter_class_author='Amir Salihefendic (amix@amix.dk)'
    "autocmd FileType java let b:jcommenter_file_author='Amir Salihefendic (amix@amix.dk)'
    "autocmd FileType java map <buffer> <F2> :call JCommentWriter()<cr>

    "Abbr'z
    autocmd FileType java inoremap <buffer> $pu public
    autocmd FileType java inoremap <buffer> $pr private
    autocmd FileType java inoremap <buffer> $i import
    autocmd FileType java inoremap <buffer> $s String
    autocmd FileType java inoremap <buffer> $v void
    autocmd FileType java inoremap <buffer> $b boolean
    autocmd FileType java inoremap <buffer> $r return
    autocmd FileType java inoremap <buffer> $nclz Class {}


    "Folding
    function! JavaFold()
        setl foldmethod=syntax
        setl foldlevelstart=1
        syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
        syn match foldImports /\(\n\?import.\+;\n\)\+/ transparent fold

        function! FoldText()
            return substitute(getline(v:foldstart), '{.*', '{...}', '')
        endfunction
        setl foldtext=FoldText()
    endfunction
    au FileType java call JavaFold()
    au FileType java setl fen



    """""""""""""""""""""""""""""""
    " Java
    """""""""""""""""""""""""""""""
    autocmd FileType java inorea <buffer> cclz   <c-r>=IMAP_PutTextWithMovement("public class<++> {\n<++>\n}")<cr>
    autocmd FileType java inorea <buffer> cmain  <c-r>=IMAP_PutTextWithMovement("public static void main(String[] argv) {\n<++>\n}")<cr>
    autocmd FileType java inorea <buffer> cfun   <c-r>=IMAP_PutTextWithMovement("public<++> <++>(<++>) {\n<++>\nreturn <++>;\n}")<cr>
    autocmd FileType java inorea <buffer> cfunpr <c-r>=IMAP_PutTextWithMovement("private<++> <++>(<++>) {\n<++>\nreturn <++>;\n}")<cr>
    autocmd FileType java inorea <buffer> cfunpu <c-r>=IMAP_PutTextWithMovement("public<++> <++>(<++>) {\n<++>\nreturn <++>;\n}")<cr>
    autocmd FileType java inorea <buffer> cif    <c-r>=IMAP_PutTextWithMovement("if(<++>) {\n<++>\n}")<cr>
    autocmd FileType java inorea <buffer> cifel  <c-r>=IMAP_PutTextWithMovement("if(<++>) {\n<++>\n}\nelse {\n<++>\n}")<cr>
    autocmd FileType java inorea <buffer> cwhile <c-r>=IMAP_PutTextWithMovement("while(<++>) {\n<++>\n}")<cr>
    autocmd FileType java inorea <buffer> cfor   <c-r>=IMAP_PutTextWithMovement("for(<++>; <++>; <++>) {\n<++>\n}")<cr>
    autocmd FileType java inorea <buffer> cch    <c-r>=IMAP_PutTextWithMovement("}\ncatch (Exception e) {\n e.printStackTrace();\n }")<cr>
    autocmd FileType java inorea <buffer> cmaps <c-r>=IMAP_PutTextWithMovement("Iterator it = args.entrySet().iterator();\nwhile(it.hasNext()){\nMap.Entry entry = (Map.Entry) it.next();\nObject key = entry.getKey();\nObject value = entry.getValue();\nSystem.out.println(key+\":\"+value.getClass().getSimpleName());\n}")<cr>

    autocmd FileType java inorea <buffer> cmtest <c-r>=IMAP_PutTextWithMovement(strftime(" %m-%d-20%y %H:%M")."jjjjjjjj")<cr>
    autocmd FileType java inorea <buffer> cmfile <c-r>=IMAP_PutTextWithMovement("\/**\nCreate by ShineTechChine\\Rentie\nDate: ".strftime("%m-%d-20%y")."\nTime: ".strftime("%H:%M")."\n/\npackage com.shinetechchina;\n")<cr><esc>
    autocmd FileType java inorea <buffer> cmclz  <c-r>=IMAP_PutTextWithMovement("\/**\nClassname        :<++>\nVersion info     : 1.0\nCopyright 2008 - Shinetech Software Inc. \n\/")<cr>
    autocmd FileType java inorea <buffer> cmbl   <c-r>=IMAP_PutTextWithMovement("\/**<++> *\/")<cr>
    autocmd FileType java inorea <buffer> cmblk  <c-r>=IMAP_PutTextWithMovement("\/**\n<++>\n\/")<cr>
