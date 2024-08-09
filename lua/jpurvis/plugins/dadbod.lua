return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dotenv", lazy = true },
			{ "tpope/vim-dadbod", lazy = true },
			--{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_winwidth = 30
			vim.g.db_ui_show_help = 0
			vim.g.db_ui_use_nvim_notify = 1
			vim.g.db_ui_win_position = "left"
			-- Set's up the Count option under a table in dadbod-ui
			-- that will auto display the below query
			vim.g.db_ui_table_helpers = {
				sqlserver = {
					Count = "select count(*) from {optional_schema}{table}",
				},
			}
			vim.g.db_ui_execute_table_helpers = 1
			vim.g.db_ui_disable_mappings_dbout = 1
			vim.g.db_ui_winwidth_dbout = 150
			--require("which-key").register({
			local wk = require("which-key")
			wk.add({
				{ "<leader>D", group = "󰆼 Db Tools" },
				{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = " DB UI Find buffer" },
				{ "<leader>Dl", "<cmd>DBUILastQueryInfo<cr>", desc = " DB UI Last query infos" },
				{ "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = " DB UI Rename buffer" },
				{ "<leader>Du", "<cmd>DBUIToggle<cr>", desc = " DB UI Toggle" },
				--`["<leader>D"] = {
				--`	name = "󰆼 Db Tools",
				--`	u = { "<cmd>DBUIToggle<cr>", " DB UI Toggle" },
				--`	f = { "<cmd>DBUIFindBuffer<cr>", " DB UI Find buffer" },
				--`	r = { "<cmd>DBUIRenameBuffer<cr>", " DB UI Rename buffer" },
				--`	l = { "<cmd>DBUILastQueryInfo<cr>", " DB UI Last query infos" },
				--`},
			})
		end,
	},
}
