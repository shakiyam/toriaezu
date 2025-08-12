#!/usr/bin/fish

set script_dir (dirname (status --current-filename))
source "$script_dir/common.fish"

echo_info 'Install Fisher'
curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

echo_info 'Verify Fisher installation'
verify_command fisher
