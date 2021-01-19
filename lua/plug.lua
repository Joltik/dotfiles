require('lsp')
require('statusline')
require('git')

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  }
}

require'colorizer'.setup(
  {'*';},
  {
    RGB      = true;
    RRGGBB   = true;
    names    = true;
    RRGGBBAA = true;
  }
)

require('nvim-autopairs').setup({
  disable_filetype = { "vim" },
})

local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')

vim.g.completion_confirm_key = ""

completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      require'completion'.confirmCompletion()
      return npairs.esc("<c-y>")
    else
      vim.fn.nvim_select_popupmenu_item(0 , false , false ,{})
      require'completion'.confirmCompletion()
      return npairs.esc("<c-n><c-y>")
    end
  else
    return npairs.check_break_line_char()
  end
end

remap('i' , '<CR>','v:lua.completion_confirm()', {expr = true , noremap = true})


