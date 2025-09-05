return {
	--adding context/files for reference
	--#file:(then this ctrl+f to open the file picker. ctrl+f if mapped below)
	--#files: no longers exists in version 4, use #glob: instead.
	--ex. #glob:src/app/**/*.tsx list all files
	--ex. #glob:src/app/**/*.tsx give a brief overview of all files
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			-- See Configuration section for options
			mappings = {
				-- Use tab for completion
				complete = {
					detail = "Use @<Tab> or /<Tab> for options.",
					insert = "<C-f>",
				},
			},
			window = {
				--layout = "float",
				width = 90, -- Fixed width in columns
				--height = 50, -- Fixed height in rows
				border = "rounded", -- 'single', 'double', 'rounded', 'solid'
				title = "🤖 AI Assistant",
				zindex = 100, -- Ensure window stays on top
				--col = 120, -- Move window 40 columns from the left
			},

			headers = {
				user = "👤 Jefferson",
				assistant = "🤖 Copilot",
				tool = "🔧 Tool",
			},

			separator = "━━",
			auto_fold = true, -- Automatically folds non-assistant messages
		},
		keys = {
			-- Custom input for CopilotChat
			-- {
			-- 	"<leader>cpi",
			-- 	function()
			-- 		local input = vim.fn.input("Ask Copilot: ")
			-- 		if input ~= "" then
			-- 			vim.cmd("CopilotChat " .. input)
			-- 		end
			-- 	end,
			-- 	desc = "CopilotChat - Ask input",
			-- },
			-- Generate commit message based on the git diff
			{
				"<leader>am",
				"<cmd>CopilotChatCommit<cr>",
				desc = "CopilotChat - Generate commit message for all changes",
			},
			{
				"<leader>aM",
				"<cmd>CopilotChatCommitStaged<cr>",
				desc = "CopilotChat - Generate commit message for staged changes",
			},
			-- Quick chat with Copilot
			{
				"<leader>cpq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						vim.cmd("CopilotChatBuffer " .. input)
					end
				end,
				desc = "CopilotChat - Quick chat",
			},
			-- Fix the issue with diagnostic
			{ "<leader>cpf", ":CopilotChatFix<cr>", mode = "v", desc = "CopilotChat - Fix Diagnostic" },
			-- Toggle Copilot Chat Vsplit
			{ "<leader>cpo", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
			-- Copilot Chat Models
			{ "<leader>c?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
			{ "<leader>cpe", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Explain Code" },
			{ "<leader>cpI", ":CopilotChat<CR>", mode = "v", desc = "Chat with Copilot" },
			{ "<leader>cpR", ":CopilotChatRename<CR>", mode = "v", desc = "Rename the variable" },
			{ "<leader>cpr", ":CopilotChatReview<CR>", mode = "v", desc = "Review code" },
			{ "<leader>cpO", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize code" },
			{ "<leader>cpD", ":CopilotChatDocs<CR>", mode = "v", desc = "Generate docs" },
		},
	},
}
