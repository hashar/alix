# Find out in which directory ALIX is installed
export ALIX_DIR=$(dirname $BASH_SOURCE)
export ALIX_PLATFORM=`uname`


. $ALIX_DIR/shell_env
. $ALIX_DIR/shell_aliases
. $ALIX_DIR/shell_functions

# Enable bash completion as provided by Mac HomeBrew
# Install using: brew install bash-completion.
if [ -n "`which brew`" ]; then
	if [ -f `brew --prefix`/etc/bash_completion ]; then
		. `brew --prefix`/etc/bash_completion
	fi
elif ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

################### GIT BRANCH IN PROMPT ##############################

# Function guessing if we are in trunk or in a branches
# A branch must be a direct subdirectory of a 'branches' directory
function parse_svn_branch {
	# Perl oneliner:
	# (?|) to offer alternatives and keep group numbering
	# (?:) do not capture this group. Let us exclude 'branches'
	svn info 2> /dev/null | perl -ne 'print $1 if /^URL:.*(?|(trunk)|(?:branches)\/([^\/]+))/'
}

# Show unstaged (*) and staged (+) changes
export GIT_PS1_SHOWDIRTYSTATE=true

# Show stashed ($)
#export GIT_PS1_SHOWSTASHSTATE=true

# Show untracked (%)
#export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM="verbose git"

# __git_ps1 might not be defined in older git versions
if [ "function" != "`type -t __git_ps1`" ]; then
	function __git_ps1 {
		git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\(\1\)/'
	}
fi

# Wrapper to look for both git & subversion branches
# git takes precedence.
function parse_repo_branch {
	local GIT_BRANCH=$(__git_ps1)
	if [ -n "$GIT_BRANCH" ]; then
		# Great we have found a git branch
		echo -n ${GIT_BRANCH// /}
	else
		local SVN_BRANCH=$(parse_svn_branch)
		if [ -n "$SVN_BRANCH" ]; then
			# Add a 'svn:' prefix so we reminder to use svn and not git
			echo -n "(svn:$SVN_BRANCH)"
		fi
	fi
}

# Specific to WMF cluster which use non human friendly hostname :-D
function get_PS1_hostname {
	if [ -n "$INSTANCENAME" ]; then
		echo $INSTANCENAME;
	else
		echo "\h";
	fi
}

function user_at_host_color {
	local domain=`hostname -f | cut -d\. -f2-`

	case $domain in

		pmtpa.wmflabs)
			echo "01;33m"  # yellow
		;;
		eqiad.wmflabs)
			echo "01;36m"  # cyan
		;;
		*)
			echo "01;35m"  # magenta
		;;

	esac
}

# set the francy prompt with colors if wanted and using the
# parse_git_branch function above.

case "$TERM" in
	xterm | xterm-color | xterm-256color)
		PS1='\[\e]0;\u@'$(get_PS1_hostname)': \w\a\]\[\033['$(user_at_host_color)'\]\u@'$(get_PS1_hostname)'\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\[\033[00;32m\]$(parse_repo_branch)\[\033[00m\]\$ '
		;;
	*)
		PS1='\u@\h:\w$(parse_repo_branch)\$ '
		;;
esac

# correct my spelling while doing cd
shopt -s cdspell

# Source local user changes if any
if [ -f $ALIX_DIR/bashrc_local ]; then
	. $ALIX_DIR/bashrc_local
fi
