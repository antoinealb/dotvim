-- General keymaps
local map = vim.keymap.set

-- Escape insert mode quickly
map("i", "jk", "<Esc>", { silent = true })

-- Clear search highlight on Enter
map("n", "<CR>", ":noh<CR><CR>", { silent = true })
