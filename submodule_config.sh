#!/bin/sh

git submodule foreach 'git config -f $(git rev-parse --show-toplevel)/.gitmodules submodule.$name.branch main'
