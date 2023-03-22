ZSH_DIR="${HOME}/dotfiles/.zsh"

if [ -d $ZSH_DIR ] && [ -r $ZSH_DIR ] && [ -x $ZSH_DIR ]; then
    for file in ${ZSH_DIR}/**/*.zsh; do
        [ -r $file ] && source $file
    done
fi

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH

./.zsh/ascii-art.zsh
