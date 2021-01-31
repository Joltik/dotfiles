require('tools')

local api = vim.api
local buf, win, callback

local function cursor_moved()
  local cursor = api.nvim_win_get_cursor(win)
  api.nvim_win_set_cursor(win, {cursor[1], 0})
end

function float_augroup()
  vim.api.nvim_command('augroup float')
  vim.api.nvim_command('autocmd!')
  vim.api.nvim_command('autocmd CursorMoved <buffer> lua require"float".cursor_moved()')
  vim.api.nvim_command('autocmd WinLeave <buffer> lua require"float".close_action()')
  vim.api.nvim_command('augroup END')
end

local function set_mappings()
  disable_buf_default_keymaps(buf)
  local mappings = {
    ['<cr>'] = 'select_action()',
    q = 'close_action()',
  }
  for k,v in pairs(mappings) do
    api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"float".'..v..'<cr>', {
      nowait = true, noremap = true, silent = true
    })
  end
end

local function show_action(position,menu,fun)
  callback = fun
  buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  local win_width = position.width
  local win_height = table.getn(menu)
  local col = position.x
  local opts = {
    style = "minimal",
    relative = 'cursor',
    width = win_width,
    height = win_height,
    row = 1,
    col = col
  }
  win = api.nvim_open_win(buf, true, opts)
  api.nvim_buf_set_option(buf, 'modifiable', true)
  api.nvim_buf_set_lines(buf, 0, -1, false, menu)
  api.nvim_buf_set_option(buf, 'modifiable', false)
  api.nvim_win_set_option(win, 'wrap', false)
  api.nvim_win_set_option(win, 'winhl', 'Normal:FloatWinBg')
  options = {
    'cursorline'
  }
  for _, opt in pairs(options) do
    api.nvim_command('setlocal '..opt)
  end
  set_mappings()
  float_augroup()
end

local function close_action()
  if win == nill then return end
  api.nvim_win_close(win, true)
  buf = nil
  win = nil
end

local function select_action()
  local line = api.nvim_win_get_cursor(win)[1]
  callback(line)
  close_action()
end

return {
  show_action = show_action,
  close_action = close_action,
  select_action = select_action,
  cursor_moved = cursor_moved
}
