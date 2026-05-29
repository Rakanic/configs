
-- Initialize lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  'nvim-lua/plenary.nvim',
  { 'nvim-telescope/telescope.nvim', tag = '0.1.4' },
  'folke/tokyonight.nvim',
  'andymass/vim-matchup',
  'machakann/vim-highlightedyank',
  'junegunn/vim-slash',
  'nvim-lualine/lualine.nvim',
  'akinsho/bufferline.nvim',
  'famiu/bufdelete.nvim',
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',
  'rcarriga/nvim-notify',
  'petertriho/nvim-scrollbar',
  'airblade/vim-gitgutter',
  'akinsho/git-conflict.nvim',
  'tpope/vim-fugitive',
  'junegunn/gv.vim',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'scalameta/nvim-metals',
  'L3MON4D3/LuaSnip',
  'NoahTheDuke/vim-just',
  'chrisbra/vim-commentary',
  'stevearc/stickybuf.nvim',
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = { "LazyGit", },
    dependencies = { "nvim-lua/plenary.nvim", },
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      direction = 'float',
      start_in_insert = true,
      insert_mappings = true,
    }
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    opts = {},
  },
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   build = "cd app && yarn install",
  --   init = function()
  --     vim.g.mkdp_filetypes = { "markdown" }
  --   end,
  --   ft = { "markdown" },
  -- },
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    opts = {},
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
})

-- General Settings
vim.cmd [[
  syntax on
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set expandtab
  set colorcolumn=79
  set listchars=tab:>·,trail:~,extends:>,precedes:<
  set list
  set background=dark
  set backspace=indent,eol,start
  set nowrap
  set number
  set relativenumber
  set showcmd
  set cursorline
  set showmatch
  set wildmenu
  set updatetime=100
  set ttyfast
  set mouse+=a
  set encoding=utf-8
  set ttimeout
  set ttimeoutlen=50
  set clipboard=unnamedplus
  filetype indent on
  filetype plugin on
  let g:python_recommended_style=0
  set incsearch
  set hlsearch
  set ignorecase
  set smartcase
  set shortmess-=F
  set noshowmode
  set laststatus=2
  set hidden
  set autowrite
  set termguicolors
  set foldmethod=manual
  set scrolloff=4
  set sidescrolloff=8
  set pumblend=10
  set winblend=0
  set fillchars=eob:\ ,vert:│,fold:·,foldopen:▾,foldclose:▸,horiz:─
  set signcolumn=yes
]]
-- NOTE: colorscheme is applied at the bottom of lua/user/tokyonight.lua,
-- AFTER setup() runs, so the on_colors palette override actually wins.

-- Termdebug configuration
vim.cmd [[
  packadd termdebug
  let g:termdebug_wide=1
  let g:termdebug_leftsource = 1
  let g:termdebug_focussource = 1
  let g:termdebug_disable_toolbar = 1
  hi debugPC term=reverse ctermbg=8 guibg=darkblue
" change termdebug path
]]

-- disable netrw at the very start of your init.lua (for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- disable gitgutter from nvimtree buffers
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "NvimTree_*",
  command = "GitGutterBufferDisable",
})

-- Conflict marker settings
vim.g.conflict_marker_enable_mappings = 0
vim.g.conflict_marker_enable_matchit = 0

-- ColorColumn is themed in user/tokyonight.lua (warm dark tint).
-- Border style for all LSP floats (rounded, matches noice/which-key).
local _orig_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return _orig_open_floating_preview(contents, syntax, opts, ...)
end

vim.diagnostic.config({
  virtual_text = { prefix = "▎", spacing = 2 },
  float        = { border = "rounded" },
  signs        = true,
  underline    = true,
  severity_sort= true,
})

-- Orange-tinted gutter signs for diagnostics.
for type, icon in pairs({ Error = " ", Warn = " ", Hint = " ", Info = " " }) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

 -- run the 'open' command on the current buffer
vim.api.nvim_create_user_command('Rfinder',
 function()
   local path = vim.api.nvim_buf_get_name(0)
   local path_format =  string.format('%q', path)
   os.execute('open ' .. path_format)
 end,
 {}
)

--------------------------------------------------------------
-- Key mappings
--------------------------------------------------------------

-- Leader key
vim.g.mapleader = ' '

-- Faster scroll
vim.api.nvim_set_keymap('n', '<C-e>', '10<C-e>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-y>', '10<C-y>', { noremap = true, silent = true })

