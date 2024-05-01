export   HISTCONTROL=ignoredups
setopt   appendhistory
setopt   HIST_IGNORE_ALL_DUPS
unsetopt HIST_IGNORE_DUPS

TERM=screen-256color
GPG_TTY=$(tty)
export GPG_TTY

# Fallback prompt
PROMPT="%F{045}%n@%m%B:%b %F{156}%1~ %F{050}%B%#%b %F{046}"

# Add homebrew to PATH
PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

if [[ $(uname) == "Darwin" ]]; then
    _zsh_plugins_dir="/opt/homebrew/share"
elif [[ $(uname) == "Linux" ]]; then
    _zsh_plugins_dir="/usr/share"
fi

source ${_zsh_plugins_dir}/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${_zsh_plugins_dir}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${_zsh_plugins_dir}/zsh-history-substring-search/zsh-history-substring-search.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

if [[ $(uname) == "Darwin" ]]; then
    # history search
    bindkey '^[[A'  history-substring-search-up
    bindkey '^[[B'  history-substring-search-down

    # option + left/right
    bindkey "^[[1;3D"   backward-word
    bindkey	"^[[1;3C"   forward-word

    # cmd + left/right
    bindkey "^[[1;9D"   beginning-of-line
    bindkey "^[[1;9C"   end-of-line

    alias brew_update="brew update && brew upgrade; brew autoremove; brew cleanup -s"
    alias lsusb="ioreg -p IOUSB"
elif [[ $(uname) == "Linux" ]]; then
    # history search
    bindkey '^[[A'  history-substring-search-up
    bindkey '^[[B'  history-substring-search-down

    # ctrl + left/right
    bindkey	"^[[1;5C"   forward-word
    bindkey "^[[1;5D"   backward-word

    # alt + left/right
    bindkey	"^[[1;3C"   forward-word
    bindkey "^[[1;3D"   backward-word

    # Home/End
    bindkey	"^[[H"      beginning-of-line
    bindkey "^[[F"      end-of-line

    # delete key
    bindkey "^[[3~"     delete-char
fi

autoload -Uz compinit
compinit

eval "$(starship init zsh)"

fastfetch

alias vim="nvim"
alias ssh="TERM=xterm-256color ssh"
alias ls="eza -g --git"
alias ll="eza -aghl --git"

# Git aliases
alias git_gc="git gc --aggressive --prune"
alias gru="git remote update --prune"
alias grp="git remote prune"
alias gsfc="git submodule foreach git checkout . && git submodule foreach git submodule foreach git checkout ."
alias gsu="git submodule update --init --recursive"

function validate_args_eq() {
    expected_num=$1
    actual_num=$2
    usage_str=$3

    if [[ ${actual_num} -ne ${expected_num} ]]; then
        echo error: expected ${expected_num} arguments, got ${actual_num} arguments
        echo usage: ${usage_str}
	return 1
    fi

    return 0
}

function validate_args_gt() {
    min_num=$1
    actual_num=$2
    usage_str=$3

    if [[ ${actual_num} -lt ${min_num} ]]; then
        echo error: expected at least ${min_num} arguments, got ${actual_num} arguments
        echo usage: ${usage_str}
	return 1
    fi

    return 0
}

function git_recreate() {
    validate_args_eq 1 $# "git_recreate [branch]"
    if [[ $? == 1 ]]; then
        return 1
    fi

    branch_name=$1

    git checkout -b temp
    git branch -D ${branch_name}
    git checkout -b ${branch_name}
    git branch -D temp
}

function git_refresh() {
    validate_args_eq 2 $# "git_refresh [remote] [branch]"
    if [[ $? == 1 ]]; then
        return 1
    fi

    remote_name=$1
    branch_name=$2

    git checkout -b temp && \
    git branch -D ${branch_name} && \
    git checkout --track ${remote_name}/${branch_name} && \
    git branch -D temp
}
