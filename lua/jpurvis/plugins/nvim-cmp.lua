return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"hrsh7th/cmp-cmdline", -- Cmdline source for nvim-cmp
		"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			--build = "make install_jsregexp",
		},
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
		--"kristijanhusak/vim-dadbod-completion", -- completion for vim-dadbod
	},
	config = function()
		local cmp = require("cmp")

		local luasnip = require("luasnip")

		vim.keymap.set({ "i" }, "<C-k>", function()
			luasnip.expand()
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-l>", function()
			luasnip.jump(1)
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			luasnip.jump(-1)
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-e>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			end
		end, { silent = true })

		local lspkind = require("lspkind")

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-a>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
				{ name = "cmdline" }, -- command-line mode
				{ name = "sqlls" }, -- completion for vim-dadbod
				--{ name = "csharp_ls" },
				--{ name = "dbui" }, -- completion for vim-dadbod
			}),
			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
				}),
				expandable_indicator = false,
			},
			-- setup vim-dadbod
			--cmp.setup.filetype({ "sql" }, {
			--filetype = {
			--	{ "sql" },
			--	sources = {
			--		{ name = "vim-dadbod-completion" },
			--		{ name = "buffer" },
			--	},
			--},
		})

		local function setup_cmp()
			-- Setup for '/' and '?' (search mode)
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
		end
		-- Setup for ':' (command-line mode)
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
			matching = { disallow_symbol_nonprefix_matching = false },
		})
		setup_cmp()
	end,
}
