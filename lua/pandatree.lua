require'tools'

M = {
  pandatree = {
    is_opening = false,
    buf_name = 'pandatree',
    buf_options = {
      bufhidden = 'wipe',
      buftype = 'nofile',
      modifiable = false,
    },
    win_width = 30,
    win_options = {
      wrap = false,
    },
    local_commands = {
      'noswapfile',
      'winfixwidth',
      'winfixheight',
      'nonumber',
      'nofoldenable',
      'signcolumn=no',
      'cursorline',
      'splitright'
    },
    cursor_line = 1,
    show_hidden = false,
    tree = {},
    tree_list = {},
    fold = {},
    icon = {
      root = "",
      file_icons = {
        default = "",
        symlink = "",
      },
      folder_icons = {
        default = "",
        open = "",
        symlink = "",
      }
    }
  }
}

local function is_show_tabline()
  local showtabline = vim.api.nvim_get_option('showtabline')
  return (showtabline == 2) or (showtabline == 1 and #vim.fn.gettabinfo() > 1)
end

local function is_pandatree_buffer(buf)
  return vim.api.nvim_buf_get_name(buf):match('.*/'..M.pandatree.buf_name..'$')
end

local function exist_tabline()
  local showtabline = vim.api.nvim_get_option('showtabline')
  local is_exist_tab = (showtabline == 2) or (showtabline == 1 and #vim.fn.gettabinfo() > 1)
  return is_exist_tab
end

local function get_pandatree_all_windows()
  local pandatree_wins = {}
  local tabs = vim.fn.gettabinfo()
  for _, tab in ipairs(tabs) do
    local windows = tab.windows
    for _, window in ipairs(windows) do
      local buf = vim.api.nvim_win_get_buf(window)
      if is_pandatree_buffer(buf) then
        table.insert(pandatree_wins,window)
      end
    end
  end
  return pandatree_wins
end

local function get_pandatree_buffer()
  local all_wins = get_pandatree_all_windows()
  if #all_wins >0 then
    return vim.api.nvim_win_get_buf(all_wins[1])
  else
    return nil
  end
end

local function get_pandatree_tab_windows()
  local pandatree_wins = {}
  local current_tab = vim.fn.tabpagenr()
  local tabs = vim.fn.gettabinfo()
  for _, tab in ipairs(tabs) do
    local is_active_tab = current_tab == tab.tabnr
    if is_active_tab then
      local windows = tab.windows
      for _, window in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(window)
        if is_pandatree_buffer(buf) then
          table.insert(pandatree_wins,window)
        end
      end
    end
  end
  return pandatree_wins
end

local function get_tab_windows()
  local tab_wins = {}
  local current_tab = vim.fn.tabpagenr()
  local tabs = vim.fn.gettabinfo()
  for _, tab in ipairs(tabs) do
    local is_active_tab = current_tab == tab.tabnr
    if is_active_tab then
      tab_wins = tab.windows
    end
  end
  return tab_wins
end

local function get_nearest_win()
  local tab_wins = get_tab_windows()
  for _, v in ipairs(tab_wins) do
    local win_buf = vim.api.nvim_win_get_buf(v)
    if not is_pandatree_buffer(win_buf)  then
      return v
    end
  end
end

local function is_exist_pandatree()
  local all_wins = get_pandatree_all_windows()
  return #all_wins > 0
end

local function is_exist_tab_pandatree()
  local tab_wins = get_pandatree_tab_windows()
  return #tab_wins > 0
end

local function create_tree_buf()
  local buf = get_pandatree_buffer()
  if buf == nil then
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, M.pandatree.buf_name)
    for k, v in pairs(M.pandatree.buf_options) do
      vim.api.nvim_buf_set_option(buf, k, v)
    end
  end
  return buf
end

local function create_tree_win()
  vim.api.nvim_command("vsplit")
  vim.api.nvim_command("wincmd H")
  vim.api.nvim_command("vertical resize "..M.pandatree.win_width)
end

local function is_item_show(name)
  if M.pandatree.show_hidden then
    return true
  else
    return not name:match('^[.].*$')
  end
end

local function sort_tree_list(item1,item2)
  if item1.t == item2.t then
    return string.lower(item1.name)<string.lower(item2.name)
  else
    return item1.t<item2.t
  end
end


local function get_cursor()
  local line = M.pandatree.cursor_line
  if not is_show_tabline() then
    line = line-1
  end
  return line
end

local function search_tree_list(cwd,level)
  local handle = vim.loop.fs_scandir(cwd)
  if type(handle) == 'string' then
    vim.api.nvim_err_writeln(handle)
  end
  local child_tree = {}
  while true do
    local name, t = vim.loop.fs_scandir_next(handle)
    if not name then break end
    if is_item_show(name) then
      local path = cwd..'/'..name
      local item = {
        t = t,
        name = name,
        path = path,
        level = level
      }
      table.insert(child_tree, item)
      if t == 'directory' then
        if M.pandatree.fold[path] == true then
          search_tree_list(path,level+1)
        end
      end
      table.sort(child_tree, sort_tree_list)
      M.pandatree.tree[cwd] = child_tree
    end
  end
end

local function reload_tree_list(cwd,is_first)
  if is_first then M.pandatree.tree_list = {} end
  if M.pandatree.tree[cwd] == nil then return end
  for _,v in pairs(M.pandatree.tree[cwd]) do
    table.insert(M.pandatree.tree_list,v)
    if v.t == 'directory' then
      local new_cwd = cwd..'/'..v.name
      if M.pandatree.fold[new_cwd] == true then
        reload_tree_list(new_cwd,false)
      end
    end
  end
end

local function tree_root_name()
  local cwd = vim.loop.cwd()
  local paths = split(cwd, '/')
  local root_name = M.pandatree.icon.root..' '..'[ROOT]'..' '..paths[#paths]
  local max_root_name_len = M.pandatree.win_width+2
  if #root_name > max_root_name_len then
    root_name = string.sub(root_name,1,max_root_name_len)
  else
    root_name = root_name..string.rep(' ',max_root_name_len-#root_name)
  end
  return root_name
end

local function reload_show_tree()
  local show_tree = {}
  local show_color = {}
  local line = -1
  if not is_show_tabline() then
    line = 0
    table.insert(show_tree,tree_root_name())
  end
  for _, v in pairs(M.pandatree.tree_list) do
    line = line+1
    local show_icon = '  '
    if v.t == 'directory' then
      local dir_icon = M.pandatree.icon.folder_icons.default
      if M.pandatree.fold[v.path] == true then
        dir_icon = M.pandatree.icon.folder_icons.open
      end
      show_icon = dir_icon..' '
    elseif v.t == 'file' then
      local extension = file_extension(v.name)
      local icon, hl_group = require'icons'.get_icon(v.name, extension)
      if icon == nil then icon = M.pandatree.icon.file.default end
      show_icon = icon..' '
    elseif v.t == 'link' then
      show_icon = M.pandatree.icon.file.symlink..' '
    end
    local space = ''
    if v.level > 0 then
      space = ' '..string.rep('  ', v.level-1)
    end
    local show_line = space..show_icon..v.name
    table.insert(show_tree,show_line)
  end
  return show_tree,show_color
end

local function reload_cursor(show_tree)
  local win = get_pandatree_tab_windows()[1]
  local line = math.min(M.pandatree.cursor_line, #show_tree)
  vim.api.nvim_win_set_cursor(win, {line, 0})
end

local function reload_tree()
  reload_tree_list(vim.loop.cwd(),true)
  local show_tree, show_color = reload_show_tree()
  local buf = get_pandatree_buffer()
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, show_tree)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  reload_cursor(show_tree)
end

local function draw_tree()
  local buf = get_pandatree_buffer()
  if buf == nil then return end
  M.pandatree.tree = {}
  search_tree_list(vim.loop.cwd(),1)
  reload_tree()
end

local function cursor_moved()
  local win = get_pandatree_tab_windows()[1]
  local line = vim.api.nvim_win_get_cursor(win)[1]
  vim.api.nvim_win_set_cursor(win, {line, 0})
  M.pandatree.cursor_line = line
end

local function exit()
  if #get_pandatree_tab_windows() == 1 and #get_tab_windows() == 1 then
    local tabs = vim.fn.gettabinfo()
    vim.api.nvim_command('q')
    if #tabs > 1 then
      draw_tree()
    end
  end
end

local function set_mappings()
  local buf = get_pandatree_buffer()
  disable_buf_default_keymaps(buf)
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
    vim.api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"pandatree".'..v..'<cr>', {
      nowait = true, noremap = true, silent = true
    })
  end
end

function pandatree_augroup()
  vim.api.nvim_command('augroup PandaTree')
  vim.api.nvim_command('autocmd!')
  vim.api.nvim_command('autocmd CursorMoved <buffer> lua require"pandatree".cursor_moved()')
  vim.api.nvim_command('autocmd BufWritePost * lua require"pandatree".draw_tree()')
  vim.api.nvim_command('autocmd BufEnter * lua require"pandatree".sync_tab_tree()')
  vim.api.nvim_command('autocmd BufEnter * lua require"pandatree".exit()')
  vim.api.nvim_command('augroup END')
end

local function open_tree()
  if is_exist_tab_pandatree() or M.pandatree.is_opening then return end
  M.pandatree.is_opening = true
  create_tree_win()
  local win = get_pandatree_tab_windows()[1]
  local buf = create_tree_buf()
  vim.api.nvim_win_set_buf(win, buf)
  for _, v in pairs(M.pandatree.local_commands) do
    vim.api.nvim_command('setlocal '..v)
  end
  for k, v in pairs(M.pandatree.win_options) do
    vim.api.nvim_win_set_option(win, k, v)
  end
  vim.api.nvim_buf_set_option(buf, 'filetype', M.pandatree.buf_name)
  draw_tree()
  set_mappings()
  pandatree_augroup()
  M.pandatree.is_opening = false
  require'pandaline'.load_tabline()
end

local function close_tree()
  local wins = get_pandatree_all_windows()
  for _, win in pairs(wins) do
    vim.api.nvim_win_close(win, true)
  end
  require'pandaline'.load_tabline()
end

local function togger_tree()
  if is_exist_tab_pandatree() then
    close_tree()
  else
    open_tree()
  end
end

local function sync_tab_tree()
  if is_exist_pandatree() and not is_exist_tab_pandatree() then
    open_tree()
    vim.api.nvim_command("wincmd l")
  end
end

local function open_file(open_type)
  local line = get_cursor()
  local item = M.pandatree.tree_list[line]
  if item == nil then return end
  if item.t == 'directory' then
    if open_type ~= nil then return end
    local is_fold = M.pandatree.fold[item.path] ~= nil
    if is_fold then
      M.pandatree.fold[item.path] = nil
    else
      M.pandatree.fold[item.path] = true
    end
    search_tree_list(item.path, item.level+1)
    reload_tree()
  else
    if open_type ~= nil then
      vim.api.nvim_command(open_type..' '..item.path)
    else
     local nearest_win = get_nearest_win()
     if nearest_win ~= nil then
       vim.api.nvim_command('wincmd l')
       vim.api.nvim_command('edit '..item.path)
     else
       vim.api.nvim_command('vsplit '..item.path)
     end
    end
  end
end

return {
  togger_tree = togger_tree,
  draw_tree = draw_tree,
  sync_tab_tree = sync_tab_tree,
  cursor_moved = cursor_moved,
  exit = exit,
  open_file = open_file,
  tree_root_name = tree_root_name,
  is_exist_tab_pandatree = is_exist_tab_pandatree
}
