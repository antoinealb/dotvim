-- LSP servers
return {
	"neovim/nvim-lspconfig",
	lazy = false,
	config = function()
		-- Completion capabilities provided by nvim-cmp
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		vim.lsp.config("*", { capabilities = capabilities })

		vim.lsp.config("emmylua_ls", {
			settings = {
				emmylua = {
					-- Tell the server which Lua you're using (Neovim embeds LuaJIT).
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					-- Make the server aware of Neovim runtime files.
					workspace = {
						library = { vim.env.VIMRUNTIME },
					},
				},
			},
		})

		vim.lsp.enable({ "clangd", "basedpyright", "emmylua_ls" })
	end,
}
