# Find out in which directory ALIX is installed
ALIX_DIR=$(dirname $BASH_SOURCE)
ALIX_PLATFORM=`uname`


. $ALIX_DIR/shell_env
. $ALIX_DIR/shell_aliases

################### GIT BRANCH IN PROMPT ##############################

# function to get the current git branch
# copied from somewhere on the internet.
function parse_git_branch {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
# Function guessing if we are in trunk or in a branches
# A branch must be a direct subdirectory of a 'branches' directory
function parse_svn_branch {
	# Perl oneliner:
	# (?|) to offer alternatives and keep group numbering
	# (?:) do not capture this group. Let us exclude 'branches'
	svn info 2> /dev/null | perl -ne 'print $1 if /^URL:.*(?|(trunk)|(?:branches)\/([^\/]+))/'
}

# Wrapper to look for both git & subversion branches
# git takes precedence.
function parse_repo_branch {
	local GIT_BRANCH=$(parse_git_branch)
	if [ -n "$GIT_BRANCH" ]; then
		# Great we have found a git branch
		echo -n "(git:$GIT_BRANCH)"
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

# set the francy prompt with colors if wanted and using the
# parse_git_branch function above.

case "$TERM" in
	xterm-color | xterm-256color)
		PS1='\[\033[01;35m\]\u@'$(get_PS1_hostname)'\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\[\033[00;32m\]$(parse_repo_branch)\[\033[00m\]\$ '
		;;
	*)
		PS1='\u@\h:\w$(parse_repo_branch)\$ '
		;;
esac

# correct my spelling while doing cd
shopt -s cdspell

# Enable bash completion as provided by Mac HomeBrew
# Install using: brew install bash-completion.
if [ -n "`which brew`" ]; then
	if [ -f `brew --prefix`/etc/bash_completion ]; then
		. `brew --prefix`/etc/bash_completion
	fi
fi

# Source local user changes if any
if [ -f $ALIX_DIR/bashrc_local ]; then
	. $ALIX_DIR/bashrc_local
fi