-- termdebug exit terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Better window navigation
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- move btw buffers
vim.api.nvim_set_keymap('n', '<Tab>',   ':bnext<CR>',     { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

-- LSP Mappings
local opts = { buffer = bufnr, noremap = true, silent = true }
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)

vim.notify = require("notify")

-- OSC52 clipboard when SSH'd in: nvim emits the clipboard contents as a
-- terminal escape sequence, and iTerm2 / tmux (with set-clipboard on) forward
-- it to the macOS clipboard. Without this, `clipboard=unnamedplus` silently
-- drops yanks on remote hosts that have no pbcopy/xclip.
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name  = "OSC 52",
    copy  = { ["+"] = osc52.copy("+"),  ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end

--------------------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------------------
require "user.tokyonight"  -- load theme first so other modules pick up palette
require "user.telescope"
require "user.metals"
require "user.lsp"
require "user.bufferline"
require "user.nvimtree"
require "user.noice"
require "user.snacks"
require "user.lualine"

require("scrollbar").setup({
  handle      = { color = "#1f1611" },
  marks = {
    Cursor   = { color = "#ff8700" },
    Search   = { color = "#ff8700" },
    Error    = { color = "#d75f5f" },
    Warn     = { color = "#ff8700" },
    Info     = { color = "#87afaf" },
    Hint     = { color = "#5a8a5a" },
    GitAdd   = { color = "#87af5f" },
    GitChange= { color = "#ff8700" },
    GitDelete= { color = "#d75f5f" },
  },
  excluded_filetypes = { "NvimTree", "noice", "snacks_dashboard", "lazy", "mason", "TelescopePrompt" },
})

-- Match vim-highlightedyank to our orange theme.
vim.g.highlightedyank_highlight_duration = 180
vim.api.nvim_set_hl(0, "HighlightedyankRegion", { bg = "#3a2410", fg = "#ff8700", bold = true })

local wk = require("which-key")
wk.add({
  -- Grep
  { "<leader>/",  function() Snacks.picker.grep() end,        desc = "Grep",                        mode = "n" },
  -- Find
  { "<leader>f", group = "find" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>",            desc = "Find File",                   mode = "n" },
  { "<leader>fw", "<cmd>Telescope live_grep<cr>",             desc = "Find Words",                  mode = "n" },
  { "<leader>fg", "<cmd>Telescope grep_string<cr>",           desc = "Find Word Under Cursor",      mode = "n" },
  { "<leader>fb", function() Snacks.picker.buffers() end,     desc = "Find buffers",                mode = "n" },
  -- Buffer
  { "<leader>b", group = "buffer" },
  { "<leader>bd", ":Bdelete<cr>",                             desc = "Bdelete",                     mode = "n" },
  { "<leader>bp", ":BufferLineTogglePin<cr>",                 desc = "Buffer (Un)Pin",              mode = "n" },
  -- git
  { "<leader>g", group = "git" },
  { "<leader>gg", ":LazyGit<cr>", desc = "Open LazyGit" },
  { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
  { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
  { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
  { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
  { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
  { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
  { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
  -- terminal
  { "<leader>t", ":ToggleTerm<cr>", desc = "Toggle terminal" },
  -- save
  { "<leader>s", ":w<cr>", desc = "Save changes" },
  -- Markdown and other writing
  { "<leader>m", group = "Markup languages (markdown, typst...)" },
  { "<leader>mr", ":RenderMarkdown<cr>",                      desc = "Enable markdown render",      mode = "n" },
  { "<leader>md", ":RenderMarkdown disable<cr>",              desc = "Disable markdown render",     mode = "n" },
  { "<leader>mp", ":MarkdownPreview<cr>",                     desc = "Preview markdown in browser", mode = "n" },
  -- Refactor
  { "<leader>r", group = "refactor" },
  { "<leader>rn", vim.lsp.buf.rename, desc = "Rename using LSP", mode = "n" },
  { "<leader>rs", ":s/",              desc = "Rename regex",     mode = "v" },
  -- LSP
  { "<leader>l", group = "LSP" },
  { "<leader>la", function() vim.lsp.buf.code_action() end, desc = "LSP Code Actions", mode = "n" },
  { "<leader>lm", ":Mason<cr>",       desc = "Open Mason",       mode = "n" },
  { "<leader>ls", ":LspStart<cr>",    desc = "Start server",     mode = "n" },
  { "<leader>lx", ":LspStop<cr>",     desc = "Stop server",      mode = "n" },
  { "<leader>lr", ":LspRestart<cr>",  desc = "Restart server",   mode = "n" },
  { "<leader>li", ":LspInfo<cr>",     desc = "LSP info",         mode = "n" },
  { "<leader>lu", ":LspUninstall",    desc = "Uninstall LSP",    mode = "n" },
  -- ai
  { "<leader>a", group = "ai" },
  { "<leader>ac", ":CodeCompanionChat<cr>", desc = "Chat with AI" },
  { "<leader>aa", ":CodeCompanionAction<cr>", desc = "Open actions pane to interact with AI" },
  -- etc
  { "<leader>o",  ":Rfinder<cr>",                             desc = "Mac \"open\" on the buffer",  mode = "n" },
  { "<leader>e",  "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Show diagnostic",             mode = "n" },
  { "<leader>x",  ":NoiceDismiss<cr>",                        desc = "Dismiss noice messages",      mode = "n" },
  { "<leader>h", hidden = true }, -- hide this keymap
})

