syn include @Sql <sfile>:p:h/sql.vim
syn region perlSQL start="qq{" end="}" contains=@Sql keepend
syn region perlSQL start="qq\[" end="\]" contains=@Sql keepend
syn region perlSQL start="<<SQL" end="^SQL" contains=@Sql keepend
