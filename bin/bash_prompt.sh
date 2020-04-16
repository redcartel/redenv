#!/bin/bash

#
# DESCRIPTION:
#
#   Set the bash prompt according to:
#    * the active virtualenv
#    * the branch of the current git/mercurial repository
#    * the return value of the previous command
#    * the fact you just came from Windows and are used to having newlines in
#      your prompts.
#
# USAGE:
#
#   1. Save this file as ~/.bash_prompt
#   2. Add the following line to the end of your ~/.bashrc or ~/.bash_profile:
#        . ~/.bash_prompt
#
# LINEAGE:
#
#   Based on work by woods
#
#   https://gist.github.com/31967

# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
  LIGHT_RED="\[\033[1;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
       BLUE="\[\033[0;34m\]"
LIGHT_BLUE="\[\033[1;34m\]"
     PURPLE="\[\033[0;35m\]"
	 LIGHT_PURPLE="\[\033[1;35m\]"
	 CYAN="\[\033[\033[0;36m\]"
LIGHT_CYAN="\[\033[\033[1;36m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
      WHITE="\[\033[1;37m\]"
 COLOR_NONE="\[\e[0m\]"

# determine git branch name
function parse_git_branch(){
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function set_title(){
  echo -en "\e]2;$(pwd)\a"
}

# determine mercurial branch name
function parse_hg_branch(){
  hg branch 2> /dev/null | awk '{print "(" $1 ")"}'
}

# Determine the branch/state information for this git repository.
function set_git_branch() {
  # Get the name of the branch.
  branch=$(parse_git_branch)
  # if not git then maybe mercurial
  if [ "$branch" == "" ]
  then
    branch=$(parse_hg_branch)
  fi

  # Set the final branch string.
  BRANCH="${PURPLE}${branch}${COLOR_NONE} "
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="${LIGHT_GREEN}\$${COLOR_NONE}"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE}"
  fi
}

function echo_todo () {
  CURDIR="$(pwd)"
  OLDDIR="$(tail -n 1 ~/.current_dir)"
  if test "$CURDIR" != "$OLDDIR" && test -f TODO.md; then
      echo ""
      echo "==== TODO.md ===="
      cat TODO.md
      echo ""
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  # Set the BRANCH variable.
  set_git_branch

  # Set the title in a gui terminal 
  set_title

  # if entering a directory for the first time & TODO.md exists, print it
  echo_todo
  
  # replace the contents of .current_dir with the current path
  echo "`pwd`" > ~/.current_dir
  
  GREENPATH="${LIGHT_CYAN}\w${COLOR_NONE}"

  PS1="${PYTHON_VIRTUALENV}${GREENPATH} ${BRANCH}
\! ${PROMPT_SYMBOL} "
}

# multiple terminals add their commands to bash_history
# see hupdate in alias.sh for func that loads current history into a running terminal
PROMPT_COMMAND="history -a; set_bash_prompt;"

# after creating these definitions (typically when the terminal opens) change
# to the last directory from the most recent terminal session
#
# I keep most of my 
if [ -f ~/.current_dir ]; then
    DIR="$(tail -n 1 ~/.current_dir)"
    DIR=`echo $DIR | sed -e "s/~\\/Dropbox\\/Home\\//~\\//"`
    if [ -d $DIR ]; then
        cd "$DIR"
    fi
fi
