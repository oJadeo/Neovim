return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = {
		{ "<leader>to", "<Cmd>Outline<CR>", desc = "[T]oggle [O]utline" },
	},
	opts = {
		symbol_folding = {
			autofold_depth = false,
		},
	},
}
