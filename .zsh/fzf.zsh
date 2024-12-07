# zsh-autocomplete
source ~/dotfiles/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# 補完機能を有効にする
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt list_packed
autoload colors
zstyle ':completion:*' list-colors ''
setopt correct


# fzfでbraveの検索履歴を検索する
fbrave() {
    local cols sep brave_history open
    cols=$(( COLUMNS / 3 ))
    sep='{::}'
    if [ "$(uname)" = "Darwin" ]; then
        brave_history="$HOME/Library/Application Support/BraveSoftware/Brave-Browser/Default/History"
        open=open
    else
        brave_history="$HOME/.config/brave/Default/History"
        open=xdg-open
    fi
    cp -f "$brave_history" /tmp/h
    sqlite3 -separator $sep /tmp/h \
        "select substr(title, 1, $cols), url
        from urls order by last_visit_time desc" |
    awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
    fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

# cdrで過去に行ったことのあるディレクトリを表示し、fzfで絞り込んでディレクトリに移動する
function fcd() {
    target_dir=`cdr -l | sed 's/^[^ ][^ ]*  *//' | fzf`
    target_dir=`echo ${target_dir/\~/$HOME}`
    if [ -n "$target_dir" ]; then
        cd $target_dir
    fi
}

# cdrの設定
autoload -Uz is-at-least
if is-at-least 4.3.11
then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:'      recent-dirs-max 500
    zstyle ':chpwd:'      recent-dirs-default yes
    zstyle ':completion:*' recent-dirs-insert both
fi

# fvim: ファイル名検索+Vimで開くファイルをカレントディレクトリからfzfで検索可能に
fvim() {
    local file
    file=$(
            rg --files --hidden --follow --glob "!**/.git/*"| fzf --preview "head -100 {}" \
                --preview 'bat  --color=always --style=header,grid {}' --preview-window=right:60%
    )
    vi "$file"
}

# search history and do it
fh() {
  local cmd
  cmd=$(history | tac | awk '{$1=""; print substr($0,2)}' | fzf --height=20 --reverse --prompt="Search history: ")
  if [[ -n "$cmd" ]]; then
    eval "$cmd"
  fi
}

# search ssh-host and connect it
fssh() {
  local host
  host=$(cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sort -u | fzf --height=20 --reverse --prompt="Select SSH host: ")
  if [[ -n "$host" ]]; then
    ssh "$host"
  fi
}

# search environment variable
fev() {
  printenv | fzf --height=20 --reverse --prompt="Search environment variable: "
}

# search process and kill it
fpkill() {
  local pid
  pid=$(ps -ef | fzf --height=20 --reverse --prompt="Select process to kill: " | awk '{print $2}')
  if [[ -n "$pid" ]]; then
    kill -9 "$pid"
  fi
}
