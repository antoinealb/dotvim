-- Settings and keymaps that must load before plugins
require("config.options")
require("config.keymaps")

-- Plugin manager setup: auto-imports every file in lua/plugins/
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
})
