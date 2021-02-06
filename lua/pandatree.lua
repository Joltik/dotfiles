require'tools'

M = {
  pandatree = {
    buf_name = 'explorer',
  }
}

local function is_pandatree_buffer(buf)
  return vim.api.nvim_buf_get_name(buf):match('.*/'..M.pandatree.buf_name..'$')
end

local function get_pandatree_windows()
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

local function exist_pandatree()
end

local function togger_tree()
  local pandatree_wins = get_pandatree_windows()
  dump(pandatree_wins)
end

return {
  togger_tree = togger_tree
}
