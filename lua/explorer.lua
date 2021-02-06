require'tools'

local api = vim.api
local luv = vim.loop
local open_mode = luv.constants.O_CREAT + luv.constants.O_WRONLY + luv.constants.O_TRUNC

local M = {}

M.explorer = {
  tab_root = false,
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
  icon = {
    root = "",
    default = "",
    symlink = "",
    git = {
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
  },
  tree = {},
  tree_list = {},
  color_list = {},
  fold = {},
  git_list = {},
  showHidden = false
}

M.git = {
  ["M "] = {
    { icon = M.explorer.icon.git.staged, hl = "ExplorerGitStaged" },
    {}
  },
  [" M"] = {
    {},
    { icon = M.explorer.icon.git.unstaged, hl = "ExplorerGitDirty" }
  },
  ["MM"] = {
    { icon = M.explorer.icon.git.staged, hl = "ExplorerGitStaged" },
    { icon = M.explorer.icon.git.unstaged, hl = "ExplorerGitDirty" }
  },
  ["A "] = {
    { icon = M.explorer.icon.git.staged, hl = "ExplorerGitStaged" },
    { icon = M.explorer.icon.git.untracked, hl = "ExplorerGitNew" }
  },
  [" A"] = {
    {},
    { icon = M.explorer.icon.git.untracked, hl = "ExplorerGitNew" }
  },
  ["AM"] = {
    { icon = M.explorer.icon.git.staged, hl = "ExplorerGitStaged" },
    { icon = M.explorer.icon.git.untracked, hl = "ExplorerGitNew" }
  },
  ["??"] = {
    { icon = M.explorer.icon.git.untracked, hl = "ExplorerGitDirty" }
  },
  ["R "] = {
    { icon = M.explorer.icon.git.renamed, hl = "ExplorerGitRenamed" },
    {}
  },
  ["RM"] = {
    { icon = M.explorer.icon.git.unstaged, hl = "ExplorerGitDirty" },
    { icon = M.explorer.icon.git.renamed, hl = "ExplorerGitRenamed" }
  },
  ["UU"] = {
    { icon = M.explorer.icon.git.unmerged, hl = "ExplorerGitMerge" }
  },
  [" D"] = {
    {},
    { icon = M.explorer.icon.git.deleted, hl = "ExplorerGitDeleted" }
  },
}

local function root_git_status()
  M.explorer.git_list = {}
  local cwd = luv.cwd()
  local status_list = vim.fn.systemlist('cd "'..cwd..'" && git status --porcelain=v1 -u')
  for _, v in pairs(status_list) do
    if string.find(v,'not a git repository') == nil then
      local status = v:sub(0, 2)
      local file_path = v:sub(4, -1)
      if file_path:match('%->') ~= nil then
        file_path = file_path:gsub('^.* %-> ', '')
      end
      local full_path = cwd..'/'..file_path
      M.explorer.git_list[full_path] = status
    end
  end
end

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

local function show_hidden(name)
  if M.explorer.show_hidden then
    return true
  else
    return not name:match('^[.].*$')
  end
end

local function reload_tab_root()
  local showtabline = vim.api.nvim_get_option('showtabline')
  local tab_root = (showtabline == 2) or (showtabline == 1 and #vim.fn.gettabinfo() > 1)
  M.explorer.tab_root = tab_root
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
    if show_hidden(name) then
      local path = cwd..'/'..name
      local item = {}
      item["t"] = t
      item["name"] = name
      item["path"] = path
      if t == 'directory' then
        table.insert(childTree, item)
        if M.explorer.fold[path] == true then
          search_dir(path,level+1)
        end
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

local function root_name()
  local cwd = luv.cwd()
  local arr = split(cwd, "/")
  local max_root_len = M.explorer.win_width+2
  local root = M.explorer.icon.root..' '..'[ROOT]'..' '..arr[table.getn(arr)]
  if #root > max_root_len then
    root = string.sub(root,1,max_root_len)
  else
    root = root..string.rep(' ',max_root_len-#root)
  end
  return root
end

local function handler_show_tree(cwd)
  M.explorer.color_list = {}
  local show_tree = {}
  local root_colors = {}
  local line = -1
  if not M.explorer.tab_root then
    line = 0
    table.insert(show_tree,root_name())
    local root_color = {}
    root_color["group"] = "ExplorerRoot"
    root_color["line"] = line
    root_color["col_start"] = 0
    root_color["col_end"] = -1
    table.insert(root_colors,root_color)
    table.insert(M.explorer.color_list,root_colors)
  end
  for k, v in pairs(M.explorer.tree_list) do
    line = line+1
    local show_icon = '  '
    local line_colors = {}
    local line_color = {}
    local icon_group
    line_color["group"] = "ExplorerFile"
    if v.fileType == 'directory' then
      local dir_icon = M.explorer.icon.folder_icons.default
      if M.explorer.fold[v.filePath] == true then
        dir_icon = M.explorer.icon.folder_icons.open
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
      local icon, hl_group = require'icons'.get_icon(v.fileName, extension)
      icon_group = hl_group
      if icon == nil then icon = M.explorer.icon.default end
      show_icon = icon..' '
    elseif v.fileType == 'link' then
      show_icon = M.explorer.icon.symlink..' '
    end
    local space = ''
    if v.level >= 1 then
      space = ' '..string.rep('  ', v.level-1)
    end
    local show_line = space..show_icon..v.fileName
    local max_line_len = M.explorer.win_width-1
    if string.len(show_line) > max_line_len then
      local name_end_index = max_line_len-7;
      show_line = string.sub(show_line,1,name_end_index)..'...'..string.sub(show_line,-4)
    else
      show_line = show_line..string.rep(' ',max_line_len-string.len(show_line))
    end
    local git_status = M.explorer.git_list[v.filePath]
    local show_git = ''
    if  git_status ~= nil then
      local git_item = M.git[git_status]
      for _, v in pairs(git_item) do
        local git_item_icon = ' '
        if v.icon ~= nil then git_item_icon = v.icon end
        show_git = show_git..git_item_icon
        if v.hl ~= nil then
          local git_hl_start = max_line_len+string.len(show_git)
          table.insert(line_colors,{group = v.hl, line = line, col_start = git_hl_start, col_end = git_hl_start+1})
        end
      end
    end
    show_line = show_line..' '..show_git
    table.insert(show_tree,show_line)
    local start = 0
    if icon_group then
      start = string.len(space..show_icon)
      local icon_color = {}
      icon_color["group"] = icon_group
      icon_color["line"] = line
      icon_color["col_start"] = string.len(space)
      icon_color["col_end"] = string.len(space..show_icon)
      table.insert(line_colors,icon_color)
    end
    line_color["line"] = line
    line_color["col_start"] = start
    line_color["col_end"] = max_line_len
    table.insert(line_colors,line_color)
    table.insert(M.explorer.color_list,line_colors)
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
  api.nvim_buf_set_lines(M.explorer.buf, 0, -1, false, show_tree)
  for _, v in pairs(M.explorer.color_list) do
    for _, v2 in pairs(v) do
      api.nvim_buf_add_highlight(M.explorer.buf, -1, v2.group, v2.line, v2.col_start, v2.col_end)
    end
  end
  api.nvim_buf_set_option(M.explorer.buf, 'modifiable', false)
  api.nvim_win_set_option(win, 'wrap', false)
  local row = math.min(cursor[1],table.getn(show_tree))
  api.nvim_win_set_cursor(win, {row, 0})
end

local function draw_tree()
  reload_tab_root()
  if M.explorer.buf == ni then return end
  M.explorer.tree = {}
  local cwd = luv.cwd()
  search_dir(cwd,0)
  root_git_status()
  reload_tree()
end

local function set_mappings()
  disable_buf_default_keymaps(M.explorer.buf)
  local mappings = {
    ['<cr>'] = 'open_file()',
    ['h'] = 'upper_stage()',
    ['l'] = 'lower_stage()',
    ['.'] = 'togger_hidden()',
    ['r'] = 'draw_tree()',
    ['<C-v>'] = 'open_file("vsplit")',
    ['<C-t>'] = 'open_file("tabe")',
    ['<C-r>'] = 'rename()',
    ['<C-a>'] = 'create()',
    ['<C-d>'] = 'delete()',
    ['q'] = 'close_explorer()',
  }
  for k,v in pairs(mappings) do
    api.nvim_buf_set_keymap(M.explorer.buf, 'n', k, ':lua require"explorer".'..v..'<cr>', {
      nowait = true, noremap = true, silent = true
    })
  end
end

local function get_cursor()
  local line = api.nvim_win_get_cursor(get_explorer_win())[1]
  if not M.explorer.tab_root then
    line = line-1
  end
  return line
end

local function open_file(open_type)
  local line = get_cursor()
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
  else
    if open_type ~= nil then
      api.nvim_command(open_type..item.filePath)
    else
      local nearest_win = get_nearest_win()
      if nearest_win ~= nil then
        api.nvim_command('wincmd l')
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
  local line = get_cursor()
  local item = M.explorer.tree_list[line]
  if item == nil then return end
  if item.fileType == 'directory' then
    local new_path = luv.cwd()..'/'..item.fileName
    api.nvim_command("cd "..new_path)
    draw_tree()
  end
end

local function togger_hidden()
  M.explorer.show_hidden = not M.explorer.show_hidden
  draw_tree()
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
  vim.api.nvim_command('autocmd BufWritePost * lua require"explorer".draw_tree()')
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
end

local function is_explorer_open()
  return M.explorer.buf ~= nil
end

local function togger_explorer()
  if get_explorer_win() ~= nil then
    close_explorer()
  else
    open_explorer()
  end
end

local function clear_buffer(file_path)
  for _, buf in pairs(api.nvim_list_bufs()) do
    if api.nvim_buf_get_name(buf) == file_path then
      api.nvim_command(':bd! '..buf)
    end
  end
end

local function create_res(res)
  if res == true then
    api.nvim_out_write('created success\n')
    draw_tree()
  else
    api.nvim_err_writeln('create failure')
  end
end

local function create()
  local line = get_cursor()
  local prefix = luv.cwd()..'/'
  if line > 0 then
    local item = M.explorer.tree_list[line]
    prefix = item.filePath..'/'
    if item.fileType ~= 'directory' then
      prefix = string.gsub(item.filePath,item.fileName,'')
    end
  end
  local new_file = vim.fn.input('Create file/directory '..prefix)
  vim.api.nvim_command('normal :esc<CR>')
  if not new_file or #new_file == 0 then return end
  local paths = new_file:gmatch('[^/]+/?')
  local new_path = prefix
  local res = true
  local is_file = false
  for path in paths do
    new_path = new_path..path
    while true do
      local stat = luv.fs_stat(new_path)
      if stat ~= nil then
        res = false
        break
      end
      if new_path:match('.*/$') then
        res = luv.fs_mkdir(new_path, 493)
      else
        is_file = true
        luv.fs_open(new_path, "w", open_mode, vim.schedule_wrap(function(err, fd)
          if err then
            create_res(false)
          else
            luv.fs_chmod(new_path, 420)
            luv.fs_close(fd)
            create_res(true)
          end
        end))
      end
      break
    end
  end
  if not is_file then
    create_res(res)
  end
end

local function delete_dir(cwd)
  local handle = luv.fs_scandir(cwd)
  if type(handle) == 'string' then
    return api.nvim_err_writeln(handle)
  end

  while true do
    local name, t = luv.fs_scandir_next(handle)
    if not name then break end
    local new_cwd = cwd..'/'..name
    if t == 'directory' then
      delete_dir(new_cwd)
      luv.fs_rmdir(new_cwd)
    else
      local success = luv.fs_unlink(new_cwd)
      if success then
        clear_buffer(new_cwd)
      end
    end
  end
  luv.fs_rmdir(cwd)
end

local function delete()
  local line = get_cursor()
  if line == 0 then return end
  local item = M.explorer.tree_list[line]
  local res = vim.fn.input("Remove " ..item.filePath.. " ? Y/n: ")
  vim.api.nvim_command('normal :esc<CR>')
  if res ~= 'Y' then return end
  if item.fileType == 'directory' then
    delete_dir(item.filePath)
  else
    luv.fs_unlink(item.filePath)
  end
  draw_tree()
end

local function rename()
  local line = get_cursor()
  if line == 0 then return end
  local item = M.explorer.tree_list[line]
  local new_name = vim.fn.input("Rename " ..item.filePath.. " to ",item.filePath)
  vim.api.nvim_command('normal :esc<CR>')
  if not new_name or #new_name == 0 then return end
  local success = luv.fs_rename(item.filePath, new_name)
  if not success then
    return api.nvim_err_writeln('Could not rename '..item.filePath..' to '..new_name)
  end
  draw_tree()
end

return {
  togger_explorer = togger_explorer,
  close_explorer = close_explorer,
  open_file = open_file,
  upper_stage = upper_stage,
  lower_stage = lower_stage,
  togger_hidden = togger_hidden,
  is_explorer_open = is_explorer_open,
  draw_tree = draw_tree,
  root_name = root_name,
  cursor_moved = cursor_moved,
  exit_vim = exit_vim,
  rename = rename,
  create = create,
  delete = delete
}
