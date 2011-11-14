# Find out in which directory ALIX is installed
ALIX_DIR=$(dirname $BASH_SOURCE)

. $ALIX_DIR/shell_env
. $ALIX_DIR/shell_aliases

################### GIT BRANCH IN PROMPT ##############################

# function to get the current git branch
# copied from somewhere on the internet.
function parse_git_branch {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# set the francy prompt with colors if wanted and using the
# parse_git_branch function above.
case "$TERM" in
	xterm-color | xterm-256color)
		PS1='\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\[\033[00;32m\]$(parse_git_branch)\[\033[00m\]\$ '
		;;
	*)
		PS1='\u@\h:\w$(parse_git_branch)\$ '
		;;
esac

# correct my spelling while doing cd
shopt -s cdspell
