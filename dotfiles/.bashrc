HISTCONTROL=erasedups
HISTFILESIZE=1000
HISTSIZE=1000
IGNOREEOF=1
PS1='[\u@\h \W]\$ '

shopt -s checkwinsize
shopt -s histappend
shopt | grep -q direxpand && shopt -s direxpand

alias beautify_tsv='q -H -t -O -b "SELECT * FROM -"'
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
alias watch='watch --color'

  # shellcheck disable=SC1091
[[ -e /opt/enhancd/init.sh ]] && . /opt/enhancd/init.sh
