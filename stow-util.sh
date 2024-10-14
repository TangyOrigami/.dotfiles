#!/bin/bash

cd ~/.dotfiles || exit

sourceable=("bash" "tmux")

packages=$(ls -d */)

for package in $packages; do
    package_name="${package%/}"
    stow "$package_name"
    echo "Stowed: $package_name"
done
