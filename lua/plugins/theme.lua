return {
	"folke/tokyonight.nvim",
	config = function()
		require("tokyonight").setup({
			style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
			transparent = true, -- Enable this to disable setting the background color
			terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
			on_colors = function(colors) end,
			on_highlights = function(hl, c) end,
		})

		vim.cmd([[colorscheme tokyonight-storm]])
	end,
}
