return {
    { 
        "nvim-treesitter/nvim-treesitter",
        version = false,
        config = function()
            require("nvim-treesitter.configs").setup({
                -- A list of parser names, or "all"
                ensure_installed = { 
                    "bash",
                    "c",
                    "diff",
                    "go",
                    "html",
                    "javascript",
                    "jsdoc",
                    "json",
                    "jsonc",
                    "lua",
                    "luadoc",
                    "luap",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "query",
                    "regex",
		       "rust",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "yaml",
                },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = false,

                highlight = {
                    enable = true,
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                  },

                  incremental_selection = {
                      enable = true,
                  }
            }
            )
        end,
    },
    -- Show context of the current function
    {
        "nvim-treesitter/nvim-treesitter-context",
        enabled = true,
        opts = { 
            mode = "cursor", 
            max_lines = 4,
            multiline_threshold = 2, -- Maximum number of lines to show for a single context
        },
    },
}
