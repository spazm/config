unlet b:current_syntax
syn include @SQL syntax/sql.vim
syn region perlSQL start="qq{"   end="}"    contains=@SQL keepend
syn region perlSQL start="qq\["  end="\]"   contains=@SQL keepend
syn region perlSQL start="<<SQL" end="^SQL" contains=@SQL keepend
syn region perlSQL start="<<\"SQL\"" end="^SQL" contains=@SQL keepend
syn region perlSQL start="<<\'SQL\'" end="^SQL" contains=@SQL keepend
