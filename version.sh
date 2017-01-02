#!/bin/bash

cat <<EOT
Installed Software
==================

## Docker ##
$(docker -v)

## Docker Compose ##
$(docker-compose version)

## dockviz ##
$(dockviz -v)

## hadolint ##
$(hadolint -v)

## git ##
$(git --version)

## Q ##
$(q -v 2>&1)

## peco ##
$(peco --version)

## tmux ##
$(tmux -V)

## Go Programming Language ##
$(go version)

## ShellCheck ##
$(shellcheck -V)

## micro ##
$(micro -version)
EOT
