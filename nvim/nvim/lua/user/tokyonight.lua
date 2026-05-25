-- =========================================================
-- ORANGE THEME — mirrors the tmux palette
--   bg     #121212  (tmux colour233)
--   accent #ff8700  (tmux colour208)
--   fg     #d0d0d0
-- =========================================================
-- We piggyback on tokyonight-night for full highlight-group
-- coverage, then override every color so the result is a
-- coherent orange-on-black scheme.

require("tokyonight").setup({
  style = "night",
  transparent = false,
  terminal_colors = true,
  styles = {
    comments  = { italic = true },
    keywords  = { italic = true, bold = true },
    functions = { bold = true },
    variables = {},
    sidebars  = "dark",
    floats    = "dark",
  },

  -- Core palette: rewrite tokyonight's blues into a warm
  -- black/orange world. Keep just enough teal so types and
  -- info diagnostics stay distinguishable from keywords.
  on_colors = function(c)
    -- backgrounds: pure neutral grays — no blue tint anywhere.
    c.bg              = "#0f0f0f"
    c.bg_dark         = "#080808"
    c.bg_dark1        = "#070707"
    c.bg_float        = "#141414"
    c.bg_popup        = "#141414"
    c.bg_sidebar      = "#0c0c0c"
    c.bg_statusline   = "#080808"
    c.bg_highlight    = "#1c1c1c"
    c.bg_search       = "#ff8700"
    c.bg_visual       = "#3a2410"

    -- foregrounds (warm whites)
    c.fg              = "#d0d0d0"
    c.fg_dark         = "#a8a8a8"
    c.fg_gutter       = "#3a3a3a"
    c.fg_sidebar      = "#bcbcbc"
    c.fg_float        = "#d0d0d0"

    -- borders / separators
    c.border          = "#2a1f15"
    c.border_highlight= "#ff8700"

    -- accent colors — orange-forward palette
    c.orange          = "#ff8700"   -- primary accent (tmux colour208)
    c.yellow          = "#ffcc66"   -- strings, warnings
    c.red             = "#d75f5f"   -- errors, deletions
    c.green           = "#87af5f"   -- success, git add
    c.green1          = "#a8c97c"
    c.green2          = "#5f8700"
    c.blue            = "#ffaf5f"   -- repurposed: warm amber (functions)
    c.blue0           = "#d75f00"
    c.blue1           = "#ffaf5f"
    c.blue2           = "#ff9933"
    c.blue5           = "#ffb86c"
    c.blue6           = "#ffcc99"
    c.blue7           = "#3a2410"
    c.cyan            = "#87afaf"   -- types — kept teal for contrast
    c.magenta         = "#d7afaf"   -- special chars
    c.magenta2        = "#af87af"
    c.purple          = "#c994ae"
    c.teal            = "#5fafaf"

    -- comments & subtle text
    c.comment         = "#5a5a5a"
    c.dark3           = "#3a3a3a"
    c.dark5           = "#4a4a4a"

    -- terminal black variant
    c.black           = "#0a0a0a"
    c.terminal_black  = "#1c1c1c"
  end,

  -- Custom highlight overrides: keep this list small and
  -- focused so syntax stays orange-dominant but readable.
  on_highlights = function(hl, c)
    -- editor chrome ------------------------------------------------
    hl.Normal              = { bg = c.bg,        fg = c.fg }
    hl.NormalNC            = { bg = c.bg,        fg = c.fg }
    hl.NormalFloat         = { bg = c.bg_float,  fg = c.fg_float }
    hl.FloatBorder         = { bg = c.bg_float,  fg = c.orange }
    hl.FloatTitle          = { bg = c.bg_float,  fg = c.orange, bold = true }
    hl.WinSeparator        = { fg = "#262626",   bg = "NONE" }
    hl.VertSplit           = { fg = "#262626",   bg = "NONE" }
    hl.SignColumn          = { bg = c.bg }
    hl.LineNr              = { fg = "#3a3a3a",   bg = c.bg }
    hl.CursorLineNr        = { fg = c.orange,    bg = c.bg, bold = true }
    hl.CursorLine          = { bg = "#181818" }
    hl.ColorColumn         = { bg = "#1a1a1a" }
    hl.MatchParen          = { fg = c.orange, bold = true, underline = true }
    hl.EndOfBuffer         = { bg = c.bg,        fg = c.bg }
    hl.MsgArea             = { bg = c.bg,        fg = c.fg }

    -- statusline / tabs --------------------------------------------
    hl.StatusLine          = { bg = c.bg_statusline, fg = c.fg }
    hl.StatusLineNC        = { bg = c.bg_statusline, fg = "#5a5a5a" }
    hl.TabLine             = { bg = c.bg_statusline, fg = "#808080" }
    hl.TabLineSel          = { bg = c.orange, fg = c.bg, bold = true }
    hl.TabLineFill         = { bg = c.bg_statusline }

    -- search / visual ----------------------------------------------
    hl.Search              = { bg = "#3a2410", fg = c.orange, bold = true }
    hl.IncSearch           = { bg = c.orange, fg = c.bg, bold = true }
    hl.CurSearch           = { bg = c.orange, fg = c.bg, bold = true }
    hl.Visual              = { bg = "#3a2410" }

    -- syntax: orange-led -------------------------------------------
    hl.Keyword             = { fg = c.orange, italic = true, bold = true }
    hl.Statement           = { fg = c.orange, bold = true }
    hl.Conditional         = { fg = c.orange, italic = true, bold = true }
    hl.Repeat              = { fg = c.orange, italic = true, bold = true }
    hl.Operator            = { fg = "#d75f00" }
    hl.Function            = { fg = "#ffaf5f", bold = true }
    hl.Identifier          = { fg = "#d0d0d0" }
    hl.Type                = { fg = "#87afaf" }
    hl.StorageClass        = { fg = "#ffaf5f", italic = true }
    hl.Structure           = { fg = "#87afaf", bold = true }
    hl.Constant            = { fg = "#ffcc66" }
    hl.String              = { fg = "#ffcc66" }
    hl.Number              = { fg = "#ffaf5f" }
    hl.Boolean             = { fg = c.orange, bold = true }
    hl.Character           = { fg = "#ffcc66" }
    hl.Special             = { fg = "#d75f00" }
    hl.SpecialChar         = { fg = "#d75f00" }
    hl.PreProc             = { fg = "#ff9933" }
    hl.Include             = { fg = c.orange, italic = true }
    hl.Macro               = { fg = "#ff9933" }
    hl.Comment             = { fg = "#5a5a5a", italic = true }
    hl.Todo                = { fg = c.bg, bg = c.orange, bold = true }

    -- treesitter mirrors -------------------------------------------
    hl["@keyword"]         = { link = "Keyword" }
    hl["@function"]        = { link = "Function" }
    hl["@function.call"]   = { fg = "#ffaf5f" }
    hl["@function.builtin"]= { fg = c.orange, bold = true }
    hl["@variable"]        = { fg = "#d0d0d0" }
    hl["@variable.builtin"]= { fg = "#ff9933", italic = true }
    hl["@parameter"]       = { fg = "#e0c090", italic = true }
    hl["@type"]            = { fg = "#87afaf" }
    hl["@type.builtin"]    = { fg = "#87afaf", italic = true }
    hl["@string"]          = { fg = "#ffcc66" }
    hl["@constant"]        = { fg = "#ffcc66", bold = true }
    hl["@constant.builtin"]= { fg = c.orange, bold = true }
    hl["@property"]        = { fg = "#e0b070" }
    hl["@field"]           = { fg = "#e0b070" }
    hl["@punctuation"]     = { fg = "#a0a0a0" }
    hl["@punctuation.bracket"] = { fg = "#a0a0a0" }
    hl["@operator"]        = { fg = "#d75f00" }
    hl["@comment"]         = { link = "Comment" }
    hl["@tag"]             = { fg = c.orange }
    hl["@tag.attribute"]   = { fg = "#ffcc66", italic = true }

    -- diagnostics --------------------------------------------------
    hl.DiagnosticError     = { fg = "#d75f5f" }
    hl.DiagnosticWarn      = { fg = c.orange }
    hl.DiagnosticInfo      = { fg = "#87afaf" }
    hl.DiagnosticHint      = { fg = "#5a8a5a" }
    hl.DiagnosticVirtualTextError = { fg = "#d75f5f", bg = "NONE", italic = true }
    hl.DiagnosticVirtualTextWarn  = { fg = c.orange, bg = "NONE", italic = true }
    hl.DiagnosticVirtualTextInfo  = { fg = "#87afaf", bg = "NONE", italic = true }
    hl.DiagnosticVirtualTextHint  = { fg = "#5a8a5a", bg = "NONE", italic = true }

    -- diff / git ---------------------------------------------------
    hl.DiffAdd             = { bg = "#1c2a14" }
    hl.DiffChange          = { bg = "#2a1f0a" }
    hl.DiffDelete          = { bg = "#2a1414" }
    hl.DiffText            = { bg = "#3a2410", fg = c.orange }
    hl.GitGutterAdd        = { fg = "#87af5f", bg = c.bg }
    hl.GitGutterChange     = { fg = c.orange,  bg = c.bg }
    hl.GitGutterDelete     = { fg = "#d75f5f", bg = c.bg }
    hl.GitSignsAdd         = { fg = "#87af5f" }
    hl.GitSignsChange      = { fg = c.orange }
    hl.GitSignsDelete      = { fg = "#d75f5f" }

    -- completion menu ----------------------------------------------
    hl.Pmenu               = { bg = c.bg_float, fg = c.fg }
    hl.PmenuSel            = { bg = "#3a2410", fg = c.orange, bold = true }
    hl.PmenuSbar           = { bg = "#1c1411" }
    hl.PmenuThumb          = { bg = c.orange }
    hl.CmpItemAbbrMatch    = { fg = c.orange, bold = true }
    hl.CmpItemAbbrMatchFuzzy = { fg = c.orange }
    hl.CmpItemKindFunction = { fg = "#ffaf5f" }
    hl.CmpItemKindKeyword  = { fg = c.orange }
    hl.CmpItemKindVariable = { fg = "#d0d0d0" }

    -- telescope ----------------------------------------------------
    hl.TelescopeBorder         = { fg = c.orange, bg = c.bg_float }
    hl.TelescopePromptBorder   = { fg = c.orange, bg = c.bg_float }
    hl.TelescopeResultsBorder  = { fg = "#2a1f15", bg = c.bg_float }
    hl.TelescopePreviewBorder  = { fg = "#2a1f15", bg = c.bg_float }
    hl.TelescopeTitle          = { fg = c.bg, bg = c.orange, bold = true }
    hl.TelescopePromptTitle    = { fg = c.bg, bg = c.orange, bold = true }
    hl.TelescopeResultsTitle   = { fg = c.bg, bg = c.orange, bold = true }
    hl.TelescopePreviewTitle   = { fg = c.bg, bg = c.orange, bold = true }
    hl.TelescopeSelection      = { bg = "#1f1611", fg = c.orange, bold = true }
    hl.TelescopeMatching       = { fg = c.orange, bold = true }

    -- nvim-tree ----------------------------------------------------
    hl.NvimTreeNormal          = { bg = c.bg_sidebar, fg = c.fg_sidebar }
    hl.NvimTreeNormalNC        = { bg = c.bg_sidebar, fg = c.fg_sidebar }
    hl.NvimTreeFolderName      = { fg = "#d0d0d0" }
    hl.NvimTreeFolderIcon      = { fg = c.orange }
    hl.NvimTreeOpenedFolderName= { fg = c.orange, bold = true }
    hl.NvimTreeEmptyFolderName = { fg = "#5a5a5a", italic = true }
    hl.NvimTreeRootFolder      = { fg = c.orange, bold = true }
    hl.NvimTreeSpecialFile     = { fg = "#ffcc66", underline = false }
    hl.NvimTreeGitDirty        = { fg = c.orange }
    hl.NvimTreeGitNew          = { fg = "#87af5f" }
    hl.NvimTreeGitDeleted      = { fg = "#d75f5f" }
    hl.NvimTreeIndentMarker    = { fg = "#2a1f15" }
    hl.NvimTreeWinSeparator    = { fg = "#2a1f15", bg = "NONE" }

    -- bufferline (also overridden in bufferline.lua) ---------------
    hl.BufferLineFill              = { bg = c.bg_statusline }
    hl.BufferLineBackground        = { bg = c.bg_statusline, fg = "#808080" }
    hl.BufferLineBufferSelected    = { bg = c.bg, fg = c.orange, bold = true, italic = false }
    hl.BufferLineBufferVisible     = { bg = c.bg_statusline, fg = "#a8a8a8" }
    hl.BufferLineIndicatorSelected = { fg = c.orange, bg = c.bg }
    hl.BufferLineSeparator         = { fg = c.bg_statusline, bg = c.bg_statusline }
    hl.BufferLineSeparatorSelected = { fg = c.bg_statusline, bg = c.bg }
    hl.BufferLineModified          = { fg = c.orange, bg = c.bg_statusline }
    hl.BufferLineModifiedSelected  = { fg = c.orange, bg = c.bg }

    -- noice / notify -----------------------------------------------
    hl.NoiceCmdlinePopupBorder        = { fg = c.orange }
    hl.NoiceCmdlinePopupTitle         = { fg = c.orange, bold = true }
    hl.NoiceCmdlineIcon               = { fg = c.orange }
    hl.NoiceCmdlinePopupBorderSearch  = { fg = c.orange }
    hl.NoiceConfirmBorder             = { fg = c.orange }
    hl.NotifyINFOBorder               = { fg = "#87afaf" }
    hl.NotifyWARNBorder               = { fg = c.orange }
    hl.NotifyERRORBorder              = { fg = "#d75f5f" }
    hl.NotifyINFOIcon                 = { fg = "#87afaf" }
    hl.NotifyWARNIcon                 = { fg = c.orange }
    hl.NotifyERRORIcon                = { fg = "#d75f5f" }
    hl.NotifyINFOTitle                = { fg = "#87afaf", bold = true }
    hl.NotifyWARNTitle                = { fg = c.orange, bold = true }
    hl.NotifyERRORTitle               = { fg = "#d75f5f", bold = true }

    -- which-key ----------------------------------------------------
    hl.WhichKey            = { fg = c.orange, bold = true }
    hl.WhichKeyGroup       = { fg = "#ffaf5f" }
    hl.WhichKeyDesc        = { fg = "#d0d0d0" }
    hl.WhichKeySeparator   = { fg = "#5a5a5a" }
    hl.WhichKeyFloat       = { bg = c.bg_float }
    hl.WhichKeyBorder      = { fg = c.orange, bg = c.bg_float }

    -- indent guides (snacks) ---------------------------------------
    hl.SnacksIndent        = { fg = "#1f1f1f" }
    hl.SnacksIndentScope   = { fg = c.orange }

    -- snacks dashboard --------------------------------------------
    -- (tokyonight's default would tint the header blue — pin to orange)
    hl.SnacksDashboardHeader  = { fg = c.orange, bold = true }
    hl.SnacksDashboardFooter  = { fg = "#5a5a5a", italic = true }
    hl.SnacksDashboardTitle   = { fg = c.orange, bold = true }
    hl.SnacksDashboardKey     = { fg = c.orange, bold = true }
    hl.SnacksDashboardDesc    = { fg = "#d0d0d0" }
    hl.SnacksDashboardIcon    = { fg = "#ffaf5f" }
    hl.SnacksDashboardSpecial = { fg = "#ffcc66", italic = true }
    hl.SnacksDashboardDir     = { fg = "#5a5a5a" }
    hl.SnacksDashboardFile    = { fg = "#a8a8a8" }
    hl.SnacksDashboardNormal  = { bg = c.bg, fg = c.fg }
    hl.SnacksNormal           = { bg = c.bg, fg = c.fg }
    hl.SnacksNormalNC         = { bg = c.bg, fg = c.fg }
    hl.SnacksWinBar           = { bg = c.bg, fg = c.orange }
    hl.SnacksWinBarNC         = { bg = c.bg, fg = "#5a5a5a" }

    -- scrollbar ----------------------------------------------------
    hl.ScrollbarHandle     = { bg = "#1f1611" }
    hl.ScrollbarCursor     = { fg = c.orange }
    hl.ScrollbarCursorHandle = { fg = c.orange, bg = "#1f1611" }
    hl.ScrollbarSearch     = { fg = c.orange }
    hl.ScrollbarSearchHandle = { fg = c.orange, bg = "#1f1611" }
  end,
})

-- Apply the colorscheme AFTER setup() so the on_colors / on_highlights
-- overrides actually take effect (otherwise nvim shows the default
-- tokyonight night palette, which has a bluish-purple background #1a1b26).
vim.cmd.colorscheme("tokyonight-night")
