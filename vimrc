
"problem with arrow keys not working under screen.
"this is a temp fix, I hope.  2008-10-23.
"http://vim.wikia.com/wiki/Fix_broken_arrow_key_navigation_in_insert_mode
"Fixes the arrows, but breaks pg-up/pg-down

"if &term == "screen"
"    :set term=builtin_ansi
"endif


"http://vim.wikia.com/wiki/VimTip563
" bind \j and \s to run a [I to show other locations of the current identifier
" and with \j follow by the number desired or \s to provide a prompt.
" looks in all open files?
" Press [I to display all lines that contain the keyword under the cursor. Lines from the current file, and from included files,
" are listed. Another command (see the references below) allows you to jump to one of the displayed occurrences.

" List occurrences of keyword under cursor, and
" jump to selected occurrence.
function! s:JumpOccurrence()
  let v:errmsg = ""
  exe "normal [I"
  if strlen(v:errmsg) == 0
    let nr = input("Which one: ")
    if nr =~ '\d\+'
      exe "normal! " . nr . "[\t"
    endif
  endif
endfunction

" List occurrences of keyword entered at prompt, and
" jump to selected occurrence.
function! s:JumpPrompt()
  let keyword = input("Keyword to find: ")
  if strlen(keyword) > 0
    let v:errmsg = ""
    exe "ilist! " . keyword
    if strlen(v:errmsg) == 0
      let nr = input("Which one: ")
      if nr =~ '\d\+'
        exe "ijump! " . nr . keyword
      endif
    endif
  endif
endfunction

nnoremap <Leader>j :call <SID>JumpOccurrence()<CR>
nnoremap <Leader>p :call <SID>JumpPrompt()<CR>


"selections from my ofb/debian .vimrc

" The following are commented out as they cause vim to behave a lot
" different from regular vi. They are highly recommended though.
set showcmd         " Show (partial) command in status line.
set showmatch       " Show matching brackets.
set ignorecase      " Do case insensitive matching
"set incsearch      " Incremental search
"set autowrite      " Automatically save before commands like :next and :make


" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible     " Use Vim defaults (much better!)
set backspace=2      " allow backspacing over everything in insert mode


" TABS!
"http://vim.wikia.com/wiki/Indenting_source_code
"set ts=4            " display tabs as 4
set expandtab        " typed tabs become spaces (CTRL-V TAB to type a literal tab)
set shiftwidth=4     " << >> is in units of 4.
                     " With smart tab, tab at start-of-line is this size also
set smarttab         " enable smart tab
set softtabstop=4    " delete in a line of spaces removes 4 chars.

" Need literal tab characters in Makefiles.
au BufRead,BufNewFile Makefile* set noexpandtab

" Now we set some defaults for the editor
set noautoindent     " always set autoindenting off
set textwidth=0      " Don't wrap words by default
set nobackup         " Don't keep a backup file
set viminfo='20,\"50 " read/write a .viminfo file, don't store more than
                     " 50 lines of registers
set history=50       " keep 50 lines of command line history
set ruler            " show the cursor position all the time

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

""""" autocmd """"
if has("autocmd")

" Set some sensible defaults for editing C-files
augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For *.c and *.h files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd BufRead *       set formatoptions=tcql nocindent comments&
  autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END


" while the following necessary in the debian world, it breaks :help on Redhat...
"
" Also, support editing of gzip-compressed files. DO NOT REMOVE THIS!
" This is also used when loading the compressed helpfiles.
"augroup gzip
  " Remove all gzip autocommands
  "au!

  " Enable editing of gzipped files
  "   read: set binary mode before reading the file
  "     uncompress text in buffer after reading
  "  write: compress file after writing
  " append: uncompress file, append, compress file
  "autocmd BufReadPre,FileReadPre    *.gz set bin
  "autocmd BufReadPre,FileReadPre    *.gz let ch_save = &ch|set ch=2
  "autocmd BufReadPost,FileReadPost  *.gz '[,']!gunzip
  "autocmd BufReadPost,FileReadPost  *.gz set nobin
  "autocmd BufReadPost,FileReadPost  *.gz let &ch = ch_save|unlet ch_save
  "autocmd BufReadPost,FileReadPost  *.gz execute ":doautocmd BufReadPost " . expand("%:r")
