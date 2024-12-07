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
function fzf-cdr() {
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

# fd - cd to selected directory
fda() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# fvim: ファイル名検索+Vimで開くファイルをカレントディレクトリからfzfで検索可能に
fvim() {
    local file
    file=$(
            rg --files --hidden --follow --glob "!**/.git/*"| fzf --preview "head -100 {}" \
                --preview 'bat  --color=always --style=header,grid {}' --preview-window=right:60%
    )
    vi "$file"
}

# zsh-autocomplete
source ~/dotfiles/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# 補完機能を有効にする
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完候補を詰めて表示
setopt list_packed

# 補完候補一覧をカラー表示
autoload colors
zstyle ':completion:*' list-colors ''

# コマンドのスペルを訂正
setopt correct

# fbr - checkout git branch (including remote branches)
fbr() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" |
            fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

# fshow - git commit browser
fshow() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
                    (grep -o '[a-f0-9]\{7\}' | head -1 |
                    xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                    {}
    FZF-EOF"
}

    # fzf_recent_command - search and reuse the recently used command
fzf_unique_recent_command() {
  local selected_command=$(history | tac | awk '{$1=""; print substr($0,2)}' | fzf --prompt="Search unique command: " --height=20 --reverse)

  if [[ -n "$selected_command" ]]; then
    echo "Executing command: $selected_command"
    eval "$selected_command"
  else
    echo "No command selected."
  fi
}
