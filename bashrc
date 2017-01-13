# shellcheck source=/dev/null

# Find out in which directory ALIX is installed
export ALIX_DIR
ALIX_DIR=$(dirname $BASH_SOURCE)
export ALIX_PLATFORM
ALIX_PLATFORM=$(uname)

. "$ALIX_DIR"/shell_env
. "$ALIX_DIR"/shell_aliases
. "$ALIX_DIR"/shell_functions

# Enable bash completion as provided by Mac HomeBrew
# Install using: brew install bash-completion.
if [[ "$ALIX_PLATFORM" = "Darwin" && -n "$(which brew)" ]]; then
	local brew_prefix
	brew_prefix=$(brew --prefix)
	if [ -f "$brew_prefix"/etc/bash_completion ]; then
		. "$brew_prefix"/etc/bash_completion
	fi
elif ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

################### GIT BRANCH IN PROMPT ##############################

# Show unstaged (*) and staged (+) changes
export GIT_PS1_SHOWDIRTYSTATE=true

# Show stashed ($)
#export GIT_PS1_SHOWSTASHSTATE=true

# Show untracked (%)
#export GIT_PS1_SHOWUNTRACKEDFILES=true

# verbose: number of commits
# git: compare HEAD to @{upstream}
# name: with verbose: upstream name
export GIT_PS1_SHOWUPSTREAM="verbose git"
# Separator between branch and state symbol
export GIT_PS1_STATESEPARATOR="|"
# Colored dirty state
export GIT_PS1_SHOWCOLORHINTS=1

# __git_ps1 might not be defined in older git versions
if [ "function" != "$(type -t __git_ps1)" ]; then
	function __git_ps1 {
		git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\(\1\)/'
	}
fi

# Wrapper to look for git branches
function parse_repo_branch {
	local GIT_BRANCH
	GIT_BRANCH=$(__git_ps1)
	if [ -n "$GIT_BRANCH" ]; then
		# Great we have found a git branch
		echo -n "${GIT_BRANCH// /}"
	fi
}

function user_at_host_color {
	local fqdn
	fqdn=$(hostname -f)

	case $fqdn in

		*.integration.eqiad.wmflabs)
			echo "01;33m" # yellow
		;;
		*.deployment-prep.eqiad.wmflabs)
			echo "01;34m" # blue
		;;
		*eqiad.wmflabs)
			echo "01;36m"  # cyan
		;;
		pico.hashar)
			echo "01;34m"  # blue
		;;
		*)
			echo "01;35m"  # magenta
		;;

	esac
}

# set the francy prompt with colors if wanted and using the
# parse_git_branch function above.

case "$TERM" in
	screen | xterm | xterm-color | xterm-256color)
		PS1='\[\e]0;\u@\h: \w\a\]\[\033['$(user_at_host_color)'\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\[\033[00;32m\]$(parse_repo_branch)\[\033[00m\]\$ '
		;;
	*)
		PS1='\u@\h:\w$(parse_repo_branch)\$ '
		;;
esac

# correct my spelling while doing cd
shopt -s cdspell

# append to history instead of overwriting
shopt -s histappend
HISTCONTROL=ignoredups:ignorespace
HISTFILESIZE=19119
HISTSIZE=1911  # 0x777
HISTIGNORE=ls:ll:cd
HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S %z | '

if [[ "$XDG_CURRENT_DESKTOP" = "KDE" ]]; then
	# Since Konsole is lame
	# Control+K to clear screen and scrollback
	bind -x "\"\C-k\":\"echo -en '\033c\e[3J'\""
fi

# Source local user changes if any
if [ -f "$ALIX_DIR"/bashrc_local ]; then
	. "$ALIX_DIR"/bashrc_local
fi
