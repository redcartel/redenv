# source ~/binfiles/alias.sh in .bashrc

#export PATH="/home/redcartel/binfiles:/home/redcartel/.local/bin:/home/redcartel/installfiles/:$PATH"

# alias virtualenv='python3 -m virtualenv'
# alias venv='if [ ! -d "venv" ]; then virtualenv venv; source venv/bin/activate; elif [ -z "$VIRTUAL_ENV" ]; then source venv/bin/activate; else deactivate; fi'

alias ducksa='du -cks -BM * .[!.]* | sort -rn | head -n 24'
alias ducks='du -cks -BM * | sort -rn | head -n 24'
alias ":q"=exit
alias "o"=xdg-open
alias "open"=xdg-open
alias i3config="vim ~/.config/i3/config"

######### Launch nohup with no nohup.out #########

no() {
	# launch a command as a detached process. nohup.out is /tmp/no.out
    nohup &> /tmp/no.out $@ &
}

######### "Working Directory" Commands ###########

wk() {
    # create a symlinke ~/wk to the current directory & 
    # log the current directory
    rm -f ~/wk
    ln -s "$(pwd)" ~/wk
    echo "$(pwd)" >> ~/var/log/wk.log
}

cdwk() {
    # go to the last directory marked with wk, expands the symlink path
    cd "$(readlink ~/wk)"
}

#alias wk='rm -f ~/wk && ln -s "$(pwd)" ~/wk && echo "$(pwd)" >> ~/var/log/wk.log'
#alias cdwk='cd "$(readlink ~/wk)"'

lswk() {
    if [ -z "$1" ]; then
        N=10
    else
        N=$!
    fi
    # outputs the nth most recent directory logged by wk
    tail -n $N ~/var/log/wk.log | head -n 1
}

cdw() {
    # moves into the nth most recent directory logged by wk
    if [ -z $1 ]; then
        cdwk
    else
        DIR=wd $1
        cd "$DIR"
    fi
}

#### HISTORY FUNCTIONS ####

# reload current terminal history, getting commands from other terminals
hupdate() {
    history -c
    history -r
}

# clear history back to n lines, n defaults to 500
hpurge() {
    if [ -z $1 ]; then
        LINES=500
    else
        LINES=$1
    fi
    HISTSIZE=$LINES
    HISTFILESIZE=$LINES
    history -c
    history -r
}

# rewrite .bash_history with current session history
hrebuild() {
    history > ~/.bash_history
}

########## Today Folders #####################################################

cdt() {
    # Creates a Today folder and creates a symlink ~/td to it
    mkdir -p `td`
    rm -f ~/td
    ln -s `td` $HOME/td
    cd `td`
}

td() {
    # Returns the path to today's Today folder
    DIR=$HOME/Today/`bytedate -p`-cohort/`bytedate -r`
    echo $DIR
}

############### Python virtual environment ###################################

venv() {
    # if no virtual environment exists, create one & activate
    # if not active, activate
    # if active, deactivate
    if [ -z "$VIRTUAL_ENV" ]; then 
        if [ ! -d "venv" ]; then
            virtualenv venv
        fi
        source venv/bin/activate
    else
        deactivate
    fi
}

source $HOME/bin/bash_prompt.sh
