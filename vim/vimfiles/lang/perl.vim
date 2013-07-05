
"""""""""""""""""""""""""""""""
" Perl section
"""""""""""""""""""""""""""""""
au FileType perl inoremap <buffer> <C-t> print ;<esc>hi


" Perl templates
let g:template['perl'] = {}
let g:template['perl']['dbg'] = "$logger->debug(\" ".g:rs."...".g:re." \");"
"let g:template['perl']['dbg'] = "$this->logger->debug(\" ".g:rs."...".g:re." \");"
let g:template['perl']['info'] = "$logger->info(\" ".g:rs."...".g:re." \");"
let g:template['perl']['warn'] = "$logger->warn(\" ".g:rs."...".g:re." \");"
let g:template['perl']['err'] = "$logger->error(\" ".g:rs."...".g:re." \");"
let g:template['perl']['fatal'] = "$logger->fatal(\" ".g:rs."...".g:re." \");"
let g:template['perl']['cc'] = "/*  */\<left>\<left>\<left>"
let g:template['perl']['pl'] = "#!/usr/bin/perl\<cr>\<left>use strict;\<cr>use warnings;\<cr>".
                               \repeat("\<down>",3).
                               \repeat("\<cr>",2)."\<Del>".
                               \g:rs."...".g:re

let g:template['perl']['pm'] = "package wt;\n\nuse strict;\nuse warnings;\n\nrequire Exporter;\n\nour @ISA = qw(Exporter);\nour $VERSION = '0.102080';\nour @EXPORT = qw(\nhello\n);\n\nsub hello($) { \nprint 'hello ^_^'; \n}\n\n1;\n__END__\n"
let g:template['perl']['fh'] = "foreach my $key (keys %".g:rs."...".g:re.") {\n".g:rs."...".g:re."\n}"
let g:template['perl']['fa'] = "foreach my $item (".g:rs."...".g:re.") {\n".g:rs."...".g:re."\n}"

    
"let g:template['c']['cd'] = "/**<  */\<left>\<left>\<left>"
"let g:template['c']['de'] = "#define     "
"let g:template['c']['in'] = "#include    \"\"\<left>"
"let g:template['c']['is'] = "#include  <>\<left>"
"let g:template['c']['ff'] = "#ifndef  \<c-r>=GetFileName()\<cr>\<CR>#define  \<c-r>=GetFileName()\<cr>".
"            \repeat("\<cr>",5)."#endif  /*\<c-r>=GetFileName()\<cr>*/".repeat("\<up>",3)
"let g:template['c']['for'] = "for( ".g:rs."...".g:re." ; ".g:rs."...".g:re." ; ".g:rs."...".g:re." )\<cr>{\<cr>".
"            \g:rs."...".g:re."\<cr>}\<cr>"
"let g:template['c']['main'] = "int main(int argc, char \*argv\[\])\<cr>{\<cr>".g:rs."...".g:re."\<cr>}"
"let g:template['c']['switch'] = "switch ( ".g:rs."...".g:re." )\<cr>{\<cr>case ".g:rs."...".g:re." :\<cr>break;\<cr>case ".
"            \g:rs."...".g:re." :\<cr>break;\<cr>default :\<cr>break;\<cr>}"
"let g:template['c']['if'] = "if( ".g:rs."...".g:re." )\<cr>{\<cr>".g:rs."...".g:re."\<cr>}"
"let g:template['c']['while'] = "while( ".g:rs."...".g:re." )\<cr>{\<cr>".g:rs."...".g:re."\<cr>}"
"let g:template['c']['ife'] = "if( ".g:rs."...".g:re." )\<cr>{\<cr>".g:rs."...".g:re."\<cr>} else\<cr>{\<cr>".g:rs."...".
"            \g:re."\<cr>}"
