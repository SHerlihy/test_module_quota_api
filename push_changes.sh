#!/bin/sh

set -eu

git pull --rebase --recurse-submodules origin main

git submodule foreach 'git push -u origin HEAD'
git push -u origin HEAD
