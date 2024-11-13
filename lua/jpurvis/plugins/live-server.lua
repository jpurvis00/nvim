return {
	"barrett-ruth/live-server.nvim",
	build = "npm add -g live-server",
	cmd = { "LiveServerStart", "LiveServerStop" },
	config = true,
	--following doesn't seem to work for some reason. Always launches chrome and port 5555
	--even though running live-server from terminal launches on port 8080
	--config = function()
	--	require("live-server").setup({
	--		-- Add your configuration options here
	--		--port = 8080, -- Example option
	--		--browser = "firefox", -- Example option
	--	})
	--end,
}
