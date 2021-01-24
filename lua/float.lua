require('tools')

local api = vim.api
local buf, win

local function set_mappings()
  local mappings = {
    ['<cr>'] = '',
    q = 'close_action()',
  }
  for k,v in pairs(mappings) do
    api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"float".'..v..'<cr>', {
        nowait = true, noremap = true, silent = true
      })
  end
end

local function show_action(position,menu)
  buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  local maxHeight = api.nvim_get_option("lines")
  local win_width = position.width
  local win_height = table.getn(menu)
  local row = math.min(position.y,maxHeight-win_height-1)
  dump(row)
  local col = position.x
  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col
  }
  win = api.nvim_open_win(buf, true, opts)
  api.nvim_buf_set_option(buf, 'modifiable', true)
  api.nvim_buf_set_lines(buf, 0, -1, false, menu)
  api.nvim_buf_set_option(buf, 'modifiable', false)
  api.nvim_win_set_option(win, 'wrap', false)
  options = {
    'cursorline'
  }
  for _, opt in pairs(options) do
    api.nvim_command('setlocal '..opt)
  end
  set_mappings()
end

local function close_action()
  api.nvim_win_close(win, true)
end

return {
  show_action = show_action,
  close_action = close_action
}
