return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.config")
		config.setup({
			ensure_installed = { "gdscript", "godot_resource", "gdshader", "lua", "markdown", "bash" },
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
