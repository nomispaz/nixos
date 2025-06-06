require "config.snippets"

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local lspkind = require "lspkind"
lspkind.init {}

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup {
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
    { name = "orgmode" },
  },
  mapping = cmp.mapping.preset.insert ({
           ["<c-k>"] = cmp.mapping(function(fallback)
           if luasnip.expand_or_jumpable() then
             luasnip.expand_or_jump()
           else
             fallback()
           end
         end, { "i", "s" }),
         ["<c-e>"] = cmp.mapping.abort(),
         ["<CR>"] = cmp.mapping.confirm({ select=true }),
        }),
}
