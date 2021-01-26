require('tools')

local api = vim.api
local buf, win, callback

local function cursor_moved()
  local cursor = api.nvim_win_get_cursor(win)
  api.nvim_win_set_cursor(win, {cursor[1], 0})
end

function action_augroup()
  vim.api.nvim_command('augroup float')
  vim.api.nvim_command('autocmd!')
  vim.api.nvim_command('autocmd CursorMoved <buffer> lua require"action".cursor_moved()')
  vim.api.nvim_command('augroup END')
end

local function set_mappings()
  disable_buf_default_keymaps(buf)
  local mappings = {
    ['<cr>'] = 'select_action()',
    q = 'close_action()',
  }
  for k,v in pairs(mappings) do
    api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"action".'..v..'<cr>', {
      nowait = true, noremap = true, silent = true
    })
  end
end

local function show_action(title,fun)
  local edge = 3;
  callback = fun
  buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")
  local win_width = string.len(title)+2*edge
  local win_height = 5

  local opts = {
    style = "minimal",
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = (height-win_height)/2,
    col = (width-win_width)/2,
  }
  win = api.nvim_open_win(buf, true, opts)
  api.nvim_buf_set_option(buf, 'modifiable', true)

  local content = {}

  local optio = 'YES    NO'
  local shift = math.floor(win_width / 2) - math.floor(string.len(optio) / 2)

  table.insert(content,'')
  table.insert(content,string.rep(' ', edge)..title)
  table.insert(content,'')
  table.insert(content,string.rep(' ', shift)..optio)

  api.nvim_buf_set_lines(buf, 0, -1, false, content)
  api.nvim_buf_set_option(buf, 'modifiable', false)
  api.nvim_win_set_option(win, 'wrap', false)
  options = {}
  for _, opt in pairs(options) do
    api.nvim_command('setlocal '..opt)
  end
  set_mappings()
  action_augroup()
end

local function close_action()
  api.nvim_win_close(win, true)
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
