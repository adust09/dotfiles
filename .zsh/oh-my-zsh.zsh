export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="cobalt2"
plugins=(git)
source $ZSH/oh-my-zsh.sh
function omz(){
    if [[ "$@" == "-g" ]]; then
        open https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
    fi
}
