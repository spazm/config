#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY

## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

## never ever beep ever
setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
MAILCHECK=0

# autoload -U colors
#colors


if [ -d $HOME/perl5 ]; then
    eval `perl -Mlocal::lib=$HOME/perl5`
fi

#add toast directories
LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$HOME/.toast/armed/lib
PATH=${PATH:+$PATH:}$HOME/.toast/armed/bin:$HOME/.toast/armed/sbin:$HOME/mybin/:$HOME/bin/

#Build ctags file, skipping .svn directories, from here down the tree.
function ctagit ()
{
	ctags -f tags --recurse --totals \
        --exclude=blib --exclude=.svn    \
        --exclue=.git  --exclude='*~'    \
        --languages=Perl --langmap=Perl:+.t
}

export EDITOR=vim


xterm_title()
{
    builtin print -n -P -- "\e]0;$@\a"
}
screen_title()
{
    builtin print -n -P -- "\ek$@\e\\"
    xterm_title "$@"
}

case $TERM in 
    screen|screen-w) 
        alias titlecmd="screen_title" 
    ;;
    xterm) 
        alias titlecmd="xterm_title"
    ;;
    *) 
        alias titlecmd=":"
    ;;
esac

## autoset title based on location and process

function preexec () {
    titlecmd "%m %4~" ":" "\"$1\""
}

function precmd () {
    titlecmd "%m %4~"
}


ssh() {
    titlecmd "$1";
    command ssh $*; 
    titlecmd "$HOSTNAME";
}


#set the prompt and right prompt.
PROMPT="[%n@%m]%# "
RPROMPT="%? %~"

#vi keybindings
bindkey -v

#named directories.  Access as ~u, etc.

#Functions & autoload
#FPATH=$HOME/.zfunc
#autoload function names here via:
#autoload foo bar baz
