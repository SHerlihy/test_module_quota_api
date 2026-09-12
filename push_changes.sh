#!/bin/sh

set -eu

git submodule foreach 'git pull --rebase origin main'
git pull --rebase origin main

git submodule foreach 'git push -u origin HEAD'
git push -u origin HEAD
