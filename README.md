# My .dotfiles

Welcome to my collection of dotfiles! These dotfiles contain configurations for various tools and programs that I use on a daily basis. This README provides an overview of how to use and manage these dotfiles effectively.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Updating](#updating)
- [Contributing](#contributing)
   - This is for me, if you like it great if you don't. Uh. Ligma.
- [License](#license)
   - I ain't got time for licenses bro.

## Prerequisites

Before using these dotfiles, ensure that you have the following prerequisites installed on your system:

- Git
- Stow (optional, for managing dotfiles)
- Neovim (optional, for using the Neovim configuration)

## Installation

To install these dotfiles on your system, follow these steps:

1. Clone this repository to your home directory:

   ```bash
   git clone https://github.com/your-username/.dotfiles.git ~/.dotfiles
   ```
2. There are some extra steps that are better detailed on the original repo's for their respective projects, they might not all be linked as submodules. Follow the steps detailed in their repos and place them where they are referenced in the file tree:
   a. [neovim](https://github.com/neovim/neovim)
   b. [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) 

3. I use ```bash stow``` to create symlinks to my configs. I'm still working on an install script to make this process even easier but for now this executable should stow everything in the ."dotfiles" directory for you:

   ```bash
   ./stow-util.sh
   ```

4. Make sure you call ```bash source``` on .conf and .*rc files[^1]:

   ```bash
   source ~/.dotfiles/bash/.bashrc
   ```
   ```bash
   source ~/.dotfiles/tmux/.tmux.conf
   ```
   ```bash
   source ~/.dotfiles/zsh/.zshrc
   source ~/.dotfiles/zsh/.zshrc.pre-oh-my-zsh
   ```

   [^1]NOTE: I don't use zsh anymore, I'm sticking to bash.
