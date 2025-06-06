return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim"
    },
    opts = {
		inlay_hints = { enabled = true },
    },
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    require('mason').setup()
    local mason_lspconfig = require 'mason-lspconfig'
    mason_lspconfig.setup {
       --ensure_installed = { "pylsp", "marksman", "gopls", "rust_analyzer" }
    }
    --require("lspconfig").pyright.setup {
    --    capabilities = capabilities,
    --}
    require("lspconfig").pylsp.setup{
        settings ={
            pylsp = {
                plugins = {
                    pyflakes = { enabled = true,
                                 maxLineLength = 200},
                    black = { enabled = true },
                    pylsp_mypy = { enabled = true },
                    pycodestyle = {
			 maxLineLength = 200,
                    },
                    --jedi_completion = { fuzzy = true },
                }
            }
        }
    }

    require("lspconfig").gopls.setup{
	cmd = {'gopls'},
	-- for postfix snippets and analyzers
	capabilities = capabilities,
	    settings = {
	      gopls = {
		      experimentalPostfixCompletions = true,
		      analyses = {
		        unusedparams = true,
		        shadow = true,
		     },
		     staticcheck = true,
                   gofumpt = true,
                   usePlaceholders = true,
		    },
	    },
	on_attach = on_attach,
    }

    require("lspconfig").rust_analyzer.setup {
    settings = {
        ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        -- Add clippy lints for Rust.
        checkOnSave = true,
        procMacro = {
          enable = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },        
	  },
    },
    }
    }

    require("lspconfig").marksman.setup {
        capabilities = capabilities,
    }
    require("lspconfig").rust_analyzer.setup {
        capabilities = capabilities,
    }

    require("lspconfig").nixd.setup {
        capabilities = capabilities,
    }



  end
}
