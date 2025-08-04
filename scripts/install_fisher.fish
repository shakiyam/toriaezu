#!/usr/bin/fish

# Source common functions
set script_dir (dirname (status --current-filename))
source "$script_dir/common.fish"

echo_info 'Install Fisher'
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
