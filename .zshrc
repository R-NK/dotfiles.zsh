export LANG=ja_JP.UTF-8
zstyle ':completion:*:default' menu select auto
zstyle ':completion:*' completer _complete _approximate _prefix
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

#set history size
export HISTSIZE=10000
#save history after logout
export SAVEHIST=10000
#history file
export HISTFILE=~/.zhistory
export LINES=1000
#append into history file
setopt INC_APPEND_HISTORY
#save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
#add timestamp for each entry
setopt EXTENDED_HISTORY

alias cat='bat --paging=never'
alias less='bat'
alias fd='fdfind'
alias awsmfa='bash awsmfa'
alias glo='gh-open $(ghq list -p | peco)'
alias ls='exa -Fla'
alias vim='gvim -v'
alias copy='xsel -ib'
alias jenkins='aws ssm start-session --target i-018189dd50d7d63cb --profile zucks-sazabi'
alias ec2-zgok="aws ec2 describe-instances --profile zucks-zgok --filter 'Name=instance-state-name, Values=running' | jq '.Reservations[].Instances[] | {InstanceId, PrivateIpAddress, InstanceName: (.Tags[] | select(.Key==\"Name\").Value)}' | less"
alias ec2-sazabi="aws ec2 describe-instances --profile zucks-sazabi --filter 'Name=instance-state-name, Values=running' | jq '.Reservations[].Instances[] | {InstanceId, PrivateIpAddress, InstanceName: (.Tags[] | select(.Key==\"Name\").Value)}' | less"
alias ec2-ada="aws ec2 describe-instances --profile zgok-ada --filter 'Name=instance-state-name, Values=running' | jq '.Reservations[].Instances[] | {InstanceId, PrivateIpAddress, InstanceName: (.Tags[] | select(.Key==\"Name\").Value)}' | less"
alias mysql="mysql -h 127.0.0.1"
#peco
function peco-kill() {
    for pid in `ps aux | peco | awk '{ print $2 }'`
    do
        kill $pid
        echo "Killed ${pid}"
    done
}
alias pk="peco-kill"
function peco-select-history() {
    BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function ghq-list() {
	local dir="$(ghq list -p | peco)"
	if [[ ! -z $dir ]]; then
		cd "$dir"
	fi
}
alias gl="ghq-list"

export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

export PATH="$PATH:`yarn global bin`"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.anyenv/envs/goenv/shims/"
export PATH="$PATH:$HOME/.cargo/bin"
export JAVA_HOME=$HOME/.sdkman/candidates/java/current
eval "$(starship init zsh)"

# eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light b4b4r07/enhancd
zinit ice blockf
zinit light zsh-users/zsh-completions
zinit ice as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/right/.sdkman"
[[ -s "/home/right/.sdkman/bin/sdkman-init.sh" ]] && source "/home/right/.sdkman/bin/sdkman-init.sh"
