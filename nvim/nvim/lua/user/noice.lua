-- Noice: smooth, orange-bordered command palette and notifications.
-- The actual color overrides live in tokyonight.lua (NoiceCmdline*, Notify*).

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"]                = true,
      ["cmp.entry.get_documentation"]                  = true,
    },
    hover     = { silent = true },
    signature = { enabled = true },
  },

  cmdline = {
    view = "cmdline_popup",
    format = {
      cmdline = { icon = " " },
      search_down = { icon = " 🔍" },
      search_up   = { icon = " 🔍" },
      filter      = { icon = " " },
      lua         = { icon = "󰢱 " },
      help        = { icon = " " },
    },
  },

  views = {
    cmdline_popup = {
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      filter_options = {},
      win_options = {
        winhighlight = {
          Normal       = "NormalFloat",
          FloatBorder  = "FloatBorder",
        },
      },
    },
    popupmenu = {
      relative = "editor",
      position = { row = 8, col = "50%" },
      size     = { width = 60, height = 10 },
      border   = { style = "rounded", padding = { 0, 1 } },
      win_options = {
        winhighlight = { Normal = "NormalFloat", FloatBorder = "FloatBorder" },
      },
    },
    mini = {
      win_options = { winblend = 0 },
    },
  },

  routes = {
    -- send "written" messages quietly to the mini view instead of a notify popup
    { filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
    -- demote any "no information available" hover spam to a hidden route
    { filter = { event = "msg_show", find = "No information available" }, opts = { skip = true } },
  },

  presets = {
    bottom_search        = true,
    command_palette      = true,
    long_message_to_split = true,
    inc_rename           = false,
    lsp_doc_border       = true,
  },
})

-- Notify: keep notifications short and unobtrusive, matched to the theme.
require("notify").setup({
  background_colour = "#121212",
  fps               = 60,
  stages            = "fade_in_slide_out",
  timeout           = 2500,
  top_down          = false,
  render            = "compact",
  max_width         = 60,
  icons = {
    DEBUG = "",
    ERROR = "",
    INFO  = "",
    TRACE = "✎",
    WARN  = "",
  },
})
