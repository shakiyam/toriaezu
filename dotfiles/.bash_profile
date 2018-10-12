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
