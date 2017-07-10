function profile() {
    START_TIME=`~/bin/unixnano`
		source $1
    END_TIME=`~/bin/unixnano`

    TIME=`expr ${END_TIME} - ${START_TIME}`
    SEC=`expr $TIME / 1000000000`
    USEC=`expr $TIME % 1000000000`
    echo "${SEC}.`printf '%09d' $USEC`: $1"
}

bindkey -e

source ~/.zsh/lib/go.zsh
source ~/.zsh/lib/aliases.zsh
source ~/.zsh/lib/basic.zsh
source ~/.zsh/lib/completion.zsh
source ~/.zsh/lib/functions.zsh
source ~/.zsh/lib/git.zsh
source ~/.zsh/lib/languages.zsh
source ~/.zsh/lib/peco.zsh
source ~/.zsh/lib/theme.zsh
source ~/.zsh/lib/tmux.zsh

# Environment-local configurations
[ -f ~/.zshrc.`uname` ] && source ~/.zshrc.`uname`
[ -f ~/.zshrc.local ]   && source ~/.zshrc.local

export NVM_DIR="/Users/kokubun/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
