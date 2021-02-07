require'tools'

M = {
  pandatree = {
    is_opening = false,
    buf_name = 'pandatree',
    buf_options = {
      bufhidden = 'wipe',
      buftype = 'nofile',
      modifiable = false,
      filetype = 'pandatree',
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
  }
}

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

local function exist_pandatree()
  local all_wins = get_pandatree_all_windows()
  return #all_wins > 0
end

local function tab_exist_pandatree()
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

local function draw_tree()
  local buf = get_pandatree_buffer()
  if buf == nil then return end
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf,0,-1,false,{'PandaTree'})
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
end

local function exit()
  if get_pandatree_tab_windows() ~= nil then
    if #get_tab_windows() == 1 then
      return vim.cmd ':q!'
    end
  end
end

function pandatree_augroup()
  vim.api.nvim_command('augroup PandaTree')
  vim.api.nvim_command('autocmd!')
  --vim.api.nvim_command('autocmd CursorMoved <buffer> lua require"explorer".cursor_moved()')
  --vim.api.nvim_command('autocmd BufWritePost * lua require"explorer".draw_tree()')
  vim.api.nvim_command('autocmd TabEnter,BufEnter * lua require"pandatree".sync_tab_tree()')
  vim.api.nvim_command('autocmd BufEnter * lua require"pandatree".exit()')
  vim.api.nvim_command('augroup END')
end

local function open_tree()
  if tab_exist_pandatree() or M.pandatree.is_opening then return end
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
  pandatree_augroup()
  M.pandatree.is_opening = false
end

local function close_tree()
  local wins = get_pandatree_all_windows()
  for _, v in pairs(wins) do
    vim.api.nvim_win_close(v, true)
  end
end

local function togger_tree()
  if tab_exist_pandatree() then
    close_tree()
  else
    open_tree()
  end
end

local function sync_tab_tree()
  if exist_pandatree() and not tab_exist_pandatree() then
    open_tree()
    vim.api.nvim_command("wincmd l")
  end
end

return {
  togger_tree = togger_tree,
  sync_tab_tree = sync_tab_tree,
  exit = exit
}
