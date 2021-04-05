require'utils'

local M = {
  pandawin = {
    show_list = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'},
    prefix = 'pandawin_',
    statusline_bank = {},
    statusline_map = {},
    mid_space = '    '
  }
}

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

local function win_statusline(win,show_item)
  local mid = M.pandawin.mid_space..string.upper(show_item)..M.pandawin.mid_space
  local width = vim.api.nvim_win_get_width(win)
  local space = string.rep(' ',math.floor((width-#mid)/2))
  local left_fill = '%#PandaWinFill#'..space..'%##'
  local right_fill = '%#PandaWinFill#'..space
  return left_fill..'%#PandaWinMid#'..mid..'%##'..right_fill
end

local function show()
  M.pandawin.statusline_bank = {}
  M.pandawin.statusline_map = {}
  local wins = get_tab_windows()
  for k, win in ipairs(wins) do
    local statusline = ''
    if not is_float_window(win) then
      statusline = vim.api.nvim_win_get_option(win,'statusline')
    end
    local bank_key = M.pandawin.prefix..win
    local show_item = M.pandawin.show_list[k]
    local map_key = M.pandawin.prefix..show_item
    M.pandawin.statusline_bank[bank_key] = statusline
    M.pandawin.statusline_map[map_key] = win
    vim.api.nvim_win_set_option(win, 'statusline', win_statusline(win,show_item))
  end
  vim.api.nvim_command('redraw')
  vim.api.nvim_command("echohl WarningMsg | echo 'choose > ' | echohl None")
  local c = vim.fn.nr2char(vim.fn.getchar())
  vim.api.nvim_command('normal :esc<CR>')
  for k, win in ipairs(wins) do
    local bank_key = M.pandawin.prefix..win
    vim.api.nvim_win_set_option(win, 'statusline', M.pandawin.statusline_bank[bank_key])
  end
  local choose_win = M.pandawin.statusline_map[M.pandawin.prefix..c]
  if choose_win ~= nil then
    local cur_win = vim.fn.winnr()
    local choose_index = index_of(M.pandawin.show_list,c)
    if choose_index and choose_index ~= cur_win then
      -- vim.api.nvim_set_current_win(wins[choose_index])
      vim.api.nvim_command("exe "..choose_index.." . 'wincmd w'")
    end
  end
end

return {
  show = show
}
