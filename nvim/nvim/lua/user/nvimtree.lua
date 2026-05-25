require("nvim-tree").setup {
  filters = {
    dotfiles = false,
    custom   = {},
  },
  git = {
    ignore = false,
  },
  view = {
    width                  = 32,
    side                   = "left",
    signcolumn             = "yes",
    preserve_window_proportions = true,
  },
  renderer = {
    root_folder_label = function(path)
      return "  " .. vim.fn.fnamemodify(path, ":t")
    end,
    highlight_git              = true,
    highlight_opened_files     = "name",
    highlight_modified         = "name",
    indent_width               = 2,
    group_empty                = true,
    indent_markers = {
      enable      = true,
      inline_arrows = true,
      icons = {
        corner  = "└",
        edge    = "│",
        item    = "│",
        bottom  = "─",
        none    = " ",
      },
    },
    icons = {
      show = { file = true, folder = true, folder_arrow = true, git = true },
      glyphs = {
        default  = "",
        symlink  = "",
        bookmark = "",
        modified = "●",
        folder = {
          arrow_closed = "",
          arrow_open   = "",
          default      = "",
          open         = "",
          empty        = "",
          empty_open   = "",
          symlink      = "",
          symlink_open = "",
        },
        git = {
          unstaged  = "●",
          staged    = "✓",
          unmerged  = "",
          renamed   = "➜",
          untracked = "★",
          deleted   = "",
          ignored   = "◌",
        },
      },
    },
  },
  diagnostics = {
    enable      = true,
    show_on_dirs = true,
    icons = { hint = "", info = "", warning = "", error = "" },
  },
  actions = {
    open_file = {
      quit_on_open = false,
      window_picker = { enable = false },
    },
  },
  on_attach = function(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    api.config.mappings.default_on_attach(bufnr)

    -- NERDTree-like mappings (preserved exactly)
    vim.keymap.set("n", "o", api.node.open.edit,        opts("Open"))
    vim.keymap.set("n", "p", api.node.navigate.parent,  opts("Go to Parent"))
    vim.keymap.set("n", "r", api.tree.reload,           opts("Refresh"))

    -- Preserve original <C-e> unmap (it's the scroll keymap)
    vim.keymap.del("n", "<C-e>", { buffer = bufnr })
  end,
}
