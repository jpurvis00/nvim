vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })
keymap.set("n", "qq", ":wq<CR>", { desc = "Save file and quit with qq" })
keymap.set("n", "ww", ":w<CR>", { desc = "Save file with ww" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- open terminal window in horizontal split
keymap.set("n", "<leader>term", "<cmd>split | term<CR>", { desc = "Open terminal window in horizontal split" })

-- turn on/off copilot
keymap.set("n", "<leader>cpd", "<cmd>Copilot disable<CR>", { desc = "Copilot - disable" })
keymap.set("n", "<leader>cpe", "<cmd>Copilot enable<CR>", { desc = "Copilot - enable" })

keymap.set("n", "<leader>r", "<cmd>Run<CR>", { desc = "Run C# Program" }) -- Run is defined in options.lua
keymap.set("n", "<leader>db", "<cmd>Debug<CR>", { desc = "Debug C# Program - DAP" }) -- Debug is defined in options.lua

-- Reloads lua files so changes take effect without having to restart neovim
keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "Source current file" })
keymap.set("n", "<space>x", ":.lua<CR>", { desc = "Execute current file" })
keymap.set("v", "<space>x", ":lua<CR>", { desc = "Execute selected text/line" })

-- Highlight when yanking (copying) text
--   Try it with 'yap' (yank a paragraph) or 'yiw' (yank inner word) in normal mode
--   See ':help vim.highlght.on_yank()'
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlihgt-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
