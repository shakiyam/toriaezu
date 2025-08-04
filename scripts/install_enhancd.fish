#!/usr/bin/fish

# Source common functions
set script_dir (dirname (status --current-filename))
source "$script_dir/common.fish"

check_command fisher
check_command fzf

echo_info 'Install enhancd'
fisher install babarot/enhancd
