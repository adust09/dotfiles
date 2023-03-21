# zsh-autocomplete
source ~/dotfiles/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH

#alias
alias chat='cd ~/dotfiles/plugins/chatgpt-cli && python3 chatgpt.py'

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="cobalt2"
plugins=(git)
source $ZSH/oh-my-zsh.sh
