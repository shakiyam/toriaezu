#!/usr/bin/fish

function echo_error
    if isatty stderr
        echo -e "\033[1;31m$argv\033[0m" >&2 # Bold Red
    else
        echo $argv >&2
    end
end

function echo_warn
    if isatty stderr
        echo -e "\033[1;33m$argv\033[0m" >&2 # Bold Yellow
    else
        echo $argv >&2
    end
end

function echo_info
    if isatty stdout
        echo -e "\033[36m$argv\033[0m" # Cyan
    else
        echo $argv
    end
end

function echo_success
    if isatty stdout
        echo -e "\033[32m$argv\033[0m" # Green
    else
        echo $argv
    end
end
