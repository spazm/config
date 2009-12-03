" set perlprove as compiler for .t files
" http://www.vim.org/scripts/script.php?script_id=1319
" :make runs prove
" :cl lists errors, :cc<number> jumps to specific, :cn :cp for next and
" previous errors.
" :help quickfix  for more information
" moved to ~/.vim/ftdetect/perl_test.vim
"au BufRead,BufNewFile *.t set filetype=perl | compiler perlprove
au BufRead,BufNewFile *.t setfiletype=perl | compiler perlprove
