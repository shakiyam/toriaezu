HISTCONTROL=erasedups
HISTFILESIZE=1000
HISTSIZE=1000
IGNOREEOF=1
PS1='[\u@\h \W]\$ '

shopt -s checkwinsize
shopt -s direxpand
shopt -s histappend

alias beautify_tsv='q -H -t -O -b "SELECT * FROM -"'
alias cp='cp -i'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias gitchmod='git update-index --add --chmod=+x'
alias grep='grep --color=auto'
alias loadenv='export $(grep -v "^#" .env | xargs -d "\n")'
alias ls='ls -F --color=auto --show-control-char -N'
alias lv='lv -Ia -Ou8'
alias mv='mv -i'
alias rm='rm -i'

[ -e /opt/enhancd/init.sh ] && . /opt/enhancd/init.sh
