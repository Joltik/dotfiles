require('gitsigns').setup {
  signs = {
    add          = {hl = 'DiffAdd'   , text = '▌', numhl='GitSignsAddNr'},
    change       = {hl = 'DiffChange', text = '▌', numhl='GitSignsChangeNr'},
    delete       = {hl = 'DiffDelete', text = '▌', numhl='GitSignsDeleteNr'},
    topdelete    = {hl = 'DiffDelete', text = '▌', numhl='GitSignsDeleteNr'},
    changedelete = {hl = 'DiffChange', text = '▌', numhl='GitSignsChangeNr'},
  },
  numhl = false,
  keymaps = {},
  watch_index = {
    interval = 1000
  },
  sign_priority = 6,
  status_formatter = nil, -- Use default
}
