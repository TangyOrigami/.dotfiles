# My .dotfiles

Welcome to my collection of dotfiles! These dotfiles contain configurations for various tools and programs that I use on a daily basis. This README provides an overview of how to use and manage these dotfiles effectively.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Updating](#updating)
- [Contributing](#contributing)
   - These .dotfiles are for me, if you like it great if you don't. Uh. Ligma.
- [License](#license)
   - I ain't got time for licenses bro.

## Prerequisites

Before using these dotfiles, ensure that you have the following prerequisites installed on your system:

- git
- stow

## Installation

To install these dotfiles on your system, follow these steps:

1. Clone this repository to your home directory:

   ```bash
   git clone https://github.com/TangyOrigami/.dotfiles.git ~/.dotfiles
   ```
2. There are some extra steps that are better detailed on the original repo's for their respective projects, they're linked as submodules but in case you missed them here are the links. Follow the steps detailed in their repos and place them where they are referenced in the file tree:
   - [neovim](https://github.com/neovim/neovim)
   - [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

3. I use ```stow``` to create symlinks to my configs. I'm still working on an install script to make this process even easier but for now this executable should stow everything in the ."dotfiles" directory for you:

   ```bash
   ./stow-util.sh
   ```

4. Make sure you call ```source``` on .conf and .*rc files :

   bash:
   ```bash
   source ~/.dotfiles/bash/.bashrc
   ```
   tmux:
   ```bash
   source ~/.dotfiles/tmux/.tmux.conf
   ```
   zsh[^1]:
   ```bash
   source ~/.dotfiles/zsh/.zshrc
   source ~/.dotfiles/zsh/.zshrc.pre-oh-my-zsh
   ```

## TOOD
1. Add Nerd Font

2. Add nvim-notify

3. profit?????


   [^1]: I don't use zsh anymore, I just haven't gotten around to deleting it since I'm still on the fence.
