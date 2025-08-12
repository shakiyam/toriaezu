#!/usr/bin/fish

set script_dir (dirname (status --current-filename))
source "$script_dir/colored_echo.fish"

function die
    if test (count $argv) -eq 0
        echo_error "Error: No message specified for die"
        exit 1
    end

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
        die "Error: No command specified for check_command"
    end
    if command -v $argv[1] &>/dev/null; or functions -q $argv[1]
        return 0
    end
    die "Error: Command not found: $argv[1]"
end

function verify_command
    if test (count $argv) -eq 0
        die "Error: No command specified for verify_command"
    end

    set command $argv[1]
    if command -v $command &>/dev/null; or functions -q $command
        echo_success "Verification passed: $command is installed and accessible"
    else
        die "Error: Command $command not found in PATH"
    end
end
