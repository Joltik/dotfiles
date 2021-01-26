require('tools')

local api = vim.api
local luv = vim.loop

local M = {}

M.icon = {
  root = "",
  default = "",
  symlink = "",
  git_icons = {
    unstaged = "✗",
    staged = "✓",
    unmerged = "═",
    renamed = "➜",
    untracked = "★",
    deleted = "✖"
  },
  folder_icons = {
    default = "",
    open = "",
    symlink = "",
  }
}

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
    'signcolumn=no',
    'cursorline'
  },
  tree = {},
  tree_list = {},
  color_list = {},
  fold = {}
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

local function get_nearest_win()
  for _, i in ipairs(api.nvim_list_wins()) do
    if api.nvim_buf_get_name(api.nvim_win_get_buf(i)):match('.*/'..M.explorer.buf_name..'$') then
    else
      return i
    end
  end
end

local function sort_tree(item1,item2)
  if item1.t == item2.t then
    return string.lower(item1.name)<string.lower(item2.name)
  else
    return item1.t<item2.t
  end
end

local function search_dir(cwd,level)
  local handle = luv.fs_scandir(cwd)
  if type(handle) == 'string' then
    api.nvim_err_writeln(handle)
    return
  end
  local childTree = {}
  while true do
    local name, t = luv.fs_scandir_next(handle)
    if not name then break end
    if not name:match('^.git$') then
      local path = cwd..'/'..name
      local item = {}
      item["t"] = t
      item["name"] = name
      item["path"] = path
      if t == 'directory' then
        table.insert(childTree, item)
      elseif t == 'file' then
        table.insert(childTree, item)
      elseif t == 'link' then
        table.insert(childTree, item)
      end
      table.sort(childTree,sort_tree)
      M.explorer.tree[cwd] = childTree
    end
  end
end

local function handle_tree_list(root,cwd)
  if M.explorer.tree[cwd] == nil then return end
  for _,v in pairs(M.explorer.tree[cwd]) do
    local level = table.getn(split(string.gsub(v.path,root..'/','',1), "/"))
    local item = {}
    item["level"] = level
    item["fileName"] = v.name
    item["filePath"] = v.path
    item["fileType"] = v.t
    table.insert(M.explorer.tree_list,item)
    if v.t == 'directory' then
      local new_cwd = cwd..'/'..v.name
      if M.explorer.fold[new_cwd] == true then
        handle_tree_list(root,new_cwd)
      end
    end
  end
end

local function handler_root_name(cwd)
  local arr = split(cwd, "/")
  return M.icon.root..' '..'[ROOT]'..' '..arr[table.getn(arr)]
end

local function handler_show_tree(cwd)
  local show_tree = {}
  local line = 0
  M.explorer.color_list = {}
  table.insert(show_tree,handler_root_name(cwd))
  local root_color = {}
  root_color["group"] = "ExplorerRoot"
  root_color["line"] = line
  root_color["col_start"] = 0
  root_color["col_end"] = -1
  table.insert(M.explorer.color_list,root_color)
  for k, v in pairs(M.explorer.tree_list) do
    line = line+1
    local show_icon = '  '
    local line_color = {}
    line_color["group"] = "ExplorerFile"
    if v.fileType == 'directory' then
      local dir_icon = M.icon.folder_icons.default
      if M.explorer.fold[v.filePath] == true then
        dir_icon = M.icon.folder_icons.open
      end
      show_icon = dir_icon..' '
      line_color["group"] = "ExplorerFolder"
    elseif v.fileType == 'file' then
      local extension = ''
      local first_char = string.sub(v.fileName,1,1)
      if(first_char ~= '.') then
        local arr = split(v.fileName,'.')
	local len = table.getn(arr)
	if len > 1 then
	  extension = arr[len]
	end
      end
      local web_devicons = require'nvim-web-devicons'
      local icon, hl_group = web_devicons.get_icon(v.fileName, extension)
      if icon == nil then icon = M.icon.default end
      show_icon = icon..' '
    elseif v.fileType == 'link' then
      show_icon = M.icon.symlink..' '
    end
    table.insert(show_tree,string.rep(' ', v.level)..show_icon..v.fileName)
    line_color["line"] = line
    line_color["col_start"] = 0
    line_color["col_end"] = -1
    table.insert(M.explorer.color_list,line_color)
  end
  return show_tree
end

