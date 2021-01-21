require('tools')

local api = vim.api
local luv = vim.loop

local M = {}

M.explorer = {
  buf_name = 'explorer',
  win_width = 30,
  buf = nil,
  options = {
    'noswapfile',
    'winfixwidth',
    'winfixheight',
    'nonumber',
    'nofoldenable',
    'signcolumn=no'
  }
}

local function create_buf()
  local options = {
    bufhidden = 'wipe',
    buftype = 'nofile',
    modifiable = false,
  }
  M.explorer.buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_name(M.explorer.buf, M.explorer.buf_name)

  for k, v in pairs(options) do
    api.nvim_buf_set_option(M.explorer.buf, k, v)
  end
end

local function create_win()
  api.nvim_command("vsplit")
  api.nvim_command("wincmd H")
  api.nvim_command("vertical resize "..M.explorer.win_width)
end

local function get_explorer_win()
  for _, i in ipairs(api.nvim_list_wins()) do
    if api.nvim_buf_get_name(api.nvim_win_get_buf(i)):match('.*/'..M.explorer.buf_name..'$') then
      return i
    end
  end
end

local function search_dir(cwd,lines,level)
  local handle = luv.fs_scandir(cwd)
  if type(handle) == 'string' then
    api.nvim_err_writeln(handle)
    return
  end
  while true do
    local name, t = luv.fs_scandir_next(handle)
    if not name then break end
    if not name:match('^.git$') then
      local show_name = name;
      if level ~= 0 then
        show_name = string.rep(' ', level)..name
      end
      if t == 'directory' then
        table.insert(lines, show_name)
        local new_cwd = cwd..'/'..name
        search_dir(new_cwd,lines,level+1)
      elseif t == 'file' then
        table.insert(lines, show_name)
      elseif t == 'link' then
        table.insert(lines, show_name)
      end
    end
  end
end

local function draw_tree()
  api.nvim_buf_set_option(M.explorer.buf, 'modifiable', true)
  local lines = {}
  local level = 0
  search_dir(luv.cwd(),lines,level)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  api.nvim_buf_set_option(M.explorer.buf, 'modifiable', false)
  api.nvim_win_set_option(get_explorer_win(), 'wrap', false)
end

local function open_explorer()
  create_buf()
  create_win()
  api.nvim_win_set_buf(get_explorer_win(), M.explorer.buf)
  for _, opt in pairs(M.explorer.options) do
    api.nvim_command('setlocal '..opt)
  end
  api.nvim_buf_set_option(M.explorer.buf, 'filetype', M.explorer.buf_name)
  api.nvim_command('setlocal splitright')
  draw_tree()
end

local function close_explorer()
  if #api.nvim_list_wins() == 1 then
    return vim.cmd ':q!'
  end
  api.nvim_win_close(get_explorer_win(), true)
  M.explorer.buf = nil
end

local function togger_explorer()
  if get_explorer_win() ~= nil then
    close_explorer()
  else
    open_explorer()
  end
end

return {
  togger_explorer = togger_explorer,
}
