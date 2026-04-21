#!/bin/bash

blacklist=(
	".git"
	".gitsubmodules"
	".gitignore"
	"tmux"
	"wsl-term"
	"tmp"
	"kickstart.nvim"
)

cd ~/.dotfiles || exit
packages=$(ls -d */)

for package in $packages; do
	package_name="${package%/}"

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

    if [[ "$package" == "bash/" ]]; then
	    stow "$package_name"
	    for file in "$package_name"/.*; do
		    file=$(basename "$file")
		    [[ "$file" == "." || "$file" == ".." ]] && continue
		    [[ -f ~/"$file" ]] && source ~/"$file"
	    done
	    echo "Stowed & Sourced: $package_name"
	    continue
    fi

    stow "$package_name"
    echo "Stowed:   $package_name"
done
