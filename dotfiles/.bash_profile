if [[ -f ~/.bashrc ]]; then
  # shellcheck source=.bashrc
  # shellcheck disable=SC1091
  . ~/.bashrc
fi

PATH="$PATH:/usr/local/go/bin:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"

if command -v scl >/dev/null; then
  collections=$(scl --list)
  for collection in ${collections}; do
    # shellcheck disable=SC1091
    . scl_source enable "$collection"
  done
fi

if [[ -f ~/py36env/bin/activate ]]; then
  # shellcheck disable=SC1090
  . ~/py36env/bin/activate
fi

http_proxy_host=$(echo "${http_proxy:-}" | sed -E 's~[^/]*//([^@]*@)?([^:/]*)(:[0-9]*)?.*~\2~')
http_proxy_port=$(echo "${http_proxy:-}" | sed -E 's~[^/]*//([^@]*@)?([^:/]*)(:[0-9]*)?.*~\3~' | sed -e 's/://')
https_proxy_host=$(echo "${https_proxy:-}" | sed -E 's~[^/]*//([^@]*@)?([^:/]*)(:[0-9]*)?.*~\2~')
https_proxy_port=$(echo "${https_proxy:-}" | sed -E 's~[^/]*//([^@]*@)?([^:/]*)(:[0-9]*)?.*~\3~' | sed -e 's/://')
export JAVA_OPTS="-Dhttp.proxyHost=${http_proxy_host} -Dhttp.proxyPort=${http_proxy_port} -Dhttps.proxyHost=${https_proxy_host} -Dhttps.proxyPort=${https_proxy_port}"
