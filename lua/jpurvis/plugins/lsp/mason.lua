return {
	--"williamboman/mason.nvim",
	"mason-org/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"ts_ls",
				--"eslint", --don't believe i need this. redundant with ts_ls for my needs
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"omnisharp",
				"jsonls",
				"sqlls",
				"yamlls",
			},
		})

		mason_tool_installer.setup({
			-- list of tools for mason to install
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"csharpier",
				"sql-formatter",
				--"eslint_d",
				"htmlhint",
				--"typos",
				--"netcoredbg",
				--"firefox-debug-adapter",
				--"chrome-debug-adapter",
			},
		})
	end,
}
