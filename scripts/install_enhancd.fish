#!/usr/bin/fish

set script_dir (dirname (status --current-filename))
source "$script_dir/common.fish"

check_dependency fisher
check_dependency fzf

echo_info 'Install enhancd'
fisher install babarot/enhancd

echo_info 'Verify enhancd installation'
verify_installation enhancd
