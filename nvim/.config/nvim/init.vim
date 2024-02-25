lua <<EOF
require('basic')
vim.o.background = 'dark'
vim.cmd('colorscheme zellner')
vim.g.mapleader = ' '

-- Remaps

print('All Settings Working')
EOF
