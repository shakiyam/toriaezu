HISTCONTROL=erasedups
HISTFILESIZE=1000
HISTSIZE=1000
IGNOREEOF=1
PS1='[\u@\h \W]\$ '

shopt -s checkwinsize
shopt -s histappend

alias cp='cp -i'
alias docker_rm_all='docker rm $(docker ps -a -q)'
alias docker_rmi_all='docker rmi $(docker images | awk "/^<none>/ { print \$3 }")'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
#alias go='docker run -i -t --rm -v /vagrant/golang/gopath:/go -e http_proxy="$http_proxy" -e https_proxy="$http_proxy" golang go $@'
alias grep='grep --color=auto'
#alias hadolint='docker run -i --rm sjourdan/hadolint'
alias ls='ls -F --color=auto --show-control-char -N'
alias lv='lv -Ia -Ou8'
alias mv='mv -i'
alias rm='rm -i'

docker_peco() {
  if [[ "$@" =~ PECOc ]]; then
    docker ps -a | peco | awk '{print $1}' | while read container
    do
      docker "${@/PECOc/$container}"
    done
  elif  [[ "$@" =~ PECOi ]]; then
    docker images | peco | awk '{print $3}' | while read image
    do
      docker "${@/PECOi/$image}"
    done
  else
    docker "$@"
  fi
}
