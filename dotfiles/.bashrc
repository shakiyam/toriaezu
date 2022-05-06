# shellcheck disable=SC2148

# shellcheck disable=SC1091
[[ $- == *i* && -e "$HOME/.blesh/ble.sh" ]] && . "$HOME/.blesh/ble.sh" --noattach

HISTCONTROL=erasedups
HISTFILESIZE=1000
HISTSIZE=1000
IGNOREEOF=1
PS1='[\u@\h \W]\$ '

shopt -s checkwinsize
shopt -s histappend
shopt | grep -q direxpand && shopt -s direxpand

alias beautify_tsv='csvq -i TSV -f FIXED "SELECT * FROM STDIN"'
alias cp='cp -i'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias gitchmod='git update-index --add --chmod=+x'
alias grep='grep --color=auto'
alias less='less -R'
alias loadenv='export $(grep -v "^#" .env | xargs -d "\n")'
alias ls='ls -F --color=auto --show-control-char -N'
alias mv='mv -i'
alias rm='rm -i'
alias shfmt='shfmt -l -d -i 2 -ci -bn -kp'
alias watch='watch --color'

# shellcheck disable=SC1091
[[ -e "$HOME/.enhancd/init.sh" ]] && . "$HOME/.enhancd/init.sh"
[[ ${BLE_VERSION-} ]] && ble-attach && ble-bind -m auto_complete -f 'C-f' 'auto_complete/insert'

# shellcheck disable=SC1090
command -v kubectl >/dev/null 2>&1 && source <(kubectl completion bash)
