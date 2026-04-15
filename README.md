# Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)

## Prerequisites

Before using these dotfiles, ensure that you have the following prerequisites installed on your system:

- git
- stow

## Installation

To install these dotfiles on your system, follow these steps:

1. Clone this repository to your home directory:

   ```bash
   cd ~ && git clone https://github.com/TangyOrigami/.dotfiles.git
   ```
2. There are some extra steps that are better detailed on the original repo's for their respective projects, they're linked as submodules but in case you missed them here are the links. Follow the steps detailed in their repos and place them where they are referenced in the file tree:
   - [neovim](https://github.com/neovim/neovim)

3. I use ```stow``` to create symlinks to my configs. I'm still working on an install script to make this process even easier but for now this executable should stow everything in the ."dotfiles" directory for you:

   ```bash
   ./stow-util.sh
   ```
