return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"benfowler/telescope-luasnip.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<S-k>"] = actions.move_selection_previous, -- move to prev result
						["<S-j>"] = actions.move_selection_next, -- move to next result
						["<S-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		--telescope.load_extension("fzf")
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("luasnip")
		require("telescope").load_extension("ui-select")

		-- Optionally set Telescope as the default vim.ui.select handler
		vim.ui.select = function(...)
			require("telescope").extensions["ui-select"].select(...)
		end

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>fl", "<cmd>Telescope luasnip<cr>", { desc = "Show snippets" })
		keymap.set("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "Show files in buffer" })
		keymap.set(
			"n",
			"<leader>fd",
			"<cmd>Telescope lsp_workspace_symbols<cr>",
			{ desc = "Show classes, methods, vars in current file" }
		)
	end,
}
