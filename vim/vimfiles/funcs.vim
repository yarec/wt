"A function that inserts links & anchors on a TOhtml export.
" Notice:
" Syntax used is:
" Link
" Anchor
function! SmartTOHtml()
  TOhtml
  try
    %s/&quot;\s\+\*&gt; \(.\+\)</" <a href="#\1" style="color: cyan">\1<\/a></g
    %s/&quot;\(-\|\s\)\+\*&gt; \(.\+\)</" \&nbsp;\&nbsp; <a href="#\2" style="color: cyan;">\2<\/a></g
    %s/&quot;\s\+=&gt; \(.\+\)</" <a name="\1" style="color: #fff">\1<\/a></g
  catch
  endtry
  exe ":write!"
  exe ":bd"
endfunction

function! Help()
  try
    let v_helpStr = "\n      This is help msg for vimrc's mapping!\n\n"
    let v_helpStr .= "        <S-F1>.....................Show this msg!\n"
    let v_helpStr .= "        <C-F2>.....................Remove the tail's blank of all lines!\n"
    let v_helpStr .= "        <C-F3>.....................Remove all blank lines!\n"
    let v_helpStr .= "        <C-F4>.....................Change all the '\\' to '/'!\n"
    let v_helpStr .= "        <C-F5>.....................Change current line's '\\' to '/'!\n"
    let v_helpStr .= "        <C-F6>.....................Iterator format!\n"
    let v_helpStr .= "        <C-F7>.....................GenLinks!\n"
    let v_helpStr .= "        <C-F7>.....................!\n"
    echo v_helpStr
    "exec ":%g/^\s*$/d"
  catch
  endtry
endfunction

function! AddComment()
  try
    if &ft == "vim"
      let s:comment_string = "\""
    endif

    if ( &ft == "perl" || &ft == "make" || &ft == "cfg" || &ft == "sh" || &ft == "python" || &ft == "yaml" )
      let s:comment_string = "#"
    endif

    if ( &ft == "java" || &ft == "javascript" || &ft == "cpp" || &ft == "c" || &ft == "php") 
      let s:comment_string = "\\/\\/"
    endif

    if &ft == "scheme"
      let s:comment_string = ";"
    endif

    exec    "normal mx"
    let s:line_num_AddComment = line(".")
    exec    "normal 'a"
    let s:line_num_AddComment_a = line(".")
    execute s:line_num_AddComment_a.",".s:line_num_AddComment."s/^/".s:comment_string."/ge"
    exec    "normal 'x"
  catch
  endtry
endfunction

function! RemoveComment()
  try
    if &ft == "vim"
      let s:comment_string = "\\s\*\""
    endif

    if ( &ft == "perl" || &ft == "make" || &ft == "cfg" || &ft == "sh" || &ft == "python" || &ft == "yaml" )
      let s:comment_string = "\\s\*#"
    endif

    if ( &ft == "java" || &ft == "javascript" || &ft == "cpp" || &ft == "c" || &ft == "php") 
      let s:comment_string = "\\s\*\\/\\/"
    endif

    if &ft == "scheme"
      let s:comment_string = "\\s\*;"
    endif

    exec    "normal mx"
    let s:line_num_AddComment = line(".")
    exec    "normal 'a"
    let s:line_num_AddComment_a = line(".")
    execute s:line_num_AddComment_a.",".s:line_num_AddComment."s/^".s:comment_string."//ge"

    exec    "normal 'x"
  catch
  endtry
endfunction


function! RemoveBlankLines()
  try
    exec    "normal ma"
    %g/^\s*$/d
    exec    "normal 'a"
  catch
  endtry
endfunction

function! ReConstructWrap()
  try
    let s:previous_line_num_ReConstructWrap= line(".")
    sil %s/}/\r}\r/ge
    sil %s/{/\r{\r/ge
    sil %s/;/;\r/ge
    %g/^\s*$/d
    sil %s/[\n\r]{/{/ge
    sil %s/}[\r\n],/},/ge

    let s:cursorlinenum_ReConstructWrap = 1 
    exec    "normal G"
    let s:linesnum_ReConstructWrap = line(".")
    while s:cursorlinenum_ReConstructWrap < s:linesnum_ReConstructWrap
      exec "normal ".s:cursorlinenum_ReConstructWrap."gg"
      if match(getline(line(".")),"for") != -1
        "if match(getline(line(".")),"{") == -1
        "sil s/;/;\r/ge
        "echo match(getline(line(".")),"for")
        let s:cursorlinenum_ReConstructWrap1=s:cursorlinenum_ReConstructWrap+1
        let s:cursorlinenum_ReConstructWrap2=s:cursorlinenum_ReConstructWrap+2

        sil s/;[\n\r]\s*/; /ge
        "exec "normal ".s:cursorlinenum_ReConstructWrap1."gg"
        "echo line(".")
        sil s/;[\n\r]\s*/; /ge

        exec    "normal G"
        let s:linesnum_ReConstructWrap = line(".")
      endif
      let s:cursorlinenum_ReConstructWrap+=1
    endwhile

    sil %s/}/\r}\r/ge
    sil %s/{/\r{\r/ge
    "sil %s/;/;\r/ge
    %g/^\s*$/d
    sil %s/[\n\r]{/{/ge
    sil %s/}[\r\n],/},/ge

    sil %s/[\n\r]\s*;/;/ge
    sil %s/},/},\r/ge

  catch
  endtry
endfunction

function! IteratorFormat(begin,end)
  try
    if a:begin != 0
      let s:range_str = a:begin.",".a:end
    else
      let s:range_str = "%"
    endif

    let s:cursorlinenum = 1 

    sil set ft=java
    exec    "normal G"
    let s:linesnum = line(".")
    echo s:linesnum
    while s:cursorlinenum < s:linesnum
      exec "normal ".s:cursorlinenum."gg=j"
      let s:cursorlinenum+=1
    endwhile
    "modify end

    exec "normal ".s:previous_line_num_ReConstructWrap."gg"

    "for i in range(1, 4)
    "  echo "count is" i
    "endfor
  catch
  endtry
endfunction

function! GenLinks()
  try
    sil %s/^.*http:/http:/ge
    sil %s/^[^h][^t].*$//ge
    sil %s/^\n//ge
    sil %g/^.*$/call setline(line("."),"li_start( {href: \"".getline(".")."\", name:\"".getline(".")."\"} );")
  catch
  endtry
  "exec    "normal gg"
  "exec    "normal /^[^h][^t][^t][^p][^:]<cr>"
endfunction

function! Sysexport()
  let s:sys_explorer_cmd= "rv -explorer ".CurDir()
  echo s:sys_explorer_cmd
endfunction
