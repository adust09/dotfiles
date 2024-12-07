alias gbd='git branch -D'
alias gcb='git checkout -b'
alias gcmm='git commit -m'
alias ghp='cat ~/git_in_omz.text'
alias gtr='git log --graph --all --format="%x09%C(cyan bold)%an%Creset%x09%C(yellow)%h%Creset %C(magenta reverse)%d%Creset %s"'
alias commitfilesname='git show commit_id --name-only'
alias fgbd='git branch | fzf -m | xargs -I {} git branch -D {}'

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

fstash() {
  local stash
  stash=$(git stash list | fzf --height=20 --reverse --prompt="Select stash: ")
  [[ -n "$stash" ]] && git stash apply "$(echo $stash | awk '{print $1}')"
}

freset() {
  local commit
  commit=$(git log --oneline --graph --color=always | fzf --ansi --height=20 --reverse --prompt="Select commit to reset: ")
  [[ -n "$commit" ]] && git reset --hard "$(echo $commit | awk '{print $1}')"
}

fdiff() {
  local file
  file=$(git diff --name-only | fzf --height=20 --reverse --prompt="Select file: ")
  [[ -n "$file" ]] && git diff "$file" | less
}

fmerge() {
  local branch
  branch=$(git branch --all | grep -v 'HEAD' | sed 's/^[ *]*//' | fzf --prompt="Select branch to merge: " --height=20 --reverse)
  [[ -n "$branch" ]] && git merge "$(echo $branch | sed 's#remotes/[^/]*/##')"
}

fclean() {
  local file
  file=$(git clean -nd | fzf --height=20 --reverse --prompt="Select file to delete: " | awk '{print $NF}')
  [[ -n "$file" ]] && git clean -f "$file"
}

frebase() {
  local branch
  branch=$(git branch --all | grep -v 'HEAD' | sed 's/^[ *]*//' | fzf --prompt="Select branch to rebase onto: " --height=20 --reverse)
  [[ -n "$branch" ]] && git rebase "$(echo $branch | sed 's#remotes/[^/]*/##')"
}

fgpull() {
  local remote
  remote=$(git remote -v | awk '{print $1}' | sort -u | fzf --prompt="Select remote: " --height=20 --reverse)
  [[ -n "$remote" ]] && git pull "$remote"
}

user_name=$(git config user.name)
fmt="\
%(if:equals=$user_name)%(authorname)%(then)%(color:default)%(else)%(color:brightred)%(end)%(refname:short)|\
%(committerdate:relative)|\
%(subject)"
function select-git-branch-friendly() {
  selected_branch=$(
    git branch --sort=-committerdate --format=$fmt --color=always \
    | column -ts'|' \
    | fzf --ansi --exact --preview='git log --oneline --graph --decorate --color=always -50 {+1}' \
    | awk '{print $1}' \
  )
  BUFFER="${LBUFFER}${selected_branch}${RBUFFER}"
  CURSOR=$#LBUFFER+$#selected_branch
  zle redisplay
}
zle -N select-git-branch-friendly
bindkey '^b' select-git-branch-friendly