"
  "autocmd BufWritePost,FileWritePost    *.gz !mv <afile> <afile>:r
  "autocmd BufWritePost,FileWritePost    *.gz !gzip <afile>:r
"
  "autocmd FileAppendPre         *.gz !gunzip <afile>
  "autocmd FileAppendPre         *.gz !mv <afile>:r <afile>
  "autocmd FileAppendPost        *.gz !mv <afile> <afile>:r
  "autocmd FileAppendPost        *.gz !gzip <afile>:r
"augroup END

augroup bzip2
  " Remove all bzip2 autocommands
  au!

  " Enable editing of bzipped files
  "       read: set binary mode before reading the file
  "             uncompress text in buffer after reading
  "      write: compress file after writing
  "     append: uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre        *.bz2 set bin
  autocmd BufReadPre,FileReadPre        *.bz2 let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost      *.bz2 |'[,']!bunzip2
  autocmd BufReadPost,FileReadPost      *.bz2 let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost      *.bz2 execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost    *.bz2 !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost    *.bz2 !bzip2 <afile>:r

  autocmd FileAppendPre                 *.bz2 !bunzip2 <afile>
  autocmd FileAppendPre                 *.bz2 !mv <afile>:r <afile>
  autocmd FileAppendPost                *.bz2 !mv <afile> <afile>:r
  autocmd FileAppendPost                *.bz2 !bzip2 -9 --repetitive-best <afile>:r
augroup END

endif " has ("autocmd")

let JK_ObjectColoring = 1
if has("syntax")
  syntax on
endif


""" minibufexpl.vim bindings """
" http://www.vim.org/scripts/script.php?script_id=159

let g:miniBufExplMapWindowNavVim    = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs  = 1
let g:miniBufExplModSelTarget       = 1

" bind ,s and ,v for sourcing and editing .vimrc
" not really that useful?
:nmap ,s :source $HOME/.vimrc
:nmap ,v :e $HOME/.vimrc

" do syntax highlighting on the whole file, not just the chunk I'm viewing.
" this helps to fix the problem where it confused on long comments
autocmd BufEnter * :syntax sync fromstart

" jtr 2004-05-26
" set inv<option> inverts an option.  This toggles between paste and nopaste and prints the status
map ,p   :set invpaste paste?

"MANY ALIGNMENT MAPS
" http://vim.sourceforge.net/scripts/script.php?script_id=294
" Align
" AlignMaps.vim provides a number of maps which make using this package easy.
" They typically either apply to the range 'a,. (from mark a to current line) or use
" the visual-selection (V, v, or ctrl-v selected):
" \t=  : align assignments (don't count logic, like == or !=)
" \t,  : align on commas
" \t|  : align on vertical bars (|)
" \tsp : align on whitespace
" \tt  : align LaTeX tabular tables

""" http://www.vim.org/scripts/script.php?script_id=1873
""" projtags.vim : set tags file for per project
"Examples:
"let g:ProjTags = [ "~/work/proj1" ]
"let g:ProjTags += [[ "~/work/proj2", "~/work/proj2/tags",
"~/work/common.tags" ]]
"let g:ProjTags = [[ "~/sandbox/rubicon_ui/trunk", "~/sandbox/utils/branches/week47", "~/sandbox/utils/trunk/" ]]

