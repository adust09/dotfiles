export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="cobalt2"
plugins=(git per-directory-history)
source $ZSH/oh-my-zsh.sh

# Ensure history settings are properly configured
# These settings may be overridden by zsh-autocomplete, so we set them explicitly
# Note: HISTFILE is managed by per-directory-history plugin, so we don't set it here
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt EXTENDED_HISTORY

function omz(){
    if [[ "$@" == "-g" ]]; then
        open https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
    fi
}
