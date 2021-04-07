vim.g.mapleader = ' '

vim.api.nvim_set_keymap('n', '<leader>e', ':Pandatree<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>w', ':Pandawin<CR>', { silent = true })