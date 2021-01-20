local api = vim.api

local buf, win

local function open_explorer()
  buf = api.nvim_create_buf(false, true)

  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(buf, 'filetype', 'explorer')

  local width = 40
  local height = api.nvim_get_option("lines")

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = 0,
    col = 0
  }

  win = api.nvim_open_win(buf, true, opts)
  api.nvim_win_set_option(win, 'cursorline', true)
end

local function close_explorer()
  api.nvim_win_close(win, true)
end

local function togger_explorer()
  open_explorer()
end

return {
  togger_explorer = togger_explorer,
}
