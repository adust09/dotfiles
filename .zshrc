ln -s ~/dotfiles/.zshrc ~

# zsh-autocomplete
source ~/dotfiles/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
alias chat='cd ~/shell/chatgpt-cli && python3 chatgpt.py'

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
