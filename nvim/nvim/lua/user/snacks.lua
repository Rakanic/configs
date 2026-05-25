-- Snacks: indent guides, smooth scroll, dashboard.
-- Smooth scroll is enabled (was disabled) for one of the
-- nicest visual transitions in nvim with virtually no cost.

require('snacks').setup({
  indent = {
    enabled    = true,
    only_scope = true,
    hl         = "SnacksIndent",
    char       = "│",
    animate    = {
      enabled  = true,
      style    = "out",
      easing   = "linear",
      duration = { step = 20, total = 200 },
    },
    scope = {
      enabled = true,
      char    = "│",
      hl      = "SnacksIndentScope",
    },
  },

  scroll = {
    enabled = true,
    animate = {
      duration = { step = 12, total = 180 },
      easing   = "linear",
    },
  },

  statuscolumn = { enabled = false },

  notifier = {
    enabled = true,
    timeout = 3000,
    style   = "compact",
    margin  = { top = 0, right = 1, bottom = 0 },
    icons   = {
      error = " ", warn = " ", info = " ", debug = " ", trace = "✎ ",
    },
  },

  input      = { enabled = true },
  quickfile  = { enabled = true },
  bigfile    = { enabled = true },
  words      = { enabled = false },
  terminal   = { enabled = true },
  image      = { enabled = false },

  styles = {
    notification = {
      wo = { wrap = true },
    },
  },

  dashboard = {
    enabled = true,
    preset = {
      header = [[
   ██╗    ██████╗
  ███║   ██╔═══██╗
  ╚██║   ██║   ██║
   ██║   ██║   ██║
   ██║   ╚██████╔╝
   ╚═╝    ╚═════╝
]],
      keys = {
        { icon = " ", key = "f", desc = "Find File",      action = ":Telescope find_files" },
        { icon = " ", key = "n", desc = "New File",       action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text",      action = ":Telescope live_grep" },
        { icon = " ", key = "r", desc = "Recent Files",   action = ":Telescope oldfiles" },
        { icon = " ", key = "c", desc = "Config",         action = ":e $MYVIMRC" },
        { icon = "󰒲 ", key = "l", desc = "Lazy",           action = ":Lazy" },
        { icon = " ", key = "q", desc = "Quit",           action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys",   gap = 1, padding = 1 },
      { section = "startup" },
    },
  },
})
