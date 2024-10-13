#!/bin/bash

vault=~/vaults
selected=$(find ~/vaults -path ~/vaults/.git -prune -o -path ~/vaults/Notes/.obsidian -prune -o -print | fzf)

if [[ -z $selected ]]; then
  exit 0
fi

nvim "${selected}"