local function reload_tree()
  local win = get_explorer_win()
  local cursor = api.nvim_win_get_cursor(win)
  local cwd = luv.cwd()
  M.explorer.tree_list = {}
  handle_tree_list(cwd,cwd)
  local show_tree = handler_show_tree(cwd)
  api.nvim_buf_set_option(M.explorer.buf, 'modifiable', true)
  api.nvim_buf_set_lines(buf, 0, -1, false, show_tree)
  for _, v in pairs(M.explorer.color_list) do
    api.nvim_buf_add_highlight(M.explorer.buf, -1, v.group, v.line, v.col_start, v.col_end)
  end
  api.nvim_buf_set_option(M.explorer.buf, 'modifiable', false)
  api.nvim_win_set_option(win, 'wrap', false)
  local row = math.min(cursor[1],table.getn(show_tree))
  api.nvim_win_set_cursor(win, {row, 0})
end

local function draw_tree()
  local cwd = luv.cwd()
  search_dir(cwd,0)
  reload_tree()
end

local function set_mappings()
  local mappings = {
    ['<cr>'] = 'open_file()',
    ['m'] = 'show_menu()',
    ['h'] = 'upper_stage()',
    ['l'] = 'lower_stage()',
    ['<C-v>'] = 'open_file("vsplit")',
    q = 'close_explorer()',
  }
  for k,v in pairs(mappings) do
    api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"explorer".'..v..'<cr>', {
        nowait = true, noremap = true, silent = true
      })
  end
end

local function select_action(index)
  dump(index)
end

local function select_menu(index)
  local menu = {" add"," delete"," rename"}
  if index == 2 then
    require"action".show_action('Are you sure delete ?')
  end
end

local function show_menu()
  local win = get_explorer_win()
  local width = api.nvim_win_get_width(win)
  local position = {}
  position["x"] = (width-15)/2
  position["width"] = 15
  local menu = {" add"," delete"," rename"}
  require('float').show_action(position,menu,select_menu)
end

local function open_file(open_type)
  local line = api.nvim_win_get_cursor(get_explorer_win())[1]-1
  local item = M.explorer.tree_list[line]
  if item == nil then return end
  if item.fileType == 'directory' then
    if open_type ~= nil then return end
    local isFold = M.explorer.fold[item.filePath] ~= nil
    if isFold then
      M.explorer.fold[item.filePath] = nil
    else
      M.explorer.fold[item.filePath] = true
    end
    search_dir(item.filePath,item.level)
    reload_tree()
  elseif item.fileType == 'file' then
    if open_type ~= nil then
      api.nvim_command(open_type..item.filePath)
    else
      local nearest_win = get_nearest_win()
      if nearest_win ~= nil then
        api.nvim_command('noautocmd wincmd l')
        api.nvim_command('edit'..item.filePath)
      else
        api.nvim_command('vsplit'..item.filePath)
      end
    end
  end
end

local function upper_stage()
  local cwd = luv.cwd()
  local paths = split(cwd,'/')
  if table.getn(paths) > 1 then
    table.remove(paths)
  end
  local new_path = table.concat(paths,'/')
  if new_path == '' then new_path = '/' end
  api.nvim_command("cd "..new_path)
  draw_tree()
end

local function lower_stage()
  local line = api.nvim_win_get_cursor(get_explorer_win())[1]-1
  local item = M.explorer.tree_list[line]
  if item == nil then return end
  if item.fileType == 'directory' then
    local new_path = luv.cwd()..'/'..item.fileName
    api.nvim_command("cd "..new_path)
    draw_tree()
  end
end

local function cursor_moved()
  local win = get_explorer_win()
  local cursor = api.nvim_win_get_cursor(win)
  api.nvim_win_set_cursor(win, {cursor[1], 0})
end

local function exit_vim()
  if get_explorer_win() ~= nil then
    if #api.nvim_list_wins() == 1 then
      return vim.cmd ':q!'
    end
  end
end

function explorer_augroup()
  vim.api.nvim_command('augroup explorer')
  vim.api.nvim_command('autocmd!')
  vim.api.nvim_command('autocmd CursorMoved <buffer> lua require"explorer".cursor_moved()')
  vim.api.nvim_command('autocmd BufEnter * lua require"explorer".exit_vim()')
  vim.api.nvim_command('augroup END')
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
  set_mappings()
  explorer_augroup()
end

local function close_explorer()
  if #api.nvim_list_wins() == 1 then
    return vim.cmd ':q!'
  end
  api.nvim_win_close(get_explorer_win(), true)
  M.explorer.buf = nil
  require"float".close_action()
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
  close_explorer = close_explorer,
  open_file = open_file,
  upper_stage = upper_stage,
  lower_stage = lower_stage,
  cursor_moved = cursor_moved,
  exit_vim = exit_vim,
  show_menu = show_menu
}
