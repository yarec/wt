" ----------------------------------------
" Vundle
" ----------------------------------------

set nocompatible
filetype off     " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle, required
Bundle 'gmarik/vundle'

" ---------------
" Plugin Bundles
" ---------------

"" Navigation
Bundle 'ZoomWin'
Bundle 'taglist-plus'

"Bundle 'wincent/Command-T'
"" This fork is required due to remapping ; to :
Bundle 'christoomey/vim-space'
Bundle 'Lokaltog/vim-easymotion'
"Bundle 'mutewinter/LustyJuggler'
Bundle 'kien/ctrlp.vim'
"" UI Additions
Bundle 'mutewinter/vim-indent-guides'
let g:indent_guides_guide_size = 1

Bundle 'Lokaltog/vim-powerline'
Bundle 'scrooloose/nerdtree'
Bundle 'Rykka/colorv.vim'
"Bundle 'nanotech/jellybeans.vim'
Bundle 'tomtom/quickfixsigns_vim'
"" Commands
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-speeddating'
"Bundle 'tpope/vim-fugitive'
Bundle 'godlygeek/tabular'
Bundle 'mileszs/ack.vim'
"Bundle 'gmarik/sudo-gui.vim'
"Bundle 'milkypostman/vim-togglelist'
"Bundle 'mutewinter/swap-parameters'
"Bundle 'keepcase.vim'
"Bundle 'scratch.vim'
Bundle 'mattn/zencoding-vim'
"" Automatic Helpers
Bundle 'IndexedSearch'
"Bundle 'xolox/vim-session'
Bundle 'Raimondi/delimitMate'
Bundle 'scrooloose/syntastic'
Bundle 'ervandew/supertab'
Bundle 'gregsexton/MatchTag'
Bundle 'Shougo/neocomplcache'
let g:neocomplcache_enable_at_startup = 1

"" Snippets
Bundle 'garbas/vim-snipmate'
Bundle 'honza/snipmate-snippets'
Bundle 'MarcWeber/vim-addon-mw-utils'
" FuzzyFinder
Bundle 'FuzzyFinder'

"
"" Language Additions
"Bundle 'spf13/PIV'

""   Ruby
"Bundle 'vim-ruby/vim-ruby'
"Bundle 'tpope/vim-haml'
"Bundle 'tpope/vim-rails'
"Bundle 'tpope/vim-rake'
""   JavaScript
"Bundle 'pangloss/vim-javascript'
"Bundle 'kchmck/vim-coffee-script'
"Bundle 'leshill/vim-json'
"Bundle 'itspriddle/vim-jquery'
"Bundle 'nono/vim-handlebars'
""   TomDoc
"Bundle 'mutewinter/tomdoc.vim'
"Bundle 'jc00ke/vim-tomdoc'
""   Other Languages
"Bundle 'msanders/cocoa.vim'
"Bundle 'mutewinter/taskpaper.vim'
"Bundle 'mutewinter/nginx.vim'
"Bundle 'timcharper/textile.vim'
"Bundle 'ChrisYip/Better-CSS-Syntax-for-Vim'
"Bundle 'acustodioo/vim-tmux'
Bundle 'hallison/vim-markdown'
"Bundle 'xhtml.vim--Grny'
"Bundle 'groenewege/vim-less'
"" MatchIt
"Bundle 'matchit.zip'
"Bundle 'kana/vim-textobj-user'
"Bundle 'nelstrom/vim-textobj-rubyblock'
"
"" Libraries
Bundle 'L9'
"Bundle 'tpope/vim-repeat'
Bundle 'tomtom/tlib_vim'
"Bundle 'mathml.vim'

" Automatically detect file types. (must turn on after Vundle)
filetype plugin indent on  

