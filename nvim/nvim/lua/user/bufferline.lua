-- Orange-themed bufferline, slanted separators for a smoother
-- transition between the active tab and the rest of the bar.

local bufferline = require('bufferline')

local bg        = "#0a0a0a"   -- matches tmux colour233-ish (statusline bg)
local bg_active = "#121212"   -- main editor bg
local fg_dim    = "#808080"
local orange    = "#ff8700"
local orange_lt = "#ffaf5f"

bufferline.setup {
  options = {
    mode               = "buffers",
    themable           = true,
    indicator          = { style = 'underline' },
    separator_style    = "slant",
    buffer_close_icon  = '¶',
    modified_icon      = '●',
    close_icon         = '|',
    left_trunc_marker  = '<<',
    right_trunc_marker = '>>',
    max_name_length    = 18,
    max_prefix_length  = 15,
    truncate_names     = false,
    tab_size           = 14,
    show_buffer_close_icons = true,
    show_close_icon         = false,
    diagnostics             = "nvim_lsp",
    diagnostics_indicator   = function(count, level)
      local icon = level:match("error") and " " or " "
      return icon .. count
    end,
    offsets = {
      {
        filetype   = "NvimTree",
        text       = "  EXPLORER",
        text_align = "left",
        separator  = true,
        highlight  = "BufferLineOffset",
      },
    },
  },
  highlights = {
    fill                  = { bg = bg },
    background            = { bg = bg, fg = fg_dim },

    buffer_selected       = { bg = bg_active, fg = orange,    bold = true, italic = false },
    buffer_visible        = { bg = bg,        fg = "#a8a8a8" },

    indicator_selected    = { bg = bg_active, fg = orange },

    -- slant separators: triangle bg = current segment bg
    separator             = { bg = bg,        fg = bg },
    separator_visible     = { bg = bg,        fg = bg },
    separator_selected    = { bg = bg,        fg = bg_active },

    modified              = { bg = bg,        fg = orange },
    modified_visible      = { bg = bg,        fg = orange },
    modified_selected     = { bg = bg_active, fg = orange },

    duplicate             = { bg = bg,        fg = fg_dim,   italic = true },
    duplicate_selected    = { bg = bg_active, fg = orange_lt, italic = true },
    duplicate_visible     = { bg = bg,        fg = fg_dim,   italic = true },

    close_button          = { bg = bg,        fg = fg_dim },
    close_button_visible  = { bg = bg,        fg = fg_dim },
    close_button_selected = { bg = bg_active, fg = orange },

    pick                  = { bg = bg,        fg = orange,   bold = true },
    pick_selected         = { bg = bg_active, fg = orange,   bold = true },
    pick_visible          = { bg = bg,        fg = orange_lt,bold = true },

    diagnostic            = { bg = bg,        fg = fg_dim },
    diagnostic_selected   = { bg = bg_active, fg = orange,   bold = true },
    info                  = { bg = bg,        fg = "#87afaf" },
    info_selected         = { bg = bg_active, fg = "#87afaf", bold = true },
    warning               = { bg = bg,        fg = orange },
    warning_selected      = { bg = bg_active, fg = orange,   bold = true },
    error                 = { bg = bg,        fg = "#d75f5f" },
    error_selected        = { bg = bg_active, fg = "#d75f5f", bold = true },

    offset_separator      = { bg = bg,        fg = "#2a1f15" },
  },
}

-- The "BufferLineOffset" highlight referenced above is used
-- to color the EXPLORER label that sits above nvim-tree.
vim.api.nvim_set_hl(0, "BufferLineOffset", { bg = "#0e0e0e", fg = orange, bold = true })
