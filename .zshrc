ZSH_DIR="${HOME}/dotfiles/.zsh"

if [ -d $ZSH_DIR ] && [ -r $ZSH_DIR ] && [ -x $ZSH_DIR ]; then
    for file in ${ZSH_DIR}/**/*.zsh; do
        [ -r $file ] && source $file
    done
fi

if [ -f $HOME/dotfiles/env.sh ]; then
    source $HOME/dotfiles/env.sh
fi

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"

export GOROOT=$(brew --prefix go)/libexec
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# 追加でexec $SHELL実行しないと反映されない
export PATH="$HOME/.pyenv/shims:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$HOME/.cargo/bin:$PATH"
eval "$(rbenv init -)"

export PATH="$HOME/go/bin/jwx:$PATH"
alias rooset='~/dotfiles/.zsh/copy_contents.sh'
