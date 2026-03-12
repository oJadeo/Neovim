return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = {
		{ "<leader>o", "<Cmd>Outline<CR>", desc = "Toggle [O]utline" },
	},
	opts = {
		symbol_folding = {
			autofold_depth = false,
		},
	},
}
