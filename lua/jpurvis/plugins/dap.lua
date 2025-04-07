return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"nvim-treesitter/nvim-treesitter",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")

		require("nvim-dap-virtual-text").setup({
			enabled = true, -- enable this plugin (the default)
			enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
			highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
			highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
			show_stop_reason = true, -- show stop reason when stopped for exceptions
			commented = false, -- prefix virtual text with comment string
			only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
			all_references = true, -- show virtual text on all all references of the variable (not only definitions)
			clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
			--- A callback that determines how a variable is displayed or whether it should be omitted
			--- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
			--- @param buf number
			--- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
			--- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
			--- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
			--- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
			display_callback = function(variable, buf, stackframe, node, options)
				-- by default, strip out new line characters
				if options.virt_text_pos == "inline" then
					return " = " .. variable.value:gsub("%s+", " ")
				else
					return variable.name .. " = " .. variable.value:gsub("%s+", " ")
				end
			end,
			-- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
			virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

			-- experimental features:
			all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
			virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
			virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
			-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
		})

		dap.adapters.coreclr = {
			type = "executable",
			--command = "C:/Users/jeffp/AppData/Local/netcoredbg/netcoredbg",
			command = "C:/Users/jeffp/AppData/Local/nvim-data/mason/packages/netcoredbg/netcoredbg/netcoredbg",
			args = { "--interpreter=vscode" },
		}
		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "launch - netcoredbg",
				request = "launch",
				program = function()
					--return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net6.0/", "file")

					-- The following will look in the root dir of the solution for the csproj file.
					-- It the extracts just the name and uses that to find the dll in the bin folder
					-- to automatically start the debug process. With the two lines above, you would
					-- have to manually enter the path to the dll everytime you started it.
					-- This will have to change based on the project version(ie. net6.0, net7.0, etc.)

					-- Get the csproj file in the current directory, returns the entire path with
					-- file name
					local csproj_file = vim.fn.glob(vim.fn.getcwd() .. "/*.csproj")

					-- Get just the name of the project, remoove the .csproj extension and the dir
					-- path
					local project_name = vim.fn.fnamemodify(csproj_file, ":t:r")

					-- Defines our dir structure depending on what version of .net we are using
					local path6 = vim.fn.getcwd() .. "/bin/Debug/net6.0/" .. project_name .. ".dll"
					local path7 = vim.fn.getcwd() .. "/bin/Debug/net7.0/" .. project_name .. ".dll"
					local path8 = vim.fn.getcwd() .. "/bin/Debug/net8.0/" .. project_name .. ".dll"
					local path9 = vim.fn.getcwd() .. "/bin/Debug/net9.0/" .. project_name .. ".dll"

					-- Check if the directory exists and return the path to the dll
					if vim.fn.isdirectory(vim.fn.getcwd() .. "/bin/Debug/net6.0") == 1 then
						return path6
					elseif vim.fn.isdirectory(vim.fn.getcwd() .. "/bin/Debug/net7.0") == 1 then
						return path7
					elseif vim.fn.isdirectory(vim.fn.getcwd() .. "/bin/Debug/net8.0") == 1 then
						return path8
					elseif vim.fn.isdirectory(vim.fn.getcwd() .. "/bin/Debug/net9.0") == 1 then
						return path9
					else
						return nil -- or handle the case where none of the directories exist
					end
				end,
				autoReload = {
					enable = true,
				},
			},
		}

		vim.api.nvim_set_keymap("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(
			"n",
			"<F10>",
			"<Cmd>lua require'dap'.step_over()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<F11>",
			"<Cmd>lua require'dap'.step_into()<CR>",
			{ noremap = true, silent = true }
		)
		--vim.api.nvim_set_keymap('n', '<F11>', "<Cmd>lua print('F11 pressed') require'dap'.step_into()<CR>", { noremap = true, silent = true })

		vim.api.nvim_set_keymap("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(
			"n",
			"<leader>b",
			"<Cmd>lua require'dap'.toggle_breakpoint()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>B",
			"<Cmd>lua require'dap'.set_breakpoint()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>lp",
			"<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>dr",
			"<Cmd>lua require'dap'.repl.open()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>dl",
			"<Cmd>lua require'dap'.run_last<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>t",
			"<Cmd>lua require'dap'.terminate()<CR>",
			{ noremap = true, silent = true }
		)

		dapui.setup({
			force_buffers = true, -- remove if causes issues
			icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
			mappings = {
				-- Use a table to apply multiple mappings
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			-- Use this to override mappings for specific elements
			element_mappings = {
				-- Example:
				-- stacks = {
				--   open = "<CR>",
				--   expand = "o",
				-- }
			},
			-- Expand lines larger than the window
			-- Requires >= 0.7
			expand_lines = vim.fn.has("nvim-0.7") == 1,
			-- Layouts define sections of the screen to place windows.
			-- The position can be "left", "right", "top" or "bottom".
			-- The size specifies the height/width depending on position. It can be an Int
			-- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
			-- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
			-- Elements are the elements shown in the layout (in order).
			-- Layouts are opened in order so that earlier layouts take priority in window sizing.
			layouts = {
				{
					elements = {
						-- Elements can be strings or table with id and size keys.
						{ id = "scopes", size = 0.75 },
						--"breakpoints",
						--"stacks",
						{ id = "console", size = 0.25 },
					},
					size = 40, -- 40 columns
					position = "left",
				},
				{
					elements = {
						"repl",
						"watches",
					},
					size = 0.20, -- 25% of total lines
					position = "bottom",
				},
			},
			controls = {
				-- Requires Neovim nightly (or 0.8 when released)
				enabled = true,
				-- Display controls in this element
				element = "repl",
				icons = {
					pause = "",
					play = "",
					step_into = "",
					step_over = "",
					step_out = "",
					step_back = "",
					run_last = "↻",
					terminate = "□",
				},
			},
			floating = {
				max_height = nil, -- These can be integers or a float between 0 and 1.
				max_width = nil, -- Floats will be treated as percentage of your screen.
				border = "single", -- Border style. Can be "single", "double" or "rounded"
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			windows = { indent = 1 },
			render = {
				max_type_length = nil, -- Can be integer or nil.
				max_value_lines = 100, -- Can be integer or nil.
			},
		})
		-- Javascript / Typescript (firefox)
		dap.adapters.firefox = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/bin/firefox-debug-adapter",
		}

		dap.configurations.typescript = {
			{
				name = "Debug with Firefox",
				type = "firefox",
				request = "launch",
				reAttach = true,
				url = "http://localhost:4200", -- Write the actual URL of your project.
				webRoot = "${workspaceFolder}",
				firefoxExecutable = "/usr/bin/firefox",
			},
		}

		dap.adapters.chrome = {
			type = "executable",
			command = "node",
			--args = { os.getenv("HOME") .. "/path/to/vscode-chrome-debug/out/src/chromeDebug.js" }, -- TODO adjust
			args = { "C:/Program Files/vscode-chrome-debug/out/src/chromeDebug.js" }, -- TODO adjust
		}

		dap.configurations.javascript = { -- change this to javascript if needed
			{
				name = "Launch Chrome against localhost",
				type = "chrome",
				request = "attach",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				port = 9222,
				webRoot = "${workspaceFolder}",
			},
		}

		dap.configurations.typescript = { -- change to typescript if needed
			{
				name = "Launch Chrome against localhost",
				type = "chrome",
				request = "attach",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				port = 9222,
				webRoot = "${workspaceFolder}",
			},
		}
		dap.configurations.javascript = dap.configurations.typescript

		dap.set_log_level("DEBUG")

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
}
