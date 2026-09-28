return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>ct", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    { "<leader>cT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
  },
  config = function(_, opts)
    require("todo-comments").setup(opts)
    -- The stock `:TodoTelescope` command (plugin/todo.vim) hard-codes the
    -- Telescope picker: `:Telescope todo-comments todo`. This config uses the
    -- Snacks picker (telescope.nvim is not installed), so rebind the command.
    vim.api.nvim_create_user_command("TodoTelescope", function(cmd)
      local keywords = cmd.args:match("keywords=([%w,]+)")
      Snacks.picker.todo_comments(keywords and { keywords = vim.split(keywords, ",") } or {})
    end, { force = true, desc = "Todo comments (Snacks)", nargs = "*" })
  end,
}