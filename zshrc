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


if [ -d /apps/perl5 ]; then
    eval $( perl -Mlocal::lib=/apps/perl5 )
fi

#add toast directories
LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$HOME/.toast/armed/lib
PATH=${PATH:+$PATH:}$HOME/.toast/armed/bin:$HOME/.toast/armed/sbin:$HOME/mybin/:$HOME/bin/:$HOME/open42/adblender/trunk/adblender/bin:$HOME/trunk/adblender/bin

#Build ctags file, skipping .svn directories, from here down the tree.
function ctagit ()
{
	ctags -f tags --recurse --totals \
        --exclude=blib --exclude=.svn    \
        --exclude=.git --exclude='*~'    \
        --extra=q                        \
        --languages=Perl --langmap=Perl:+.t
}

export EDITOR=vim
export ADB_HOME=$HOME/trunk/adblender

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

#vi keybindings + ctrl-r to search backward.
bindkey -v
bindkey "^r" history-incremental-search-backward

#named directories.  Access as ~u, etc.
s=$HOME/src
o=$ADB_HOME

#Functions & autoload
#FPATH=$HOME/.zfunc
#autoload function names here via:
#autoload foo bar baz

#export SVN=http://nile:1984/svn/svnroot/
export SVN=https://open42.svn.cvsdude.com/adblender/

# export this for skype to function with my microphone.
export PULSE_SERVER=127.0.0.1 

#ibus? what is this?
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
