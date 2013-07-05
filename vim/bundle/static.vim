
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" => bufExplorer plugin
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
map <leader>o :BufExplorer<cr>


" => Minibuffer plugin
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplModSelTarget = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplVSplit = 25
let g:miniBufExplSplitBelow=1

let g:bufExplorerSortBy = "name"

"autocmd BufRead,BufNew :call UMiniBufExplorer

map <leader>u :TMiniBufExplorer<cr>


let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
    autocmd Filetype java setlocal omnifunc=javacomplete#Complete
    autocmd FileType python setlocal  omnifunc=pythoncomplete#Complete
    autocmd FileType javascript setlocal  omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html setlocal  omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css setlocal  omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml setlocal  omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php setlocal  omnifunc=phpcomplete#CompletePHP
    autocmd FileType c setlocal  omnifunc=ccomplete#Complete
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

so $RV_VIMRT/plugin-noload/taglist.vim
so $RV_VIMRT/plugin-noload/calendar.vim
so $RV_VIMRT/plugin-noload/autocomplpop.vim
so $RV_VIMRT/plugin-noload/JumpInCode.vim
so $RV_VIMRT/plugin-noload/imaps.vim
so $RV_VIMRT/plugin-noload/code_complete.vim
so $RV_VIMRT/plugin-noload/bufexplorer.vim
so $RV_VIMRT/plugin-noload/minibufexpl.vim
"so $RV_VIMRT/plugin-noload/popup_it.vim
so $RV_VIMRT/plugin-noload/NERD_tree.vim
so $RV_VIMRT/plugin-noload/vtreeexplorer.vim
so $RV_VIMRT/plugin-noload/matrix.vim

"for no install vim
so $VIMRUNTIME/plugin/netrwPlugin.vim
so $VIMRUNTIME/plugin/tohtml.vim


""""""""""""""""""""""""""""""
" NERD_tree
""""""""""""""""""""""""""""""
map <leader>nt :NERDTree<cr>

""""""""""""""""""""""""""""""
" VTreeExplorer
""""""""""""""""""""""""""""""
map <leader>vt :VTreeExplore<cr>


""""""""""""""""""""""""""""""
" File explorer
""""""""""""""""""""""""""""""
"Split vertically
let g:explVertical=1

"Window size
let g:explWinSize=35

let g:explSplitLeft=1
let g:explSplitBelow=1

"Hide some files
let g:explHideFiles='^\.,.*\.class$,.*\.swp$,.*\.pyc$,.*\.swo$,\.DS_Store$'

"Hide the help thing..
let g:explDetailedHelp=0



""""""""""""""""""""""""""""""
" Tag list
""""""""""""""""""""""""""""""
let Tlist_Ctags_Cmd = "ctags"
let Tlist_Sort_Type = "name"
let Tlist_Show_Menu = 1
map <leader>tl :Tlist<cr>
"map <leader>tl :TlistToggle<cr>

""""""""""""""""""""""""""""""
" Tag map
""""""""""""""""""""""""""""""
set tags+=e:/upg/cvs/goodemail/working/src/tags
"d:\runtime\linux1.0\tags
"
"map <C-F12> ,cd:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
map <C-F12> ,cd:!ctags -R --java-kinds=+p --fields=+iaS --extra=+q .<CR>
