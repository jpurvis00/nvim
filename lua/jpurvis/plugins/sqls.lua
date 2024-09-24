return {
	"nanotee/sqls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("SqlsConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Run Query"
				keymap.set("n", "<leader>rq", "<cmd>SqlsExecuteQuery<CR>", opts)

				opts.desc = "Run Query Vertical"
				keymap.set("n", "<leader>rv", "<cmd>SqlsExecuteQueryVertical<CR>", opts)

				opts.desc = "Show Databases"
				keymap.set("n", "<leader>sdb", "<cmd>SqlsShowDatabases<CR>", opts)

				opts.desc = "Show Connections"
				keymap.set("n", "<leader>sdbc", "<cmd>SqlsShowConnections<CR>", opts)

				opts.desc = "Switch Databases"
				keymap.set("n", "<leader>swd", "<cmd>SqlsSwitchDatabase<CR>", opts)

				opts.desc = "Switch Connections"
				keymap.set("n", "<leader>swc", "<cmd>SqlsSwitchConnection<CR>", opts)

				opts.desc = "Show Schemas"
				keymap.set("n", "<leader>ss", "<cmd>SqlsShowSchemas<CR>", opts)

				opts.desc = "Show Tables"
				keymap.set("n", "<leader>st", "<cmd>SqlsShowTables<CR>", opts)
			end,
		})
	end,
}
