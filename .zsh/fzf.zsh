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
# search and checkout git branch using fzf
fgb() {
  local branch
  branch=$(git branch --all --color=always | grep -v '/HEAD\s' | fzf --height=20 --ansi --reverse --prompt="Select git branch: " | sed 's/.* //' | sed 's#remotes/[^/]*/##')
  if [[ -n "$branch" ]]; then
    git checkout "$branch"
  fi
}

# interactive git worktree creation using fzf
fwq() {
  local branch worktree_path
  
  # Select branch interactively
  branch=$(git branch --all --color=always | grep -v '/HEAD\s' | fzf --height=20 --ansi --reverse --prompt="Select branch for worktree: " | sed 's/.* //' | sed 's#remotes/[^/]*/##')
  
  if [[ -z "$branch" ]]; then
    echo "No branch selected"
    return 1
  fi
  
  # Default worktree path based on branch name
  local default_path="../worktree-${branch}"
  
  # Prompt for worktree path
  echo -n "Enter worktree path (default: $default_path): "
  read worktree_path
  
  # Use default if no path provided
  if [[ -z "$worktree_path" ]]; then
    worktree_path="$default_path"
  fi
  
  # Create the worktree
  echo "Creating worktree for branch '$branch' at '$worktree_path'"
  git worktree add "$worktree_path" "$branch"
  
  if [[ $? -eq 0 ]]; then
    echo "Worktree created successfully!"
    echo "You can now cd to: $worktree_path"
  else
    echo "Failed to create worktree"
  fi
}

# interactive git worktree deletion using fzf
fwd() {
  local worktree_info worktree_path
  
  # Get worktree list and select interactively
  worktree_info=$(git worktree list --porcelain | grep -E '^worktree|^branch' | paste - - | sed 's/worktree //' | sed 's/branch //' | fzf --height=20 --reverse --prompt="Select worktree to delete: " --preview="echo 'Path: {}' | cut -d$'\t' -f1; echo 'Branch: {}' | cut -d$'\t' -f2")
  
  if [[ -z "$worktree_info" ]]; then
    echo "No worktree selected"
    return 1
  fi
  
  # Extract worktree path
  worktree_path=$(echo "$worktree_info" | cut -d$'\t' -f1)
  
  # Skip if it's the main worktree (usually current directory)
  if [[ "$worktree_path" == "$(git rev-parse --show-toplevel)" ]]; then
    echo "Cannot delete the main worktree"
    return 1
  fi
  
  # Confirmation prompt
  echo "Are you sure you want to delete worktree at '$worktree_path'? (y/N)"
  read -r confirmation
  
  if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    echo "Removing worktree at '$worktree_path'"
    git worktree remove "$worktree_path"
    
    if [[ $? -eq 0 ]]; then
      echo "Worktree removed successfully!"
    else
      echo "Failed to remove worktree"
    fi
  else
    echo "Worktree deletion cancelled"
  fi
}