"set tags=./tags\ ~/sandbox/utils/branches/week47/tags
"set tags=./tags,~/sandbox/utils/branches/week47/tags,tags
" tags controls the search list for tags files.
" . is replaced with the path to the current file
" ./tags            => tags file in same dir as current file
" tags              => tags file in current directory
" full/path/to/tags => tags file from specific location
set tags=./tags,tags,~/trunk/adblender/tags,~/tags

"color settings:
" /usr/share/vim/vim70/colors/
"colorscheme desert

""
"" SQL::Beautify
""
autocmd Filetype sql :set equalprg=sql-beatufiy.pl
command! -range SQLF :'<,'>!$HOME/bin/sql-beautify.pl

""
"" perl vim tips
"" http://www.perlmonks.org/?node_id=540167
""
" autoindent
autocmd FileType perl set autoindent|set smartindent
autocmd FileType perl set autoindent|set smartindent

"show matching brackets
autocmd FileType perl set showmatch

" show line numbers
" autocmd FileType perl set number

" check perl code with :make
"autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set makeprg=perl\ $VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

" dont use Q for Ex mode
map Q :q

" make tab in v mode ident code
vmap <tab> >gv
vmap <s-tab> <gv

" make tab in normal mode ident code
nmap <tab>   >>
nmap <s-tab> <<

" my perl includes pod
let perl_include_pod = 1

" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1

" for something like $pack::var
let perl_want_scope_in_variables = 1

"folding
let perl_fold=1         "fold perl subs and pod
let perl_fold_blocks=1  "fold perl loops and blocks.
":%foldopen!             "open all folds.
set foldlevel=5
"set foldlevel=99 "default to no folding

"set foldmethod=indent "indent fold
"set foldmethod=marker "fold on manual {{{  }}}
"set foldmethod=syntax "fold based on syntax
"set foldmethod=manual "manual folding

" Tidy selected lines (or entire file) with ,t:
"nnoremap <silent> ,t :%!perltidy -q<Enter>
vnoremap <silent> ,t :!perltidy -q<Enter>

" use = to run perltidy instead of the builtin indenter
"set equalprg=perltidy
"set equalprg = "perltidy -q"

" paste mode - this will avoid unexpected effects when you
" cut or copy some text from one window and paste it in Vim.
" set pastetoggle=<F11>
" (see my ,p toggle above, which displays the current status of paste)

" Dictionary completion via ^x ^k
set dictionary+=/usr/share/dict/words
" Thesaurus completion via ^x ^t
" set thesaurus+=

let g:ctags_statusline=1
let g:ctags_title=0
let g:generate_tags=1
let g:ctags_regenerate=1

let g:zenburn_high_Contrast=1
let g:zenburn_alternate_Visual=1
let g:zenburn_old_Visual=1
set t_Co=256

set bg=dark
colors zenburn


set exrc

"enable the ftplugin and indent directories to get loaded
filetype plugin indent on

" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" " Show trailing whitepace and spaces before a tab and tabs that are not at
" the start of a line:
" match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+/
":highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
":au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
":au InsertLeave * match ExtraWhitespace /\s\+$/

highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
" hightlight trailing spaces and all tabs.
autocmd BufWinEnter * match ExtraWhitespace /\t\+\|\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\t\+\|\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$\|\t\+/
autocmd BufWinLeave * call clearmatches()

" show trailing spaces.  Don't show end-of-line $ marker
" list trailing spaces as "."  show tabs as ">       "
set list listchars=tab:>\ ,trail:.,extends:>

"http://geekblog.oneandoneis2.org/index.php/2012/02/15/cuz-multiple-steps-into-one-is-cool
" Get the commit responsible for the current line
nmap <f4> :call BlameCurrentLine()<cr>
" Get the current line number & file name, view the git commit that inserted it
fun! BlameCurrentLine()
let lnum = line(".")
let file = @%
exec "!gitBlameFromLineNo " lnum file
endfun

" map to run pep8
let g:pep8_map='<leader>8'

" set clipboard to use the + register -- the X clipboard
set clipboard=unnamedplus
