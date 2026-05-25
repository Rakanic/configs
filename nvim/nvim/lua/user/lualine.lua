-- Custom orange lualine theme that mirrors the tmux statusline
-- (orange "session" pill on a near-black bar).

local bg       = "#0a0a0a"
local bg_alt   = "#1c1411"
local fg       = "#bcbcbc"
local fg_dim   = "#5a5a5a"
local orange   = "#ff8700"
local orange_d = "#d75f00"
local black    = "#121212"
local red      = "#d75f5f"
local green    = "#87af5f"

local theme = {
  normal = {
    a = { fg = black, bg = orange,  gui = "bold" },
    b = { fg = orange, bg = bg_alt },
    c = { fg = fg,     bg = bg },
  },
  insert = {
    a = { fg = black, bg = green,  gui = "bold" },
    b = { fg = green,  bg = bg_alt },
    c = { fg = fg,     bg = bg },
  },
  visual = {
    a = { fg = black, bg = "#ffaf5f", gui = "bold" },
    b = { fg = orange, bg = bg_alt },
    c = { fg = fg,     bg = bg },
  },
  replace = {
    a = { fg = black, bg = red,    gui = "bold" },
    b = { fg = red,    bg = bg_alt },
    c = { fg = fg,     bg = bg },
  },
  command = {
    a = { fg = black, bg = orange_d, gui = "bold" },
    b = { fg = orange, bg = bg_alt },
    c = { fg = fg,     bg = bg },
  },
  inactive = {
    a = { fg = fg_dim, bg = bg, gui = "bold" },
    b = { fg = fg_dim, bg = bg },
    c = { fg = fg_dim, bg = bg },
  },
}

require('lualine').setup {
  options = {
    theme              = theme,
    icons_enabled      = true,
    component_separators = { left = '', right = '' },
    section_separators   = { left = '', right = '' },
    globalstatus       = true,
    refresh            = { statusline = 200 },
  },
  sections = {
    lualine_a = { { 'mode', fmt = function(s) return ' ' .. s end } },
    lualine_b = {
      { 'branch', icon = '' },
      {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        diff_color = {
          added    = { fg = green },
          modified = { fg = orange },
          removed  = { fg = red },
        },
      },
    },
    lualine_c = {
      {
        'filename',
        path       = 1,
        symbols    = { modified = ' ●', readonly = ' ', unnamed = '[no name]' },
        color      = { fg = fg },
      },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        diagnostics_color = {
          error = { fg = red },
          warn  = { fg = orange },
          info  = { fg = '#87afaf' },
          hint  = { fg = '#5a8a5a' },
        },
      },
    },
    lualine_x = {
      { 'encoding', color = { fg = fg_dim } },
      { 'fileformat', color = { fg = fg_dim } },
      { 'filetype', color = { fg = orange } },
    },
    lualine_y = {
      { 'progress', color = { fg = orange, gui = 'bold' } },
    },
    lualine_z = {
      { 'location', icon = '' },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 1, color = { fg = fg_dim } } },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { 'nvim-tree', 'fugitive', 'lazy', 'mason', 'quickfix' },
}
