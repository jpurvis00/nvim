vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.nu = true
opt.relativenumber = true
opt.number = true

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
    command! Run execute '!dotnet run'
]])

-- Set the background to transparent
vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
vim.cmd("highlight NonText guibg=NONE ctermbg=NONE")
