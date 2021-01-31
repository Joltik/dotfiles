local api = vim.api
local wo = vim.wo

require'nvim-web-devicons'.setup()

require'tools'

local M = {}
M.mode = {
  n = {
    name = 'NORMAL',
    color = '#98c379'
  },
  i = {
    name = 'INSERT',
    color = '#61afef'
  },
  c = {
    name = 'Command',
    color = '#98c379'
  },
  v = {
    name = 'VISUAL',
    color = '#c678dd'
  },
  V = {
    name = 'V·Line',
    color = '#c678dd'
  },
  [''] = {
    name = 'VISUAL',
    color = '#c678dd'
  },
  R = {
    name = 'REPLACE',
    color = '#e06c75'
  },
  t = {
    name = 'TERMINAL',
    color = '#61afef'
  },
  s = {
    name = 'SELECT',
    color = '#e5c07b'
  },
  S = {
    name = 'S-LINE',
    color = '#e5c07b'
  }
}

local buffer_is_empty = function()
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

local function mode_name()
  local mode_info = M.mode[vim.fn.mode()]
  local name = mode_info.name
  vim.api.nvim_command('hi PandaViMode guibg=' .. mode_info.color .. ' guifg=#ffffff')
  return string.upper(name)
end

function load_pandaline()
  local is_empty = buffer_is_empty()
  local wins = api.nvim_list_wins()
  local hl_name = 'NomalStatusline'
  if #wins == 1 and is_empty then
    hl_name = 'EmptyStatusline'
  end
  local bg = vim.fn.synIDattr(vim.fn.hlID(hl_name),'bg')
  local fg = vim.fn.synIDattr(vim.fn.hlID(hl_name),'fg')
  vim.api.nvim_command('hi statusline guibg='..bg..' guifg='..fg)
  local show_line = " "
  if not is_empty then
    if vim.fn.winwidth(0) > 40 then
      show_line = '%#PandaViMode#'..' '..[[%{luaeval('require("pandaline").mode_name()')}]]..' '..'%##'..'%#PandaFile# '..'%##'
      local file_name = vim.fn.expand('%:t')
      local web_devicons = require'nvim-web-devicons'
      local extension = file_extension(file_name)
      local icon, hl_group = web_devicons.get_icon(file_name, extension)
      if icon ~= nil then
        show_line = show_line..'%#'..hl_group..'#'..icon..'%##'
      end
      show_line = show_line..'%#PandaFile# '..file_name..' '..'%##'
    else
      show_line = vim.bo.filetype
    end
  end
  wo.statusline = show_line..'%#PandaOther#'..'%##'
end

function pandaline_augroup()
  local events = { 'ColorScheme', 'FileType','BufWinEnter','BufReadPost','BufWritePost', 'BufEnter','WinEnter','FileChangedShellPost','VimResized','TermOpen'}
  api.nvim_command('augroup pandaline')
  api.nvim_command('autocmd!')
  for _, v in ipairs(events) do
    local command = string.format('autocmd %s * lua require("pandaline").load_pandaline()', v)
    vim.api.nvim_command(command)
  end
  api.nvim_command('augroup END')
end

return {
  pandaline_augroup = pandaline_augroup,
  load_pandaline = load_pandaline,
  mode_name = mode_name,
}
