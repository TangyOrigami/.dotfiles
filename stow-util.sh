#!/bin/bash

blacklist=(
    ".git"
    ".gitsubmodules"
    ".gitignore"
    "bash"
    "tmux"
    "wsl-term"
)

cd ~/.dotfiles || exit
packages=$(ls -d */)

for package in $packages; do
    package_name="${package%/}"

    # Check if package is blacklisted
    skip=false
    for ignored in "${blacklist[@]}"; do
        if [[ "$package_name" == "$ignored" ]]; then
            skip=true
            break
        fi
    done

    if $skip; then
        echo "Skipped:  $package_name"
        continue
    fi

    stow "$package_name"
    echo "Stowed:   $package_name"
done
