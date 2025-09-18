#!/usr/bin/fish

set script_dir (dirname (status --current-filename))
source "$script_dir/colored_echo.fish"

if test (count $argv) -eq 0
    echo_error "Error: No input files specified"
    echo "Usage: fishlint.fish <files...>" >&2
    exit 1
end

set files $argv
set failed 0
for f in $files
    if test -f "$f"
        if not fish_indent --check "$f" 2>/dev/null
            echo_warn "$f needs formatting:"
            fish_indent "$f" | diff -u "$f" -
            set failed 1
        end
    else
        echo_error "Error: File not found: $f"
        set failed 1
    end
end

exit $failed
