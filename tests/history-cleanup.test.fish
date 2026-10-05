#!/usr/bin/fish
# Tests for bin/history-cleanup.fish using isolated atuin and fish histories

set repo_dir (realpath (dirname (status --current-filename))/..)
set script "$repo_dir/bin/history-cleanup.fish"
source "$repo_dir/scripts/colored_echo.fish"

set tmp (mktemp -d)
function cleanup --on-event fish_exit
    rm -rf $tmp
end

mkdir -p $tmp/atuin-config $tmp/atuin-data $tmp/data/fish $tmp/config/fish
printf '%s\n' \
    "db_path = \"$tmp/atuin-data/history.db\"" \
    "record_store_path = \"$tmp/atuin-data/records.db\"" \
    "key_path = \"$tmp/atuin-data/key\"" \
    'auto_sync = false' \
    'update_check = false' \
    '[daemon]' \
    'enabled = false' >$tmp/atuin-config/config.toml
printf '%s\n' \
    'abbr -a gs git status' \
    'function myfn; end' >$tmp/config/fish/config.fish
printf '%s\n' '[alias]' '    st = status' >$tmp/gitconfig

set -gx ATUIN_CONFIG_DIR $tmp/atuin-config
set -gx ATUIN_DATA_DIR $tmp/atuin-data
set -gx ATUIN_SESSION (atuin uuid)
set -gx XDG_DATA_HOME $tmp/data
set -gx XDG_CONFIG_HOME $tmp/config
set -gx GIT_CONFIG_GLOBAL $tmp/gitconfig
set -gx GIT_CONFIG_NOSYSTEM 1

set failed 0
function check -a name
    if test "$argv[2]" = ok
        echo_success "✓ $name"
    else
        echo_error "✗ $name"
        set failed 1
    end
end

# Compare two newline-separated sets given as single strings
function same_set -a actual expected
    test (string split \n -- $actual | sort | string collect) = (string split \n -- $expected | sort | string collect)
end

function add_history -a cmd exit_code
    set -l id (atuin history start -- $cmd)
    atuin history end --exit $exit_code $id
    # fish stores commands without trailing spaces
    set -l escaped (string trim -r -- $cmd | string collect)
    set escaped (string replace -a '\\' '\\\\' -- $escaped | string collect)
    set escaped (string replace -a \n '\\n' -- $escaped)
    # fish ignores entries not older than its own start time
    printf '- cmd: %s\n  when: %d\n' $escaped (math (date +%s) - 60) >>$tmp/data/fish/fish_history
end

# Print commands one per line, with newlines shown as \n
function show_commands
    string replace -a \n '\\n' -- $argv | string collect
end

function atuin_commands
    show_commands (atuin history list --print0 --format '{command}' | string split0)
end

function fish_commands
    show_commands (fish --no-config -c 'set fish_history fish; history --null' | string split0)
end

# Not candidates
add_history ls 127
add_history ./foo 127
add_history 'FOO=1 bar' 127
add_history gs 127
add_history myfn 127
add_history 'docker ps' 0
add_history 'git status' 1
add_history 'git st' 1
add_history 'git -C x status' 128
# Not candidates because they succeeded once (e.g. a tool installed later and then removed)
add_history 'zzq --help' 127
add_history 'zzq --version' 0
add_history 'git frob x' 1
add_history 'git frob' 0
# Candidates
add_history 'gti status' 127
add_history doc 127
add_history 'git stauts' 1
add_history 'git s' 1
add_history 'gti log  ' 127
add_history 'gti a
  b' 127

set expected_candidates 'gti status' doc 'git stauts' 'git s' 'gti log' 'gti a\n  b'
# Deleted from both histories; `git s` is skipped in atuin because `git status` shares its prefix, exit code and time
set expected_atuin_after ls ./foo 'FOO=1 bar' gs myfn 'docker ps' 'git status' 'git st' 'git -C x status' \
    'zzq --help' 'zzq --version' 'git frob x' 'git frob' 'git s'
set expected_fish_after ls ./foo 'FOO=1 bar' gs myfn 'docker ps' 'git status' 'git st' 'git -C x status' \
    'zzq --help' 'zzq --version' 'git frob x' 'git frob'

if command -q docker
    add_history 'docker pss' 1
    set -a expected_candidates 'docker pss'
    if docker compose version &>/dev/null
        add_history 'docker compose upp' 1
        add_history 'docker compose ps' 1
        set -a expected_candidates 'docker compose upp'
        set -a expected_atuin_after 'docker compose ps'
        set -a expected_fish_after 'docker compose ps'
    end
end
if command -q mise
    add_history 'mise isntall' 1
    add_history 'mise ls' 1
    set -a expected_candidates 'mise isntall'
    set -a expected_atuin_after 'mise ls'
    set -a expected_fish_after 'mise ls'
end

set atuin_before (atuin_commands)
set fish_before (fish_commands)

echo_info 'Answer n: list candidates and delete nothing'
set output (echo n | fish $script)
set rc $status
check 'exits successfully' (test $rc -eq 0; and echo ok)
set listed (string match -r -g '^\S+ \S+ +-?\d+  (.*)$' -- $output | string collect)
if same_set "$listed" "$(string join \n -- $expected_candidates)"
    check 'lists exactly the expected candidates' ok
else
    check 'lists exactly the expected candidates' ng
    printf '  listed: %s\n' (string split \n -- $listed)
end
check 'keeps atuin history' (test "$(atuin_commands)" = "$atuin_before"; and echo ok)
check 'keeps fish history' (test "$(fish_commands)" = "$fish_before"; and echo ok)

echo_info 'Answer y: delete candidates'
set output (echo y | fish $script 2>&1)
set rc $status
check 'exits successfully' (test $rc -eq 0; and echo ok)
check 'warns about the skipped entry' (string match -e -i skip -- $output | string match -q -- '*git s'; and echo ok)
if same_set "$(atuin_commands)" "$(string join \n -- $expected_atuin_after)"
    check 'deletes candidates from atuin without prefix matches' ok
else
    check 'deletes candidates from atuin without prefix matches' ng
    printf '  atuin: %s\n' (atuin_commands | string split \n)
end
if same_set "$(fish_commands)" "$(string join \n -- $expected_fish_after)"
    check 'deletes candidates from fish' ok
else
    check 'deletes candidates from fish' ng
    printf '  fish: %s\n' (fish_commands | string split \n)
end

exit $failed
