return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},

    keys = {
        {
            "<leader>tt",
            function()
                Snacks.picker.todo_comments({ keywords = { "TODO" } })
            end,
            desc = "Todo",
        },

        {
            "<leader>tf",
            function()
                Snacks.picker.todo_comments({
                    keywords = { "TODO", "FIX", "FIXME" },
                })
            end,
            desc = "Todo / Fix / Fixme",
        },

        {
            "<leader>tn",
            function()
                Snacks.picker.todo_comments({ keywords = { "NOTE" } })
            end,
            desc = "Notes",
        },

        {
            "<leader>ta",
            function()
                Snacks.picker.todo_comments()
            end,
            desc = "All annotations",
        },
    },

    config = function(_, opts)
        require("todo-comments").setup(opts)

        vim.api.nvim_create_user_command("TodoTelescope", function(cmd)
            local keywords = cmd.args:match("keywords=([%w,]+)")
            Snacks.picker.todo_comments(keywords and { keywords = vim.split(keywords, ",") } or {})
        end, {
            force = true,
            desc = "Todo comments (Snacks)",
            nargs = "*",
        })
    end,
}
