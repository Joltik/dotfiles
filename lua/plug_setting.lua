require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  }
}

require'colorizer'.setup(
  {'*';},
  {
    RGB      = true;
    RRGGBB   = true;
    names    = true;
    RRGGBBAA = true;
  }
)

local galaxyline = require('galaxyline')
local utils = require('utils')
local galaxylineSection = galaxyline.section

local colors = {
  bg = '#282a36',
  fg = '#f8f8f2',
  section_bg = '#38393f',
  yellow = '#f1fa8c',
  cyan = '#8be9fd',
  green = '#50fa7b',
  orange = '#ffb86c',
  magenta = '#ff79c6',
  blue = '#8be9fd',
  red = '#ff5555'
}

local mode_color = function()
  local mode_colors = {
    n = colors.cyan,
    i = colors.green,
    c = colors.orange,
    V = colors.magenta,
    [' '] = colors.magenta,
    v = colors.magenta,
    R = colors.red,
  }
  return mode_colors[vim.fn.mode()]
end

local buffer_not_empty = function()
  return not utils.is_buffer_empty()
end

local checkwidth = function()
  return utils.has_width_gt(40) and buffer_not_empty()
end

galaxylineSection.left[1] = {
  FirstElement = {
    provider = function() return '▋ ' end,
    condition = checkwidth,
    highlight = { colors.cyan, colors.section_bg }
  },
}
galaxylineSection.left[2] = {
  ViMode = {
    provider = function()
      local alias = {
        n = 'NORMAL',
        i = 'INSERT',
        c = 'COMMAND',
        V = 'VISUAL',
        [' '] = 'VISUAL',
        v = 'VISUAL',
        R = 'REPLACE',
      }
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color())
      return alias[vim.fn.mode()]..' '
    end,
    condition = checkwidth,
    highlight = { colors.bg, colors.section_bg },
  },
}
galaxylineSection.left[3] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = checkwidth,
    highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.section_bg },
  },
}
galaxylineSection.left[4] = {
  FileName = {
    provider = { 'FileName' },
    condition = buffer_not_empty,
    highlight = { colors.fg, colors.section_bg },
  }
}
galaxylineSection.left[5] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = checkwidth,
    highlight = {colors.red,colors.section_bg},
  }
}
galaxylineSection.left[6] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = checkwidth,
    highlight = {colors.fg,colors.section_bg},
  }
}
galaxylineSection.right[1]= {
  FileFormat = {
    provider = function() return vim.bo.filetype end,
    condition = checkwidth,
    highlight = { colors.fg,colors.section_bg },
    separator = ' ',
    separator_highlight = { colors.section_bg,colors.section_bg},
  }
}
galaxylineSection.right[2] = {
  LineInfo = {
    provider = 'LineColumn',
    condition = checkwidth,
    highlight = { colors.fg, colors.section_bg },
    separator = ' | ',
    separator_highlight = { colors.bg, colors.section_bg },
  },
}
galaxylineSection.right[3] = {
  Heart = {
    provider = function() return ' ' end,
    condition = checkwidth,
    highlight = { colors.red, colors.section_bg },
    separator = ' | ',
    separator_highlight = { colors.bg, colors.section_bg },
  }
}
