return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = { "gdscript", "godot_resource", "gdshader" },
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
