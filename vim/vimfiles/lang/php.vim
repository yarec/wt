
"
" Php section
"
au FileType php inoremap <buffer> <C-t> echo ;<esc>hi


" Php templates
let g:template['php'] = {}

let g:template['php']['kv'] = "'".g:rs.g:re."'=>".g:rs.g:re
let g:template['php']['php'] = "<?php \n\t".g:rs.g:re
let g:template['php']['pt'] = "echo ".g:rs.g:re.";"
let g:template['php']['ptln'] = "echo ".g:rs.g:re.".\"\\n\";"

" for Yii
let g:template['php']['qb'] = "Yii::app()->db_hb->createCommand()->from(".g:rs.g:re."::tableName())->where(\n'".
                              \g:rs.g:re."',\narray(".g:rs.g:re.")\n".
                              \")->queryAll();"


let g:template['php']['dbg'] = "$logger->debug(\" ".g:rs.g:re." \");"
"let g:template['php']['dbg'] = "$this->logger->debug(\" ".g:rs.g:re." \");"
let g:template['php']['info'] = "$logger->info(\" ".g:rs.g:re." \");"
let g:template['php']['warn'] = "$logger->warn(\" ".g:rs.g:re." \");"
let g:template['php']['err'] = "$logger->error(\" ".g:rs.g:re." \");"
let g:template['php']['fatal'] = "$logger->fatal(\" ".g:rs.g:re." \");"
let g:template['php']['cc'] = "/*  */\<left>\<left>\<left>"
let g:template['php']['pl'] = "#!/usr/bin/php\<cr>\<left>use strict;\<cr>use warnings;\<cr>".
                               \repeat("\<down>",3).
                               \repeat("\<cr>",2)."\<Del>".
                               \g:rs.g:re

let g:template['php']['pm'] = "package wt;\n\nuse strict;\nuse warnings;\n\nrequire Exporter;\n\nour @ISA = qw(Exporter);\nour $VERSION = '0.102080';\nour @EXPORT = qw(\nhello\n);\n\nsub hello($) { \nprint 'hello ^_^'; \n}\n\n1;\n__END__\n"
let g:template['php']['fh'] = "foreach my $key (keys %".g:rs.g:re.") {\n".g:rs.g:re
let g:template['php']['fa'] = "foreach my $item (".g:rs.g:re.") {\n".g:rs.g:re

