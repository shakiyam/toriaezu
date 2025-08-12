#!/usr/bin/fish

set script_dir (dirname (status --current-filename))
source "$script_dir/common.fish"

check_command fisher
check_command fzf

echo_info 'Install enhancd'
fisher install babarot/enhancd

echo_info 'Verify enhancd installation'
verify_command enhancd
