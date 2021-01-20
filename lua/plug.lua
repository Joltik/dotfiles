require('lsp')
require('statusline')

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
