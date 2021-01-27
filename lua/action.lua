require('tools')

local api = vim.api
local buf, win, callback
local win_width
local win_height = 5
local shift 
local optio = 'YES    NO'
local namespace_id = api.nvim_create_namespace('AlertHighlights')

local function cursor_moved()
  local cursor = api.nvim_win_get_cursor(win)
  local row = shift+1
  local col_start = row-1
  local col_end = row+2
  if cursor[2] > win_width/2 then 
    row = shift+string.len(optio)-2 
    col_start = row
    col_end = row+2
  end
  api.nvim_win_set_cursor(win, {win_height-1, row})
  api.nvim_buf_clear_namespace(buf, namespace_id, 0, -1)
  api.nvim_buf_add_highlight(buf, namespace_id, 'AlertOptionSelect', win_height-2, col_start, col_end)
end

local function cursor_move()
  local cursor = api.nvim_win_get_cursor(win)
  local row = shift+1
  if cursor[2] < win_width/2 then row = shift+string.len(optio)-2 end
  api.nvim_win_set_cursor(win, {win_height-1, row})
end

function action_augroup()
  vim.api.nvim_command('augroup float')
  vim.api.nvim_command('autocmd!')
  vim.api.nvim_command('autocmd CursorMoved <buffer> lua require"action".cursor_moved()')
  vim.api.nvim_command('autocmd WinLeave <buffer> lua require"action".close_action()')
  vim.api.nvim_command('augroup END')
end

local function set_mappings()
  disable_buf_default_keymaps(buf)
  local mappings = {
    ['<cr>'] = 'select_action()',
    q = 'close_action()',
    j = 'cursor_move()',
    k = 'cursor_move()',
    ['<Left>'] = 'cursor_move()',
    ['<Right>'] = 'cursor_move()',
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
  win_width = string.len(title)+2*edge

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

  shift = math.floor(win_width / 2) - math.floor(string.len(optio) / 2)

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
  cursor_move()
end

local function close_action()
  if win == nill then return end
  api.nvim_win_close(win, true)
  buf = nil
  win = nil
end

local function select_action()
  local col = api.nvim_win_get_cursor(win)[2]
  local res = 0
  if col < win_width/2 then res = 1 end
  callback(res)
  close_action()
end

return {
  show_action = show_action,
  close_action = close_action,
  select_action = select_action,
  cursor_move = cursor_move,
  cursor_moved = cursor_moved
}
