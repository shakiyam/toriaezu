#!/usr/bin/fish

function echo_error
    if isatty stdout
        echo -e "\033[1;31m$argv\033[0m" # Bold Red
    else
        echo $argv
    end
end

function echo_warn
    if isatty stdout
        echo -e "\033[1;33m$argv\033[0m" # Bold Yellow
    else
        echo $argv
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
