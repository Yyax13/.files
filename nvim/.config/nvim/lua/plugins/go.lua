return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()

            require("mason-lspconfig").setup({
                ensure_installed = { "gopls" },
            })

            local lspconfig = require("lspconfig")

            lspconfig.gopls.setup({
                settings = {
                    gopls = {
                        gofumpt = true,
                        staticcheck = true,
                        analyses = {
                            unusedparams = true,
                            shadow = true,
                        },
                    },
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "go",
                "gomod",
                "gowork",
                "gosum",
            },
        },
    },

    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                go = { "goimports", "gofumpt" },
            },

            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    },

    {
        "mfussenegger/nvim-dap",
    },

    {
        "leoluz/nvim-dap-go",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("dap-go").setup()
        end,
    },
}
