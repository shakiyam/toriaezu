toriaezu
========

Install some tools and dotfiles.

How to use
----------

```console
git clone https://github.com/shakiyam/toriaezu
cd toriaezu
./provision.sh
```

Installed Software
------------------

Tools are organized into groups. `./provision.sh` installs the Base group by default.
To install other groups or individual tools, pass Makefile targets to `./provision.sh` (e.g., `./provision.sh base dev container` or `./provision.sh install_tmux`).
Run `make help` to list all targets.

### Base (`base`)

* [atuin](https://github.com/atuinsh/atuin)
* [bat](https://github.com/sharkdp/bat)
* [chezmoi](https://www.chezmoi.io/)
* [delta](https://github.com/dandavison/delta)
* [enhancd](https://github.com/b4b4r07/enhancd)
* [eza](https://github.com/eza-community/eza)
* [fd](https://github.com/sharkdp/fd)
* [fish](https://fishshell.com/)
* [Fisher](https://github.com/jorgebucaran/fisher)
* [fzf](https://github.com/junegunn/fzf)
* Git
* jq
* [mise](https://mise.jdx.dev/)
* [ripgrep](https://github.com/BurntSushi/ripgrep)
* UnZip
* XZ Utils
* Zip

### Development (`dev`)

* [actionlint](https://github.com/rhysd/actionlint)
* [Claude Code](https://claude.ai/code)
* [dockerfmt](https://github.com/reteps/dockerfmt)
* [GitHub CLI](https://github.com/cli/cli)
* [hadolint](https://github.com/hadolint/hadolint)
* [herdr](https://herdr.dev/)
* [hunk](https://github.com/modem-dev/hunk)
* [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2)
* Node.js
* [ruff](https://github.com/astral-sh/ruff)
* [ShellCheck](https://github.com/koalaman/shellcheck)
* [shfmt](https://github.com/mvdan/sh)
* [Trivy](https://github.com/aquasecurity/trivy)
* [yamlfmt](https://github.com/google/yamlfmt)
* [zizmor](https://github.com/zizmorcore/zizmor)

### Container (`container`)

* Docker Engine or Podman
* Docker Compose
* Docker Tools (dcls, dclogs)

### Others

* [csvq](https://github.com/mithrandie/csvq)
* [dive](https://github.com/wagoodman/dive)
* [dockviz](https://github.com/justone/dockviz)
* Go Programming Language
* history-cleanup
* kubectl
* NFS client
* OCI CLI
* [regctl](https://github.com/regclient/regclient)
* [s3fs](https://github.com/s3fs-fuse/s3fs-fuse)
* tmux

Target OS
---------

* Oracle Linux Server 9
* Oracle Linux Server 8
* Ubuntu 26.04 LTS
* Ubuntu 24.04 LTS

Author
------

[Shinichi Akiyama](https://github.com/shakiyam)

License
-------

[MIT License](https://opensource.org/licenses/MIT)
