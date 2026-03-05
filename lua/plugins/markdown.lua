return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "SecondBrain",
					path = "/mnt/d/Obsidian/SecondBrain/",
				},
			},
		},
		completion = {
			blink = true,
		},
		picker = {
			name = "telescope",
		},
		ui = {
			enable = false,
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- Make Markdown buffers look beautiful
		ft = { "markdown", "codecompanion" },
		opts = {
			render_modes = true, -- Render in ALL modes
			-- other options...
		},
		config = function()
			require("render-markdown").setup({
				completions = { lsp = { enabled = true } },
			})
		end,
	},
	{
		"magnusriga/markdown-tools.nvim",
		opts = {
			picker = "telescope",
		},
	},
}
