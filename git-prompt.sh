if test -f /etc/profile.d/git-sdk.sh
then
	TITLEPREFIX=SDK-${MSYSTEM#MINGW}
else
	TITLEPREFIX=$MSYSTEM
fi

# custom
echo -ne '\e]4;0;#5C6370\a' # black
echo -ne '\e]4;1;#E06C75\a' # red
echo -ne '\e]4;2;#98C379\a' # green
echo -ne '\e]4;3;#D19A66\a' # yellow
echo -ne '\e]4;4;#61AFEF\a' # blue
echo -ne '\e]4;5;#C678DD\a' # magenta
echo -ne '\e]4;6;#56B6C2\a' # cyan
echo -ne '\e]4;7;#ABB2BF\a' # white
echo -ne '\e]4;8;#5C6370\a' # bold black
echo -ne '\e]4;9;#E06C75\a' # bold red
echo -ne '\e]4;10;#98C379\a' # bold green
echo -ne '\e]4;11;#D19A66\a' # bold yellow
echo -ne '\e]4;12;#61AFEF\a' # bold blue
echo -ne '\e]4;13;#C678DD\a' # bold magenta
echo -ne '\e]4;14;#56B6C2\a' # bold cyan
echo -ne '\e]4;15;#ABB2BF\a' # bold white

echo -ne '\e]10;#ABB2BF\a' # foreground
echo -ne '\e]11;#1E2127\a' # background
echo -ne '\e]12;#61AFEF\a' # cursor

MAGENTA="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[34m\]"
LIGHT_GRAY="\[\033[0;37m\]"
CYAN="\[\033[0;36m\]"
GREEN="\[\033[0;32m\]"
GIT_PS1_SHOWDIRTYSTATE=true
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

export PS1=$LIGHT_GRAY"\u@\h"'$(
    if [[ $(__git_ps1) =~ \*\)$ ]]
    # a file has been modified but not added
    then echo "'$YELLOW'"$(__git_ps1 " (%s)")
    elif [[ $(__git_ps1) =~ \+\)$ ]]
    # a file has been added, but not commited
    then echo "'$MAGENTA'"$(__git_ps1 " (%s)")
    # the state is clean, changes are commited
    else echo "'$CYAN'"$(__git_ps1 " (%s)")
    fi)'$BLUE" \w"$GREEN": "

if test -f ~/.config/git/git-prompt.sh
then
	. ~/.config/git/git-prompt.sh
else
	HN=`hostname`
	UN=`whoami`
	PS1='\[\033]0;${PWD//[^[:ascii:]]/?}\007\]' # set window title
	PS1="$PS1"'\n'                 # new line
	PS1="$PS1"'\[\033[32m\]'       # change to green
	#PS1="$PS1"'${UN,,}@${HN,,} '             # user@host<space>
	#PS1="$PS1"'🔥  '             # fire emoji
	PS1="$PS1"'\t '             # user@host<space>
	#PS1="$PS1"'\[\033[35m\]'       # change to purple
	#PS1="$PS1"'$MSYSTEM '          # show MSYSTEM
	PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
	PS1="$PS1"'\w'                 # current working directory
	if test -z "$WINELOADERNOEXEC"
	then
		GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
		COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
		COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
		COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
		if test -f "$COMPLETION_PATH/git-prompt.sh"
		then
			. "$COMPLETION_PATH/git-completion.bash"
			. "$COMPLETION_PATH/git-prompt.sh"
			PS1="$PS1"'\[\033[36m\]'  # change color to cyan
			PS1="$PS1"'`__git_ps1`'   # bash function
		fi
	fi
	PS1="$PS1"'\[\033[1;34m\]'        # change color
	#PS1="$PS1"'\n'                 # new line
	PS1="$PS1"' $ '                 # prompt: always $
	PS1="$PS1"'\[\033[0m\]'        # change color
fi

MSYS2_PS1="$PS1"               # for detection by MSYS2 SDK's bash.basrc

# Evaluate all user-specific Bash completion scripts (if any)
if test -z "$WINELOADERNOEXEC"
then
	for c in "$HOME"/bash_completion.d/*.bash
	do
		# Handle absence of any scripts (or the folder) gracefully
		test ! -f "$c" ||
		. "$c"
	done
fi
