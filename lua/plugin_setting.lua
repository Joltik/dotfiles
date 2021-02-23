require'colorizer'.setup({'*'},{
  RGB      = true;
  RRGGBB   = true;
  names    = true;
  RRGGBBAA = true;
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
    disable = { "c", "rust" },
  },
  indent = {
    enable = true
  }
}

require'lsp'
