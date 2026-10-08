vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- 3. Plugins Setup
-- ============================================================================
require("lazy").setup({
	-- Colorscheme
	{
		"navarasu/onedark.nvim",
		config = function()
			vim.cmd.colorscheme("onedark")
		end,
	},

	-- File Tree (replaces NERDTree)
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
		keys = { { "<F2>", "<cmd>Neotree toggle<CR>", desc = "Toggle NeoTree" } },
		lazy = false,
	},

	-- Better whitespace highlighting
	{
		"ntpeters/vim-better-whitespace",
		config = function()
			vim.g.better_whitespace_enabled = 1
		end,
	},

	-- Formatting with conform.nvim
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = {
			formatters_by_ft = {
				cpp = { "clang-format" },
				c = { "clang-format" },
				python = { "ruff_format" },
				javascript = { "prettier" },
				go = { "gofmt" },
				bzl = { "buildifier" },
				lua = { "stylua" },
			},
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
		},
	},

	-- LSP servers
	{
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
	},

	-- Completion with nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-e>"] = cmp.mapping.abort(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
})

vim.opt.showcmd = true

vim.opt.mouse = "a"

-- Search options
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.wildmenu = true
vim.opt.scrolloff = 8

-- ============================================================================
-- 5. Keymaps
-- ============================================================================
local map = vim.keymap.set

-- Escape insert mode quickly
map("i", "jk", "<Esc>", { silent = true })

-- Clear search highlight on Enter
map("n", "<CR>", ":noh<CR><CR>", { silent = true })
