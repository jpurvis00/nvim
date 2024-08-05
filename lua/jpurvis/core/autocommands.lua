-- Create an augroup for inactive window settings
local inactive_windows_group = vim.api.nvim_create_augroup("InactiveWindows", { clear = true })

-- Disable cursorline in inactive windows
vim.api.nvim_create_autocmd("WinEnter", {
	group = inactive_windows_group,
	pattern = "*",
	callback = function()
		vim.wo.cursorline = true
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	group = inactive_windows_group,
	pattern = "*",
	callback = function()
		vim.wo.cursorline = false
	end,
})

-- Set highlight for inactive windows
vim.api.nvim_create_autocmd("WinEnter", {
	group = inactive_windows_group,
	pattern = "*",
	callback = function()
		vim.wo.winhighlight = "Normal:Normal"
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	group = inactive_windows_group,
	pattern = "*",
	--callback = function()
	--	vim.wo.winhighlight = "Normal:InactiveWindow"
	--end,
	command = "setlocal winhighlight=Normal:InactiveWindow",
})

-- Define the highlight group for inactive windows
--vim.cmd("highlight InactiveWindow guibg=#1e1e1e")
vim.cmd("highlight InactiveWindow guibg=NONE ctermbg=NONE")
--vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
vim.cmd("highlight NonText guibg=NONE ctermbg=NONE")
