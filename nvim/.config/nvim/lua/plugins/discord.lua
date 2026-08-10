local started_at = os.time() - (2 * 60 * 60 + 3 * 60 + 1)
local timestamp_set = false

return {
    "vyfor/cord.nvim",
    opts = {
        display = {
            theme = "minecraft",
        },

        timestamp = {
            enabled = false,
            reset_on_idle = false,
            reset_on_change = false,
        },

        idle = {
            enabled = true,
        },

        hooks = {
            post_activity = function(opts, activity)
                activity.timestamps = {
                    start = started_at,
                }
            end,
        },

        buttons = {
            {
                label = function(opts)
                    return opts.repo_url and "View Repository" or "My Digital Garden :3"
                end,
                url = function(opts)
                    return opts.repo_url or "https://howosec.com"
                end,
            },
        },

        text = {
            editing = function(opts)
                local path = vim.fn.fnamemodify(opts.filename, ":.")

                if opts.workspace_dir then
                    path = vim.fs.relpath(opts.workspace_dir, opts.filename) or path
                end

                return "Editing " .. path
            end,

            viewing = function(opts)
                local path = vim.fn.fnamemodify(opts.filename, ":.")

                if opts.workspace_dir then
                    path = vim.fs.relpath(opts.workspace_dir, opts.filename) or path
                end

                return "Viewing " .. path
            end,
        },
    },
}
