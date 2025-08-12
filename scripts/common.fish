#!/usr/bin/fish

set script_dir (dirname (status --current-filename))
source "$script_dir/colored_echo.fish"

# Unified error exit function
function die
    set message $argv[1]
    set exit_code 1
    if test (count $argv) -ge 2
        set exit_code $argv[2]
    end
    echo_error "$message"
    exit $exit_code
end

function check_command
    if test (count $argv) -eq 0
        die "check_command: No command specified"
    end
    if command -v $argv[1] &>/dev/null; or functions -q $argv[1]
        return 0
    end
    die "$argv[1] not found"
end
