#!/bin/sh

[ -z $1 ] && { echo "ERROR: Argument for branch name must be provided." >&2; exit 1; }

git switch -c $1
git submodule foreach 'git switch -c '"$1"
