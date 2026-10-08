-- Formatting with conform.nvim
return {
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
}
