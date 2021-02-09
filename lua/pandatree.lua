require'tools'

M = {
  pandatree = {
    is_opening = false,
    buf_name = 'pandatree',
    buf_options = {
      bufhidden = 'wipe',
      buftype = 'nofile',
      modifiable = false,
      filetype = 'pandatree'
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
    cursor_line_item = nil,
    show_hidden = false,
    tree = {},
    tree_list = {},
    fold = {},
    git_list = {},
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
      },
      git = {
        unstaged = "✹",
        staged = "✓",
        unmerged = "═",
        renamed = "➜",
        untracked = "★",
        deleted = "✗"
      },
    },
    git = {
      ["M "] = {
        { icon = 'staged', hl = "PandaTreeGitStaged" },
        {}
      },
      [" M"] = {
        {},
        { icon = 'unstaged', hl = "PandaTreeGitDirty" }
      },
      ["MM"] = {
        { icon = 'staged', hl = "PandaTreeGitStaged" },
        { icon = 'unstaged', hl = "PandaTreeGitDirty" }
      },
      ["A "] = {
        { icon = 'staged', hl = "PandaTreeGitStaged" },
        { icon = 'untracked', hl = "PandaTreeGitNew" }
      },
      [" A"] = {
        {},
        { icon = 'untracked', hl = "PandaTreeGitNew" }
      },
      ["AM"] = {
        { icon = 'staged', hl = "PandaTreeGitStaged" },
        { icon = 'untracked', hl = "PandaTreeGitNew" }
      },
      ["??"] = {
        { icon = 'untracked', hl = "PandaTreeGitDirty" },
        {}
      },
      ["R "] = {
        { icon = 'renamed', hl = "PandaTreeGitRenamed" },
        {}
      },
      ["RM"] = {
        { icon = 'unstaged', hl = "PandaTreeGitDirty" },
        { icon = 'renamed', hl = "PandaTreeGitRenamed" }
      },
      ["UU"] = {
        { icon = 'unmerged', hl = "PandaTreeGitMerge" },
        {}
      },
      [" D"] = {
        {},
        { icon = 'deleted', hl = "PandaTreeGitDeleted" }
      },
    }
  }
}

local function reload_git_status()
  M.pandatree.git_list = {}
  local cwd = vim.loop.cwd()
  local status_list = vim.fn.systemlist('cd "'..cwd..'" && git status --porcelain=v1 -u')
  for _, v in pairs(status_list) do
    if string.find(v,'.git') == nil then
      local status = v:sub(0, 2)
      local file_path = v:sub(4, -1)
      if file_path:match('%->') ~= nil then
        file_path = file_path:gsub('^.* %-> ', '')
      end
      local full_path = cwd..'/'..file_path
      M.pandatree.git_list[full_path] = status
      local paths = split(file_path,'/')
      local dir_path = cwd
      for _, path in ipairs(paths) do
        M.pandatree.git_list[dir_path] = ' M'
        dir_path = dir_path..'/'..path
      end
    end
  end
end

