#!/usr/bin/fish
# List likely typos in atuin and fish histories and delete them after confirmation
#
# Candidates are taken from atuin, which records exit codes:
#   - Exit code 127 and the first word is not currently runnable
#     (checked in an interactive fish so that abbrs and functions count)
#   - Failed git, docker, docker compose or mise whose subcommand is not in
#     the tool's help (and git aliases)
# First words and subcommands that succeeded at least once are excluded.
#
# Notes:
#   - Running fish sessions keep their in-memory history until restarted
#   - The atuin database is not vacuumed (that requires sqlite3)

function die
    echo "Error: $argv" >&2
    exit 1
end

command -q atuin; or die 'Command not found: atuin'

# Print command names and aliases listed in "...Commands:" sections of help text from stdin
function help_commands
    set -l in_section 0
    set -l lines
    while read -l line
        if string match -qr 'Commands:$' -- $line
            set in_section 1
        else if test -z "$line"
            set in_section 0
        else if test $in_section -eq 1
            set -a lines $line
        end
    end
    string match -r -g '^  (\S+)' -- $lines | string trim -r -c '*'
    string match -r -a -g '\[aliases: ([^\]]+)\]' -- (string join ' ' -- $lines) | string split , | string trim
end

# Print known subcommands of a tool: git, docker, docker-compose or mise
function known_subcommands -a tool
    switch $tool
        case git
            git help -a 2>/dev/null | string match -r -g '^   (\S+)'
            git config --get-regexp '^alias\.' 2>/dev/null | string match -r -g '^alias\.(\S+)'
        case docker
            docker --help 2>/dev/null | help_commands
        case docker-compose
            docker compose --help 2>/dev/null | help_commands
        case mise
            mise --help 2>/dev/null | help_commands
    end
end

# Words that look like plain command names: no options, paths, assignments, expansions or quotes
function is_plain_word -a word
    string match -qr -- '^[^-]' $word
    and not string match -qr -- '[\s/=$\'"\\\\(){}\[\]*?~<>|;&#`]' $word
end

# Set entry_time, entry_exit and entry_command from "time<TAB>exit<TAB>command"
# (commands may contain newlines, which command substitution would split)
function parse_entry -a entry
    set -g entry_time (string replace -r '(?s)\t.*' '' -- $entry)
    set -g entry_exit (string replace -r '(?s)^[^\t]*\t([^\t]*)\t.*' '$1' -- $entry)
    set -g entry_command (string replace -r '(?s)^[^\t]*\t[^\t]*\t' '' -- $entry | string collect)
end

# Print the words of the first line of a command
function first_line_words -a command
    string match -a -r '\S+' -- (string split -m 1 \n -- $command)[1]
end

set entries (atuin history list --print0 --timezone +0 --format '{time}'\t'{exit}'\t'{command}' | string split0)

# Typos never succeed, so skip first words and subcommands that succeeded at least once
# (e.g. commands of a tool that was installed later and then removed)
set succeeded_words (string replace -r -f '(?s)^[^\t]*\t0\t[ \t]*(\S+).*' '$1' -- $entries | sort -u)
set succeeded_subcommands (begin
    string replace -r -f '(?s)^[^\t]*\t0\t[ \t]*(git|docker|mise)[ \t]+(\S+).*' '$1 $2' -- $entries
    string replace -r -f '(?s)^[^\t]*\t0\t[ \t]*docker[ \t]+compose[ \t]+(\S+).*' 'docker compose $1' -- $entries
end | sort -u)

set candidates
set unknown_word_entries
set unknown_words
for entry in $entries
    parse_entry $entry
    test "$entry_exit" != 0; or continue
    set -l words (first_line_words $entry_command)

    if test "$entry_exit" = 127; and is_plain_word $words[1]
        contains -- $words[1] $succeeded_words; and continue
        set -a unknown_word_entries $entry
        contains -- $words[1] $unknown_words; or set -a unknown_words $words[1]
        continue
    end

    set -l tool $words[1]
    set -l subcommand $words[2]
    if test "$words[1] $words[2]" = 'docker compose'
        set tool docker-compose
        set subcommand $words[3]
    end
    contains -- $tool git docker docker-compose mise; or continue
    command -q $words[1]; or continue
    test -n "$subcommand"; and is_plain_word $subcommand; or continue
    contains -- (string replace docker-compose 'docker compose' $tool)" $subcommand" $succeeded_subcommands; and continue

    set -l known_var known_(string replace -a - _ $tool)
    if not set -q $known_var
        set -g $known_var (known_subcommands $tool)
    end
    if not contains -- $subcommand $$known_var
        contains -- $entry $candidates; or set -a candidates $entry
    end
end

# Check all words at once in an interactive fish to include abbrs and interactive-only functions
if test (count $unknown_words) -gt 0
    set -l missing (fish -i -c 'for w in $argv; type -q -- $w; or abbr -q -- $w; or echo "missing:$w"; end' $unknown_words </dev/null 2>/dev/null | string replace -r -f '^missing:' '')
    for entry in $unknown_word_entries
        parse_entry $entry
        set -l words (first_line_words $entry_command)
        if contains -- $words[1] $missing; and not contains -- $entry $candidates
            set -a candidates $entry
        end
    end
end

if test (count $candidates) -eq 0
    echo 'No candidates found'
    exit 0
end

echo "Candidates ($(count $candidates)):"
for entry in $candidates
    parse_entry $entry
    printf '%s  %4s  %s\n' $entry_time $entry_exit (string replace -a \n '\\n' -- $entry_command)
end

read -l -P 'Delete these entries from atuin and fish histories? [y/N] ' answer
if not string match -qi -r '^y(es)?$' -- "$answer"
    echo 'Nothing deleted'
    exit 0
end

test -n "$fish_history"; or set -g fish_history fish

set deleted 0
set skipped 0
for entry in $candidates
    parse_entry $entry
    set -l query (string trim -r -- $entry_command | string collect)

    # atuin deletes by prefix match, so narrow to this entry's exit code and time,
    # and delete only when every match is this command (atuin trims trailing spaces)
    set -l epoch (date -u -d "$entry_time UTC" +%s)
    set -l opts --filter-mode global --search-mode prefix --exit=$entry_exit \
        --after (date -u -d @(math $epoch - 1) +%Y-%m-%dT%H:%M:%SZ) \
        --before (date -u -d @(math $epoch + 1) +%Y-%m-%dT%H:%M:%SZ)
    set -l matches (atuin search $opts --print0 --format '{command}' -- $query | string split0)
    set -l others
    for match in $matches
        test "$match" = "$query"; or set -a others $match
    end
    if test (count $matches) -gt 0
        if test (count $others) -gt 0
            echo "Skipped in atuin (other entries match within ±1s): $(string replace -a \n '\\n' -- $query)" >&2
            set skipped (math $skipped + 1)
        else
            atuin search $opts --delete -- $query >/dev/null
            set deleted (math $deleted + 1)
        end
    end

    # fish saves commands without trailing spaces
    history delete --exact --case-sensitive -- $query
end

echo "Deleted $deleted entries from atuin (skipped $skipped) and matching commands from fish history"
echo 'Restart running fish sessions to drop deleted commands from their in-memory history'
