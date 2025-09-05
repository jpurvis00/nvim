vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.nu = true
opt.relativenumber = true
opt.number = true

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99

-- tabs and indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.textwidth = 100
opt.wrap = true

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

-- turn on termgui colors for tokyonight colorscheme to work
-- (have to use a true color terminal)
opt.termguicolors = true

--opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as defaul register

-- split window
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the right

opt.colorcolumn = "0"

opt.scrolloff = 10 -- keep 8 lines above and below the cursor

--opt.winblend = 100

vim.cmd([[
    command! Debug execute '!dotnet build' | call luaeval("require'dap'.continue()")
]])

vim.cmd([[
  highlight DiagnosticUnnecessary guifg=#767ea3
]])

-- Set colors for diagnostics and comments to go better for my sight. Diagnostic color was blending
-- in with image background and I wanted comments to be brighter.
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#767ea3" })
		vim.api.nvim_set_hl(0, "Comment", { fg = "#aef7a6" })
	end,
})

-- Set the background to transparent
vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
vim.cmd("highlight NonText guibg=NONE ctermbg=NONE")
-- not working, trying to set the color of the fold method line vim.cmd("highlight Folded guifg=#A9B1D6 guibg=#1F2335")

-- vim.cmd([[
--     command! Run execute '!dotnet run'
-- ]])

vim.cmd([[
    command! Run lua require('jpurvis.core.options').run_in_popup()
]])

local M = {}

function M.run_in_popup()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = vim.o.columns
	local height = vim.o.lines
	local win_height = math.ceil(height * 0.9)
	local win_width = math.ceil(width * 0.75)
	local row = math.ceil((height - win_height) / 2)
	local col = math.ceil((width - win_width) / 2)

	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		border = "single",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })

	vim.fn.termopen("dotnet run")

	--vim.fn.termopen("dotnet run", {
	--	on_exit = function()
	--		vim.api.nvim_win_close(win, true)
	--	end,
	--})
end

return M
