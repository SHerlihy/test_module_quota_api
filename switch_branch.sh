#!/bin/sh

[ -z $1 ] && { echo "ERROR: Argument for branch name must be provided." >&2; exit 1; }

git switch $1
git submodule foreach 'git switch '"$1"' || echo Branch '"$1"' not found in submodule '"$name"', skipping.'
