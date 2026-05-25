-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require('lspconfig')

-- Mason setup
require("mason").setup()
-- require("mason-lspconfig").setup()

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {
  'clangd',
  'metals',
  'pylyzer',
  'ts_ls',
  'marksman',
  'bashls',
  'gopls',
  'lua_ls',
  'rust_analyzer',
  'cssls',
  'jsonls',
  'just',
  'tinymist',
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
-- on_attach = true,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
}


-- [Adding other filetypes](https://github.com/neovim/nvim-lspconfig/issues/3186)
lspconfig.ltex.setup({
  capabilities = capabilities,
  filetypes = { "latex", "typst", "typ", "bib", "markdown", "plaintex", "tex" },
  settings = {
    ltex = {
      enabled = { "latex", "typst", "typ", "bib", "markdown", "plaintex", "tex" },
    }
  }
})