local function is_show_tabline()
  local showtabline = vim.api.nvim_get_option('showtabline')
  return (showtabline == 2) or (showtabline == 1 and #vim.fn.gettabinfo() > 1)
end

local function is_pandatree_buffer(buf)
  return vim.api.nvim_buf_get_name(buf):match('.*/'..M.pandatree.buf_name..'$')
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


local function get_cursor_line()
  local line = 1
  for k, v in pairs(M.pandatree.tree_list) do
    if M.pandatree.cursor_line_item == v then
      line = k
    end
  end
  return line
end

local function search_tree_list(cwd,level)
  if level == 1 then M.pandatree.tree = {} end
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
  if is_first then 
    M.pandatree.tree_list = {} 
    if not is_show_tabline() then
      table.insert(M.pandatree.tree_list,{level = 0})
    end
  end
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
  local line = 0
  for _, v in pairs(M.pandatree.tree_list) do
    if v.level > 0 then
      local line_colors = {}
      local show_icon
      local group = 'PandaTreeFile'
      local col_start = 0
      local space = ''
      if v.level > 0 then
        space = ' '..string.rep('  ', v.level-1)
      end
      if v.t == 'directory' then
        show_icon = M.pandatree.icon.folder_icons.default
        if M.pandatree.fold[v.path] == true then
          show_icon = M.pandatree.icon.folder_icons.open
        end
        group = 'PandaTreeFolder'
      elseif v.t == 'link' then
        show_icon = M.pandatree.icon.file_icons.symlink
      else
        local extension = file_extension(v.name)
        local icon, hl_group = require'icons'.get_icon(v.name, extension)
        if icon == nil then
          show_icon = M.pandatree.icon.file_icons.default
        else
          show_icon = icon
        end
        if hl_group ~= nil then
          col_start = #space+#show_icon
          table.insert(line_colors, {
            group = hl_group,
            line = line,
            col_start = 0,
            col_end = col_start
          })
        end
      end
      show_icon = show_icon..' '
      local show_line = space..show_icon..v.name
      local max_line_len = M.pandatree.win_width-1
      if #show_line > max_line_len then
        local name_end_index = max_line_len-7
        show_line = string.sub(show_line,name_end_index)..'...'..string.sub(show_line,-4)
      else
        show_line = show_line..string.rep(' ',max_line_len-#show_line)
      end
      table.insert(line_colors, {
        group = group,
        line = line,
        col_start = col_start,
        col_end = #show_line
      })
      local git_status = M.pandatree.git_list[v.path]
      local show_git = ''
      if  git_status ~= nil then
        local git_item = M.pandatree.git[git_status]
        for _, v in pairs(git_item) do
          local git_item_icon = ' '
          if v.icon ~= nil then
            git_item_icon = M.pandatree.icon.git[v.icon]
          end
          show_git = show_git..git_item_icon
          if v.hl ~= nil then
            local git_hl_start = max_line_len+#show_git
            table.insert(line_colors, {
              group = v.hl,
              line = line,
              col_start = git_hl_start,
              col_end = git_hl_start+1
            })
          end
        end
      end
      show_line = show_line..' '..show_git
      table.insert(show_tree, show_line)
      table.insert(show_color, line_colors)
    else
      table.insert(show_color, {{
        group = "ExplorerRoot",
        line = line,
        col_start = 0,
        col_end = -1
      }})
      table.insert(show_tree,tree_root_name())
    end
    line = line+1
  end
  return show_tree,show_color
end

local function reload_cursor()
  local win = get_pandatree_tab_windows()[1]
  local line = math.min(get_cursor_line(), #M.pandatree.tree_list)
  vim.api.nvim_win_set_cursor(win, {line, 0})
end

local function reload_tree()
  reload_tree_list(vim.loop.cwd(), true)
  local show_tree, show_color = reload_show_tree()
  local buf = get_pandatree_buffer()
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, show_tree)
  for _, v in pairs(show_color) do
    for _, v2 in pairs(v) do
      vim.api.nvim_buf_add_highlight(buf, -1, v2.group, v2.line, v2.col_start, v2.col_end)
    end
  end
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  reload_cursor()
end

local function draw_tree()
  local buf = get_pandatree_buffer()
  if buf == nil then return end
  search_tree_list(vim.loop.cwd(),1)
  reload_git_status()
  reload_tree()
end

local function cursor_moved()
  local win = get_pandatree_tab_windows()[1]
  local line = vim.api.nvim_win_get_cursor(win)[1]
  vim.api.nvim_win_set_cursor(win, {line, 0})
  M.pandatree.cursor_line_item = M.pandatree.tree_list[line]
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
    ['q'] = 'close_tree()',
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
  draw_tree()
  set_mappings()
  pandatree_augroup()
  M.pandatree.is_opening = false
  require'pandaline'.load_pandaline(true)
  require'pandaline'.load_tabline()
end

local function close_tree()
  local wins = get_pandatree_all_windows()
  for _, win in pairs(wins) do
    if vim.api.nvim_get_current_win() == win then
      vim.api.nvim_command("wincmd l")
    end
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
  local line = get_cursor_line()
  local item = M.pandatree.tree_list[line]
  if item.path == nil then return end
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
      if open_type == 'tabe' then
        vim.api.nvim_command('wincmd l')
      end
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
