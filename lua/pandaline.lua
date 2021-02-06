local api = vim.api
local luv = vim.loop
local wo = vim.wo

require'tools'

local M = {
  mode = {
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
    ['\22'] = {
      name = 'V·Colum',
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
      name = 'S·LINE',
      color = '#e5c07b'
    }
  }
}

local buffer_is_empty = function()
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

local function mode_name()
  local mode = vim.fn.mode()
  local mode_info = M.mode[mode]
  if mode_info == nil then return mode end
  local name = mode_info.name
  local mode_fg = vim.fn.synIDattr(vim.fn.hlID('PandaViMode'),'fg')
  vim.api.nvim_command('hi PandaViMode guibg=' .. mode_info.color .. ' guifg='..mode_fg)
  return string.upper(name)
end

function VIMode()
  local mode = '%#PandaViMode# '..[[%{luaeval('require("pandaline").mode_name()')}]]..' %##'
  return mode
end

function FileSpace()
  local space = '%#PandaFile# '..'%##'
  return space
end

function FileName()
  local file_name = vim.fn.expand('%:t')
  local extension = file_extension(file_name)
  local icon, hl_group = require'icons'.get_icon(file_name, extension)
  local show_name = FileSpace()..'%#PandaFile#'..file_name..'%m'..'%##'..FileSpace()
  if icon ~= nil then
    local icon_fg = vim.fn.synIDattr(vim.fn.hlID(hl_group),'fg')
    local icon_bg = vim.fn.synIDattr(vim.fn.hlID('PandaFile'),'bg')
    local icon_hl_group = 'PandaFileIcon'..hl_group
    vim.api.nvim_command('hi '..icon_hl_group..' guibg='..icon_bg..' guifg='..icon_fg)
    return FileSpace()..'%#'..icon_hl_group..'#'..icon..'%##'..show_name
  end
  return show_name
end

function FileType()
  local fileType = vim.bo.filetype:gsub("^%l", string.upper)
  local file_type = FileSpace()..'%#PandaFile#'..fileType..'%##'..FileSpace()
  return file_type
end

function GitSpace()
  local space = '%#PandaGit# '..'%##'
  return space
end

function GitBranch()
  local cwd = luv.cwd()
  local git_branch = vim.fn.systemlist('cd "'..cwd..'" && git symbolic-ref --short -q HEAD')
  local branch_name = git_branch[1]
  if string.find(branch_name,'.git') == nil then
    local icon, hl_group = require'icons'.get_icon('git', '')
    local icon_fg = vim.fn.synIDattr(vim.fn.hlID(hl_group),'fg')
    local icon_bg = vim.fn.synIDattr(vim.fn.hlID('PandaGit'),'bg')
    local icon_hl_group = 'PandaFileIcon'..hl_group
    vim.api.nvim_command('hi '..icon_hl_group..' guibg='..icon_bg..' guifg='..icon_fg)
    local show_name = GitSpace()..'%#PandaGit#'..branch_name..'%##'..GitSpace()
    return GitSpace()..'%#'..icon_hl_group..'#'..icon..'%##'..show_name
  else
    return ''
  end
end

function Fill()
  return '%#PandaFill#'
end

function RightSplit()
  return '%='
end

function LinePercent(is_hl)
  local hl_group = 'PandaDim'
  local sep_group = 'PandaLinePercentSeparatorDim'
  if is_hl then 
    hl_group = 'PandaLinePercent' 
    sep_group = 'PandaLinePercentSeparator'
  end
  local sep_fg = vim.fn.synIDattr(vim.fn.hlID(hl_group),'bg')
  local sep_bg = vim.fn.synIDattr(vim.fn.hlID('PandaFill'),'bg')
  vim.api.nvim_command('hi '..sep_group..' guibg='..sep_bg..' guifg='..sep_fg)
  return '%#'..sep_group..'#'..''..'%##'..'%#'..hl_group..'#'..' %p%% '..'%##'
end

function load_pandaline(is_hl)
  local is_empty = buffer_is_empty()
  local wins = api.nvim_list_wins()
  if is_empty then 
    wo.statusline = ' '
    return 
  end
  if vim.fn.winwidth(0) <= 40 then 
    wo.statusline = FileType()..Fill()..RightSplit()..LinePercent(is_hl)
    return
  end
  if not is_hl then
    wo.statusline = FileName()..Fill()..RightSplit()..LinePercent(is_hl)
    return
  end
  wo.statusline = VIMode()..FileName()..Fill()..RightSplit()..GitBranch()..LinePercent(is_hl)
end

function load_tabline()
  local tabs = vim.fn.gettabinfo()
  local current_tab = vim.fn.tabpagenr()
  for i, tab in ipairs(tabs) do
    local is_active_tab = current_tab == tab.tabnr
  end
  --wo.tabline = '哈哈哈哈哈哈'
end

function pandaline_augroup()
  local hl_events = {'FileType','BufEnter','WinEnter','BufWinEnter','FileChangedShellPost','VimResized'}
  local nohl_events = {'WinLeave'}
  api.nvim_command('augroup pandaline')
  api.nvim_command('autocmd!')
  for _, v in ipairs(hl_events) do
    local command = string.format('autocmd %s * lua require("pandaline").load_pandaline(true)', v)
    vim.api.nvim_command(command)
  end
  for _, v in ipairs(nohl_events) do
    local command = string.format('autocmd %s * lua require("pandaline").load_pandaline(false)', v)
    vim.api.nvim_command(command)
  end
  api.nvim_command('augroup END')
  load_tabline()
end

return {
  pandaline_augroup = pandaline_augroup,
  load_pandaline = load_pandaline,
  mode_name = mode_name,
}
