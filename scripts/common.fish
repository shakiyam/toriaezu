#!/usr/bin/fish

set script_dir (dirname (status --current-filename))
source "$script_dir/colored_echo.fish"

function check_command
    if test (count $argv) -eq 0
        echo_error "check_command: No command specified"
        exit 1
    end
    if command -v $argv[1] &>/dev/null; or functions -q $argv[1]
        return 0
    end
    echo_error "$argv[1] not found"
    exit 1
end
