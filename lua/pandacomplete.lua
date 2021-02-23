require'tools'

function feed_popup()
  local completefunc = vim.api.nvim_buf_get_option(0,'completefunc')
  if #completefunc == 0 then
    vim.api.nvim_exec(
      [[
      if !pumvisible()
      call feedkeys("\<C-n>", "n")
      endif
      ]], false
    )
  else
    vim.api.nvim_exec(
      [[
      if !pumvisible()
      call feedkeys("\<C-x>\<C-u>", "n")
      endif
      ]], false
    )
  end
end

function complete_done()
end

function pandacomplete_enable()
  vim.api.nvim_exec(
    [[
    augroup pandacomplete
    autocmd!
    autocmd InsertCharPre <buffer> nested lua require("pandacomplete").feed_popup()
    autocmd CompleteDone <buffer> lua require("pandacomplete").complete_done()
    augroup END
    ]],false
  )
end

function pandacomplete_disable()
  vim.api.nvim_exec(
    [[
    augroup pandacomplete
    autocmd!
    augroup END
    ]], false
  )
end

function pandacomplete_augroup()
  vim.api.nvim_exec(
    [[
    augroup pandacomplete_init
    autocmd!
    autocmd FileType * lua require("pandacomplete").pandacomplete_enable()
    augroup END
    ]], false
  )
end

function pandacomplete_func(findstart, base)
  local value = vim.lsp.omnifunc(findstart, base)
  dump(value)
end

return {
  pandacomplete_augroup = pandacomplete_augroup,
  pandacomplete_enable = pandacomplete_enable,
  pandacomplete_disable = pandacomplete_disable,
  feed_popup = feed_popup,
  complete_done = complete_done,
  pandacomplete_func = pandacomplete_func
}
