-- File Tree (replaces NERDTree)
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
	keys = { { "<F2>", "<cmd>Neotree toggle<CR>", desc = "Toggle NeoTree" } },
	lazy = false,
}
