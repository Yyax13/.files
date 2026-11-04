-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

-- Quick Exit
map("n", "<leader>q", function()
    vim.cmd("confirm %bd")
    require("snacks").dashboard.open()
end, { desc = "Restart to Dashboard" })

local modes = { "n", "v", "s", "i" }

-- Alt + Arrows: viewport scrolling (1)
map(modes, "<A-Up>", "1<C-y>", { desc = "Scroll Up" })
map(modes, "<A-Down>", "1<C-e>", { desc = "Scroll Down" })

map(modes, "<A-Left>", "1zh", { desc = "Scroll Left" })
map(modes, "<A-Right>", "1zl", { desc = "Scroll Right" })

-- Shift + Alt + Up/Down: viewport scrolling (2)
map(modes, "<A-S-Up>", "2<C-y>", { desc = "Scroll Up (3)" })
map(modes, "<A-S-Down>", "2<C-e>", { desc = "Scroll Down (3)" })

-- Ctrl + Arrows: cursor movement (9)
map(modes, "<C-Up>", "9k", { desc = "Move Up (9 lines)" })
map(modes, "<C-Down>", "9j", { desc = "Move Down (9 lines)" })

-- Buffer change
map("n", "<S-z>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-x>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
