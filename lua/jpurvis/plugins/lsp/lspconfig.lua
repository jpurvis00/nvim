return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"nanotee/sqls.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")
		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap -- for conciseness
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }
				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})
		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		mason_lspconfig.setup({
			ensure_installed = { "emmet_ls", "html", "lua_ls", "omnisharp", "ts_ls", "sqls" },
			handlers = {
				-- default handler for installed servers
				function(server_name)
					vim.lsp.start({
						name = server_name,
						capabilities = capabilities,
					})
				end,
				["emmet_ls"] = function()
					-- configure emmet language server
					vim.lsp.start({
						name = "emmet_ls",
						capabilities = capabilities,
						filetypes = {
							"html",
							"typescriptreact",
							"javascriptreact",
							"typescript",
							"javascript",
							"css",
							"sass",
							"scss",
							"less",
							"svelte",
						},
					})
				end,
				["html"] = function()
					-- configure html language server
					vim.lsp.start({
						name = "html",
						capabilities = capabilities,
						cmd = { "vscode-html-language-server", "--stdio" },
						filetypes = {
							"html",
							"templ",
							"ejs",
						},
						init_options = {
							configurationSection = { "html", "css", "javascript" },
							embeddedLanguages = {
								css = true,
								javascript = true,
							},
						},
					})
				end,
				["lua_ls"] = function()
					-- configure lua server (with special settings)
					vim.lsp.start({
						name = "lua_ls",
						capabilities = capabilities,
						settings = {
							Lua = {
								-- make the language server recognize "vim" global
								diagnostics = {
									globals = { "vim" },
								},
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					})
				end,
				["omnisharp"] = function()
					vim.lsp.start({
						name = "omnisharp",
						capabilities = capabilities,
						cmd = {
							"omnisharp",
							"--languageserver",
							"--hostPID",
							tostring(vim.fn.getpid()),
							"UseModernNet",
							"true",
						},
						root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln"),
						enable_editor_config_support = true,
						enable_import_completion = true,
						organize_imports_on_format = true,
						enable_roslyn_analyzers = true,
						settings = {
							diagnostics = {
								display = {
									width = 80, -- Set this to a value that fits your screen
								},
							},
							["omnisharp.formattingOptions"] = {
								NewLine = "\n",
								UseTabs = false,
								TabSize = 4,
								IndentationSize = 4,
								NewLinesForBracesInTypes = true,
								NewLinesForBracesInMethods = true,
								NewLinesForBracesInProperties = true,
								NewLinesForBracesInAccessors = true,
								NewLinesForBracesInAnonymousMethods = true,
								NewLinesForBracesInControlBlocks = true,
								NewLinesForBracesInAnonymousTypes = true,
								NewLinesForBracesInObjectCollectionArrayInitializers = true,
								NewLinesForBracesInLambdaExpressionBody = true,
								NewLineForElse = true,
								NewLineForCatch = true,
								NewLineForFinally = true,
								NewLineForMembersInObjectInit = true,
								NewLineForMembersInAnonymousTypes = true,
								NewLineForClausesInQuery = true,
								WrapLongLines = true, -- Enable line wrapping
							},
						},
					})
				end,
				["ts_ls"] = function()
					vim.lsp.start({
						name = "ts_ls",
						capabilities = capabilities,
					})
				end,
				["sqls"] = function()
					vim.lsp.start({
						name = "sqls",
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							require("sqls").on_attach(client, bufnr) -- require sqls.nvim
						end,
					})
				end,
			},
		})

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			virtual_text = true, -- Add this line to enable inline diagnostics
		})
	end,
}
