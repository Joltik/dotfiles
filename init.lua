local api = vim.api

api.nvim_command('set nu')
api.nvim_command('set rtp+=/Users/xiaogao/.config/nvim/plugin/*.vim')

vim.api.nvim_set_keymap('n', '<Space>e', ':Explorer<CR>', { noremap = true, silent = true })
